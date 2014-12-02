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

        qq=$(echo -n $result | grep -Eo "[0-9⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑①②③④⑤⑥⑦⑧⑨⑩⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽❶❷❸❹❺❻❼❽❾❿㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ１２３４５６７８９０一二三四五六七八九零壹贰叁肆伍陆柒捌玖]+");
        
        if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
            encryption=$(echo -n $result | md5)
        else
            qq=$(echo -n $qq | sed 's/[[:space:]]//g');
            encryption=$(echo -n $qq | md5);
        fi 
        
        if [ -f "./result/$i.txt" ]; then
            isExists=$(cat ./result/$i.txt | grep -o $encryption);
        else
            isExists="";
        fi

        if [ -z "$isExists" ]; then
            echo -en "$line" >> ./result/$i.txt;
            
            if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
                echo -en "\tas content\t" >> ./result/$i.txt;
            else
                echo -en "\t$qq\t" >> ./result/$i.txt;
            fi

            echo $encryption >> ./result/$i.txt;
        else
            echo $encryption >> ./result/encryption.tt;
        fi
    done) &

    let "i+=$limit";
done

wait

cat ./result/*.txt > ./result/result.txt
