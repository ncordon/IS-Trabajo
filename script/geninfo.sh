#!/bin/bash

# Rutas de montaje de los discos a analizar
PATHS="/media/usuario/5206ba37-ffc6-4ba5-9de3 /media/usuario/NTFS /"
# Nombre de fichero que se copiará
TFILE="testfile"
# Nombre que se le dará a cada uno de los ficheros transferidos
DEST="copiedfile"
# Número máximo de transferencias simultáneas
LIMIT=5
# Frecuencia de muestreo de iostat
FREQ="2"
# Flags de iostat
FLAGS="-y -c -d -x -t -m" 
export LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8


# Se borran las carpetas de destino
for p in ${PATHS}
do
    rm -r $p/temp/* 2> /dev/null
done


for k in `seq 1 $LIMIT`
do
    NUM_COPIES=$k

    # Para cada disco y un número de copias simultáneas k dado...
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

	# Se espera a que terminan las copias para seguir
	wait ${PIDS}

	# Interrumpe la ejecución de IOStat. Las copias ya han terminado
	kill ${IOSPID} &> /dev/null
	wait ${IOSPID} &> /dev/null

	# Genera las gráficas y los archivos de datos
	./iostat_plotter_v3.py ${LOG}
	mv REPORT ${LOG%.out}

	# Limpia el directorio para la siguiente ejecución
	rm -r $p/temp/* 2> /dev/null
    done
    
    sleep 2
done
	
    
