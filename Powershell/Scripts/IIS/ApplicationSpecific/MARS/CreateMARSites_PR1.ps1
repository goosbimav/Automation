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
#Site3 Parameters
$SiteName3 = "coresvcs.macmillanhighered.com" 
$AppPoolName3 = $SiteName3
$AppPoolVersion3 = "v4.0" # Entered as (v2.0 or v4.0)
$HostHeader3 = "pr-coresvcs.macmillanhighered.com"
$FolderName3 = "DeployFolder"
$PhysicalPath3 = "c:\EmptySite\"
#-------
#ApplicationSite1 Parameters
$WebAppDirName1 = "eCommerce"
$WebAppPhysicalPath1 = "S:\deployments\PRISTINE\eCommerceService\"
$WebAppAppPool1 = $SiteName3
$WebAppAppPoolVersion1 = "v4.0"
#-------
#ApplicationSite2 Parameters
$WebAppDirName2 = "entitlement"
$WebAppPhysicalPath2 = "S:\deployments\PRISTINE\EntitlementService.Gateway\"
$WebAppAppPool2 = $SiteName3
$WebAppAppPoolVersion2 = "v4.0"
#-------
#ApplicationSite3 Parameters
$WebAppDirName3 = "profile"
$WebAppPhysicalPath3 = "S:\deployments\PRISTINE\CW.ProfileService\"
$WebAppAppPool3 = $SiteName3
$WebAppAppPoolVersion2 = "v4.0"
#-------

#Site4 Parameters
$SiteName4 = "sampling.macmillanhighered.com" 
$AppPoolName4 = $SiteName4
$AppPoolVersion4 = "v4.0" # Entered as (v2.0 or v4.0)
$HostHeader4 = "pr-sampling.macmillanhighered.com"
$FolderName4 = "DeployFolder"
$PhysicalPath4 = "S:\deployments\PRISTINE\iSample\"

#---------------------------------------------------------------------

#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Stop the Default IIS Site to mitigate conflicts
#Stop-WebSite 'Default Web Site'
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#---------------------------------------------------------------------
	
#Site3 - "coresvcs.bfwpub.com"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $PhysicalPath3))
	{
		New-Item -ItemType directory -Path ($PhysicalPath3 + $FolderName3) #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName3)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $siteName3)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $AppPoolVersion3
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool.enable32BitAppOnWin64 = "True"		#Enable 32-bit Application Setting
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle Request Limit
		#Set-ItemProperty ("IIS:\AppPools\" + $AppPoolName1) -Name recycling.periodicRestart.requests -Value 100000
		
		#Enable 32-bit Application Setting
		#Set-itemProperty I("IIS:\AppPools\" + $AppPoolName3) -Name enable32BitAppOnWin64 -Value "true"
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName3)))
	{
		New-Website -Name $SiteName3 -Port 80 -IPAddress "10.9.211.235" -HostHeader $HostHeader3 -ApplicationPool $SiteName3 -PhysicalPath $PhysicalPath3
	}
#-------	
#ApplicationSite1 - "eCommerce"
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
		New-WebApplication -Name $WebAppDirName1 -Site $SiteName3 -PhysicalPath $WebAppPhysicalPath1 -ApplicationPool $WebAppAppPool1
	}
#-------	
#ApplicationSite2 - "entitlement"
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
		New-WebApplication -Name $WebAppDirName2 -Site $SiteName3 -PhysicalPath $WebAppPhysicalPath2 -ApplicationPool $WebAppAppPool2	
	}
#-------
#ApplicationSite3 - "profile"
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
		New-WebApplication -Name $WebAppDirName3 -Site $SiteName3 -PhysicalPath $WebAppPhysicalPath3 -ApplicationPool $WebAppAppPool3	
	}
#-------	
#Site4 - "sampling.macmillanhighered.com"
	#Check to see if folder path exists. If it does not create it. 
	If(!(Test-Path $PhysicalPath4))
	{
		New-Item -ItemType directory -Path ($PhysicalPath4 + $FolderName4) #-confirm
	}
	#Check to see if the AppPool exits. If it does not exist then add a completely new AppPool
	if(!(Test-Path ("IIS:\AppPools\" + $AppPoolName4)))
	{
		#Name the app pool the same as the site name
		$appPool = New-Item ("IIS:\AppPools\" + $siteName4)

	#Display Default AppPool Settings
		#"AppPool = " + $appPool
		#"UserName = " + $appPool.processModel.userName
		#"Password = " + $appPool.processModel.password
		#"Runtime = " + $appPool.managedRuntimeVersion

	#Set AppPool Settings	
		#$appPool.processModel.identityType = "SomeUser" #Specify User here or use numbers (1-4)
		#$appPool.processModel.username = "someUser"
		#$appPool.processModel.password = "somePassword"
		$appPool.managedRuntimeVersion = $AppPoolVersion4
		#$appPool.managedPipeLineMode = "Integrated"
		$appPool | Set-Item
		
	#Change Advanced AppPool Settings
		#Set AppPool Recycle Request Limit
		#Set-ItemProperty ("IIS:\AppPools\" + $AppPoolName1) -Name recycling.periodicRestart.requests -Value 100000
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName4)))
	{
		New-Website -Name $SiteName4 -Port 80 -IPAddress "10.9.211.235" -HostHeader $HostHeader4 -ApplicationPool $SiteName4 -PhysicalPath $PhysicalPath4
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

#msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02s" > C:\Logs\Custom_Staging\tmpcustomweb02s.log -confirm
	If(!(Test-Path $ServerSyncPath)){
		New-Item -ItemType directory -Path $ServerSyncPath #-confirm
	}

	%windir%\system32\inetsrv\appcmd.exe -verb:sync -source:webserver -dest:webserver,computerName=$Server2 > $ServerSyncPath\$Server2.log -confirm

#>