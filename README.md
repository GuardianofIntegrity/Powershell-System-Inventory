# PowerShell System Inventory Scripts

This repository contains PowerShell scripts for collecting system inventory information.

## Scripts

### Inventory_v1.ps1
- Collects information from the **local computer** only.

### Inventory_v2.ps1
- Collects information from **multiple computers** (specified by `-ComputerName` or in `machines.txt`).
- Includes error handling for unreachable machines.

### Inventory_v3_Function.ps1
- Defines a reusable function `Get-SystemInventory`.
- Can collect info from one or multiple computers.
- Optional parameter `-IncludeDisks` adds disk usage info.
- Supports pipeline usage.

## How to Run

Open PowerShell in the folder where these scripts are located and run:

```powershell
# Run local inventory
.\Inventory_v1.ps1
 ##Example Output
![Example Output](https://github.com/GuardianofIntegrity/Powershell-System-Inventory/blob/main/Script%20test.jpg)

# Run multi-computer inventory
.\Inventory_v2.ps1 -ComputerListPath .\machines.txt

# Load function and run with disk info
. .\Inventory_v3_Function.ps1
Get-SystemInventory -ComputerName localhost -IncludeDisks |
  Export-Csv .\output\SystemInventory_Function.csv -NoTypeInformation
```

## Output

All results are saved in the `output` folder as CSV files.
