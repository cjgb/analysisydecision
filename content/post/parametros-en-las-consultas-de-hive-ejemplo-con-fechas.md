---
author: rvaquerizo
categories:
- big data
- formación
- trucos
date: '2017-05-18'
lastmod: '2025-07-13'
related:
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
- truco-python-restar-meses-con-formato-yyyymm.md
- truco-sas-transformar-variable-caracter-a-fecha.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
tags:
- hive
- set
title: Parámetros en las consultas de Hive. Ejemplo con fechas
url: /blog/parametros-en-las-consultas-de-hive-ejemplo-con-fechas/
---
Soy cinturón blanco de Hive pero aprovecho el blog para mostraros como he añadido unas variables a mi consulta de Hive, en realidad espero que algún alma caritativa me indique alguna forma más elegante. Necesito que mis consultas vayan parametrizadas por fechas que hacen mención a particiones de la tabla, estas particiones no son variables fecha, son string con el formato YYYYMMDD así que es necesario transformar las variables para realizar operaciones con ellas. En este caso tengo una fecha _inicio_ y quiero irme tres meses hacia atrás:

[sourcecode language=»sql»]
set inicio="20161231";
set f_aux = add_months(from_unixtime(unix_timestamp({hiveconf:inicio} ,’yyyyMMdd’), ‘yyyy-MM-dd’),-3);
set f_mes_menos3 = from_unixtime(unix_timestamp({hiveconf:f_aux} ,’yyyy-MM-dd’), ‘yyyyMMdd’);
[/sourcecode]

Con set defino las variables de mi entorno a las que yo referencio como _${hiveconf:variable}_ , desconozco si hay otra forma mejor de hacerlo y transformo de caracter a fecha con **from_unixtime + unix_timestamp** para así poder usar la función **add_months** que no me funcionaba con string. Después deshago el cambio y ya tengo otra variable a partir de la primera, puedo automatizar mis parámetros. ¿Lo estoy haciendo bien?