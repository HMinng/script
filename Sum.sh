#!/bin/bash

file=tmp.tt
out=out.tt

cat $file | awk 'BEING{SUM=0}{
    if(NR % 8 != 0) {
        SUM += $1;
    }else{
        SUM += $1;
        print SUM"\t"$2"\t"$4
        SUM=0
    }
}' | sort -k 1 -nr > out.tt


