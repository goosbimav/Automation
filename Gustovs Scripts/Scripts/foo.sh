#!/bin/bash

URL="http://www.macmillanhighered.com/externals/beingmetasearch/whxbook/predict?prefix=com"

/usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}" $URL -o /dev/null 2>&1
