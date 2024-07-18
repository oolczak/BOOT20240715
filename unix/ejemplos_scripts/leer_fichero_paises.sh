#!/bin/bash

input="../ficheros/Pedidos.txt"

while IFS= read -r line
do
	  echo $line | cut -d \; -f 6
  done < "$input"
