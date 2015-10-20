#!/bin/bash


#curl -X GET 'https://api.newrelic.com/v2/servers.json'      -H 'X-Api-Key:44ce8b8ab9fcdfdec951dd044bf47c0d89abba208edd9c4' -i | tr ',' '\n' | grep -e "host" -e "memory\""
curl -X GET 'https://api.newrelic.com/v2/servers.json'      -H 'X-Api-Key:44ce8b8ab9fcdfdec951dd044bf47c0d89abba208edd9c4' -i | tr ',' '\n'


