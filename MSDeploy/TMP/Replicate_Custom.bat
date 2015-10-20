rem Author: Tin Chu
rem Last Modified:8/19/2014
rem This will sync the Custom farm IIS web servers: tmpcustomweb02p, tmpcustomweb03p, tmpcustomweb04p, tmpcustomweb05p.

cd "c:\Program Files\IIS\Microsoft Web Deploy V3"

@echo -----------------------------
@echo Replicating...
@echo ----------------------------- 
msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb02p" -disableLink:ContentExtension > C:\Logs\Custom_Sync\tmpcustomweb02p.log
msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb03p" -disableLink:ContentExtension > C:\Logs\Custom_Sync\tmpcustomweb03p.log
msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb04p" -disableLink:ContentExtension > C:\Logs\Custom_Sync\tmpcustomweb04p.log
msdeploy -verb:sync -source:webserver -dest:webserver,computerName="tmpcustomweb05p" -disableLink:ContentExtension > C:\Logs\Custom_Sync\tmpcustomweb05p.log
@echo -----------------------------
@echo Custom Replication Completed.
@echo -----------------------------
Pause