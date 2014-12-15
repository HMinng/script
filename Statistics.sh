#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)


u=./result/j.tt
r=./result/result.txt

cat $u | while read line;
do
    search=$(echo -n "$line" | awk '{print $2}');
    
    num=$(echo -n "$line" | awk '{print $1}');

    content=$(cat $r | grep $search | tail -n 1 | awk -F'\t' '{print $5}');
    
    echo -e "$num\t$content" >> statistics.tt;
done
