#!/bin/bash

suma(){
	r=$(($1+$2))	
	echo $r
}

echo "Teclear dos numeros:"
read a b
val=$(suma $a $b)

echo "Resultado: $val"
