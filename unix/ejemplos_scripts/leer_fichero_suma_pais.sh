#!/bin/bash

input="../ficheros/Pedidos.txt"

echo "Filtro por: $1"

total=0

while IFS= read -r line
do
	pais=$(echo $line | cut -d \; -f 6)
        pais=${pais:0:-1}

	if [ "$pais" = "$1" ]; 
	then
		importe=$(echo $line | cut -d \; -f 5)
		echo "importe: $importe"
		total=$(($total+$importe))
	fi	

  done < "$input"
  echo "Total: $total para: $1"
