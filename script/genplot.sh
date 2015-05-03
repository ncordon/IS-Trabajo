#!/bin/bash

for file in $(find .. -name "*.out")
do
    DIR=${file%.out}
    FOLDER=$(echo $file | egrep -o "log-[[:digit:]]+")	
    ./iostat_plotter_v3.py ${file}
    rm -r ${DIR}	     
    mv REPORT ${FOLDER}
    mv ${FOLDER} ${DIR}
done
	
    
