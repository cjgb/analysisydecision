---
author: rvaquerizo
categories:
  - consultoría
  - formación
date: '2010-05-22'
lastmod: '2025-07-13'
related:
  - acercamiento-a-wps-migrando-desde-sas.md
  - en-breve-revision-de-wps-clonico-de-sas.md
  - curso-de-lenguaje-sas-con-wps-introduccion.md
  - wps-en-el-mercado-espanol.md
  - curso-de-lenguaje-sas-con-wps-lenguaje-sas.md
tags:
  - consultoría
  - formación
title: Curso de lenguaje SAS con WPS. Introducción
url: /blog/curso-de-lenguaje-sas-con-wps-introduccion-2/
---

Hoy me gustaría mostraros el interfaz de WPS y cuales son las características principales de WPS y cuales son comunes entre SAS y WPS. Si pincháis [este link](http://teamwpc.co.uk/tryorbuy) podréis descargaros una demo de WPS y seguir este curso. Cuando lo hagáis y abráis WPS os encontraréis con esto:

![interfaz_wps.jpg](/images/2010/05/interfaz_wps.jpg "interfaz_wps.jpg")

Este es el interfaz de WPS. Desde mi prisma es muy parecido a la versión 4 del Enterprise Guide. Se compone fundamentalmente de una ventana donde podemos editar programas con un código semafórico igual al de SAS. Tenemos una ventana donde navegamos por resultados, log y controlamos las ejecuciones. A la izquierda de ella tenemos las propiedades que se activarán cuando seleccionemos un elemento (particularmente me gusta mucho este elemento). El navegador del proyecto nos permitirá movernos entre los programas o scripts de SAS y además a la derecha tenemos una ventana que nos permite movernos entre los elementos y los procesos del código.

En este sentido hay que reconocer que la gente de WPS ha trabajado bastante bien y tienen un interfaz muy conseguido.

Por cierto, es muy importante señalar que WPS funciona en distintos sistemas operativos:

- Microsoft Windows
- Linux
- Solaris
- AIX
- Apple Mac
- OS X z/OS on Mainframe System z
- Linux on Mainframe System z

Si, es posible tener una arquitectura cliente servidor y es posible montarlo en un mainframe. Aunque el curso va muy orientado a trabajar en un PC, si es necesario montamos una máquina virtual y también trabajamos cliente servidor. Los módulos disponibles en WPS son:

- `WPS Core`: Es un interprete de SAS y soporta lenguaje `BASE`, `macros`, `ODS` y `formatos`.
- `WPS Graphing`: Equivalente al `GRAPH` de SAS.
- `WPS Statistics`: Procedimientos estadísticos.
- `WPS SDK`: Módulo específico para trabajar con otros lenguajes de programación
- `WPS Workbench`: Interfaz gráfico de usuario
- `WPS Engine for DB Files`: Acceso a `SPSS` o `dBase`
- `WPS Engine for DB2`: Acceso a `DB2`
- `WPS Engine for MySQL`
- Library engine for accessing `ODBC` datasources.
- `WPS Engine for Oracle`
- `WPS Engine for Teradata`
- `WPS Engine for SQL Server`

Estas son las posibilidades que nos ofrece WPS. De nuevo insisto que en estas líneas nos vamos a centrar en trabajar con lenguaje `BASE`, si detecto un mayor interés en otros módulos trabajaremos sobre ellos.

Saludos.
