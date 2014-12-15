#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

for i in {0..99} 
do 
    if [ $i -lt 10 ]; then 
        i=0$i; 
    fi 
    b=$(mysql -h 172.16.4.126 -u msgSEC -pCdeT*WiRr$ -D nmsg_center_5 -A -e "select count(*) from InboxMsgList$i where reservedStr in (1002010001, 1002040001, 1003010001, 1010010001, 1020010001, 1307010001) and createDate BETWEEN '2014-12-11 00:00:00' and '2014-12-12 00:00:00' and content like '%对你比较有意向加Q聊吧%'" 2>jjj.log); 
    echo $b; 
    echo $i; 
done
