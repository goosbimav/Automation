#################################################################
##  Powershell command to start a service on a remote computer ##
#################################################################

# List available service on remote machine and there status
#[System.ServiceProcess.ServiceController]::GetServices('DTPSW101')

# Stop Remote Windows Service
#(new-Object System.ServiceProcess.ServiceController('TermService','DTPSW101')).Stop()

# Stop Remote Windows Service
#Get-Service -ComputerName $Server -Name $serviceName | Stop-Service -Verbose
Get-Service -ComputerName dtpsw101.prod.corp.ad1 -Name TermService | Stop-Service -Verbose /user:gsbirakisad

PAUSE