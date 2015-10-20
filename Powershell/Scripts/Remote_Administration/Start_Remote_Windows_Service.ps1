#################################################################
##  Powershell command to start a service on a remote computer ##
#################################################################

# List available service on remote machine and there status
#[System.ServiceProcess.ServiceController]::GetServices('ics-webtools-01')

# Start Remote Windows Service
#(new-Object System.ServiceProcess.ServiceController('print spooler','ics-webtools-01')).Start()

# Start Remote Windows Service
#Get-Service -ComputerName dtpsw101.prod.corp.ad1 -Name TermService | Stop-Service -Verbose
Get-Service -ComputerName dtpsw101.prod.corp.ad1 -Name TermService | Start-Service -Verbose /user:gsbirakisad

PAUSE