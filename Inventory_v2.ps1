# Inventory_v2.ps1
# Collects system information from multiple computers listed in a file or parameter

param(
    [string[]]$ComputerName,
    [string]$ComputerListPath = ".\machines.txt"
)

# Load computer names from file if not provided
if (-not $ComputerName) {
    if (Test-Path $ComputerListPath) {
        $ComputerName = Get-Content $ComputerListPath
    } else {
        Write-Error "No computer names provided and $ComputerListPath not found."
        exit
    }
}

# ✅ Safeguard: Warn if no computer names were loaded
if (-not $ComputerName -or $ComputerName.Count -eq 0) {
    Write-Warning "⚠️ No computer names found. Please provide input via parameter or populate machines.txt."
    exit
}

$Results = foreach ($Computer in $ComputerName) {
    try {
        # Use local queries if targeting localhost or current machine
        if ($Computer -eq "localhost" -or $Computer -eq $env:COMPUTERNAME) {
            $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
            $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
            $BIOS = Get-CimInstance Win32_BIOS -ErrorAction Stop
        } else {
            $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop
            $OS = Get-CimInstance Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
            $BIOS = Get-CimInstance Win32_BIOS -ComputerName $Computer -ErrorAction Stop
        }

        # Create inventory object
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

# Ensure output directory exists
$OutputDir = ".\output"
if (!(Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory | Out-Null
}

# Export results to CSV
$Results | Export-Csv -Path "$OutputDir\SystemInventory_Multi.csv" -NoTypeInformation
Write-Output "✅ System inventory exported to $OutputDir\SystemInventory_Multi.csv"
