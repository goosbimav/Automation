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
$SiteName1 = "reg.macmillanhighered.com" 
$AppPoolName1 = $SiteName1
$AppPoolVersion1 = "v4.0" #Entered as (v2.0 or v4.0)
$HostHeader1 = "pr-reg.macmillanhighered.com"
$FolderName1 = "DeployFolder"
$PhysicalPath1 = "S:\deployments\PRISTINE\MarsUI\"

#---------------------------------------------------------------------

#This can be used as a PAUSE to step through the script
#$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#Stop the Default IIS Site to mitigate conflicts
#Stop-WebSite 'Default Web Site'
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#Site1 - "activation.macmillanhighered.com"
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
		#Set AppPool Recycle Request Limit
		#Set-ItemProperty ("IIS:\AppPools\" + $AppPoolName1) -Name recycling.periodicRestart.requests -Value 100000
		
		#Set AppPool Private Memory Limit
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name recycling.periodicRestart.privateMemory -Value 2000000
		
		#Set AppPool Recycle to a specific Time Interval
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.time -Value 0.00:00:00 #Translates to (days.hours:minutes:seconds)
		
		#Set AppPool Idle Time-out Recycle Value
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName2) -Name processModel.idleTimeOut -value '00:00:00'
		
		#Set AppPool Recycle to a specific Time Schedule
		#Set-ItemProperty -Path ("IIS:\AppPools\" + $AppPoolName1) -Name Recycling.periodicRestart.schedule -Value @{value="08:00"}
		
	}	
	#Check to see if the Site exits. If it does not exist then add a completely new Site
	if((Test-Path ("IIS:\AppPools\" + $AppPoolName1)))
	{	
		#Create site and add default host header
		New-Website -Name $SiteName1 -Port 80 -IPAddress "10.9.211.133" -HostHeader $HostHeader1 -ApplicationPool $SiteName1 -PhysicalPath $PhysicalPath1
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