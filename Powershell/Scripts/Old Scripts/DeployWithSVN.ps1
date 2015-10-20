#
#      This uses SharpSvn-x64 in which the path needs to be specified below to call the proper dll's.
#
#		This script also conducts a Backup of a working directory that already exists by appending a .old to it"
#		This script also checks to see if the deploy is a Java service based on input from the source xml file."

        $Deploy
		[switch]$SkipBackup
		#[xml]$xmldata = Get-Content mxserver.xml    	
		$svnUrl = $xmldata.settings.common.release
		$localDir = $xmldata.settings.site.localDir
		$appFolder = $xmldata.settings.common.appName
		$sitePath = $xmldata.settings.site.path
		$backupDir = $xmldata.settings.site.backupPath
        $appCode = $localDir + $appFolder
		$NewAppCode = $sitePath + $appFolder
		#$backupPath = $NewAppCode + "-" + $currentDate;				#write to a new backup file appending the current date to name
		#$backupPath = $NewAppCode + "." + "old";
		$backupPath = $backupDir + $appFolder + "." + "old";
		$configItem = $xmldata.settings.site.configDir
		$appType = $xmldata.settings.common.appType
		$serviceName = $xmldata.settings.site.serviceName
		$Server = $xmldata.settings.site.server
				
		$source = $xmldata.settings.site.localDir
		$destination = $sitePath
		$localpath = $localDir + $appFolder
		$DoNotInclude = @('.svn', 'thumbs.db')
		
		#[string]$localDir = "C:\inetpub\ixdoc"
		#[string]$svnUrl = "http://svn.arc/insight/ixdoc/tags/release-candidates/1.8.13-RC11/webroot"

$success = $false


function svnCheckout($site){
try{

   #Test to see if local checkout already exists. If it does remove it before proceeding with new checkout 
	if (test-Path $localpath){
		    write-Host "Local Path: " $localpath "Already exist!" -Foreground Red
			write-Host "Removing current checkout..." -Foreground Red
			rm -force -recurse $localpath
			write-Host "Removed!" -Foreground Green
			write-Host
			write-Host "Proceeding with SVN checkout..." -Foreground Green			
		}
	else{ 
			write-Host "Local Path: " $localpath "Does Not exist" -Foreground White
			write-Host "Proceeding with SVN checkout..." -Foreground Green
		}

	#Deploys Code locally from subversion
	$currentScriptDirectory = Get-Location
	[System.IO.Directory]::SetCurrentDirectory($currentScriptDirectory)
	[Reflection.Assembly]::LoadFile(($currentScriptDirectory.Path + ".\SharpSvn-x64\SharpSvn.dll"))

	#Creating SvnClient
	$svnClient = New-Object SharpSvn.SvnClient

	#Getting SVN Url
	Write-Host "Getting source code from subversion repository:" -Foreground White
	Write-Host $svnUrl -Foreground Blue
	Write-Host	#Added to provide Space
	$repoUri = New-Object SharpSvn.SvnUriTarget($svnUrl)

	#Checking out Code to Local Path
	Write-Host "Checking out code to Local Path:" -Foreground White
	Write-Host $localDir -Foreground Blue
	Write-Host	#Added to provide Space
	$svnClient.CheckOut($repoUri, $localDir + $appFolder)
	Write-Host "Done with Checkout!" -Foreground Green
}

catch 
	{
		Write-Host ("Could not svn checkout. EXCEPTION: {1}" -f $_) -Foreground Red
	}
}		

#Function that does the actual deployCopy  
function deployCopy($site) {
try {
	
	if (test-Path ($sitePath + $appFolder)){
		Write-Host ("Removing existing files at {0}." -f ($sitePath + $appFolder)) -Foreground Red
        rm -force -recurse ($sitePath + $appFolder)								  
		Write-Host "Removed!" -Foreground Green
		
		#copy contents while preserving svn hidden file attributes
		Write-Host "Copying deploy check out to:" ($sitePath + $appFolder) -Foreground White
		robocopy $appCode ($sitePath + $appFolder) /E /MOVE /LOG:Logs/Copy.log
	
		Write-Host "Copy of deploy check out succeeded!" -Foreground Green
		}
	else{ 
					
		#copy contents while preserving svn hidden file attributes		
		Write-Host "Copying deploy check out to:" ($sitePath + $appFolder) -Foreground White
		robocopy $appCode ($sitePath + $appFolder) /E /MOVE /LOG:Logs/Copy.log
	
		Write-Host "Copy of deploy check out succeeded!" -Foreground Green
		}
	
<#	
	#ONLY UNCOMMENT IF YOU ARE DOING A COPY AND NOT A MOVE
	$originalCount = (gci -recurse ($appCode)).count		  		#counting of files in versioned release directory
	$siteCount = (gci -recurse ($sitePath + $appFolder)).count		#counting of files in deployCopyed path	
	
	
	if ($originalCount -ne $siteCount)
	{
		Write-Host ( "Not sure what happened; attempted to copy {0} file(s) and only copied {1} file(s)." -f $originalCount, $siteCount) -Foreground Red
	}
	else 
	{
		Write-Host ("Copy of Deployment succeeded.") -Foreground Green
	}
#>
	
}
	catch 
	{
		Write-Host ("Could not copy deploy. EXCEPTION: {1}" -f $_) -Foreground Red
	}
}


#Function that backups any existing folder
function backup($site) {
try {

	write-Host "WARNING: Remote Deploy Directory Already exists" -Foreground Red
	Write-Host	#Added to provide Space
	
	#Re-enable the below if you want to append a date vale as part of the backup path
	#$currentDate = (Get-Date).ToString("yyyy-MM-dd-HHmmss");		#get the current date
	#$backupPath = $NewAppCode + "-" + $currentDate;				#This is not needed here. It is defined globally at top of script
	
	# .old's the current folder
	#$backupPath = $NewAppCode + "." + "old"; 						 #This is not needed here. It is defined globally at top of script
	$originalCount = (gci -recurse $NewAppCode).count				 #counting the files in deployCopyed path
	
	Write-Host ("Making backup of {0} file(s) at {1} to {2}." -f $originalCount, $NewAppCode, $backupPath) -Foreground White
	
	if (test-Path $backupPath){
		#Remove any .old files that currently exits to back up the most current file
		rm -force -recurse $backupPath
		
		#backup contents while preserving svn hidden file attributes
		robocopy $NewAppCode $backupPath /E /LOG:Logs/Backup.log
	
		#counting the files in the new back up path to make sure they match
		$backupCount = (gci -recurse $backupPath).count					
	    if ($originalCount -ne $backupCount)
	    {
		Write-Host ("Backup failed; attempted to copy {0} file(s) and only copied {1} file(s)." -f $originalCount, $backupCount) -Foreground Red
		Write-Host	#Added to provide Space
	    }
	    else 
	    {
		Write-Host	#Added to provide Space
		Write-Host ("Backup succeeded!") -Foreground Green
		Write-Host	#Added to provide Space
	    }
	}
	else {		
		#backup contents while preserving svn hidden file attributes
		robocopy $NewAppCode $backupPath /E /LOG:Logs/Backup.log
	
		#counting the files in the new back up path to make sure they match
		$backupCount = (gci -recurse $backupPath).count					
	    if ($originalCount -ne $backupCount)
	    {
		Write-Host ("Backup failed; attempted to copy {0} file(s) and only copied {1} file(s)." -f $originalCount, $backupCount) -Foreground Red
		Write-Host	#Added to provide Space
	    }
	    else 
	    {
		Write-Host	#Added to provide Space
		Write-Host ("Backup succeeded!") -Foreground Green
		Write-Host	#Added to provide Space
	    }
	}	
}
	
	catch
	{
		Write-Host ("Could not complete backup. EXCEPTION: {1}" -f $_) -Foreground Red
	}

}

#Function that deploys the configs after the site has been deployed
function deployConfigs($site) {
try {
		Write-Host #Added for space
		Write-Host "Checking for config items now..." -Foreground White
		
		#If config items with ".xml" and ".conf" exits in the ".old" path than they can be copied to new deploy path from here
		if (test-Path $backupPath\config\* -include *.xml, *.conf) {
			Write-Host "Found!" -Foreground Green
		    Write-Host "Config Items exist in" $backupPath"\config"  -Foreground White			
			Write-Host "copying over config items..." -Foreground White
        	Copy-Item $backupPath\config\config.xml $NewAppCode/config
			Copy-Item $backupPath\config\wrapper.conf $NewAppCode/config
			Write-Host "Copied!" -Foreground Green
		}
        else{
			Write-Host "No config items found! " -Foreground Red
			Write-Host "Please populate them manually!" -Foreground Red
			}
			
			#Write-Host #Added for space
			#Write-Host "Deploy Succeded!" -Foreground Green
}

catch
	{
		Write-Host ("Could not complete Config Update. EXCEPTION: {1}" -f $_) -Foreground Red
	}

}

#Function that stop java service if it determins that the app is a java application
function stopServices{		
		
		Write-Host "The Application is a Java App" -Foreground Green
		Write-Host "Stopping Java Service..."$serviceName -Foreground White
			
		Get-Service -ComputerName $Server -Name $serviceName | Stop-Service -Verbose
		Write-Host "The Java Service has been stopped" -Foreground Green		
}

function startServices{

		Write-Host "The Application is a Java App" -Foreground Green
		Write-Host "Starting Java Service..."$serviceName -Foreground White
		
		Get-Service -ComputerName $Server -Name $serviceName | Start-Service -Verbose
		Write-Host "The Java Service has been started" -Foreground Green
}			

#Deploy to each site specified in xml file
foreach ($site in $xmldata.settings.site) {
	
		Write-Host ("Found deployment plan for {0} {1} -> {2}." -f $xmldata.settings.site.name, $appFolder, $sitePath) -Foreground White
		Write-Host #Added for space				
		
		#Test to see if remove Checkout already exists. If it does back it up before proceeding with copy
		if (test-Path $NewAppCode) {
		    svnCheckout($site)
			#backup($site)
			
			Write-Host "Determining if Apptype is a Java Application" -Foreground White
			if ($appType -eq "Java"){				
				stopServices
				backup($site)
				deployCopy($site)
				deployConfigs($site)
				startServices
			}
			else{
				Write-Host "The Application is not a Java App" -Foreground White
				Write-Host "No need to do anything here. Proceeding to next step..." -Foreground White
				Write-Host #Added for space
				backup($site)
				deployCopy($site)
				deployConfigs($site)
			}			
		}
		
		else
		{
		Write-Host ("INFO: Deploy directory does not exist. No need to Backup anything...") -Foreground Green
			svnCheckout($site)
			
			Write-Host "Determining if Apptype is a Java Application" -Foreground White
			if ($appType -eq "Java"){				
				stopServices
				deployCopy($site)
				deployConfigs($site)
				startServices
			}
			else{
				Write-Host "The Application is not a Java App" -Foreground White
				Write-Host "No need to do anything here. Proceeding to next step..." -Foreground White
				Write-Host #Added for space
				deployCopy($site)
				deployConfigs($site)
			}			
		}
			Write-Host #Added for space
			Write-Host "Deploy Succeded!" -Foreground Green
			$success = $true		
			break;
}		





