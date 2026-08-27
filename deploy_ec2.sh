#!/bin/bash
# ==============================================================================
#  Orus Healthcare - 1-Click AWS EC2 Deployment & White-Labeling Script
#  Supports: Amazon Linux 2023/AL2, Ubuntu, Debian, RHEL, CentOS
# ==============================================================================

set -e

echo "=========================================================="
echo "  Deploying Orus Healthcare HMS on AWS EC2..."
echo "=========================================================="

# 1. Setup 4GB Swap (Essential for t2.micro / t3.micro 1GB RAM)
if [ ! -f /swapfile ]; then
    echo "Creating 4GB Swap File for memory stability..."
    sudo fallocate -l 4G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "✅ 4GB Swap configured."
fi

# 2. Install Docker & Docker Compose based on Linux Distro
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo "Detecting OS and Installing Docker & Docker Compose..."
    if command -v dnf &> /dev/null; then
        # Amazon Linux 2023 / Fedora / RHEL 9
        sudo dnf update -y
        sudo dnf install -y docker git curl
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER || true
        # Install Docker Compose Plugin
        sudo mkdir -p /usr/local/lib/docker/cli-plugins
        sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
        sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    elif command -v yum &> /dev/null; then
        # Amazon Linux 2 / CentOS 7
        sudo yum update -y
        sudo yum install -y docker git curl
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER || true
        # Install Docker Compose Plugin
        sudo mkdir -p /usr/local/lib/docker/cli-plugins
        sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
        sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    elif command -v apt-get &> /dev/null; then
        # Ubuntu / Debian
        sudo apt-get update
        sudo apt-get install -y docker.io docker-compose-v2 git curl
        sudo systemctl enable --now docker
        sudo usermod -aG docker $USER || true
    fi
    echo "✅ Docker and Docker Compose configured."
fi

# 3. Pull required Docker images
echo "Pulling Docker images..."
sudo docker pull frappe/erpnext:v15.45.1
sudo docker pull mariadb:10.8
sudo docker pull redis:alpine

# 4. Start Docker Compose Stack
echo "Starting containers..."
sudo docker compose up -d

# 5. Wait for site creation and database initialization
echo "Waiting for site 'frontend' initialization (~90 seconds)..."
until sudo docker compose logs create-site | grep -q "Current Site set to frontend"; do
    echo -n "."
    sleep 5
done
echo -e "\n✅ Site initialized."

# 6. Install Healthcare App
echo "Installing Healthcare App..."
sudo docker compose exec -T backend bench get-app healthcare --branch version-15
sudo docker compose exec -T backend python -m pip install -e /home/frappe/frappe-bench/apps/healthcare
sudo docker compose exec -T backend bench --site frontend migrate

# 7. Copy Orus Healthcare Logos & Favicon
echo "Copying Orus Healthcare logos..."
sudo docker compose cp orus_logo.svg backend:/home/frappe/frappe-bench/sites/frontend/public/files/orus_logo.svg
sudo docker compose cp orus_favicon.svg backend:/home/frappe/frappe-bench/sites/frontend/public/files/orus_favicon.svg
sudo docker compose cp apply_branding.py backend:/home/frappe/frappe-bench/apps/healthcare/healthcare/apply_branding.py

# 8. Apply Orus Healthcare Branding & Activate Healthcare Domain
echo "Applying Orus Healthcare branding and activating Healthcare domain..."
sudo docker compose exec -T backend bench --site frontend execute "frappe.get_doc('Domain Settings').append('active_domains', {'domain': 'Healthcare'}).save"
sudo docker compose exec -T backend bench --site frontend execute healthcare.apply_branding.run
sudo docker compose exec -T backend bench --site frontend clear-cache

# 9. Restart web frontend to refresh assets
sudo docker compose restart backend frontend

echo ""
echo "=========================================================="
echo "  🎉 ORUS HEALTHCARE IS LIVE ON EC2!"
echo "=========================================================="
echo "  URL: http://$(curl -s http://checkip.amazonaws.com || curl -s https://api.ipify.org):8080"
echo "  Username: Administrator"
echo "  Password: admin"
echo "=========================================================="
