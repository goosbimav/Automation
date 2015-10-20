#!/bin/bash

APIKEY="44ce8b8ab9fcdfdec951dd044bf47c0d89abba208edd9c4"

#curl -X GET 'https://api.newrelic.com/v2/servers.json'      -H "X-Api-Key:$APIKEY" -i | tr ',' '\n' | grep "host" | cut -d: -f2 | tr -d '"' | cut -d. -f1 | tr '[:lower:]' '[:upper:]'
#curl -X GET 'https://api.newrelic.com/v2/servers.json'      -H "X-Api-Key:$APIKEY" -i | tr '}' '\n'

echo -e "\n\n\n\n"

SERVERID="4874558"

curl -X GET "https://api.newrelic.com/v2/servers/${SERVERID}/metrics/data.json" -H "X-Api-Key:${APIKEY}" -i -d 'names[]=System/Load&values[]=average_value' 

echo -e "\n\n\n\n"

#CPU
curl -X GET "https://api.newrelic.com/v2/servers/${SERVERID}/metrics/data.xml" -H "X-Api-Key:${APIKEY}" -i -d 'names[]=System/CPU/System/percent&names[]=System/CPU/User/percent&values[]=average_value&summarize=true'


#DISKS

#LIST DISKS

#curl -X GET "https://api.newrelic.com/v2/servers/${SERVERID}/metrics.xml" -H "X-Api-Key:${APIKEY}" -i -d 'name=System/Filesystem' | tr '}' '\n'

# %5e = ^ ; this is the replacement for / in NR
DISK_NAME="%5edata"

curl -X GET "https://api.newrelic.com/v2/servers/${SERVERID}/metrics/data.xml"\
    -H "X-Api-Key:${APIKEY}" -i\
    -d "names[]=System/Filesystem/${DISK_NAME}/Used/bytes&values[]=average_response_time&values[]=average_exclusive_time&summarize=true" | tr '}' '\n

#Total disk space used = <average_response_time> / (1024)**2
#Capacity of the disk = <average_exclusive_time>/ (1024)**2
#Percent disk used = (<average_response_time> / <average_exclusive_time>) * 100



#RAM

#The data for total memory available returned by this API call appears in the values labeled average_exclusive_time. The fields in the database are reused.

curl -X GET "https://api.newrelic.com/v2/servers/${SERVERID}/metrics/data.xml" -H "X-Api-Key:${APIKEY}" -i -d 'names[]=System/Memory/Used/bytes&values[]=average_exclusive_time&summarize=true'



