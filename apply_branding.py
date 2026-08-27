import frappe

def run():
    print("Applying Orus Healthcare branding...")
    
    # 0. Ensure Domain Healthcare exists and is active
    try:
        if not frappe.db.exists("Domain", "Healthcare"):
            frappe.get_doc({"doctype": "Domain", "domain": "Healthcare"}).insert(ignore_permissions=True)
            frappe.db.commit()
            
        domain_doc = frappe.get_doc("Domain Settings")
        existing_domains = [d.domain for d in (domain_doc.active_domains or [])]
        if "Healthcare" not in existing_domains:
            domain_doc.append("active_domains", {"domain": "Healthcare"})
            domain_doc.save(ignore_permissions=True)
    except Exception as e:
        print(f"Domain activation note: {e}")
    
    # 1. System Settings
    sys_doc = frappe.get_doc("System Settings")
    sys_doc.app_name = "Orus Healthcare"
    sys_doc.app_logo_url = "/files/orus_logo.svg"
    sys_doc.favicon = "/files/orus_favicon.svg"
    sys_doc.enable_onboarding = 0
    sys_doc.save(ignore_permissions=True)
    
    # 2. Website Settings
    web_doc = frappe.get_doc("Website Settings")
    web_doc.app_name = "Orus Healthcare"
    web_doc.app_logo = "/files/orus_logo.svg"
    web_doc.banner_html = '<img src="/files/orus_logo.svg" style="height: 48px;" alt="Orus Healthcare">'
    web_doc.brand_html = 'Orus Healthcare'
    web_doc.favicon = "/files/orus_favicon.svg"
    web_doc.splash_image = "/files/orus_logo.svg"
    web_doc.copyright = "© 2026 Orus Healthcare. All rights reserved."
    web_doc.hide_footer_signup = 1
    web_doc.disable_signup = 1
    web_doc.head_html = """
    <title>Orus Healthcare - Hospital Management System</title>
    <style>
        .powered-by-frappe, .footer-powered { display: none !important; }
        .navbar-brand { font-weight: 700; color: #0284c7 !important; }
        .page-head { border-bottom: 1px solid #e2e8f0; }
    </style>
    """
    web_doc.save(ignore_permissions=True)
    
    # 3. Navbar Settings (Hide all frappe external links)
    try:
        nav_doc = frappe.get_doc("Navbar Settings")
        for item in nav_doc.help_dropdown:
            if item.item_label in ["Documentation", "User Forum", "Frappe School", "Report an Issue", "About", "Frappe Support"]:
                item.hidden = 1
        nav_doc.save(ignore_permissions=True)
    except Exception as e:
        print(f"Navbar note: {e}")

    # 4. Clear cache and commit
    frappe.db.commit()
    frappe.clear_cache()
    print("✅ All Orus Healthcare branding and domains applied cleanly!")

if __name__ == "__main__":
    run()
