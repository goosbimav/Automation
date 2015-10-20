#!/bin/bash


host=$1
pass=

hostname=`sshpass -p $pass ssh -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$host "hostname" 2>/dev/null`
if [ -z "$hostname" ]; then
	echo "Could not connect to $host"
else

	shares=`sshpass -p $pass ssh -o ConnectTimeout=10 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$host "cat /etc/fstab | grep cifs" 2>/dev/null`
	if [ ! -z "$shares" ] ; then
		IFS=$'\n'
		for share in $shares
		do
			echo -n "$hostname has share: " | tee -a list
			echo $share | tee -a list
		done
	else
		echo "$hostname has no shares"
	fi
fi
