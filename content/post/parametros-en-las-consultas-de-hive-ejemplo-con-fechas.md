---
author: rvaquerizo
categories:
- Big Data
- Formación
- Trucos
date: '2017-05-18T10:54:36-05:00'
slug: parametros-en-las-consultas-de-hive-ejemplo-con-fechas
tags:
- Hive
- set
title: Parámetros en las consultas de Hive. Ejemplo con fechas
url: /parametros-en-las-consultas-de-hive-ejemplo-con-fechas/
---

Soy cinturón blanco de Hive pero aprovecho el blog para mostraros como he añadido unas variables a mi consulta de Hive, en realidad espero que algún alma caritativa me indique alguna forma más elegante. Necesito que mis consultas vayan parametrizadas por fechas que hacen mención a particiones de la tabla, estas particiones no son variables fecha, son string con el formato YYYYMMDD así que es necesario transformar las variables para realizar operaciones con ellas. En este caso tengo una fecha _inicio_ y quiero irme tres meses hacia atrás:

[sourcecode language=»sql»]  
set inicio="20161231";  
set f_aux = add_months(from_unixtime(unix_timestamp({hiveconf:inicio} ,’yyyyMMdd’), ‘yyyy-MM-dd’),-3);  
set f_mes_menos3 = from_unixtime(unix_timestamp({hiveconf:f_aux} ,’yyyy-MM-dd’), ‘yyyyMMdd’);  
[/sourcecode]

Con set defino las variables de mi entorno a las que yo referencio como _${hiveconf:variable}_ , desconozco si hay otra forma mejor de hacerlo y transformo de caracter a fecha con **from_unixtime + unix_timestamp** para así poder usar la función **add_months** que no me funcionaba con string. Después deshago el cambio y ya tengo otra variable a partir de la primera, puedo automatizar mis parámetros. ¿Lo estoy haciendo bien?