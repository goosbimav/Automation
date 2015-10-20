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
$SiteName1 = "PX" 
$AppPoolName1 = $SiteName1
$AppPoolVersion1 = "v4.0" #Entered as (v2.0 or v4.0)
$HostHeader1 = "aws.macmillanhighered.com"
$HostHeader1a = "aws.whfreeman.com"
$HostHeader1b = "aws.worthpublishers.com"
$HostHeader1c = "aws.bedfordstmartins.com"
$HostHeader1d = "aws.highschool.bfwpub.com"
$FolderName1 = "DeployFolder"
$PhysicalPath1 = "S:\Deployments\AWS\PlatformX\$FolderName"
#-------
#ApplicationSite1 Parameters
$WebAppDirName1 = "BFWGlobal"
$WebAppPhysicalPath1 = "S:\Deployments\AWS\BFWGlobal"
$WebAppAppPool1 = $WebAppDirName1
$WebAppAppPoolVersion1 = "v4.0"
#-------
#ApplicationSite2 Parameters
$WebAppDirName2 = "hts"
$WebAppPhysicalPath2 = "S:\Deployments\AWS\QuestionEditor"
$WebAppAppPool2 = $SiteName1 # PX
$WebAppAppPoolVersion2 = "v4.0"
#-------
#ApplicationSite3 Parameters
$WebAppDirName3 = "secure"
$WebAppPhysicalPath3 = "S:\Deployments\AWS\PlatformX"
$WebAppAppPool3 = $SiteName1 # PX
$WebAppAppPoolVersion3 = "v4.0"
#-------
#ApplicationSite4 Parameters
$WebAppDirName4 = "xbook"
$WebAppPhysicalPath4 = "S:\Deployments\AWS\xbook"
$WebAppAppPool4 = $SiteName1 # PX
$WebAppAppPoolVersion4 = "v4.0"
#-------


#Site2 Parameters
$SiteName2 = "PXVideoTools" 
$AppPoolName2 = $SiteName2
$AppPoolVersion2 = "v4.0" # Entered as (v2.0 or v4.0)
$HostHeader2 = "aws.video.macmillanhighered.com"
$FolderName2 = "DeployFolder"
$PhysicalPath2 = "S:\Deployments\AWS\PlatformX\$FolderName"
#---------------------------------------------------------------------

#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Stop the Default IIS Site to mitigate conflicts
Stop-WebSite 'Default Web Site'
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#Site1 - "PX"
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
		$appPool.processModel.identityType = "NetworkService" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $AppPoolVersion1
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle to a specific Time Interval
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.time -Value 0.00:00:00 #Translates to (days.hours:minutes:seconds)
		
		#Set AppPool Recycle to a specific Time Schedule
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.schedule -Value @{value="08:00"}
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName1)))
	{	
		#Create site and add default host header
		New-Website -Name $SiteName1 -Port 80 -IPAddress "*" -HostHeader $HostHeader1 -ApplicationPool $SiteName1 -PhysicalPath $PhysicalPath1
		#Add the additional host headers
		New-WebBinding -Name $SiteName1 -Port 80 -IPAddress "*"  -HostHeader $HostHeader1a
		New-WebBinding -Name $SiteName1 -Port 80 -IPAddress "*"  -HostHeader $HostHeader1b
		New-WebBinding -Name $SiteName1 -Port 80 -IPAddress "*"  -HostHeader $HostHeader1c
		New-WebBinding -Name $SiteName1 -Port 80 -IPAddress "*"  -HostHeader $HostHeader1d
	}
#-------	
#Site2 - "PXVideoTools"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $PhysicalPath2))
	{
		New-Item -ItemType directory -Path ($PhysicalPath2 + $FolderName2) #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName2)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $siteName2)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $AppPoolVersion2
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle Request Limit
		#Set-ItemProperty ("IIS:\AppPools\" + $AppPoolName1) -Name recycling.periodicRestart.requests -Value 100000
		
		#Set AppPool Private Memory Limit
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName2) -Name recycling.periodicRestart.privateMemory -Value 2000000
		
		#Set AppPool Recycle to a specific Time Interval
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName2) -Name Recycling.periodicRestart.time -Value 3.00:00:00 #Translates to (days.hours:minutes:seconds)
		
		#Set AppPool Idle Time-out Recycle Value
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName2) -Name processModel.idleTimeOut -value '00:00:00'
		
		#Set App Pool Recycle to a specific Time Schedule
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName2) -Name Recycling.periodicRestart.schedule -Value @{value="08:00"}
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName2)))
	{
		New-Website -Name $SiteName2 -Port 80 -IPAddress "*" -HostHeader $HostHeader2 -ApplicationPool $SiteName2 -PhysicalPath $PhysicalPath2
	}	
#---------------------------------------------------------------------
#ApplicationSite1 - "BFWGlobal"
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
		
	}
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $WebAppAppPool1)))
	{
		#Create New Web-Application
		New-WebApplication -Name $WebAppDirName1 -Site $SiteName1 -PhysicalPath $WebAppPhysicalPath1 -ApplicationPool $WebAppAppPool1
	}
#-------	
#ApplicationSite2 - "HTS"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $WebAppPhysicalPath2))
	{
		New-Item -ItemType directory -Path $WebAppPhysicalPath2 #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $WebAppAppPool2)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $WebAppAppPool2)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $WebAppAppPoolVersion2
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
	}
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $WebAppAppPool2)))
	{
		#Create New Web-Site
		New-WebApplication -Name $WebAppDirName2 -Site $SiteName1 -PhysicalPath $WebAppPhysicalPath2 -ApplicationPool $WebAppAppPool2	
	}
#-------
#ApplicationSite3 - "secure"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $WebAppPhysicalPath3))
	{
		New-Item -ItemType directory -Path $WebAppPhysicalPath3 #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $WebAppAppPool3)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $WebAppAppPool3)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $WebAppAppPoolVersion3
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
	}
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $WebAppAppPool3)))
	{
		#Create New Web-Site
		New-WebApplication -Name $WebAppDirName3 -Site $SiteName1 -PhysicalPath $WebAppPhysicalPath3 -ApplicationPool $WebAppAppPool3	
	}
#-------
#ApplicationSite4 - "xbookapp"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $WebAppPhysicalPath4))
	{
		New-Item -ItemType directory -Path $WebAppPhysicalPath4 #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $WebAppAppPool4)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $WebAppAppPool4)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $WebAppAppPoolVersion4
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
	}
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $WebAppAppPool4)))
	{
		#Create New Web-Site
		New-WebApplication -Name $WebAppDirName4 -Site $SiteName1 -PhysicalPath $WebAppPhysicalPath4 -ApplicationPool $WebAppAppPool4	
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