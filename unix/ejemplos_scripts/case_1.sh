#!/bin/bash

echo "DIA SEMANA"
for i in `seq 1 7`
do
	case $i in
		1) 	echo "L";;
		2)	echo "M";;
		3)	echo "X";;
		4)	echo "J";;
		5)	echo "V";;
		*)	echo "FINDE";;
	esac
done

