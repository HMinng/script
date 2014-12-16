#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)


g=./result/tt/g.tt
h=./result/tt/h.tt
dict=./result/tt/dict1.tt

cat $g | while read line;
do
    search=$(echo -n "$line" | awk '{print $2}');
    
    exists=$(cat $dict | grep $earch | wc -l);

    if [ $exists -eq 0 ]; then
        num=$(echo -n "$line" | awk '{print $1}');
        content=$(cat $h | grep $search | tail -n 1 | awk -F'\t' '{print $5}');
        echo -e "$num\t$content" >> statistics.tt;
    fi
done
