#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

total=20;
num=$(cat ./result/result.txt | wc -l);

complicating=50;

let "integer=$num/$complicating";
let "remainder=$num%$complicating";

if [ $remainder -ge 0 ]; then
    remainder=1;
else
    remainder=0;
fi

let "cycles=$integer+$remainder";

j=1;

for ((i=1; i<=$num;))
do
    let "endPlace=$complicating*$j";
    
    $(sed -n "${i},${endPlace}p" ./result/result.txt | while read line; 
    do
        encryption=$(echo -n "$line" | awk -F'\t' '{print $7}');

        num=$(cat ./result/encryption.tt | grep "$encryption"  | wc -l);

        if [ "$num" -ge "$total" ]; then
            echo -e "$line" >> ./result/h.tt
            echo -e "$encryption $num" >> ./result/g.tt
        fi
    done) &
    
    let "i+=$complicating";
    let "j+=1";
done

wait;
