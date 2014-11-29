#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='InboxMsgList'

limit=100000

num=$(mysql -h $ip -u $username -p$password -D $database -A -Ne "select count(*) from $table" 2>error.log);

for ((i=0; i<$num;)) 
do
    $(mysql -h $ip -u $username -p$password -D $database -A -Ne "select id, sourceId, destId, reservedStr, content from $table limit $i,$limit" 2>error.log | 
    while read line; do 
        result=$(echo -n "'$line'" | awk -F'\t' '{
        {
        #    #$0="\047" $0 "\047";
            gsub(/\r/,"\\r");
            gsub(/n/,"\\n");
        }
        {
            print $5;
        }}');

        qq=$(echo -n $result | grep -Eo "[0-9⒋⒌⒍⒐⒎]+");
        
        if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
            encryption=$(echo -n $result | md5)
        else
            qq=$(echo -n $qq | sed 's/[[:space:]]//g');
            encryption=$(echo -n $qq | md5);
        fi 
        
        if [ -f "./result/$i.txt" ]; then
            isExists=$(grep -o $encryption ./result/$i.txt);
        fi

        if [ -z "$isExists" ]; then
            echo -en "$line\t" >> ./result/$i.txt;

            if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
                echo -en "as content" >> ./result/$i.txt;
            else
                echo -en "$qq\t" >> ./result/$i.txt;
            fi

            echo $encryption >> ./result/$i.txt;
        fi
    done) &

    let "i+=$limit";
done

wait

cat ./result/*.txt > ./result/result.txt
