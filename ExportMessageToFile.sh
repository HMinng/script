#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='172.16.4.126'
username='msgSEC'
password='CdeT*WiRr$'
database='nmsg_center_5'

startDate='2015-01-01 00:00:00';
endDate='2015-01-23 00:00:00';

limit=700000;

#主站打招呼
#where='reservedStr=1010010003';

#主站、3g手写信
where='reservedStr in (1002010001, 1002040001, 1003010001, 1010010001, 1020010001, 1307010001, 1013010050, 1020010001, 1408010001)';


for i in {11..40}
do
    if [ $i -lt 10 ]; then
        i=0$i;
    fi

#    num=$(mysql -h $ip -u $username -p$password -D $database -A -N -e "select count(*) from InboxMsgList$i where $where and createDate BETWEEN '$startDate' and '$endDate';" 2>>error.log);
    
#    j=0;
    
#    while [ $j -lt $num ]
#    do
#        mysql -h $ip -u $username -p$password -D $database -A -N -e "set names utf8;select * from InboxMsgList$i where $where and createDate BETWEEN '$startDate' and '$endDate' limit $j,$limit" >> ./result/data.tt 2>>error.log
        mysql -h $ip -u $username -p$password -D $database -A -N -e "set names utf8;select * from InboxMsgList$i where $where and createDate BETWEEN '$startDate' and '$endDate' limit 0,$limit" >> ./result/data.tt 2>>error.log
    done
done
