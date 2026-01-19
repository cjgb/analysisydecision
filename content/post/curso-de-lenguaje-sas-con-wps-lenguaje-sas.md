---
author: rvaquerizo
categories:
- consultoría
- formación
date: '2010-05-25'
lastmod: '2025-07-13'
related:
- curso-de-lenguaje-sas-con-wps-librerias-en-wps.md
- curso-de-lenguaje-sas-con-wps-el-paso-data.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- acercamiento-a-wps-migrando-desde-sas.md
- curso-de-lenguaje-sas-con-wps-introduccion-2.md
tags:
- libname
title: Curso de lenguaje SAS con WPS. Lenguaje SAS
url: /blog/curso-de-lenguaje-sas-con-wps-lenguaje-sas/
---
El lenguaje SAS tiene 3 elementos fundamentales:

  * Sentencias globales
  * Pasos DATA
  * Procedimientos PROC

SAS es un lenguaje de alto nivel interpretado. Esto es, ya está todo inventado y es muy costoso implementar nuevos procedimientos y algoritmos, algo de gran importancia en el mundo estadístico, pero para ello tenemos R. Ahora bien, ¿por qué las grandes organizaciones tienen SAS? Tiene una característica que destaca sobre todas: **trabaja sobre disco** , no trabaja sobre memoria como R o MATLAB. Esto nos permite gestionar grandes cantidades de registros y no estamos limitados por la memoria de nuestra máquina. WPS, evidentemente, hace lo mismo que SAS (a menor precio). Por la propia naturaleza de SAS es muy complicado poder crear nuevos procedimientos y funciones.

Volviendo a los elementos del lenguaje SAS vamos a comenzar con las sentencias globales. Estas sentencias son todos aquellos elementos que no son un paso DATA o un paso PROC y de ellas destaca LIBNAME. Esta sentencia nos permite crear librerías SAS que son el lugar físico donde guardamos tablas SAS. WPS tiene el Server Explorer para poder navegar por librerías:

![server-explorer.jpg](/images/2010/05/server-explorer.jpg)

Vemos que por defecto WPS tiene 3 librerías SASHELP, SASUSER y WORK. La primera es una librería del sistema y contiene elementos de la sesión de WPS. SASUSER es una**librería permanente** del usuario y la WORK es la**librería temporal** de la sesión de WPS. Aparecen dos conceptos fundamentales a la hora de trabajar con WPS los elementos permanentes y los elementos temporales. Como ya se indicó WPS trabaja fundamentalmente con disco, es decir, te deja la memoria tranquila y te llena el disco duro de tablas SAS por ello es muy importante determinar que tablas han de guardarse de forma permanente y que tablas han de guardarse de forma temporal. No hay norma, la propia experiencia nos indica cuando tenemos que guardar una tabla en disco o cuando podemos prescindir de ella.

Para crear nuestras propias librerías tenemos LIBNAME, la sintaxis genérica sería:

LIBNAME <NOMBRE> «<UBICACIÓN FÍSICA>» -ENGINE- -OPCIONES-;

Una librería tiene que tener un nombre que no empiece por números y que no exceda de 8 caracteres. Al final es una ubicación, un directorio de nuestro PC y le asignamos una ENGINE. En WPS, el motor, la engine tiene mucha importancia. Tenemos las siguientes:

  * SASV6
  * SASV7
  * SASV8
  * SASV9
  * SAS7BDAT
  * SD2
  * SASSEQ
  * V8SEQ
  * V9SEQ
  * WPDSEQ
  * WPD
  * WPD (z/OS)
  * WPD1
  * XPORT

Por defecto la engine es WPD, es decir, crear ficheros WPS. Para trabajar con ficheros SAS7BDAT tenemos que usar esa engine, esto nos facilitará a la perfección la migración de nuestros procesos SAS a WPS. A lo largo de las sucesivas entradas veremos como asignar librerías y como trabajar con ellas.