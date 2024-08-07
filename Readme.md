# Bootcamp Asturias (SQL - PL/SQL - Scripts UNIX - Lenguaje Groovy - SoapUI - Automatización De Pruebas)

## SQL y PL/SQL

### Instalación

- Clientes de bases de datos (opciones)
  - [Oracle SQL Developer](https://www.oracle.com/database/sqldeveloper/technologies/download/)
  - [Visual Studio Code](https://code.visualstudio.com/download) + [Oracle Developer Tools for VS Code (SQL and PLSQL)](https://marketplace.visualstudio.com/items?itemName=Oracle.oracledevtools)
  - [DBeaver Community](https://dbeaver.io/download/)
- Script de instalación del tablespace para los laboratorios:
  - [lab_schema.sql](./lab_schema.sql)

### Documentación

- https://docs.oracle.com/en/database/oracle/oracle-database/21/development.html
- https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/sql-language-reference.pdf
- https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/database-pl-sql-language-reference.pdf
- https://docs.oracle.com/en/database/oracle/oracle-database/21/arpls/database-pl-sql-packages-and-types-reference.pdf
- https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/index.html

### Database Sample Schemas

**Repositorio:** https://github.com/oracle-samples/db-sample-schemas

**Documentación:** https://www.oracle.com/pls/topic/lookup?ctx=dblatest&id=COMSC

Start SQL*Plus and run the top level installation:

    sqlplus system/systempw@//localhost:1521/XE
    SQL> @/mnt/c/labs/samples.sql
    
    cd /mnt/c/app/usuario.qaracter/product/21c/dbhomeXE/bin
    ./sqlplus.exe system/Qaracter123@//localhost:1521/XE

### Labs

- https://livesql.oracle.com/apex/f?p=590:1000

## SoapUI con Groovy

### Instalación

- [SoapUI Open Source](https://www.soapui.org/downloads/soapui/)
- [Groovy](https://groovy.apache.org/download.html)
- [JDK (si es necesario)](https://www.oracle.com/es/java/technologies/downloads/)
- JDBC Drivers (copiar en %soapui_home%/bin/ext):
  - [OracleThin/
oracle.jdbc.driver.OracleDriver](https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.4.0.24.05/ojdbc11-23.4.0.24.05.jar)

### Instalación manual

Descargar binarios: <https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.22.zip>

Descomprimir en un directorio, por ejemplo: c:\curso\groovy

Abrir aplicación: Editar variables de entorno ***de esta cuenta***. En la lista superior, variables de usuario:

- Nueva:

      Nombre de variable: GROOVY_HOME
      Valor de variable: c:\curso\groovy

- Localizar en la lista Path -> Editar -> Nueva -> *c:\curso\groovy\bin*

### Documentación

- [SoapUI Open Source](https://www.soapui.org/docs/soapui-projects/)
- [Groovy](https://www.groovy-lang.org/documentation.html)

### Servicios

- <http://www.dneonline.com/calculator.asmx?wsdl>
- <https://petstore.swagger.io/v2/swagger.json>
- <https://jsonplaceholder.typicode.com/>

### Ejerccios

- Tablas de multiplicar
- Calcula el factorial de un número
- Muestra los números primos entre 1 y 100.
- Crea un función que reciba un texto y devuelva la vocal que más veces se repita (con y sin tilde son la misma vocal).
- Crea dos funciones, una que calcule el máximo común divisor (MCD) y otra que calcule el mínimo común múltiplo (mcm) de dos números enteros. No se pueden utilizar operaciones del lenguaje que lo resuelvan directamente.
- Juego de piedra, papel, tijera.
- Juego de “Adivina el número que estoy pensando”, un número del 1 al 100, ya te diré si es mayor o menor que el mío, pero tienes 10 intentos como mucho.
- Crear una función que valide un NIF
- Definir una función que determine si la cadena de texto que se le pasa como parámetro es un palíndromo, es decir, si se lee de la misma forma desde la izquierda y desde la derecha. Ejemplo de palíndromo complejo: "La ruta nos aporto otro paso natural".
