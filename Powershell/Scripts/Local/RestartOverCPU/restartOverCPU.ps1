$otherServer="192.168.225.15"

$CPU_Limit="0"
$timeSpan="6" #averige of 5 min

$delayIfOtherServerNotPingable="18" # 3 min





$PSEmailServer="10.249.0.12"
send-mailmessage -from "Von Roth, Gustav <Gustav.VonRoth@macmillan.com>" -to "Von Roth, Gustav <Gustav.VonRoth@macmillan.com>" -subject "test1" -body "TEST1"


#########

$cpuutil=(get-counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples $timeSpan |
    select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average

echo "CPU: $cpuutil"



IF ($cpuutil -ge $CPU_Limit)
{
	IF(!(Test-Connection -Cn $otherServer -BufferSize 16 -Count 1 -ea 0 -quiet))
	{
		echo "Problem connecting to $otherServer.  Sleeping for $delayIfOtherServerNotPingable sec and then rebooting"

		IF( ((get-counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples $delayIfOtherServerNotPingable |
			select -ExpandProperty countersamples | select -ExpandProperty cookedvalue |
			Measure-Object -Average).average) -ge $CPU_Limit )
		
		{
			echo "too long... rebooting $env:computername"
			# restart-computer
		}
	}
				
	ELSE {
		"Connected to other server $otherServer. Rebooting $env:computername now"
		#restart-computer 
	} #end if\
}


#Restart-Service MyService1, "MyService2", MyService3




