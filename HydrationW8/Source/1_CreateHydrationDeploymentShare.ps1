# ----------------------------------------------------------------------------------------------
# Note, to allow PowerShell script to run, use the following command
# Set-ExecutionPolicy Unrestricted –Force
# ----------------------------------------------------------------------------------------------


# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}

# Check free space on C: - Minimum is 30 GB
$NeededFreeSpace = 30GB
$disk = Get-wmiObject Win32_LogicalDisk -computername . | where-object {$_.DeviceID -eq "C:"} 

[float]$freespace = $disk.FreeSpace;
$freeSpaceGB = [Math]::Round($freespace / 1073741824);

if($disk.FreeSpace -lt $NeededFreeSpace)
{
Write-Warning "Oupps, you need at least 30 GB of free disk space"
Write-Warning "Available free space on C: is $freeSpaceGB GB"
Write-Warning "Aborting script..."
Break
}

# Create MDT Deployment share
$MDTServer = (get-wmiobject win32_computersystem).Name

Add-PSSnapIn Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue 
md C:\HydrationW8\DS
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\HydrationW8\DS" -Description "Hydration W8" -NetworkPath "\\$MDTServer\HydrationW8$" -Verbose | add-MDTPersistentDrive -Verbose

md C:\HydrationW8\ISO\Content\Deploy
new-item -path "DS001:\Media" -enable "True" -Name "MEDIA001" -Comments "" -Root "C:\HydrationW8\ISO" -SelectionProfile "Everything" -SupportX86 "False" -SupportX64 "True" -GenerateISO "True" -ISOName "HydrationW8.iso" -Verbose
new-PSDrive -Name "MEDIA001" -PSProvider "MDTProvider" -Root "C:\HydrationW8\ISO\Content\Deploy" -Description "Hydration media deployment share" -Force -Verbose