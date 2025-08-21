# Inventory_v3_Function.ps1
# Defines a reusable function Get-SystemInventory

function Get-SystemInventory {
    param(
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [switch]$IncludeDisks
    )

    foreach ($Computer in $ComputerName) {
        try {
            $ComputerSystem = Get-CimInstance Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop
            $OS = Get-CimInstance Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
            $BIOS = Get-CimInstance Win32_BIOS -ComputerName $Computer -ErrorAction Stop

            $Output = [PSCustomObject]@{
                ComputerName = $Computer
                Manufacturer = $ComputerSystem.Manufacturer
                Model        = $ComputerSystem.Model
                RAM_GB       = [math]::Round($ComputerSystem.TotalPhysicalMemory / 1GB, 2)
                OS           = $OS.Caption
                OS_Version   = $OS.Version
                BIOS_Serial  = $BIOS.SerialNumber
            }

            if ($IncludeDisks) {
                $Disks = Get-CimInstance Win32_LogicalDisk -ComputerName $Computer -ErrorAction Stop |
                    Where-Object { $_.DriveType -eq 3 } |
                    ForEach-Object {
                        "{0} ({1}GB free of {2}GB)" -f $_.DeviceID, 
                        [math]::Round($_.FreeSpace / 1GB, 2),
                        [math]::Round($_.Size / 1GB, 2)
                    }
                $Output | Add-Member -NotePropertyName "Disks" -NotePropertyValue ($Disks -join "; ")
            }

            $Output
        } catch {
            Write-Warning "Failed to query $Computer : $_"
        }
    }
}

Write-Output "Function Get-SystemInventory loaded. Example:"
Write-Output "Get-SystemInventory -ComputerName localhost -IncludeDisks | Export-Csv .\output\SystemInventory_Function.csv -NoTypeInformation"
