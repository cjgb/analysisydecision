---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-04-09T08:34:04-05:00'
lastmod: '2025-07-13T16:08:18.865701'
related:
- truco-sas-sas-y-dde-aliados-de-excel.md
- importar-a-sas-desde-otras-aplicaciones.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- truco-sas-crear-ficheros-excel-sin-proc-export-i.md
- trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
slug: truco-sas-leer-datos-de-excel-con-sas-con-dde
tags: []
title: Truco SAS. Leer datos de Excel con SAS vía DDE
url: /blog/truco-sas-leer-datos-de-excel-con-sas-con-dde/
---

Si no disponemos del módulo Access to PC Files de SAS no podremos importar a SAS datos de Excel sin emplear el DDE. En un [truco anterior ](https://analisisydecision.es/truco-sas-sas-y-dde-aliados-de-excel/)vimos como vía DDE exportábamos ficheros de SAS a Excel. Empleando esta misma vía vamos a importar datos. La metodología es análoga a la empleada con la exportación. Asignamos un _filename_ dinámico a un rango de datos de Excel,  y nuestro paso data lee de ese _filename_ para crear una tabla SAS. Partimos del una tabla ejemplo con estos datos:

![null](/images/2008/04/tabla2.JPG)

Lo primero que tenemos que tener en cuenta es la configuración regional, en este caso tenemos configuración europea y SAS tiene configuración americana. Nuestro paso data tendrá que transformar las variables. Por otro lado el rango de datos va desde la F1:C1 a F3:C20, este valor es imprescindible para nuestro _filename_. El DDE no es muy flexible y es necesario especificar el rango de datos. Veamos como queda nuestro programa SAS:

```r
/*FILEMANE PARA REFERENCIAR AL SISTEMA Y EMPLEAR CODIGO DDE*/
 filename sis dde 'EXCEL|SYSTEM';/*ABRIMOS NUESTRO FICHERO DE EJEMPLO*/
data _null_; file sis; put "[open(""C:\temp\ej_dde.xls"")]"; run;

/*ASIGNAMOS UN FILENAME AL RANGO AL QUE VAMOS ESCRIBIR*/
filename ejemplo dde 'excel|Hoja2!f1c1:f20c3';

/*EN NUESTRO PASO DATA ASIGNAMOS LOS FORMATOS DE LECTURA Y SALIDA*/
data uno;
 informat x commax16.5;
 informat y commax16.;
 informat z commax16.5;
 format x best16.;
 format y best16.;
 format z best16.;
 infile ejemplo;
 input x y z;
run;

/*CERRAMOS Y GUARDAMOS EL FICHERO EXCEL*/
data _null_;
file sis;
put "[File.Close()]";
run;
```


Con este sistema podremos leer de tablas Excel y volcar su contenido a SAS.

En mi caso particular no soy muy partidario del uso del DDE para leer datos de Excel debido a la «rigidez» que tiene el DDE a la hora de de asignar el rango de lectura. Si leemos una tabla con la misma extructura no tendremos problema, sin embargo, si leemos datos variables el rango será siempre modificado. Yo emplearía macros que modificarnan la configuración regional y guardaran la tabla Excel como csv; posteriormente importaría los datos desde SAS. Todo esto se puede ejecutar perfectamente desde SAS y no habría problemas a la hora de automatizar el proceso. Por supuesto si tenéis dudas o sugerencias podéis contactar en [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)