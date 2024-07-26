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

### Documentación

- [SoapUI Open Source](https://www.soapui.org/docs/soapui-projects/)
- [Groovy](https://www.groovy-lang.org/documentation.html)
