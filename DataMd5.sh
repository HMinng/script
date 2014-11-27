#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='InboxMsgList'

limit=3;

mysql -h $ip -u $username -p$password -D $database -A -Ne "select content from $table limit $limit" 2>error.log | 
awk -F'\t' '{
    if(NR==NR) {
        #$0="\047" $0 "\047";
        gsub(/\r/,"\\\\r\\");
    }
    {
        print $0;
    }
}' > result.txt

#cat result.txt |  while read line ; do php -r 'echo md5($line);'>>result.txt;  done
cat result.txt |  while read line ; do echo -n $line | md5 >>result.txt;  done
