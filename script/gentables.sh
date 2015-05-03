#!/bin/bash

HDD="Maxtor6K040L0 ST34321A ST320410A ST320413A ST3320613AS WDBUZG0010BBK"
FS="ext4 fat32 ntfs"
PARAMS="wMB w avgrqsz avgqusz util"
declare -A TEXT=(["wMB"]="MB/s transferidos"
		 ["w"]="Media pet. escritura completadas por segundo"
		 ["avgrqsz"]="Tamaño medio peticiones escritura(KB)"
		 ["avgqusz"]="Longitud media de la cola de escritura"
		 ["util"]="Ancho de banda para el dispositivo")

FIRST_IT="wMB"
DATA_DIR=./data
# Floating point numbers precision
PREC=3

for hdd in $HDD
do
    echo '\begin{longtable}{|l|l|l|l|}'
    echo '\caption{Tabla de resultados para [M1]}\\'
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


	for j in `seq 1 5`
	do
	    echo -n "$j copias simultáneas"

	    for fs in $FS
	    do
		data=$(cat $DATA/$fs/$hdd/log-$j/averages |
		      grep -o "$p:.*" | egrep -o "[[:digit:]]+\.[[:digit:]]+")
		echo -n " & "
                printf "%.*f" $PREC "$data"
	    done

	    echo '\\'
	    echo '\hline'
	done

    done

    echo '\end{longtable}'
done
