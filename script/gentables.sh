#!/bin/bash

HDD="Maxtor6K040L0 ST34321A ST320410A ST320413A ST3320613AS WD800JD WDBUZG0010BBK"
FS="ext4 fat32 ntfs"
PARAMS="wMB w avgrqsz avgqusz"
declare -A TEXT=(["wMB"]="MB/s transferidos"
		 ["w"]="Media pet. escritura completadas por segundo"
		 ["avgrqsz"]="Tamaño medio peticiones escritura(KB)"
		 ["avgqusz"]="Longitud media de la cola de escritura")

declare -A IDS=(["Maxtor6K040L0"]="M1"
		["ST34321A"]="S1"
		["ST320410A"]="S2"
		["ST320413A"]="S3"
		["ST3320613AS"]="S4"
		["WD800JD"]="WD1"
		["WDBUZG0010BBK"]="WD2")

SIZE=5
FIRST_IT="wMB"
DATA_DIR="../data"
# Floating point numbers precision
PREC=3

for hdd in $HDD
do
    echo '\begin{longtable}{|>{\centering}m{5cm}|c|c|c|}'
    echo -n "\caption{Tabla de resultados para [${IDS[$hdd]}]}"
    echo '\\'
    echo '\hline'

    
    for p in $PARAMS
    do
	if [[ $p == ${FIRST_IT} ]]
	then
	    echo -n "\cellcolor{blue!25}\textbf{${TEXT[$p]}} & \cellcolor{blue!25}\textbf{ext4} &\cellcolor{blue!25}\cellcolor{blue!25}\textbf{FAT32} & \cellcolor{blue!25}\textbf{NTFS}"
	    echo '\\'
	    echo '\hline'
	else
	    echo -n "\cellcolor{blue!25}\textbf{${TEXT[$p]}} & \multicolumn{3}{c|}{\cellcolor{blue!25}}"
            echo '\\'
	    echo '\hline'
	fi


	for j in `seq 1 ${SIZE}`
	do
	    echo -n "$j copias simultáneas"

	    for fs in $FS
	    do
		data=$(cat $DATA_DIR/$fs/$hdd/log-$j/averages |
		      grep -o "$p:.*" | egrep -o "[[:digit:]]+\.[[:digit:]]+")
		echo -n " & "
		
		if [[ ! -z "$data" ]]
		then
                    printf "%.*f" $PREC "$data"
		else
		    echo "-"
		fi
	    done

	    echo '\\'
	    echo '\hline'
	done

    done

    echo '\end{longtable}'
done