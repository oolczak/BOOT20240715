#!/bin/bash

input="../ficheros/Pedidos.txt"

echo "Filtro por: $1"

while IFS= read -r line
do
	pais=$(echo $line | cut -d \; -f 6)
        pais=${pais:0:-1}
	

	if [ "$pais" = "$1" ]; 
	then
		echo "$line"
	fi	

  done < "$input"
