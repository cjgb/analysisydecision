---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-04-09'
lastmod: '2025-07-13'
related:
  - truco-sas-sas-y-dde-aliados-de-excel.md
  - importar-a-sas-desde-otras-aplicaciones.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
tags:
  - sas
  - trucos
title: Truco SAS. Leer datos de Excel con SAS vía DDE
url: /blog/truco-sas-leer-datos-de-excel-con-sas-con-dde/
---

Si no disponemos del módulo `Access to PC Files` de SAS, no podremos importar a SAS datos de `Excel` sin emplear el `DDE`. En un [truco anterior](https://analisisydecision.es/truco-sas-sas-y-dde-aliados-de-excel/) vimos cómo, vía `DDE`, exportábamos ficheros de SAS a `Excel`. Empleando esta misma vía vamos a importar datos.

La metodología es análoga a la empleada con la exportación: asignamos un `filename` dinámico a un rango de datos de `Excel`, y nuestro paso `DATA` lee de ese `filename` `DDE` para crear una tabla SAS. Partimos de una tabla de ejemplo con estos datos:

![null](/images/2008/04/tabla2.JPG)

Lo primero que tenemos que tener en cuenta es la configuración regional; en este caso tenemos configuración europea y SAS tiene configuración americana. Nuestro paso `DATA` tendrá que transformar las variables. Por otro lado, el rango de datos va desde la `F1C1` a la `F20C3`; este valor es imprescindible para nuestro `filename`. El `DDE` no es muy flexible y es necesario especificar el rango de datos exacto. Veamos cómo queda nuestro programa SAS:

```sas
/* FILENAME PARA REFERENCIAR AL SISTEMA Y EMPLEAR CÓDIGO DDE */
filename sis dde 'EXCEL|SYSTEM';

/* ABRIMOS NUESTRO FICHERO DE EJEMPLO */
data _null_; 
    file sis; 
    put "[open(\"C:\\temp\\ej_dde.xls\")]"; 
run;

/* ASIGNAMOS UN FILENAME AL RANGO DEL QUE VAMOS A LEER */
filename ejemplo dde 'excel|Hoja2!f1c1:f20c3';

/* EN NUESTRO PASO DATA ASIGNAMOS LOS FORMATOS DE LECTURA Y SALIDA */
data uno;
    infile ejemplo;
    informat x commax16.5;
    informat y commax16.;
    informat z commax16.5;
    format x best16.;
    format y best16.;
    format z best16.;
    input x y z;
run;

/* CERRAMOS EL FICHERO EXCEL */
data _null_;
    file sis;
    put "[File.Close()]";
run;
```

Con este sistema podremos leer de tablas `Excel` y volcar su contenido a SAS.

En mi caso particular, no soy muy partidario del uso del `DDE` para leer datos de `Excel` debido a la «rigidez» que tiene a la hora de asignar el rango de lectura. Si leemos siempre una tabla con la misma estructura no tendremos problema; sin embargo, si el número de filas varía, el rango ha de ser modificado dinámicamente. Yo preferiría emplear macros en `Excel` que guarden la tabla como `.csv` y luego importarla desde SAS. Todo ésto se puede orquestar desde SAS. 

Por supuesto, si tenéis dudas o sugerencias, podéis contactar en `rvaquerizo@analisisydecision.es`. Saludos.