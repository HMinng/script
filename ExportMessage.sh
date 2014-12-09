#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='172.16.4.126'
username='msgSEC'
password='CdeT*WiRr$'
database='nmsg_center_5'

startDate='2014-11-24 00:00:00';
endDate='2014-11-25 00:00:00';

limit=500;

for i in {0..99}
do
    if [ $i -lt 10 ]; then
        i=0$i;
    fi

    num=$(mysql -h $ip -u $username -p$password -D $database -A -e "select count(*) from InboxMsgList$i where reservedStr=1010010003 and createDate BETWEEN '$startDate' and '$endDate';" 2>>error.log | sed -n '2p');
   
    j=0;
    while [ $j -lt $num ]
    do
        result=$(mysql -h $ip -u $username -p$password -D $database -A -e "select * from InboxMsgList$i where reservedStr=1010010003 and createDate BETWEEN '$startDate' and '$endDate' limit $j,$limit" 2>>error.log | awk -F'\t' -v limit="$limit" 'BEGIN{data=""}{
            if(NR!=1){
                i=1;
                str2="(";
                while(i<=NF){
                    if(i==NF){
                        if(NR==(limit+1)) {
                            str2=str2"\""$i"\")";
                        }else{
                            str2=str2"\""$i"\"),";
                        }
                    }else{
                        if($i=="NULL"){
                            str2=str2 $i",";
                        }else{
                            str2=str2"\""$i"\",";
                        }   
                    }
                    i++;
                }
                data=data str2
            }else{
                i=1;
                str1="(";
                while(i<=NF){
                    if(i==NF){
                        str1=str1"\`"$i"\`)";
                    }else{
                        str1=str1"\`"$i"\`,";
                    }
                    i++;
                }
            }
        }END{print result="insert into InboxMsgList" str1 " values" data ";"}');
        
        let "j+=$limit";

        echo $result > 1.sql;
        
        mysql -h 192.168.20.43 -u root -pheming -D anti_cheat < 1.sql 2>>error.log;
    done
done
