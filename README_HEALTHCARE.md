# 🏥 ERPNext Healthcare Hospital Management System (HMS)

This repository contains the complete, enterprise-grade **ERPNext Healthcare** system configured for easy Docker-based local setup and management.

---

## 🚀 Quick Start Guide

### 1. Start the Hospital Management System
You can start all services using either the helper script or standard Docker Compose:

* **Using Batch Script:**
  Double-click or run:
  ```cmd
  start.bat
  ```
* **Using PowerShell:**
  ```powershell
  .\start.ps1
  ```
* **Using Docker Compose directly:**
  ```bash
  docker compose up -d
  ```

---

### 2. Access the System
Once started, open your web browser and navigate to:
👉 **[http://localhost:8080](http://localhost:8080)**

#### 🔑 Default Administrator Credentials:
* **Username:** `Administrator`
* **Password:** `admin`

*(Note: On first startup, it takes about 1-2 minutes for the site creation and database migrations to complete).*

---

## 🛠️ Management Commands

| Action | Script | Docker Command |
| :--- | :--- | :--- |
| **Start System** | `start.bat` or `.\start.ps1` | `docker compose up -d` |
| **Stop System** | `stop.bat` | `docker compose down` |
| **View Live Logs** | `logs.bat` | `docker compose logs -f` |
| **Check Container Status** | `status.bat` | `docker compose ps` |

---

## 🏥 Hospital Facilities & Modules Included

The system includes end-to-end features covering all hospital workflows:

### 1. 📋 Patient & Appointment Management
* **Patient Registration:** Full demographic data, emergency contacts, medical history, blood group, identification.
* **Appointment Scheduling:** Doctor availability slots, patient appointment booking, department queues.
* **Patient Encounters & OPD:** Outpatient consultation notes, symptoms, vitals, diagnosis.

### 2. 🛏️ Inpatient (IPD) & Bed Management
* **Admission & Discharge:** Inpatient admission workflows, discharge summaries, care plans.
* **Ward & Bed Allocation:** Real-time visual bed occupancy, room categories (ICU, General Ward, Private, Semi-private).
* **Nursing Tasks & Vitals:** Inpatient medication schedules, nursing observations, progress notes.

### 3. 🔬 Laboratory Information System (LIS)
* **Lab Test Templates:** Pre-configured test parameters, reference ranges, units.
* **Lab Orders & Sample Collection:** Sample barcoding/tracking, status updates.
* **Result Entry & Reporting:** Doctor sign-off, printable/downloadable lab reports.

### 4. 💊 Pharmacy & Inventory
* **Prescription Dispensing:** Direct electronic prescriptions from doctor encounters to pharmacy.
* **Medication Inventory:** Batch numbers, expiry date alerts, re-order levels.
* **Suppliers & Purchase Orders:** Stock management, supplier invoices, material receipts.

### 5. 💰 Billing, Invoicing & Insurance
* **Healthcare Service Pricing:** Standardized fees for consultations, procedures, lab tests, bed stay.
* **Consolidated Invoicing:** Automatic aggregation of OPD, IPD, pharmacy, and lab charges into a single patient bill.
* **Payment Gateways & Receipts:** Multiple payment methods, outstanding balances, refunds.

### 6. 🩺 Clinical EHR / EMR
* **ICD-10 / ICD-11 Diagnosis:** Standard medical classification coding.
* **Clinical Procedures:** Surgical schedules, procedure notes, pre-op/post-op instructions.
* **Vital Signs Recording:** BP, pulse, temperature, SpO2, BMI, respiration rate tracking over time.

### 7. 👥 Staff, Doctors & Roles (RBAC)
* Dedicated role profiles: **Physician**, **Nursing Staff**, **Laboratory User**, **Pharmacist**, **Receptionist**, **Accountant**, **Healthcare Administrator**.

---

## 📁 Repository Structure
```
hms-2/
├── docker-compose.yml     # Complete Docker Compose configuration
├── apps.json              # Frappe / ERPNext app definitions
├── start.bat / start.ps1  # One-click start scripts
├── stop.bat               # One-click stop script
├── logs.bat               # Live logging script
├── status.bat             # Container status script
├── images/                # Container build templates & assets
├── overrides/             # Optional compose overrides (SSL, domains, etc.)
└── README_HEALTHCARE.md   # This documentation guide
```
