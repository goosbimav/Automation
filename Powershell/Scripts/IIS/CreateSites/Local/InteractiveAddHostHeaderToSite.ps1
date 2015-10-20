# This script will create a new host header to a site in IIS. 

Write-Output " "
Write-Output "-------------------------------------------------------------"
Write-Host "This script will ADD a host header to an existing site in IIS" -foreground green
Write-Output "-------------------------------------------------------------"
Write-Output " "
Write-Output " "

Import-Module WebAdministration

$HostHeader = Read-Host "Please enter the new host header to add"
$SiteName = Read-Host "Please enter the name of the site to add the host header"
#$ServerName = "TMPTBWEB02P", "TMPTBWEB03P", "TMPTBWEB04P", "TMPTBWEB05P", "TMPTBWEB06P", "TMPTBWEB07P", "TMPTBWEB08P", "TMPTBWEB09P", "TMPTBWEB10P", "TMPTBWEB11P", "TMPTBWEB12P", "TMPTBWEB01S", "TMPTBWEB02S", "TMPTB101D", "TMPTB102D", "TMPTB101Q", "TMPTB102Q"  
$ServerName = "TMPTBWEB11P"
$WebDeployLog = "C:\Webdeploylogs\$SiteName\Prod\" + $ServerName + ".log"
$MsDeployCommand = & "c:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe" "-verb:sync" "-source:apphostconfig=$SiteName" "-dest:apphostconfig=$SiteName,computername=$ServerName" "-disablelink:contentextension" "-disablelink:FrameworkConfigExtension" "-disablelink:CertificateExtension" "-disablelink:AppPoolExtension" "-disablelink:HttpCertConfigExtension" > $WebDeployLog


if(!(Test-Path ("IIS:\Sites\" + $HostHeader)))
{
   	Write-Output " "
	Write-Output " "
	Write-Host "... The Host Header does NOT Exits! ..." -foreground blue
	Write-Output " "
}
else
{
	Write-Output " "
	Write-Host "... CANNOT ADD Host Header. It already EXISTS! ..." -foreground red
	Write-Output " "
}	

#Summary Of Changes:
Write-Output " "
Write-Output " "
Write-Host "Summary Of Changes:" -foreground green
Write-Output "-------------------"
Write-Output " "
Write-Host "Host Header Name: " -foreground green -NoNewline 
Write-Host $HostHeader -foreground white
Write-Host "Site to add Host Header: " -foreground green -NoNewline
Write-Host $SiteName -foreground white 
Write-Output " "
Write-Output "..."
Write-Output " "
Write-Host "Press any key to continue with these changes..."
Write-Output " "
$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


#Function to replicate changes to Server Farm
function ReplicateSites ($SiteName, $ServerName)
{

	cd "c:\Program Files\IIS\Microsoft Web Deploy V3"
	
	#invoke-expression msdeploy -verb:sync -source:apphostconfig="$($SiteName)" -dest:apphostconfig="$($SiteName)",computername=$ServerName -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > $WebDeployLog
	#invoke-expression $MsDeployCommand
	$MsDeployCommand
}

#Check to see if the site exits. If it does not exist then add a completely new site
if(!(Test-Path ("IIS:\Sites\" + $HostHeader)))
{
    New-WebBinding -Name $SiteName -IPAddress "*" -Port 80 -HostHeader $HostHeader
	 
	Write-Output " " 
	Write-Output " "
	Write-Host "..."$HostHeader "has been ADDED to IIS" "..." -foreground blue
	Write-Output " "
	Write-Output " "
	
	Write-Output " "
	Write-Host "Press any key to continue..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

else
{
	Write-Output " "
	Write-Host "... CANNOT ADD Host Header. It already EXISTS! ..." -foreground red
	Write-Output " "
}

#Replicate Sites out using the Appcmd based on Site
If ($SiteName -eq 'seositecluster')
{
	Write-Output " "
	Write-Output " "
	Write-Output "---------------------------------------------------"
	Write-Host "Replicating" Seositecluster "Changes to Server Farm:" -foreground green
	Write-Output "---------------------------------------------------"
	Write-Output "..."
	Write-Output " "

	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	#Replicate Sites to Server Farm
	ReplicateSites ($SiteName, $ServerName)
}

ElseIf ($SiteName -eq 'SEOSiteClusterQA')
{
	Write-Output " "
	Write-Output " "
	Write-Output "-----------------------------------------------------"
	Write-Host "Replicating" SEOSiteClusterQA "Changes to Server Farm:" -foreground green
	Write-Output "-----------------------------------------------------"
	Write-Output "..."
	Write-Output " "

	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	#Replicate Sites to Server Farm
	ReplicateSites ($SiteName, $ServerName)
}

ElseIf ($SiteName -eq 'SeoSiteRedirect')
{
	Write-Output " "
	Write-Output " "
	Write-Output "----------------------------------------------------"
	Write-Host "Replicating" SeoSiteRedirect "Changes to Server Farm:" -foreground green
	Write-Output "----------------------------------------------------"
	Write-Output "..."
	Write-Output " "

	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	#Replicate Sites to Server Farm
	ReplicateSites ($SiteName, $ServerName)
}

ElseIf ($SiteName -eq 'TB-Akamai')
{
	Write-Output " "
	Write-Output " "
	Write-Output "----------------------------------------------"
	Write-Host "Replicating" TB-Akamai "Changes to Server Farm:" -foreground green
	Write-Output "----------------------------------------------"
	Write-Output "..."
	Write-Output " "

	Write-Output " "
	Write-Host "Press any key to continue with these changes..."
	Write-Output " "
	$Pause = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

	#Replicate Sites to Server Farm
	ReplicateSites ($SiteName, $ServerName)
}
else
{ 
	Write-Host -BackgroundColor White -ForegroundColor Red "INVALID ENTRY! Please try again."
}


