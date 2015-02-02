#!/bin/bash

uniqFileName=uniq
fileName=encryption
suffix=_xaa.tt
result=result.tt

if [ ! -f $result ]; then
    sort -d $fileName$suffix | uniq -c | sort -nr > $result
fi

awk '{if($1 > 5){print $1","$2}}' $result | while read line
do
    OLD_IFS="$IFS" 
    IFS="," 
    arr=($line) 
    IFS="$OLD_IFS" 
    
    data=$(grep ${arr[1]} $uniqFileName$suffix)
    
    echo -e "${arr[0]}\t$data" >> 1.tt

done
