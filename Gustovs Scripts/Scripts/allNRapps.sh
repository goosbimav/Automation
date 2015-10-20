#!/bin/bash

API_key="44ce8b8ab9fcdfdec951dd044bf47c0d89abba208edd9c4"

#curl -X GET 'https://api.newrelic.com/v2/applications.json'      -H "X-Api-Key:$API_key" -i | tr ',' '\n' | grep "host" | cut -d: -f2 | tr -d '"' | cut -d. -f1
curl -X GET 'https://api.newrelic.com/v2/applications.json'      -H "X-Api-Key:$API_key" -i | tr ',' '\n'
