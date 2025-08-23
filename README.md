# PowerShell System Inventory Scripts

This repository contains PowerShell scripts for collecting system inventory information.

## Scripts

### Inventory_v1.ps1
- Collects information from the **local computer** only.

**Importance of script**: This script will help gather data for system Inventory. It can be useful for asset mangagement, compliance audits, and troubleshooting.


### Inventory_v2.ps1
- Collects information from **multiple computers** (specified by `-ComputerName` or in `machines.txt`).
- Includes error handling for unreachable machines.

  **Importance of script**: In large organizations, this script can allow admins to pull reports from many computers at once, saving hours of manuel work.

### Inventory_v3_Function.ps1
- Defines a reusable function `Get-SystemInventory`.
- Can collect info from one or multiple computers.
- Optional parameter `-IncludeDisks` adds disk usage info.
- Supports pipeline usage.

**Importance of script**: With this script being a function, it will allow automation, intergration with other scripts, and scalability.
## How to Run

Open PowerShell in the folder where these scripts are located and run:

```powershell
# Run local inventory
.\Inventory_v1.ps1
Each run generates a 'SystemInventory.csv' report.
You can view an example screenshot in this repo:
See file: 'example-outputscript1.jpg'

# Run multi-computer inventory
.\Inventory_v2.ps1 -ComputerListPath .\machines.txt

# Load function and run with disk info
. .\Inventory_v3_Function.ps1
Get-SystemInventory -ComputerName localhost -IncludeDisks |
  Export-Csv .\output\SystemInventory_Function.csv -NoTypeInformation
```

## Output

All results are saved in the `output` folder as CSV files.
