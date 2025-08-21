# Inventory_v2.ps1
# Collects system information from multiple computers listed in a file or parameter

param(
    [string[]]$ComputerName,
    [string]$ComputerListPath = ".\machines.txt"
)

if (-not $ComputerName) {
    if (Test-Path $ComputerListPath) {
        $ComputerName = Get-Content $ComputerListPath
    } else {
        Write-Error "No computer names provided and $ComputerListPath not found."
        exit
    }
}

$Results = foreach ($Computer in $ComputerName) {
    try {
        $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop
        $OS = Get-CimInstance Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
        $BIOS = Get-CimInstance Win32_BIOS -ComputerName $Computer -ErrorAction Stop

        [PSCustomObject]@{
            ComputerName = $Computer
            Manufacturer = $ComputerSystem.Manufacturer
            Model        = $ComputerSystem.Model
            RAM_GB       = [math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB, 2)
            OS           = $OS.Caption
            OS_Version   = $OS.Version
            BIOS_Serial  = $BIOS.SerialNumber
        }
    } catch {
        Write-Warning "Failed to query $Computer : $_"
        [PSCustomObject]@{
            ComputerName = $Computer
            Manufacturer = "Error"
            Model        = "Error"
            RAM_GB       = "Error"
            OS           = "Error"
            OS_Version   = "Error"
            BIOS_Serial  = "Error"
        }
    }
}

$OutputDir = ".\output"
if (!(Test-Path $OutputDir)) { New-Item -Path $OutputDir -ItemType Directory | Out-Null }

$Results | Export-Csv -Path "$OutputDir\SystemInventory_Multi.csv" -NoTypeInformation
Write-Output "System inventory exported to $OutputDir\SystemInventory_Multi.csv"
