rem Author: Tin Chu
rem Last Modified:8/19/2014
rem This will sync the Custom farm IIS web servers: tmpcustomweb02p, tmpcustomweb03p, tmpcustomweb04p, tmpcustomweb05p.

cd "c:\Program Files\IIS\Microsoft Web Deploy V3"

@echo -----------------------------
@echo Replicating...
@echo ----------------------------- 
msdeploy -verb:sync -source:apphostconfig="careers.directv.com" -dest:apphostconfig="careers.directv.com",computerName="tmpcustomweb02p" > C:\Logs\Custom_Sync\tmpcustomweb02p.log
msdeploy -verb:sync -source:apphostconfig="careers.directv.com" -dest:apphostconfig="careers.directv.com",computerName="tmpcustomweb03p" > C:\Logs\Custom_Sync\tmpcustomweb03p.log
msdeploy -verb:sync -source:apphostconfig="careers.directv.com" -dest:apphostconfig="careers.directv.com",computerName="tmpcustomweb04p" > C:\Logs\Custom_Sync\tmpcustomweb04p.log
msdeploy -verb:sync -source:apphostconfig="careers.directv.com" -dest:apphostconfig="careers.directv.com",computerName="tmpcustomweb05p" > C:\Logs\Custom_Sync\tmpcustomweb05p.log
@echo -----------------------------
@echo Custom Replication Completed.
@echo -----------------------------
Pause