cd C:\WINdows\system32\inetsrv

Appcmd add vdir /app.name:"seositeclusterqa"/ /path:/m /physicalPath:D:\p4\Deployment.TMPPRODCLUSTER\AdCommsNA\dev\Product\TalentBrew\TB4.0\web\SeoSiteMobile
appcmd add app /site.name:"seositeclusterqa" /path:/m /physicalPath:"D:\p4\Deployment.TMPPRODCLUSTER\AdCommsNA\dev\Product\TalentBrew\TB4.0\web\SeoSiteMobile" 

Appcmd add vdir /app.name:"SeoSiteCluster RoundRobin"/ /path:/m /physicalPath:D:\p4\Deployment.TMPPRODCLUSTER\AdCommsNA\dev\Product\TalentBrew\TB4.0\web\SeoSiteMobile
appcmd add app /site.name:"SeoSiteCluster RoundRobin" /path:/m /physicalPath:"D:\p4\Deployment.TMPPRODCLUSTER\AdCommsNA\dev\Product\TalentBrew\TB4.0\web\SeoSiteMobile" 

