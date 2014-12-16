#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

base=./result/tt/
resultFileName=result.txt
encryptionFileName=encryption.tt
gFileName=g.tt
hFileName=h.tt
uniqe=uniqe.tt


if [ ! -f ${base}${uniqe} ]; then
    awk -F'\t' '{print $7}' ${base}${resultFileName} >> ${base}${encryptionFileName};
    sort ${base}${encryptionFileName} | uniq > ${base}${uniqe}
fi

num=$(cat ${base}${uniqe} | wc -l);

complicating=200;

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
    
    $(sed -n "${i},${endPlace}p" ${base}${uniqe} | while read line; 
    do
        match=$(cat ${base}${resultFileName} | grep $line | tail -n 1);
        echo -e "$match" >> ${base}${hFileName};

        total=$(cat ${base}${encryptionFileName} | grep $line | wc -l);
        echo -e "$total\t$line" >> ${base}${gFileName};
    done) &
    
    let "i+=$complicating";
    let "j+=1";
done

wait;
