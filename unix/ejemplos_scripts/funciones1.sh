#!/bin/bash

saludo(){
	str="Hola $name"
	echo $str
}

echo "Introduzca el nombre:"
read name

val=$(saludo)
echo "Valor retornado de la funcion: $val"

