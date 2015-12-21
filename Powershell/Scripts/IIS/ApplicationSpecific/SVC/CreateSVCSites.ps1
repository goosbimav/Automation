# This script will create a new site in IIS. 

Write-Output " "
Write-Output "------------------------------------------"
Write-Host "This script will CREATE a new site in IIS" -foreground green
Write-Output "------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration
set-executionpolicy unrestricted
#Import-CSV hostheaders.csv | New-Website

#---------------------------------------------------------------------
#Server Parameters
$Server1 = "10.9.212.174" #"ATTUNITY01"
$Server2 = "10.9.212.175" #"ATTUNITY02"
$ServerSyncPath = "S:\Logs\ServerSync\"

#---------------------------------------------------------------------
#Site1 Parameters
$SiteName1 = "api.bfwpub.com" 
$AppPoolName1 = $SiteName1
$AppPoolVersion1 = "v4.0" #Entered as (v2.0 or v4.0)
$HostHeader1 = ""
$FolderName1 = "Empty"
$PhysicalPath1 = "S:\Web\$FolderName1"
#-------
#ApplicationSite1 Parameters
$WebAppDirName1 = "api"
$WebAppPhysicalPath1 = "S:\Deployments\AWS\PXWebAPI\"
$WebAppAppPool1 = "api.bfwpub.com"
$WebAppAppPoolVersion1 = "v4.0"
#-------
#---------------------------------------------------------------------

#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Stop the Default IIS Site to mitigate conflicts
Stop-WebSite 'Default Web Site'
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#Site1 - "api.bfwpub.com"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $PhysicalPath1)){
		New-Item -ItemType directory -Path ($PhysicalPath1 + $FolderName1) #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName1)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $siteName1)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "NetworkService" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $AppPoolVersion1
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle to a specific Time Interval
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.time -Value 08:00:00 #Translates to (days.hours:minutes:seconds)
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName1)))
	{	
		#Create site and add default host header
		New-Website -Name $SiteName1 -Port 80 -IPAddress "*" -HostHeader $HostHeader1 -ApplicationPool $SiteName1 -PhysicalPath $PhysicalPath1
	}
#---------------------------------------------------------------------
#ApplicationSite1 - "api"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $WebAppPhysicalPath1))
	{
		New-Item -ItemType directory -Path $WebAppPhysicalPath1 #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $WebAppAppPool1)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $WebAppAppPool1)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $WebAppAppPoolVersion1
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
		
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle to a specific Time Interval
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $WebAppAppPool1) -Name Recycling.periodicRestart.time -Value 09:00:00 #Translates to (days.hours:minutes:seconds)
		
	}
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $WebAppAppPool1)))
	{
		#Create New Web-Application
		New-WebApplication -Name $WebAppDirName1 -Site $SiteName1 -PhysicalPath $WebAppPhysicalPath1 -ApplicationPool $WebAppAppPool1
	}
#---------------------------------------------------------------------
#---------------------------------------------------------------------

<#
#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Output " "
Write-Output " "
Write-Output "----------------------------------"
Write-Host "Replicating Changes to Server Farm:" -foreground green
Write-Output "----------------------------------"
Write-Output "..."
Write-Output " "

#msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02s" > S:\Logs\Custom_Staging\tmpcustomweb02s.log -confirm
	If(!(Test-Path $ServerSyncPath)){
		New-Item -ItemType directory -Path $ServerSyncPath #-confirm
	}

	%windir%\system32\inetsrv\appcmd.exe -verb:sync -source:webserver -dest:webserver,computerName=$Server2 > $ServerSyncPath\$Server2.log -confirm

#>