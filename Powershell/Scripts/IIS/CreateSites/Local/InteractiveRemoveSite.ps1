# This script will REMOVE a site from IIS. 

Write-Output " "
Write-Output "------------------------------------------"
Write-Host "This script will REMOVE a site from IIS" -foreground green
Write-Output "------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration

$SiteName = Read-Host "Please enter the Site Name"
$HostHeader = $SiteName

#Get the physical path of the IIS site you want to remove
$SiteFolder = Get-WebFilePath IIS:\Sites\$SiteName
#$PhysicalPath = "D:\p4\Deployment.TMPPRODCLUSTER\AdCommsNA\dev\product\TalentBrew\TB4.0\WEB"


#Check to see if folder path exists. It it does remove it 
If (Test-Path $SiteFolder)
{
	Write-Output " "
	Write-Host "... The Path exists! ..." -foreground white
	Write-Output " "
	Write-Host "The Site folder to be removed is: " -foreground white
	Write-Host $SiteFolder -foreground green
	Write-Output " "

	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	
	#Remove physical folder within path
	Remove-Item $SiteFolder
}
else
{
	Write-Output " "
	Write-Host "... The Path does not exists! ..." -foreground red
	Write-Output " "
}

#Remove the site and the App Pool

Remove-Website -Name $SiteName
Remove-WebAppPool -Name $SiteName

Write-Output " "
Write-Output "------------------------------------------"
Write-Host $SiteName "Has been Removed from IIS" -foreground green
Write-Output "------------------------------------------"
Write-Output " "

Write-Host "Press any key to continue..."
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
