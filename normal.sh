#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

ip='192.168.20.43'
username='root'
password='heming'
database='anti_cheat'
table='normal'

file=dict.tt

num=$(cat $file | wc -l);
$(cat $file | while read line; 
do 
    result=$(echo -n "'$line'" | awk -F'\t' '{
    {
        gsub(/\r/,"\\r");
        gsub(/n/,"\\n");
    }
    {
        print $1;
    }}');

    encryption=$(echo -n $result | md5)

    echo -en "$line" >> ./result/1.txt;

    echo -en "\t" >> ./result/1.txt;

    echo $encryption >> ./result/1.txt;
done
