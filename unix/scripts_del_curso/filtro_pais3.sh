: '
Generar un fichero por cada pais a partir de fichero de pedidos. El  fichero de pedidos se recibe por
parametro.

'
#!/bin/bash

# Extraer los paises sin repetidos:
# Genera un fichero auxiliar con los paises
cat $1 | cut -d \; -f 6 | sort | uniq > ./ficheros_pedidos/paises.txt


# Utilizamos el while con un fichero auxiliar porque el bucle for rompe las cadenas por el espacio en blanco, por EEUU y UK
while  IFS= read -r  p
do
	# Limpiar el salto de linea:
	pais=${p:0:-1}	

	# Evitar  las cabeceras:
	if [ "$pais" != "pais" ];
	then
		#echo "Pais: $pais"

		#  El pais que obtenemos del fichero de pedidos lo utilizamos para generar el fichero destino	
		path_destino="./ficheros_pedidos/$pais.txt"

		# Reemplazar el espacio en blanco del nombre del fichero por un guion bajo:
		path_destino="${path_destino// /_}"

		#  Sobre el fichero  pedidos filtramos los pedidos del pais
		cat $1 | grep "$pais" > $path_destino

		echo "Generando el fichero: $path_destino"
	fi


done <  ./ficheros_pedidos/paises.txt

# Borrar el fichero auxiliar:
rm ./ficheros_pedidos/paises.txt
exit 0

