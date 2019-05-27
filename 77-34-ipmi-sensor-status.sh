#!/bin/bash

sensor_id=$1
#host='10.198.77.34'
#user='admin'
#passwd='admin#123'
host=$2
user=$3
passwd=$4

sensor_data=(`ipmitool -I lanplus -H ${host} -U ${user} -P ${passwd} sdr get "${sensor_id}" | grep "Status" | awk '{print $3}'`)

echo ${sensor_data}

