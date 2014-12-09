#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='normal'

file=dict.tt

sort -k1n $file | uniq | while read line; 
do 
    result=$(echo -n "'$line'" | awk -F'\t' '{
    {
        gsub(/\r/,"\\r");
        gsub(/n/,"\\n");
    }
    {
        print $1;
    }}');

    encryption=$(echo -n $result | md5);

    date=$(date '+%s');

    mysql -h $ip -u $username -p${password} -D $database -e "insert into ${table}(content, uniqe_code, gmt_created) value('$line', '$encryption', $date)" 2>>error.log;
done
