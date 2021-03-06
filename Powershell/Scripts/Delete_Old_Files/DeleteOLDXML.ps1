# This script will DELETE Any Logs that are older than 3 months 

#Set-ExecutionPolicy remotesigned
#Set-ExecutionPolicy Unrestricted

#Define directories to use as variables
$IISDir = "S:\Deployments\PROD\PxHTS\2015.02.04.192\htsplayer\session"

#Add list of directories here
$ListOfDir = $IISDir

foreach ($Log in $ListOfDir) {

	#Only include files that are of type ".log"
	get-childitem -Path $Log -recurse -include *.xml |

	#Set retention period here and action for logfiles
	where-object {$_.lastwritetime -lt (get-date).addDays(-15)} |
	Foreach-Object { del $_.FullName }
	
}