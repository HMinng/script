#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='InboxMsgList'

limit=100

#num=$(mysql -h $ip -u $username -p$password -D $database -A -Ne "select count(*) from $table limit $limit" 2>error.log);

num=1000

for ((i=0; i<$num;)) 
do
    $(mysql -h $ip -u $username -p$password -D $database -A -Ne "select content from $table limit $i,$limit" 2>error.log | 
    while read line; do 
        result=$(echo -n $line | awk -F'\t' '{
        {
            #$0="\047" $0 "\047";
            gsub(/\r/,"\\r");
            gsub(/n/,"\\n");
        }
        {
            print $0;
        }}');

        #echo -n $result | md5 >> ./result/$i.txt;
        echo $result >> ./result/$i.txt;
    done) &

    let "i+=$limit";
done

wait
