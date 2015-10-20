cd "c:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

msdeploy -verb:sync -source:apphostconfig="PX" -dest:apphostconfig="PX",computername=HBEUPXBCS04 -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Webdeploylogs\PX\Prod\HBEUPXBCS04.log

