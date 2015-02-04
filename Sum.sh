#!/bin/bash

file=tmp.tt
out=out.tt

cat $file | awk 'BEING{SUM=0;KEY="";VALUE=""}{
    if(NR == 1) {
        SUM += $1
        KEY = $2
        VALUE = $4
    }else{
        if($2 == KEY) {
            SUM += $1
        } else {
            print SUM"\t"KEY"\t"VALUE
            
            SUM = 0
            KEY = $2
            VALUE = $4

            SUM += $1
        }
    }
}' | sort -k 1 -nr > out.tt


