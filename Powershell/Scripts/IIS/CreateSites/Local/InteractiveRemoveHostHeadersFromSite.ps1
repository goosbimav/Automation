# This script will REMOVE a host header from a site in IIS. 

Write-Output " "
Write-Output "------------------------------------------------------------"
Write-Host "This script will REMOVE a host header from a site in IIS" -foreground green
Write-Output "------------------------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration

$HostHeader = Read-Host "Please enter the Host Header to remove"
$SiteName = Read-Host "Please enter the Site Name to remove the Host Headers from"

#cd IIS:\Sites\$SiteName

#Check to see if folder path exists. It it does remove it 
If (Get-WebBinding -Name $SiteName -HostHeader $HostHeader)
{
	
	Write-Output " "
	Write-Output " "
	Write-Host "... The Host Header EXISTS! ..." -foreground blue
	Write-Output " "
	
	#Summary Of Changes:
	Write-Output " "
	Write-Output " "
	Write-Host "Summary Of Changes:" -foreground green
	Write-Output "-------------------"
	Write-Output " "
	Write-Host "Host Header Name to remove: " -foreground green -NoNewline 
	Write-Host $HostHeader -foreground white
	Write-Host "Site Name: " -foreground green -NoNewline
	Write-Host $SiteName -foreground white 
	Write-Output " "
	Write-Output "..."
	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	
	#Remove physical folder within path
	Remove-WebBinding -Name $SiteName -Port 80 -IPAddress "*" -HostHeader $HostHeader
	
	Write-Output " " 
	Write-Output " "
	Write-Host "..."$HostHeader "has been REMOVED from IIS" "..." -foreground blue
	Write-Output " "
	Write-Output " "
	
	Write-Output " "
	Write-Host "Press any key to continue..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	
	Write-Output " "
	Write-Output " "
	Write-Output "-----------------------------------"
	Write-Host "Replicating Changes to Server Farm:" -foreground green
	Write-Output "-----------------------------------"
	Write-Output " "
	Write-Output "..."
	Write-Output " "

	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	#msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02s" > C:\Logs\Custom_Staging\tmpcustomweb02s.log -confirm
}
else
{
	Write-Output " "
	Write-Host "... The Host Header does not exists! ..." -foreground red
	Write-Output " "
	
	Write-Output " "
	Write-Host "Press any key to continue..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}



