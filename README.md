# 🎯 SQL Server Availability Group Toolbox

Welcome to your one-stop script shop for managing SQL Server Availability Groups with style! This repo contains a small but mighty set of SQL scripts to help you:

- 🔁 Suspend HADR (replication) safely
- ▶️ Resume HADR (replication) with confidence
- ➕ Add new or existing databases to your AG.  
- ⭐ Works great when dealing with TDE encrypted databases.

> 💡 Whether you're prepping for maintenance, onboarding a new database, or recovering from a hiccup, this toolkit saves you time and sanity.

---

## 🧰 Included Scripts

### `add_database_to_AG.sql`  
🚀 **Mission:** Adds a new or existing database to a specified Availability Group.

**What it does:**
- Checks prerequisites and AG status
- Restores database if necessary
- Joins it to the AG
- Kicks off automatic seeding (if enabled)


**Define Variables**
- Primary - Server currently set as Primary in AG or AG Name
- Secondary - Server currently set as Secondary
- DbName - Database you want to add to the Availability Group
- BkupDir - Directory where you want to save data and log backup
- DataDir - Data directory of SQL Server instance (e.g. D:\MSSQL15.MSSQLSERVER\MSSQL\DATA)
- LogDir - Log directory of SQL Server instance (e.g. L:\MSSQL15.MSSQLSERVER\MSSQL\Data)
- LogBkupJob - Agent job that runs log backups

Perfect for automating AG onboarding or refreshing secondary replicas!
---

### `AG_check_status.sql`  
✅ **Mission:** Returns the current status of all availabilty groups and databases.

**What it does:**
- Outputs `AvailabilityGroupName, DatabaseName, AGState, failover_mode_desc, availability_mode_desc, isSuspended` for all AG databases
- Easy way to quickly monitor and track the status of your AG.

---

### `AG_backup_restore_status.sql`  
✅ **Mission:** Monitors both the primary and secondary for backup and restore activity.

**What it does:**
- Allows the user to set the primary and secondary hosts and with a single click check the backup and restore status without having to switch connections manually.

---

### `generate_hadr_suspend.sql`  
⛔ **Mission:** Safely suspend data movement for your databases.

**What it does:**
- Generates `ALTER DATABASE ... SET HADR SUSPEND` statements for each participating database
- Keeps you in control during patching or troubleshooting

Copy, paste, and execute at will!

---

### `generate_hadr_resume.sql`  
✅ **Mission:** Resume data movement like nothing ever happened.

**What it does:**
- Outputs `ALTER DATABASE ... SET HADR RESUME` for all AG databases
- Simple way to bring things back online after maintenance

---

## 💾 Usage

1. Clone or download the repo.
2. Open the script you need in SQL Server Management Studio.
3. Run the script to generate the SQL you want (or execute it directly, depending on the file).
4. Relax knowing your AG is under control.

---

## ⚠️ Disclaimer

These scripts are designed for DBA use in controlled environments. Always test in dev before deploying in prod. You know the drill. 😉

---

## 🤝 Contributing

Found a bug? Want to suggest improvements? Open a PR or start a discussion!

---

## 🧙‍♂️ Author

Jack Worthen

---

## ⭐ If you find this repo helpful...

Give it a ⭐ and share it with your fellow DBAs. Keep your AGs happy and healthy!


