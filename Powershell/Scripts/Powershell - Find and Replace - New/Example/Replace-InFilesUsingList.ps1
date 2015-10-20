Param (
	[String]$List = "UNIV_MIGRATION\UnivMIGRATION.csv",
	#[String]$List = "IXADMIN_STAGE\IXADMIN_STAGEconfig.csv",
    #[String]$List = "FNIC\FNICconfig.csv",
	#[String]$List = "DR\DRUnivPROXY.csv
	#[String]$List = "TEST\TESTUnivPROXY.csv",
    #[String]$Files = ".\Files\*.*"
	#[String]$Files = "F:\Scripts\DR Test\ZeusProxy\conf\"
	#[String]$Files = "F:\NewBuilds\DR\Universals\Jupiterproxy01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\Universals\Jupiterproxy02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\Universals\Jupiterweb01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\Universals\Jupiterweb02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\DSS\Neptuneproxy01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\DSS\Neptuneproxy02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\DSS\Neptuneweb01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\DSS\Neptuneweb02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\DSS\Neptuneweb03\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusproxy01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusproxy02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusweb01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusweb02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusweb03\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\CRU\Venusweb04\Apache\conf"
	#[String]$Files = "F:\NewBuilds\DR\ixConfig\ixconfig\ics"
	#[String]$Files = "F:\NewBuilds\DR\ixConfig\ixconfig\dss"
	#[String]$Files = "F:\NewBuilds\DR\ixConfig\ixconfig\cru"
	#[String]$Files = "F:\NewBuilds\DR\ixConfig\ixconfig\cru-4"
	#[String]$Files = "F:\NewBuilds\Test\Universals\Amarilloproxy01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\Universals\Amarilloproxy02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\Universals\Amarilloweb01\Apache\conf\vhosts"
	#[String]$Files = "F:\NewBuilds\Test\Universals\Amarilloweb02\Apache\conf\vhosts"
	#[String]$Files = "F:\NewBuilds\Test\DSS\Bravoproxy01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\DSS\Bravoproxy02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\DSS\Bravoweb01\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\DSS\Bravoweb02\Apache\conf"
	#[String]$Files = "F:\NewBuilds\Test\ixConfig\ixconfig\ics"
	#[String]$Files = "F:\NewBuilds\Test\ixConfig\ixconfig\dss\staging"
	#[String]$Files = "F:\NewBuilds\Test\ixConfig\ixconfig\cru-4\staging"
	#[String]$Files = "\\Web_deploy_02.opd.com\c$\NewBuilds\TEST\Universals\Amarilloproxy02\inetpub"
	#[String]$Files = "\\Web_deploy_02.opd.com\c$\NewBuilds\TEST\Universals\Amarilloweb02\inetpub"
	#[String]$Files = "F:\NewBuilds\Stage\FNIC\ALEXANDERPROXY02\Apache\conf\"
	#[String]$Files = "F:\NewBuilds\Stage\FNIC\ALEXANDERWEB02\Apache\conf\"
	#[String]$Files = "F:\NewBuilds\Stage\ixConfig\fnic-1"
	#[String]$Files = "F:\NewBuilds\Test\Universals"
	#[String]$Files = "\\ANDERSONWEB01.opd.com\c$\inetpub\ixconfig\fnic-1\staging"
	#[String]$Files = "F:\NewBuilds\WEB_PROD_05\ixconfig\IXADMIN_STAGE"	
	[String]$Files = "G:\SkyDrive\Insight Catastrophe Group\IT Stuff\ICG IT Stuff\Project List\Virginia\PROD\UNIV\Scripts\Conf\ixconfig\New"
	#[String]$Files = "G:\SkyDrive\Insight Catastrophe Group\IT Stuff\ICG IT Stuff\Project List\Virginia\PROD\UNIV\Scripts\Conf\ixconfig\New\Virginia"
	
		
)
$ReplacementList = Import-Csv $List;
#Get-ChildItem $Files -recurse -include *.conf |
Get-ChildItem $Files -recurse -include *.conf, *.xml, *.ini, *.json, *.html, *.js, *.txt, *.new, *.php, *.htaccess, *.config |
ForEach-Object {
    $Content = Get-Content -Path $_.FullName;
    foreach ($ReplacementItem in $ReplacementList)
    {
        #$Content = $Content.Replace($ReplacementItem.OldValue, $ReplacementItem.NewValue)
		$old = $ReplacementItem.OldValue
		$new = $ReplacementItem.NewValue
			$Content = $Content -Replace "$old", "$new"
    }
    Set-Content -Path $_.FullName -Value $Content
}