
#!/bin/bash

# Expresiones:

a=10
b=20

if [ $a -eq $b ]
then
	echo "$a y $b son iguales"
else
	echo "$a y $b son distintos"

fi

# Otras pruebas
if [ $a -lt $b ]
then
	echo "$a menor que $b"

fi

if test $a -lt $b
then
	echo "$a menor que $b"
fi
