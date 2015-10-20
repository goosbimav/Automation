#!/bin/bash

SERVER=$1
PORT=$2
USERNAME=$3
PASSWORD=$4

ENDPOINT="http://${SERVER}:${PORT}"

GET_AUTH=`curl -sLm 10 -w "%{http_code}\\n" -X POST "${ENDPOINT}/rest/user/process_login?username=${USERNAME}&amp;password=${PASSWORD}" -c /etc/nagios/tmp/cookie.txt -o /dev/null`
if [[ $GET_AUTH -eq 200 ]]; then
        GET_STATUS=`curl -sLm 10 -w "%{http_code}\\n" -X POST "${ENDPOINT}/rest/products/list" -b /etc/nagios/tmp/cookie.txt -o /dev/null`
        if [[ $GET_STATUS -eq 200 ]]; then
                CHECK="OK"
        fi
        rm /etc/nagios/tmp/cookie.txt
else
        CHECK="Failed"
fi

if [[ "$CHECK" == "OK" ]]; then
   echo "SERVICE OK"
   exit 0
elif [[ "$CHECK" == "Failed" ]]; then
   echo "Service not working: ${SERVER}"
   exit 2
else
   echo "Check failed"
   exit 3
fi
