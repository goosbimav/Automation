# This script will Add a new site with a Redirect in IIS. 

Write-Output " "
Write-Output "----------------------------------------------------"
Write-Host "This script will Add a new site with a Redirect in IIS" -foreground green
Write-Output "----------------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration

$SiteName = Read-Host "Please enter the name of the Site to add"
$SiteRedirect = Read-Host "Please enter where the site should redirect"
$AppPoolName = Read-Host "Please enter the name of the App Pool"
#$AppPoolVersion = Read-Host "Please enter the App Pool Version to use. Entered as (v2.0 or v4.0)"
$HostHeader = $SiteName
$FolderName = Read-Host "Please enter the Folder Name"
$PhysicalPath = "C:\inetpub\wwwroot\Redirect\$FolderName"

#Redirect
#Set-IisHttpRedirect -SiteName $SiteName -Destination '$SiteRedirect'
#Set-WebConfiguration system.webServer/httpRedirect IIS:\sites\$SiteName -Value @{enabled="true";destination=$SiteRedirect;exactDestination="true";httpResponseStatus="Permanent"}

#Summary Of Changes:

Write-Output " "
Write-Output " "
#Write-Output "-------------------"
Write-Host "Summary Of Changes:" -foreground green
Write-Output "-------------------"
Write-Output " "
Write-Host "Site Name: " -foreground green -NoNewline 
Write-Host $SiteName -foreground white
Write-Host "Site Redirect: " -foreground green -NoNewline
Write-Host $SiteRedirect -foreground white 
Write-Host "App Pool Name: " -foreground green -NoNewline 
Write-Host $AppPoolName -foreground white
#Write-Host "App Pool Version: " -foreground green -NoNewline 
#Write-Host $AppPoolVersion -foreground white
Write-Host "Folder Path: " -foreground green -NoNewline
Write-Host $PhysicalPath -foreground white
Write-Output " "
#Write-Output "------------------"
Write-Output " "
Write-Host "Press any key to continue with these changes..."
Write-Output " "

$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Check to see if folder path exists. If it does not create it. 
If(!(Test-Path $PhysicalPath)){
	New-Item -ItemType directory -Path $PhysicalPath
}

#Check to see if the site exits. If it does not exist then add a completely new site
if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName)))
{
     #Name the app pool the same as the site name
	 $appPool = New-Item ("IIS:\AppPools\" + $siteName)

	 #Create the new site
	 New-Website -Name $SiteName -Port 80 -IPAddress "*" -HostHeader $HostHeader -ApplicationPool $SiteName -PhysicalPath $PhysicalPath
	 
	 #Display Default AppPool Settings
     #"AppPool = " + $appPool
     #"UserName = " + $appPool.processModel.userName
     #"Password = " + $appPool.processModel.password
     #"Runtime = " + $appPool.managedRuntimeVersion

     #$appPool.processModel.userName = $userAccountName
     #$appPool.processModel.password = $userAccountPassword
     #$appPool.managedRuntimeVersion = "$AppPoolVersion"
     $appPool | Set-Item

     #Display Updated AppPool Settings
     #"AppPool = " +$appPool
     #"UserName = " + $appPool.processModel.userName
     #"Password = " + $appPool.processModel.password
     #"Runtime = " + $appPool.managedRuntimeVersion
	 
	 #Reconfigure the site to be a Redirect
	 #Set-iisHttpRedirect -SiteName $SiteName -Destination '$SiteRedirect'
	 Set-WebConfiguration system.webServer/httpRedirect IIS:\sites\$SiteName -Value @{enabled="true";destination="$($SiteRedirect)";exactDestination="true";httpResponseStatus="Permanent"}
}

Write-Output " "
Write-Host "Press any key to continue with these changes..."
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Output " "
Write-Output " "
Write-Output "----------------------------------"
Write-Host "Replicating Changes to Server Farm:" -foreground green
Write-Output "----------------------------------"
Write-Output "..."
Write-Output " "

Write-Output " "
Write-Host "Press any key to continue with these changes..."
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02s" > C:\Logs\Custom_Staging\tmpcustomweb02s.log -confirm
