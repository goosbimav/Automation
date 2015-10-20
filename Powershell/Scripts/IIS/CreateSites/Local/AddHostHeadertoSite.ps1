
import-module WebAdministration

#Adding a new Site Binding
New-WebBinding -Name "SeoSiteCluster" -IPAddress "*" -Port 80 -HostHeader gustest.tmpseoqa.com

#Removing a new Site Binding
#Remove-WebBinding -Name "SeoSiteCluster" -Port 80 -IPAddress "*" -HostHeader gustest2

#Check to see if bindings are there
#Get-WebBinding -Name gustest2

#Add a completely new site
#New-Website -name "[name]" -HostHeader "[www.example.com]" -PhysicalPath "[c:\inetpub\example.com\]"