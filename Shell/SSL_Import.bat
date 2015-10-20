cd "c:\Program Files\IIS\Microsoft Web Deploy V3"

msdeploy -verb:sync -source:metakey=lm/w3svc/561,computername=tmpprod104 -dest:metakey=lm/w3svc/561 > mytest1.log
msdeploy -verb:sync -source:metakey=lm/w3svc/562,computername=tmpprod104 -dest:metakey=lm/w3svc/562 > mytest2.log
msdeploy -verb:sync -source:metakey=lm/w3svc/563,computername=tmpprod104 -dest:metakey=lm/w3svc/563 > mytest3.log