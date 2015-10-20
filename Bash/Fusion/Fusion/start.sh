#!/bin/bash

sudo service fusion-solr start
sleep 30
sudo service fusion-ui start
sleep 5
sudo service fusion-connectors start
sleep 5
sudo service fusion-api start
