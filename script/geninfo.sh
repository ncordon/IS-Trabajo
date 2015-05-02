#!/bin/bash

PATHS="/media/usuario/5206ba37-ffc6-4ba5-9de3-4bf50bfeffe1"
TFILE="testfile"
DEST="copiedfile"
LIMIT=5
FREQ="2"
FLAGS="-y -c -d -x -t -m" 
export LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8

for p in ${PATHS}
do
    rm -r $p/temp/* 2> /dev/null
done

for k in `seq 1 $LIMIT`
do
    NUM_COPIES=$k
    j=0
    
    for p in ${PATHS}
    do
	PIDS=""
	HDD=$(lsblk -io MODEL,MOUNTPOINT | sed '/^\s*$/d' | grep -B1 "$p" | head -1)
	DIR=${HDD// }
	DEVICE=$(df -h | grep ".*$p*" | grep -o "^[^[:blank:][:digit:]]*")
	
	LOG=./${DIR}/log-${k}.out

	mkdir $p/temp 2> /dev/null
	mkdir ${DIR} 2> /dev/null
	(iostat ${FREQ} ${FLAGS} ${DEVICE} > ${LOG})&
	IOSPID=$!
	
	for i in `seq 1 $NUM_COPIES`
	do
	    cp ${TFILE} $p/temp/${i}${DEST} &
	    PIDS="${PIDS} $!"
	done
	
	wait ${PIDS}
	
	kill ${IOSPID} &> /dev/null
	wait ${IOSPID} &> /dev/null

	./iostat_plotter_v3.py ${LOG}
	mv REPORT ${LOG%.out}
	let j++

	rm -r $p/temp/* 2> /dev/null
    done
    
    sleep 2
done
	
    
