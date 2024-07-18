#!/bin/bash

input="../ficheros/Pedidos.txt"

while IFS= read -r line
do
	  echo "$line"
  done < "$input"
