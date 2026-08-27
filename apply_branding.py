import frappe

def run():
    print("Applying Orus Healthcare branding and configuring workspaces...")
    
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
    
    # 1. System Settings (direct DB value set to bypass mandatory checks)
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
    
    # 2. Website Settings (direct DB value set)
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
    
    # 3. Clean Sidebar Workspaces (Hide non-healthcare clutter)
    try:
        workspaces_to_hide = [
            'Manufacturing', 'Quality', 'Projects', 'Buying', 'Selling', 
            'Stock', 'Assets', 'CRM', 'ERPNext Integrations', 'Support', 
            'Integrations', 'Build', 'Tools', 'Website'
        ]
        for ws in workspaces_to_hide:
            if frappe.db.exists("Workspace", ws):
                frappe.db.set_value("Workspace", ws, "is_hidden", 1)
                
        # Make sure Healthcare workspace is visible and active
        if frappe.db.exists("Workspace", "Healthcare"):
            frappe.db.set_value("Workspace", "Healthcare", "is_hidden", 0)
            frappe.db.set_value("Workspace", "Healthcare", "public", 1)
    except Exception as e:
        print(f"Workspace customization note: {e}")
    
    # 4. Navbar Settings (Hide all frappe external links)
    try:
        nav_doc = frappe.get_doc("Navbar Settings")
        for item in (nav_doc.help_dropdown or []):
            if item.item_label in ["Documentation", "User Forum", "Frappe School", "Report an Issue", "About", "Frappe Support"]:
                item.hidden = 1
        nav_doc.flags.ignore_mandatory = True
        nav_doc.save(ignore_permissions=True)
    except Exception as e:
        print(f"Navbar note: {e}")

    # 5. Clear cache and commit
    frappe.db.commit()
    frappe.clear_cache()
    print("✅ All Orus Healthcare branding, Healthcare workspace, and clean sidebar applied!")

if __name__ == "__main__":
    run()
