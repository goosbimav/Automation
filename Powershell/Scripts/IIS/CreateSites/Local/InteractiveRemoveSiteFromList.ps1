# This script will REMOVE a site from IIS. 

Write-Output " "
Write-Output "----------------------------------------------"
Write-Host "This script will REMOVE a List of sites from IIS" -foreground green
Write-Output "----------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration

#$SiteName = Read-Host "Please enter the Site Name"
$Directory = "U:\TMP\E-stuff\Scripting\Powershell\Scripts\IIS\CreateSites\Local\ListOfSites.txt"
$ListOfSites = Get-Content $Directory | Where {$_ -notmatch '^\s+$'}

#Get the physical path of the IIS site you want to remove
$SiteFolder = Get-WebFilePath IIS:\Sites\$ListOfSites

#Check to see if folder path exists. It it does remove it 
foreach ($Site in $ListOfSites) 
{
	
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
	
		#Removing a list of Sites and the App Pool
		Remove-Website -Name $SiteName
		Remove-WebAppPool -Name $SiteName
	
		#Remove physical folder within path
		Remove-Item $SiteFolder
	}
	else
	{
		Write-Output " "
		Write-Host "... The Path does not exists! ..." -foreground red
		Write-Output " "
	}

}


Write-Output " "
Write-Output "------------------------------------------"
Write-Host  " Sites have been Removed from IIS" -foreground green
Write-Output "------------------------------------------"
Write-Output " "

Write-Host "Press any key to continue..."
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
