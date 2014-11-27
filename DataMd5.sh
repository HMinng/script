#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='InboxMsgList'

limit=3;

result=$(mysql -h $ip -u $username -p$password -D $database -A -Ne "select sourceId,destId,content from $table limit $limit" 2>error.log | awk -F'\t' '{
    if(NF==3) {
        $3="\"" $3 "\"";
    }
    {
        print result=$1 $2 $3;
    }
}');

echo $result > result.txt

