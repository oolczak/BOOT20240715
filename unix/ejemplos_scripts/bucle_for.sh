: '
Un bucle for por los parametros
'

echo "Numero de parametros:", $#

for var in $@
do
	echo "param: $var"
done
