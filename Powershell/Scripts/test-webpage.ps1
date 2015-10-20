#
# Script: test-webpage.ps1
#
# Purpose: Open a connection to a web page from a remote system to test its
#          availability.
#
#############################################################################

# set the URL to be tested
$urlToBeTested = 'http://www.jobsattmp.com'

# create a new web request object & retrieve the page
$webRequest = [Net.WebRequest]::Create($urlToBeTested)
$response   = $webRequest.GetResponse()

#set the Numeric status code
$StatusCode = [int] $response.StatusCode 

# the statistic is unimportant, so let's get it out of the way now
Write-Host "Statistic: 0"

# test the return (200 = OK, otherwise, fail)
If ($response.StatusCode -eq 200) {
    Write-Host "Status Code: $StatusCode" $response.StatusCode
    Write-Host "SUCCESS, return UP"
    Exit(0)  # success, return UP
} 
Else {
    Write-Host $response.StatusCode
    Write-Host "Status Code: $StatusCode" $response.StatusCode
    Write-Host "FAILURE, return DOWN"
    Exit(1)  # failure, return DOWN
}

PAUSE