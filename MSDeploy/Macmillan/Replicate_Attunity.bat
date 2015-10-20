REM - @echo off

REM - Set the current directory of the script before you do anything
set cwd=%cd%

echo ==================================
echo Replicating IIS site configuration
echo ==================================

timeout /t 2

cd "c:\Program Files\IIS\Microsoft Web Deploy V3"

REM - msdeploy -verb:sync -source:apphostconfig="activation.macmillanhighered.com" -dest:apphostconfig="activation.macmillanhighered.com",computername=10.9.212.175 -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Webdeploylogs\ATTUNITY02.log
REM - msdeploy -verb:sync -source:apphostconfig="coresvcs.bfwpub.com" -dest:apphostconfig="coresvcs.bfwpub.com",computername=10.9.212.175 -enableLink:AppPoolExtension -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:HttpCertConfigExtension > C:\Webdeploylogs\ATTUNITY02.log

msdeploy -verb:sync -source:apphostconfig="coresvcs.bfwpub.com" -dest:apphostconfig="coresvcs.bfwpub.com",computername=10.9.212.175 -enableLink:AppPoolExtension > C:\Webdeploylogs\ATTUNITY02.log

cd /d %cwd%

echo ================
echo *** FINISHED ***		
echo ================


timeout /t 2