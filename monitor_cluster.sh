#!/bin/bash

while read line; do
    ssh -t $line "
    sudo ntpd -q;
    nohup python ~/sverma11/Monitoring/monitor.py ~/sverma11/LOGS/$1.csv &
    sleep 0.1
    cat /tmp/monitor_pid.txt
    " < /dev/null &
done < ~/machines
shift
sleep 1 && $@ && sleep 2
while read line; do
    ssh -t $line "
    echo \"kill \$(cat /tmp/monitor_pid.txt)\"
    kill \$(cat /tmp/monitor_pid.txt)
    " < /dev/null
done < ~/machines
