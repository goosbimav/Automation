#Utilizes WMI to get CPU, Memory, Disk, etc stats from a list of Windows Servers and output it into a CSV file
#!/bin/bash

#set -E

#set -x

OUTFILE="./complete.csv"

IFS=$'\n'
for server in `cat Servers.csv`
do
        HOST=$( echo $server | cut -d',' -f1)
        IP=$( echo $server | cut -d',' -f3)
        OS=$( echo $server | cut -d',' -f7)
        DOMAIN=$( echo $server | cut -d',' -f9)

        if  grep -q ${HOST} ${OUTFILE} ; then
                echo "$HOST,$IP - Exists in ${OUTFILE}"
        else
                if test "$OS" = "Windows"; then
                        if test "$DOMAIN" = "hbpna";then
                                echo -n -e "$HOST,$IP"

                                user=———————————                                pass=———————
                                cpuMinusOne=$(/bin/wmic -U hbpna/${user}%${pass} //${IP} "SELECT Name FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name <> '_Total'" | tail -1)
                                cpuNumber=$(($cpuMinusOne + 1))

                                mem=$(/bin/wmic -U hbpna/${user}%${pass} //${IP} "SELECT TotalVisibleMemorySize FROM Win32_OperatingSystem" | tail -1)
                                if echo $mem | grep -q "Microsoft" ;then
                                        memory=$(echo $mem | cut -d'|' -f4)
                                else
                                        memory=$mem
                                fi

                                #memGb=$(($memory / 1024))
                                #echo -n -e "$memory,"
                                disks=$(/bin/wmic -U hbpna/${user}%${pass} //${IP} 'SELECT DeviceID,Size,VolumeName FROM Win32_LogicalDisk WHERE DriveType=3' | tr '\n' ';' |cut -d';' -f3- )
                                size=0
                                IFS=$';'
                                for disk in $disks
                                do
                                        bytes=$(echo $disk | cut -d'|' -f2)
                                        size=$(($bytes + $size))

                                done
                                echo "$HOST,$IP,${cpuNumber},${memory},${size},${disks}" >> ${OUTFILE}
                                echo ",${cpuNumber},${memory},${size},${disks}"
                        fi
                fi
        fi

done