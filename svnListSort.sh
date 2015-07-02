#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

svnPath="http://211.151.58.8:1722/svn/platform/common/baihe-online/branches/"

#data=$(svn list ${svnPath} | awk -F'-' '{print $2}' | sort -nk1)
data=$(cat 1.tt | awk -F'-' '{print $2}' | sort -nk1)

FNum=0
SNum=0
TNum=0

echo "$data" | awk -F'.' -v FNum="$FNum" -v SNum="$SNum" -v TNum="$TNum" '{
    sub(/\//, "",  $3)
    if (NR == 1) {
        second[$1,SNum] = 1; SNum++
        second[$1,SNum] = $2;

        three[$1,$2,TNum] = 1; TNum++
        three[$1,$2,TNum] = $3

        FNum++
    } else {
        if (second[$1,1] != "") {
            SNum++
            second[$1,0]++
            second[$1,SNum] = $2
        } else {
            SNum = 0
            second[$1,SNum] = 1; SNum++
            second[$1,SNum] = $2
            FNum++
        }

        if (three[$1,$2,1] != "") {
           TNum++
           three[$1,$2,0]++
           three[$1,$2,TNum] = $3
        } else {
            TNum = 0
            three[$1,$2,TNum] = 1; TNum++
            three[$1,$2,TNum] = $3
        }
    }
}
END {
    for (i=1; i<=FNum; i++) {
        for (j=1; j<=second[i,0]; j++) {
            secondTMP[j] = second[i,j]
        }
        
        SLen = length(secondTMP)
        for (m=1; m<=SLen; m++) {
            for (n=m+1; n<=SLen; n++){
                if (secondTMP[m] > secondTMP[n]) {
                    STValue = secondTMP[n]
                    secondTMP[n] = secondTMP[m]
                    secondTMP[m] = STValue
                }
            }
        }

        for (m=1; m<=SLen; m++) {
            if (uniq[i, secondTMP[m]] == "") {
                for (n=1; n<=three[i,secondTMP[m],0]; n++) {
                    threeTMP[n] = three[i,secondTMP[m],n] + 0
                }
                
                TLen = length(threeTMP)

                for (q=1; q<=TLen; q++) {
                    for (w=q+1; w<=TLen; w++){
                        if (threeTMP[q] > threeTMP[w]) {
                            TTValue = threeTMP[w]
                            threeTMP[w] = threeTMP[q]
                            threeTMP[q] = TTValue
                        }
                    }
                }

                for (n=1; n<=TLen; n++) {
                    print i"."secondTMP[m]"."threeTMP[n]"/"
                }
                
                uniq[i, secondTMP[m]] = 1
            }
            delete threeTMP
        }
        delete secondTMP
    }
}
'
