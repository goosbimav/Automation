#!/bin/bash

API_key="44ce8b8ab9fcdfdec951dd044bf47c0d89abba208edd9c4"

curl -H "x-api-key:$API_key" -d "deployment[app_name]=CoreSvcs QA" -d "deployment[description]=Gus* is awesome" https://api.newrelic.com/deployments.xml
