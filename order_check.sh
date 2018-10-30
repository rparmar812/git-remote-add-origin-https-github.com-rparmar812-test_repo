#!/bin/bash
file="log.txt"

count=1
declare -a tmp=()
while read line
do
  msgType=`echo $line | awk -F"|" '{print $1}'`
  reqTime=`echo $line | awk -F"|" '{print $2}'`
  orderId=`echo $line | awk -F"|" '{print $3}'`
  seq=`echo $line | awk -F"|" '{print $4}'`
  order_list=($(sed -n "$count,\$p" log.txt | grep -w "$orderId" | grep "$seq" | grep 'RES' | head -1 | xargs))
  for ord in "${order_list[@]}"
  do
    resOrderId=`echo $ord | awk -F"|" '{print $3}'`
    resSeq=`echo $ord | awk -F"|" '{print $4}'`
    resTime=`echo $ord | awk -F"|" '{print $2}'`
    rtt=`expr $resTime - $reqTime`
    if [[ $msgType == 'REQ' ]] && [[ $resSeq == $seq ]] && [[ $orderId == $resOrderId ]]
    then
        tmp+=([$orderId]="$orderId:$seq,$rtt|")
    fi
  done

 ((count++))
done < "${file}" 

for m in "${tmp[@]}"
do
  ordpair=($(echo $m | sed -e 's/|$//'))
  ordpair=($(echo $ordpair | tr -s '|' ' ' | xargs ))
  oid=`echo $ordpair | awk '{print $1}' | cut -d":" -f1`
  echo "OrderId:$oid"
  for od in "${ordpair[@]}"
  do
    seqPair=`echo $od | awk -F":" '{print $2}'`
    echo "Seq,RTT:$seqPair"
  done
  echo ""
done
