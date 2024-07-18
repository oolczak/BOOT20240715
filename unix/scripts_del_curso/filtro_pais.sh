: '
Generar un fichero con los pedidos del pais que recibimos por parametro

'
#!/bin/bash


# Suponemos que el primer parametro es el fichero de pedido y el segundo parametro el  pais
path_destino="./ficheros_pedidos/$2.txt"

# Visualizar el fichero, filtrar con grep  el pais y escribir en un fichero
cat $1 | grep $2 > $path_destino    

echo "Generando el fichero: $path_destino"



