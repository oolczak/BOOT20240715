: '
Controlar que nos han pasado  2 parametros, si no vienen dos parametros 
emitir un mensaje de error

Despues controlar si el primer parametro es un fichero que existe

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
		echo "ok, el fichero existe"
		exit 0
	else
		echo "El fichero no existe"
		exit 1

	fi
else
	echo "Se esperaban dos parametros"
	echo "sintaxis:  control_parametros2.sh fichero columna"
	exit 1
fi 
