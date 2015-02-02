#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

fileName=1.tt

cat $fileName | while read line; 
do 
    result=$(echo -n "'$line'" | awk -F'\t' '{
    #{
    #    #$0="\047" $0 "\047";
    #    gsub(/\r/,"\\r");
    #    gsub(/n/,"\\n");
    #}
    {
        print $12;
    }}');

    qq=$(echo -n "'$result'" | grep -Eo "[0-9⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑①②③④⑤⑥⑦⑧⑨⑩⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽❶❷❸❹❺❻❼❽❾❿㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ１２３４５６７８９０一二三四五六七八九零壹贰叁肆伍陆柒捌玖]+");

    if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
        encryption=$(echo -n $result | md5)
    else
        qq=$(echo -n $qq | sed 's/[[:space:]]//g');
        encryption=$(echo -n $qq | md5);
    fi 

    if [ -f "./result/1.txt" ]; then
        isExists=$(cat ./result/1.txt | grep -o $encryption);
    else
        isExists="";
    fi

    if [ -z "$isExists" ]; then
        echo -en "$line" >> ./result/$fileName;

        if [ -z "$qq" ] || [ ${#qq} -lt 4 ]; then
            echo -en "\tas content\t" >> ./result/$fileName;
        else
            echo -en "\t$qq\t" >> ./result/$fileName;
        fi

        echo $encryption >> ./result/$fileName;

        echo -e "$encryption\t$result" >> ./result/uniq_$fileName.tt
    else
        echo $encryption >> ./result/encryption_$fileName.tt;
    fi
done

#wait

#cat ./result/*.txt > ./result/result.txt
