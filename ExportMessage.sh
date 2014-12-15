#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='172.16.4.126'
username='msgSEC'
password='CdeT*WiRr$'
database='nmsg_center_5'

startDate='2014-12-11 00:00:00';
endDate='2014-12-12 00:00:00';

limit=500;

#主站打招呼
#where='reservedStr=1010010003';

#主站、3g手写信
where='reservedStr in (1002010001, 1002040001, 1003010001, 1010010001, 1020010001, 1307010001)';


for i in {0..99}
do
    if [ $i -lt 10 ]; then
        i=0$i;
    fi
    mysql -h $ip -u $username -p$password -D $database -A -e 'set names utf8' 2>>error.log;

    num=$(mysql -h $ip -u $username -p$password -D $database -A -e "select count(*) from InboxMsgList$i where $where and createDate BETWEEN '$startDate' and '$endDate';" 2>>error.log | sed -n '2p');
    
    j=0;
    while [ $j -lt $num ]
    do
        result=$(mysql -h $ip -u $username -p$password -D $database -A -e "select * from InboxMsgList$i where $where and createDate BETWEEN '$startDate' and '$endDate' limit $j,$limit" 2>>error.log | awk -F'\t' -v limit="$limit" 'BEGIN{data=""}{
            gsub(/\\\\/,"\\");
            if(NR!=1){
                i=1;
                str2="(";
                while(i<=NF){
                    if(i==NF){
                        str2=str2"'\''"$i"'\''),";
                    }else{
                        if($i=="NULL"){
                            str2=str2 $i",";
                        }else{
                            str2=str2"'\''"$i"'\'',";
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
        }END{print result="insert into InboxMsgList" str1 " values" data}');
        
        let "j+=$limit";

        result=${result%,}";";

        echo $result > 1.sql;

        mysql -u 127.0.0.1 -u root -pheming -D anti_cheat -A -e "set names utf8" 2>>error.log;
        #mysql -h 192.168.20.43 -u root -pheming -D anti_cheat < 1.sql 2>>error.log;
        mysql -h 127.0.0.1 -u root -pheming -D anti_cheat < 1.sql 2>>error.log;

        if [ $? -ne 0 ]; then
            echo -n $result >> error.sql
            echo -e "\r\n\r\n\r\n">> error.sql;
        fi
    done
done
