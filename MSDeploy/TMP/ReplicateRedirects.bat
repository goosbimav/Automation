rem Author: Tin Chu
rem Last Modified:9/24/2013
rem This will sync the redirect farm IIS web server, tmpredirect01, tmpredirect02, tmpredirect03
msdeploy.exe -verb:sync -source:webserver -dest:webserver,computerName="tmpredirect02" >tmpredirect02.log
msdeploy.exe -verb:sync -source:webserver -dest:webserver,computerName="tmpredirect03" >tmpredirect03.log
Pause