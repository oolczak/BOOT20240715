: '
El script recibe un parametro que indica el numero de iteraciones

'
echo "Numero de iteracciones:"
read n
echo "el valor leido es: $n"

# Primer ejemplo de while
i=0
while [ $i -lt $n ];do
	echo "Valor de: $i"
	i=$(($i+1))
done
