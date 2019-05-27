#!/bin/bash

#host='10.198.72.92'
#user='admin'
#passwd='Admin#123'
host=$1
user=$2
passwd=$3

ipmitool -I lanplus -H ${host} -U ${user} -P ${passwd} sdr | awk -F"|" '{print $1}' > ipmi_sensor_id.txt
grep "_" ipmi_sensor_id.txt > test_test
if [ `cat test_test | wc -l` -eq 0 ];then
    sed -i 's/ *$//g' ipmi_sensor_id.txt
    sed -i 's/ /_/g' ipmi_sensor_id.txt
fi

sensor_id=(`cat ipmi_sensor_id.txt`)
sensor_num=(`ipmitool -I lanplus -H ${host} -U ${user} -P ${passwd} sdr | wc -l`)

id_data_str=''

for (( i = 0; i < sensor_num; i++ )); 
do
	id_data_str=${id_data_str}"\t\t{\"{#SENSOR-ID-NAME}\":\"${sensor_id[i]\"},\n"
done

printf "{\n" >/tmp/DELL_ipmi_sensor_data.log
        printf  '\t'"\"data\":[\n" >>/tmp/DELL_ipmi_sensor_data.log
printf ${id_data_str%,*} >>/tmp/DELL_ipmi_sensor_data.log
        printf  "\n\t]\n" >>/tmp/DELL_ipmi_sensor_data.log
printf "}\n" >>/tmp/DELL_ipmi_sensor_data.log

if [ `cat test_test | wc -l` -ne 0 ];then
    cat /tmp/DELL_ipmi_sensor_data.log
else
    sed -i 's/_/ /g' /tmp/DELL_ipmi_sensor_data.log
    cat /tmp/DELL_ipmi_sensor_data.log
fi

