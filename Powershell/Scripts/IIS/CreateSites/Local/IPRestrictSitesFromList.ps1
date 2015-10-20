# This script will set the "Deny Entry" list to block all IP's for a specific site. It will then add a list of IP's (specified in a text file) to the "Allow Entry" list. 

Write-Output " "
Write-Output "------------------------------------------------------------------------------"
Write-Host "This script will add a list of IP's to be Filtered for a specific site in IIS" -foreground green
Write-Output "------------------------------------------------------------------------------"
Write-Output " "
Write-Output " "

import-module WebAdministration
#$SiteName = "WWM4WebService"
$SiteName = Read-Host "Please enter the name of the Site to add"
$Directory = "C:\Scripts\Lists\ListofIPs.txt"
$ListOfips = Get-Content $Directory | Where {$_ -notmatch '^\s+$'}

Set-WebConfigurationProperty -Filter /system.webServer/security/ipSecurity -Name allowUnlisted -Value false -Location $SiteName
#Set-WebConfigurationProperty -Filter /system.webServer/security/ipSecurity -Name allowUnlisted -Value true -Location $SiteName

foreach ($ipAddress in $ListOfips) 
{
	Add-WebConfiguration -Filter /system.webserver/security/ipsecurity -Value @{ipAddress="$($ipAddress)";allowed='true'} -Location $SiteName
	#Add-WebConfiguration -Filter /system.webServer/security/ipSecurity -PSPath IIS: -location 'WWM4WebService' -value @{ipAddress='171.159.192.22';subnetMask='255.255.255.255';allowed='true'}
}

Write-Output " "
Write-Output " "
Write-Host "IP's have been added to" $SiteName -foreground green
Write-Output " "
Write-Host "..." -foreground white
Write-Output " "
Write-Host "Press any key to continue..." -foreground white
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

