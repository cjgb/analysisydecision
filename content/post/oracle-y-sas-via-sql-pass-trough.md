---
author: rvaquerizo
categories:
- business intelligence
- formación
- sas
date: '2009-06-12'
lastmod: '2025-07-13'
related:
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- trucos-sas-trasponer-con-sql-para-torpes.md
- proc-sql-merge-set.md
- curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
tags:
- oracle y sas
- pass thru
title: Oracle y SAS vía SQL pass trough
url: /blog/oracle-y-sas-via-sql-pass-trough/
---
Para trabajar directamente con el motor de BBDD SAS cuenta con «Pass trougth». SAS crea una conexión al gestor de BBDD y desde ese momento podemos ejecutar sentencias de SQL directamente. Para seguir con la línea de trabajo habitual emplearemos ejemplos para conocer su funcionamiento. Los ejemplos que vamos a emplear serán sobre una BBDD Oracle ya que es muy común trabajar en entornos SAS con acceso a algún datamart de Oracle. Evidentemente la utilidad pass trough o pas thru convive perfectamente con

las librerías dinámicas de SAS a Oracle. Los ejemplos que vamos a ver serán:

  * Bajada de tabla Oracle a SAS vía pass thru. Usuario de consulta.
  * Subida de tabla SAS a un esquema Oracle. Usuario propierario asigna permisos.
  * Oracle como motor de consulta desde SAS. Usuario propietario crea tabla.
  * Borrar tabla Oracle. Usuario propietario hace DROP.

Estos 4 ejemplos pueden ayudarnos a conocer mejor como funciona la utilidad pass thru y sobre todo estoy seguro que pueden ser de utilidad para muchos profesionales que tengan que migrar procesos en PL/SQL a SAS. Lo primero que vamos a hacer es definir un usuario de consulta, un usuario propietario y un usuario de carga que tendrán sus respectivos roles en la BBDD Oracle (*con_role, *car_role y *own_role) . Emplearemos un lenguaje SAS muy genérico:

```r
*DECLARAMOS LOS USUARIOS PROPIETARIOS;

%let usuario_propietario=*******;

%let contrasenia_propietario=********;

*DECLARAMOS LOS USUARIOS DE CONSULTA;

%let usuario_consulta=*****;

%let contrasenia_consulta=********;

*DECLARAMOS LOS USUARIOS DE CARGA;

%let usuario_carga=*****;

%let contrasenia_carga=********;
```

**Bajada de tabla Oracle a SAS vía pass thru:**

```r
proc sql;

connect to oracle as mycon

(user=&usuario_consulta password=&contrasenia_consulta path='PATH');

 create table TABLA_SAS as

 select * from connection to mycon (

  select CAMPO1 as CAMPO1,

  CAMPO2 as CAMPO2,...

  from ESQUEMA.TABLA_ORACLE) ;

%put &sqlxmsg;

disconnect from mycon;

quit;
```

Lo primero que hacemos es crear una conexión al path de Oracle. La tabla SAS es una selección del total de columnas de la _select_ que enviámos al motor de BBDD. Esta select será en el lenguaje de la conexión. En este caso como la conexión es Oracle emplearemos PL/SQL. Si la conexión fuera a SQL Server emplearíamos ese lenguaje. Con la macrovariable _& sqlxmsg_ indicamos que en el log deseamos ver los mensajes del motor de la BBDD, muy importante para chequear errores.

**Subida de tabla SAS a un esquema Oracle:**

```r
libname ORASAS oracle user=&usuario_propietario pass=&contrasenia_propietario

 path= 'PATH' schema=ESQUEMA dbindex=yes;

*SUBIDA MEDIANTE PASO DATA;

data ORASAS.TABLA_ORACLE;

 set LIBSAS.TABLA_SAS;

run;

*DESASIGNAMOS LA LIBERIA;

libname ORASAS clear;

*ASIGNAMOS PERMISOS A LOS ROLES PARA LOS USUARIOS DE CARGA Y CONSULTA;

proc sql;

connect to oracle as mycon (user=&usuario_propietario.

 password=&contrasenia_propietario. path='PATH');

  execute(GRANT DELETE, INSERT, SELECT, UPDATE ON TABLA_ORACLE TO *_CON_ROLE) by mycon;

  execute(GRANT DELETE, INSERT, SELECT, UPDATE ON TABLA_ORACLE TO *_CAR_ROLE) by mycon;

  EXECUTE(COMMIT)by mycon;

%put &sqlxmsg;

  disconnect from mycon;

quit;
```

Creamos una librería dinámica a Oracle (la forma habitual de obtener tablas de la DBMS) pero hemos de crearla con el usuario propietario y sobre el esquema en el que tenemos permisos. Subir la tabla es tan fácil como hacer un paso _data_. Después como buen práctica desasignamos la librería dinámica (creada con el usuario propietario) y asignamos permisos a los roles de consulta y/o de carga para que puedan acceder a las tablas. El usuario de consulta hará consultas y el propietario, dará permisos, hará cargas (no empleamos usuario de carga), borrará tablas,… Esta metodología será más apropiada a la hora de trabajar con la BBDD.

**Oracle como motor de consulta desde SAS:**

```r
proc sql;

 connect to oracle as mycon (user=&usuario_propietario

password=&contrasenia_propietario path='PATH');

 CREATE TABLE ESQUEMA1.TABLA_DESTINO AS SELECT * FROM CONNECTION TO MYCON(

  SELECT CAMPO1 AS CAMPO1, CAMPO2 AS CAMPO2,...

  FROM ESQUEMA2.TABLA_ORACLE

  WHERE ... );

disconnect from mycon;QUIT;

*ASIGNAMOS PERMISOS;

proc sql;

connect to oracle as mycon (user=&usuario_propietario.

  password=&contrasenia_propietario. path='PATH');

  execute(GRANT DELETE, INSERT, SELECT, UPDATE ON ESQUEMA1.TABLA_DESTINO TO *_CON_ROLE) by mycon;

  execute(GRANT DELETE, INSERT, SELECT, UPDATE ON ESQUEMA1.TABLA_DESTINO TO *_CAR_ROLE) by mycon;

  EXECUTE(COMMIT)by mycon;

%put &sqlxmsg;

  disconnect from mycon;

quit;
```

En este ejemplo se realiza una consulta y se crea una tabla en el esquema en el que asumimos que somos propietarios, pero podemos hacer la consulta sobre el mismo esquema de la instancia Oracle sobre la que trabajamos, posteriormente asignamos permisos a los usuarios de carga y consulta. Otra forma de realizar este proceso es crear la estructura y posteriormente cargar los datos, algunos profesionales consideran que es la forma óptima de trabajo:

```r
proc sql;

 connect to oracle as mycon (user=&usuario_propietario

 password=&contrasenia_propietario path='PATH');

 CREATE TABLE TABLA_DESTINO AS SELECT * FROM CONNECTION TO MYCON(

  SELECT CAMPO1 AS CAMPO1, CAMPO2 AS CAMPO2,...

  FROM ESQUEMA.TABLA_ORACLE

  WHERE ... AND ROWNUM<1 );

disconnect from mycon;QUIT;

*ASIGNAMOS PERMISOS A LOS ROLES DE USUARIOS DE CARGA Y CONSULTA;

proc sql;

 connect to oracle as mycon (user=&usuario_propietario password=&contrasenia_propietario path='PATH');

  execute(GRANT SELECT, update, insert, delete ON TABLA_DESTINO TO *_car_ROLE) by mycon;

  execute(GRANT SELECT, update, insert, delete ON TABLA_DESTINO TO *_con_ROLE) by mycon;

  EXECUTE(COMMIT)by mycon;

disconnect from mycon;QUIT;

*CARGAMOS LA TABLA CON EL USUARIO DE CARGA;

proc sql;

 connect to oracle as mycon (user=&usuario_carga

 password=&contrasenia_carga. path='PATH');

  EXECUTE(INSERT INTO TABLA_DESTINO

  SELECT CAMPO1 AS CAMPO1, CAMPO2 AS CAMPO2,...

  FROM ESQUEMA.TABLA_ORACLE

  WHERE ...)BY MYCON;

disconnect from mycon;QUIT;
```

Esta metodología es más óptima pero mucho más compleja como puede comprobarse. Esto puede ser de gran utilidad para realizar consultas con el motor de Oracle y beneficiarnos de sus particiones e índices. Además no gastamos espacio de temporal con SAS e incluso si tenemos un buen _tablespace_ las consultas irán mejor.

**Borrar tabla Oracle**

```r
proc sql;

connect to oracle as mycon (user=&usuario_propietario

password=&contrasenia_propietario path='PATH');

 execute(DROP TABLE ESQUEMA_PROPIETARIO.TABLA) by mycon;

 execute(COMMIT) by mycon;

 %put &sqlxmsg;

disconnect from mycon;

quit;
```

Un buen ejemplo de ejecución de PL bajo SAS. Recordad que el código que ponemor desde el ; de la _connect_ es el código que emplea el motor de BBDD. Espero que estos ejemplos genéricos os sean de utilidad sobre todo para aquellos que tenéis que migrar procesos a SAS. Por supuesto si tenéis dudas o un trabajo excelentemente remunerado… [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)