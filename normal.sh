#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='172.16.4.224'
username='anti_cheat_w'
password='nti#_#cheaw'
database='anti_cheat'
port=3307
table='normal'

file=dict.tt

sort -k1n $file | uniq | while read line; 
do 
    result=$(echo -n "$line" | awk -F'\t' '{
    {
        gsub(/\r/,"\\r");
        gsub(/n/,"\\n");
    }
    {
        print $1;
    }}');

    encryption=$(echo -n $result | md5);
#    echo -e "$encryption" >> dict1.tt;
    date=$(date '+%s');

    mysql -h $ip -u $username -p${password} -D $database -P $port -e "insert into ${table}(content, uniqe_code, gmt_created) value('$line', '$encryption', $date)" 2>>error.log;
done
