cd "c:\Program Files\IIS\Microsoft Web Deploy V3"
@echo -----------------------------
@echo Replicating...
@echo ----------------------------- 

#---------  Production ------------
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB02P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB02P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB03P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB03P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB04P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB04P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB05P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB05P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB06P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB06P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB07P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB07P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB08P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB08P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB09P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB09P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB10P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB10P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB11P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB11P.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB12P -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB12P.log

#----------------  Staging ---------------------
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB01S -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB01s.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTBWEB02S -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTBWEB02s.log

#-------------  QA  -------------------
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTB101Q -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTB101Q.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTB102Q -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTB102Q.log

#------------  Dev  ----------------
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTB101D -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTB101D.log
msdeploy -verb:sync -source:apphostconfig="jobs.pizzahut.com" -dest:apphostconfig="jobs.pizzahut.com",computername=TMPTB102D -disablelink:contentextension -disablelink:FrameworkConfigExtension -disablelink:CertificateExtension -disablelink:AppPoolExtension -disablelink:HttpCertConfigExtension > C:\Logs\pizzahut\TMPTB102D.log

@echo -----------------------------
@echo Replication Completed.
@echo -----------------------------
Pause