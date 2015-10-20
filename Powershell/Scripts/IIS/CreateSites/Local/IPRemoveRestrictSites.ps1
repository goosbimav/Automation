# This script will remove any "Deny Entries that have been previously been set up to be Filtered for a specific site in IIS " 

Write-Output " "
Write-Output "---------------------------------------------------------------------"
Write-Host "This script will remove All IP restrictions for a specific site in IIS" -foreground green
Write-Output "---------------------------------------------------------------------"
Write-Output " "
Write-Output " "

import-module WebAdministration
#$SiteName = "WWM4WebService"
$SiteName = Read-Host "Please enter the name of the Site"

#Remove any IP Restrictions from specified site
Clear-WebConfiguration -Filter /system.webServer/security/ipSecurity -Location $SiteName

Write-Output " "
Write-Output " "
Write-Host "IP Security Restrictions have been removed for" $SiteName -foreground green
Write-Output " "
Write-Host "..." -foreground white
Write-Output " "
Write-Host "Press any key to continue..." -foreground white
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

