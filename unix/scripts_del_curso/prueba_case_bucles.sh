: '

	Sentencias de control: case, bucle for y while
	variable dia: valor del 1 al 7 imprimir: L, M, X, J, V, finde
'
#!/bin/bash


# Ejemplo de case,  para imprimir el dia de la semana en funcion de un numero
dia=2
case $dia in
	1) echo "L";;
	2) echo "M";;
	3) echo "X";;
	4) echo "J";;
	5) echo "V";;
	*) echo "finde";;
esac 

# Bucle for, valores del 1 al 10:
echo  "for del 1 al 10"
# funciona tambien valores= seq 1 10
valores=`seq 1 10`
for i in $valores
do
	echo $i
done


echo "for del 0 al 50 de 5 en 5"
for i in $(seq  0 5 50)
do
	echo $i
done

# Bucle while con let:
j=0
while ((j < 10))
do
	echo "j = $j"	
	j=$((j+1))
done











