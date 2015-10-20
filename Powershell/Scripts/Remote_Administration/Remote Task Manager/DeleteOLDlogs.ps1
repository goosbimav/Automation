# This script will DELETE Any Logs that are older than 3 months 

#Set-ExecutionPolicy remotesigned
#Set-ExecutionPolicy Unrestricted

#Define directories to use as variables
$IISDir = "S:\Logs"
$LogstashSDir = "S:\logstash"

#$IISDir = "c:\Logs"
#$LogstashDir = "c:\Logstash"

#Add list of directories here
$ListOfDir = $IISDir, $LogstashDir

foreach ($Log in $ListOfDir) {

	#Only include files that are of type ".log"
	get-childitem -Path $Log -recurse -include *.log |

	#Set retention period here and action for logfiles
	where-object {$_.lastwritetime -lt (get-date).addDays(-90)} |
	Foreach-Object { del $_.FullName }
	
}