#!/usr/bin/env python
from collections import defaultdict
import math

order_dict = defaultdict(list)
order_list = []


def reqOrder():
    with open('log.txt','r') as infile:
         for line in infile:
             line = line.rstrip()
	     line = line.split('|')
             msgType = line[0]
             reqTime = int(line[1])
             orderId = line[2]
             seq = line[3]
             if 'RES' in line:
                 order_list.append(line)


def resOrder():
    with open('log.txt','r') as infile:
         for line in infile:
             line = line.rstrip()
             line = line.split('|')
             msgType = line[0]
             reqTime = int(line[1])
             orderId = line[2]
             seq = line[3]
             for order in order_list:
                 if seq in order:
                    resOrderId = order[2]
                    resSeq = order[3]
                    resTime = int(order[1])
                    rtt = resTime - reqTime
                    if (msgType == 'REQ') and (resSeq == seq) and (orderId == resOrderId):
                       seqRtt = [resSeq, rtt]
                       order_dict[orderId].append(seqRtt)
                       break 

    order_dict_new = sorted(order_dict.items())
    for key, value in order_dict_new:
        print ("OrderId:",key)
        for v in value:
            print ("Seq,RTT:",v[0],v[1])
    
        print "\n"

def main():
    reqOrder()
    resOrder()



if __name__ == "__main__":
    main()
