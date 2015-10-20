#!/bin/bash

URL=$1
delay=$2
log=$3

echo "HTTP Code,Download Time,Download Size,URL" >>$log

while [ 1 ]
do
	TimeStamp=`date '+%m/%d/%Y %H:%M:%S %p' | tr -d '\n'`
	echo -n $TimeStamp  >> $log
	/usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/predict?prefix=c -o /dev/null 2>&1 >> $log
        echo -n $TimeStamp  >> $log
        /usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/predict?prefix=co -o /dev/null 2>&1 >> $log
        echo -n $TimeStamp  >> $log
        /usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/predict?prefix=com -o /dev/null 2>&1 >> $log
        echo -n $TimeStamp  >> $log
        /usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/predict?prefix=comm -o /dev/null 2>&1 >> $log
        echo -n $TimeStamp  >> $log
        /usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/predict?prefix=comma -o /dev/null 2>&1 >> $log

        echo -n $TimeStamp  >> $log
        /usr/bin/curl -sL -w ",%{http_code},%{time_total},%{size_download},%{url_effective}\n" ${URL}/search?QTEXT=comma -o /dev/null 2>&1 >> $log

	sleep $delay
done

