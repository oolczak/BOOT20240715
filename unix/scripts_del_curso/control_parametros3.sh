: '
Controlar que nos han pasado  2 parametros, si no vienen dos parametros 
emitir un mensaje de error

Despues controlar si el primer parametro es un fichero que existe
Controlar que la columna esta entre 1 y 6

-eq  =  igual
-lt  <  menor que
-le   <=  menor o igual
-ne   != no igual
-gt   > mayor que
-ge   >= mayor o igual

'

if [ $# -eq 2 ];
then
	if [ -f $1 ];
	then
		
			
		if [ $2 -ge 1 -a $2 -le 6 ];
		then
			# En este punto ya tenemos todos los parametros validados
			echo "todo ok"
			exit 0
		else
			echo "la col $2  debe estar entre 1 y 6"
			exit 1
	
		fi

	else
		echo "El fichero $1 no existe"
		exit 1

	fi
else
	echo "Se esperaban dos parametros"
	echo "sintaxis: $0 fichero columna"
	exit 1
fi 
