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
$SiteName1 = "root.px.bfwpub.com" 
$AppPoolName1 = $SiteName1
$AppPoolVersion1 = "v4.0" #Entered as (v2.0 or v4.0)
$HostHeader1 = ""
$FolderName1 = "px"
$PhysicalPath1 = "S:\www\$FolderName1"
#-------
#ApplicationSite1 Parameters
$WebAppDirName1 = "BrainHoney"
$WebAppPhysicalPath1 = "S:\www\px\BrainHoney\"
$WebAppAppPool1 = $SiteName1
$WebAppAppPoolVersion1 = "v4.0"
#-------
#VirtualSite1 Parameters
$WebVirtualDirName1 = "BFWglobal"
$WebVirtualDirPhysicalPath1 = "S:\www\BFW_include\BFWglobal"

#---------------------------------------------------------------------
#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Stop the Default IIS Site to mitigate conflicts
Stop-WebSite 'Default Web Site'
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#Site1 - "root.px.bfwpub.com"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $PhysicalPath1)){
		New-Item -ItemType directory -Path ($PhysicalPath1) #-confirm
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
		$appPool.processModel.loadUserProfile = $true	#Set AppPool Load User Profile
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle to a specific Time Schedule
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.schedule -Value @{value="06:00"}
		New-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.schedule -Value @{value="18:00"} #This sets an additional time value
		
		#Set AppPool Recycle to a specific Time Interval
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.time -Value 3.00:00:00 #Translates to (days.hours:minutes:seconds)
		Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.time -Value 0.00:00:00 #Translates to (days.hours:minutes:seconds)
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName1)))
	{	
		#Create site and add default host header
		New-Website -Name $SiteName1 -Port 80 -IPAddress "*" -HostHeader $HostHeader1 -ApplicationPool $SiteName1 -PhysicalPath $PhysicalPath1
	}
#-------	
#ApplicationSite1 - "BrainHoney"
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
#VirtualSite1 - "BFWglobal"
#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $WebVirtualDirPhysicalPath1))
	{
		New-Item -ItemType directory -Path $WebVirtualDirPhysicalPath1 #-confirm
		
		New-WebVirtualDirectory -Site $SiteName1 -Name $WebVirtualDirName1 -PhysicalPath $WebVirtualDirPhysicalPath1
	}
	
#---------------------------------------------------------------------
#---------------------------------------------------------------------
