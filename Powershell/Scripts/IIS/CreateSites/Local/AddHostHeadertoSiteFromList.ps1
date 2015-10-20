import-module WebAdministration
#Pipe in a list of sites from a text file
$Directory = "C:\Scripts\Lists\ListOfSites.txt"
$ListOfSites = Get-Content $Directory | Where {$_ -notmatch '^\s+$'}

#Adding a list of Site Binding
foreach ($Site in $ListOfSites) {
New-WebBinding -Name "SEOSiteClusterQA" -IPAddress "*" -Port 80 -HostHeader $Site
}

#Removing a list of Site Binding
#foreach ($Site in $ListOfSites) {
#Remove-WebBinding -Name "SeoSiteCluster" -Port 80 -IPAddress "*" -HostHeader $Site
#}

#Check to see if bindings are there
#Get-WebBinding -Name gustest2