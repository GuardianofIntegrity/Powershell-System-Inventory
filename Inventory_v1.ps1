# Inventory_v1.ps1
# Collects basic system information from the local computer

$ComputerSystem = Get-CimInstance Win32_ComputerSystem
$OS = Get-CimInstance Win32_OperatingSystem
$BIOS = Get-CimInstance Win32_BIOS

$Output = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    Manufacturer = $ComputerSystem.Manufacturer
    Model        = $ComputerSystem.Model
    RAM_GB       = [math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB, 2)
    OS           = $OS.Caption
    OS_Version   = $OS.Version
    BIOS_Serial  = $BIOS.SerialNumber
}

$OutputDir = ".\output"
if (!(Test-Path $OutputDir)) { New-Item -Path $OutputDir -ItemType Directory | Out-Null }

$Output | Export-Csv -Path "$OutputDir\SystemInventory.csv" -NoTypeInformation
Write-Output "System inventory exported to $OutputDir\SystemInventory.csv"
