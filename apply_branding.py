import frappe

def run():
    print("Applying Orus Healthcare branding, permissions, and roles...")
    
    # 0. Ensure Domain Healthcare exists and is active in database
    try:
        if not frappe.db.exists("Domain", "Healthcare"):
            frappe.get_doc({"doctype": "Domain", "domain": "Healthcare"}).insert(ignore_permissions=True)
            frappe.db.commit()
            
        domain_doc = frappe.get_doc("Domain Settings")
        existing_domains = [d.domain for d in (domain_doc.active_domains or [])]
        if "Healthcare" not in existing_domains:
            domain_doc.append("active_domains", {"domain": "Healthcare"})
            domain_doc.flags.ignore_mandatory = True
            domain_doc.save(ignore_permissions=True)
    except Exception as e:
        print(f"Domain activation note: {e}")
    
    # 1. System Settings (Direct DB writes)
    try:
        frappe.db.set_single_value("System Settings", "app_name", "Orus Healthcare")
        frappe.db.set_single_value("System Settings", "app_logo_url", "/files/orus_logo.svg")
        frappe.db.set_single_value("System Settings", "favicon", "/files/orus_favicon.svg")
        frappe.db.set_single_value("System Settings", "enable_onboarding", 0)
        if not frappe.db.get_single_value("System Settings", "language"):
            frappe.db.set_single_value("System Settings", "language", "en")
        if not frappe.db.get_single_value("System Settings", "time_zone"):
            frappe.db.set_single_value("System Settings", "time_zone", "UTC")
    except Exception as e:
        print(f"System Settings note: {e}")
    
    # 2. Website Settings (Direct DB writes)
    try:
        frappe.db.set_single_value("Website Settings", "app_name", "Orus Healthcare")
        frappe.db.set_single_value("Website Settings", "app_logo", "/files/orus_logo.svg")
        frappe.db.set_single_value("Website Settings", "banner_html", '<img src="/files/orus_logo.svg" style="height: 48px;" alt="Orus Healthcare">')
        frappe.db.set_single_value("Website Settings", "brand_html", 'Orus Healthcare')
        frappe.db.set_single_value("Website Settings", "favicon", "/files/orus_favicon.svg")
        frappe.db.set_single_value("Website Settings", "splash_image", "/files/orus_logo.svg")
        frappe.db.set_single_value("Website Settings", "copyright", "© 2026 Orus Healthcare. All rights reserved.")
        frappe.db.set_single_value("Website Settings", "hide_footer_signup", 1)
        frappe.db.set_single_value("Website Settings", "disable_signup", 1)
        frappe.db.set_single_value("Website Settings", "head_html", """
        <title>Orus Healthcare - Hospital Management System</title>
        <style>
            .powered-by-frappe, .footer-powered { display: none !important; }
            .navbar-brand { font-weight: 700; color: #0284c7 !important; }
            .page-head { border-bottom: 1px solid #e2e8f0; }
        </style>
        """)
    except Exception as e:
        print(f"Website Settings note: {e}")
    
    # 3. Clean Sidebar Workspaces (Hide ALL non-healthcare clutter)
    try:
        non_healthcare_workspaces = [
            'Accounting', 'Buying', 'Selling', 'Stock', 'Assets', 
            'Manufacturing', 'Quality', 'Projects', 'Support', 
            'Website', 'CRM', 'Tools', 'ERPNext Settings', 'Integrations', 
            'ERPNext Integrations', 'Build', 'Settings', 'Getting Started'
        ]
        for ws in non_healthcare_workspaces:
            if frappe.db.exists("Workspace", ws):
                frappe.db.set_value("Workspace", ws, "is_hidden", 1)
                frappe.db.set_value("Workspace", ws, "public", 0)
                
        # Make Healthcare the primary visible Workspace
        if frappe.db.exists("Workspace", "Healthcare"):
            frappe.db.set_value("Workspace", "Healthcare", "is_hidden", 0)
            frappe.db.set_value("Workspace", "Healthcare", "public", 1)
            frappe.db.set_value("Workspace", "Healthcare", "sequence_id", 1)
    except Exception as e:
        print(f"Workspace customization note: {e}")
    
    # 4. Grant Full Healthcare Roles & Permissions to Users (including Orus-studio@gmail.com and Administrator)
    try:
        healthcare_roles = [
            "System Manager", 
            "Healthcare Administrator", 
            "Physician", 
            "Nursing User", 
            "Laboratory User",
            "Desk User"
        ]
        users = frappe.db.get_list("User", filters={"enabled": 1, "name": ["not in", ["Guest"]]}, pluck="name")
        for u_email in users:
            u_doc = frappe.get_doc("User", u_email)
            for r in healthcare_roles:
                if frappe.db.exists("Role", r):
                    u_doc.add_roles(r)
            u_doc.flags.ignore_mandatory = True
            u_doc.save(ignore_permissions=True)
        print("✅ Healthcare roles assigned to all active users.")
    except Exception as e:
        print(f"Role assignment note: {e}")

    # 5. Navbar Settings (Hide all Frappe external links)
    try:
        nav_doc = frappe.get_doc("Navbar Settings")
        for item in (nav_doc.help_dropdown or []):
            if item.item_label in ["Documentation", "User Forum", "Frappe School", "Report an Issue", "About", "Frappe Support"]:
                item.hidden = 1
        nav_doc.flags.ignore_mandatory = True
        nav_doc.save(ignore_permissions=True)
    except Exception as e:
        print(f"Navbar note: {e}")

    # 6. Clear cache and commit
    frappe.db.commit()
    frappe.clear_cache()
    print("✅ Full permissions and branding applied successfully!")

if __name__ == "__main__":
    run()
