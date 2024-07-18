: '
Test sobre los archivos para saber si son o no archivos y que permisos tienen
'

# primero comprobar si viene el parametro o no
if [ $# -eq 0 ];
then	
	echo "falta el parametro"
else
	echo 'Analisis del parametro', $1
	if test -e $1;
	then
		if test -f $1;
		then
			echo $1,'es un archivo'

		elif test -d $1;
		then
			echo $1,'es un directorio'
		fi

		echo "Con los siguientes permisos:"
		if test -r $1;
		then
			echo "permiso de lectura"
		else
			echo "sin permiso de lectura"
		fi
		if test -w $1;
		then
			echo "permiso de escritura"
		else
			echo "sin permiso de escritura"
		fi
		if test -x $1;
		then
			echo "permiso de ejecucion"
		else
			echo "sin permiso de ejecucion"
		fi
	else
		echo "no existe el archivo", $1
	fi
fi
	
