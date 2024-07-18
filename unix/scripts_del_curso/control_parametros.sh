: '
Controlar que nos han pasado  2 parametros, si no vienen dos parametros 
emitir un mensaje de error

-eq  =  igual
-lt  <  menor que
-le   <=  menor o igual
-ne   != no igual
-gt   > mayor que
-ge   >= mayor o igual

'

if [ $# -eq 2 ];
then
	echo "parametros ok, recibimos: $#"
	echo "lista de parametros: $*"
	exit 0
else
	echo "Se esperaban dos parametros"
	exit 1
fi 
