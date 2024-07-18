: '
Operaciones aritmeticas
Leer de teclado con read  dos variables y sumarlas
'
#!/bin/bash

echo "Teclear un numero:"
read a
echo "Teclear otro numero:"
read b
((suma=$a+$b))

echo "a: $a"
echo "b: $b"
echo "La suma : $suma"

if (($a < $b))
then
	echo "El menor es a: $a"

elif (($a == $b))
then 
	echo "Los dos numeros son iguales"

else
	echo "El menor es b: $b"
fi
