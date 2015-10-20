import-module WebAdministration
#Pipe in a list of sites from a text file
$Directory = "U:\TMP\E-stuff\Scripting\Powershell\Scripts\IIS\CreateSites\Remote\ListOfSites.txt"
$ListOfSites = Get-Content $Directory | Where {$_ -notmatch '^\s+$'}

#Adding a list of Site Binding
#$AddSites = Invoke-Command -ComputerName TMPTBWEB12P {foreach ($Site in $ListOfSites) {Import-Module WebAdministration; New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site}}
#$AddSites.value

#foreach ($Site in $ListOfSites) {
#Invoke-Command -ComputerName TMPTBWEB12P Import-Module WebAdministration; (New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site)
#}

$command = foreach ($Site in $ListOfSites) {New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader $Site}
#Invoke-Command -ComputerName TMPTBWEB12P -ScriptBlock {$command}
#Invoke-Command -ComputerName TMPTBWEB12P -Script {$command}
Invoke-Command -FilePath U:\TMP\E-stuff\Scripting\Powershell\CreateSitesFromList.ps1 -ComputerName TMPTBWEB12P 


#Removing a list of Site Binding
#foreach ($Site in $ListOfSites) {
#Remove-WebBinding -Name "SeoSiteCluster" -Port 80 -IPAddress "*" -HostHeader $Site
#}

#Check to see if bindings are there
#Get-WebBinding -Name gustest2