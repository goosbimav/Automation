# This script will create a new site in IIS. 

Write-Output " "
Write-Output "------------------------------------------"
Write-Host "This script will CREATE a new site in IIS" -foreground green
Write-Output "------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration
set-executionpolicy unrestricted

[xml]$xmldata = Get-Content settings.xml

#Site1 Parameters
$SiteName = $xmldata.settings.site1.name 
$AppPoolName = $xmldata.settings.site1.appPool 
$AppPoolVersion = $xmldata.settings.site1.appPoolVersion # Entered as (v2.0 or v4.0)
$HostHeader = $xmldata.settings.site1.HostHeader #"aws.macmillanhighered.com"
$FolderName = $xmldata.settings.site1.FolderName #"DeployFolder"
$PhysicalPath = $xmldata.settings.site1.PhysicalPath #"C:\Deployments\AWS\PlatformX\$FolderName"

#Summary Of Changes:

Write-Output " "
Write-Output " "
#Write-Output "-------------------"
Write-Host "Summary Of Changes:" -foreground green
Write-Output "-------------------"
Write-Output " "
Write-Host "Site Name: " -foreground green -NoNewline 
Write-Host $SiteName -foreground white
Write-Host "Host Header: " -foreground green -NoNewline
Write-Host $SiteName -foreground white 
Write-Host "App Pool Name: " -foreground green -NoNewline 
Write-Host $AppPoolName -foreground white
Write-Host "App Pool Version: " -foreground green -NoNewline 
Write-Host $AppPoolVersion -foreground white
Write-Host "Folder Path: " -foreground green -NoNewline
Write-Host $PhysicalPath ...\$AppPoolName -foreground white
Write-Output " "
#Write-Output "------------------"
Write-Output " "
Write-Host "Press any key to continue with these changes..."
Write-Output " "

#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


#Check to see if folder path exists. If it does not create it. 
If(!(Test-Path $PhysicalPath)){
	New-Item -ItemType directory -Path ($PhysicalPath + $FolderName) #-confirm
}

#Check to see if the site exits. If it does not exist then add a completely new site
if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName)))
{
     #Name the app pool the same as the site name
	 $appPool = New-Item ("IIS:\AppPools\" + $siteName)

	 New-Website -Name $SiteName -Port 80 -IPAddress "*" -HostHeader $HostHeader -ApplicationPool $SiteName -PhysicalPath $PhysicalPath
	 
     #Display Default AppPool Settings
     #"AppPool = " + $appPool
     #"UserName = " + $appPool.processModel.userName
     #"Password = " + $appPool.processModel.password
     #"Runtime = " + $appPool.managedRuntimeVersion

     #$appPool.processModel.userName = $userAccountName
     #$appPool.processModel.password = $userAccountPassword
     $appPool.managedRuntimeVersion = "$AppPoolVersion"
     $appPool | Set-Item

     #Display Updated AppPool Settings
     #"AppPool = " +$appPool
     #"UserName = " + $appPool.processModel.userName
     #"Password = " + $appPool.processModel.password
     #"Runtime = " + $appPool.managedRuntimeVersion
}

#Write-Output " "
#Write-Host "Press any key to continue with these changes..."
#Write-Output " "


#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Output " "
Write-Output " "
Write-Output "----------------------------------"
Write-Host "Replicating Changes to Server Farm:" -foreground green
Write-Output "----------------------------------"
Write-Output "..."
Write-Output " "

#Write-Output " "
#Write-Host "Press any key to continue with these changes..."
#Write-Output " "
#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02s" > C:\Logs\Custom_Staging\tmpcustomweb02s.log -confirm
