#!/bin/bash
# ==============================================================================
#  Orus Healthcare - 1-Click AWS EC2 Deployment & White-Labeling Script
# ==============================================================================

set -e

echo "=========================================================="
echo "  Deploying Orus Healthcare HMS on AWS EC2..."
echo "=========================================================="

# 1. Setup 4GB Swap (Essential for t2.micro / t3.micro 1GB RAM)
if [ ! -f /swapfile ]; then
    echo "Creating 4GB Swap File for memory stability..."
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "✅ 4GB Swap configured."
fi

# 2. Install Docker & Docker Compose if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker & Docker Compose..."
    sudo apt-get update
    sudo apt-get install -y docker.io docker-compose-v2
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo "✅ Docker installed."
fi

# 3. Pull required Docker images
echo "Pulling Docker images..."
docker pull frappe/erpnext:v15.45.1
docker pull mariadb:10.8
docker pull redis:alpine

# 4. Start Docker Compose Stack
echo "Starting containers..."
docker compose up -d

# 5. Wait for site creation and database initialization
echo "Waiting for site 'frontend' initialization (~90 seconds)..."
until docker compose logs create-site | grep -q "Current Site set to frontend"; do
    echo -n "."
    sleep 5
done
echo -e "\n✅ Site initialized."

# 6. Install Healthcare App
echo "Installing Healthcare App..."
docker compose exec -T backend bench get-app healthcare --branch version-15
docker compose exec -T backend python -m pip install -e /home/frappe/frappe-bench/apps/healthcare
docker compose exec -T backend bench --site frontend migrate

# 7. Copy Orus Healthcare Logos & Favicon
echo "Copying Orus Healthcare logos..."
docker compose cp orus_logo.svg backend:/home/frappe/frappe-bench/sites/frontend/public/files/orus_logo.svg
docker compose cp orus_favicon.svg backend:/home/frappe/frappe-bench/sites/frontend/public/files/orus_favicon.svg
docker compose cp apply_branding.py backend:/home/frappe/frappe-bench/apps/healthcare/healthcare/apply_branding.py

# 8. Apply Orus Healthcare Branding & Activate Healthcare Domain
echo "Applying Orus Healthcare branding and activating Healthcare domain..."
docker compose exec -T backend bench --site frontend execute "frappe.get_doc('Domain Settings').append('active_domains', {'domain': 'Healthcare'}).save"
docker compose exec -T backend bench --site frontend execute healthcare.apply_branding.run
docker compose exec -T backend bench --site frontend clear-cache

# 9. Restart web frontend to refresh assets
docker compose restart backend frontend

echo ""
echo "=========================================================="
echo "  🎉 ORUS HEALTHCARE IS LIVE ON EC2!"
echo "=========================================================="
echo "  URL: http://$(curl -s http://checkip.amazonaws.com):8080"
echo "  Username: Administrator"
echo "  Password: admin"
echo "=========================================================="
