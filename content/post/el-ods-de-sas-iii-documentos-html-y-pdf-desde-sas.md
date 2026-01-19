---
author: rvaquerizo
categories:
- formación
- sas
date: '2008-06-19'
lastmod: '2025-07-13'
related:
- el-ods-de-sas-ii-dataset-desde-output.md
- el-ods-de-sas-i-elementos-del-output.md
- truco-sas-crear-ficheros-excel-sin-proc-export-i.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- macros-sas-informe-de-un-dataset-en-excel.md
tags:
- sin etiqueta
title: El ODS de SAS (III). Documentos HTML y PDF desde SAS
url: /blog/el-ods-de-sas-iii-documentos-html-y-pdf-desde-sas/
---
Desde SAS podemos generar PDF y HTML. Esto es muy práctico a la hora de reportar información ya que no necesitaremos pasar por Excel o cualquier otra herramienta de ofimática para generar informes. Además, si generamos HTML podemos crear webs en las que podemos navegar por los resultados obtenidos con SAS. En este mensaje veremos algunos ejemplos prácticos de uso del ODS para conocer mejor su funcionamiento. El primero de ellos crea un informe web a partir de un proc univariate:

```r
*CONJUNTO DE DATOS ALEATORIO;
data uno;
do i=1 to 20000;
importe=round(rand("normal")*1000,.1);
num_productos=min(max(1,rand("pois",4)),8);
num_cargos=max(0,rand("pois",10)-int(rand("uniform")*10));
output ;
end;
run;

*EN EL ODS ESPECIFICAMOS LA RUTA DE SALIDA
 Y LOS NOMBRES DE LAS PAGINAS;;
ods html
	path='C:\temp\web'
	body='salida.htm'
    	contents='menu.htm'
	frame='contenido.htm'
	page='paginas.htm';

title "Cargos para clientes con 2 o menos productos";
proc univariate data=uno;
class num_productos;
var num_cargos;
where num_productos <=2;
quit;
title;
ods html close;
```


Generamos un dataset aleatorio y posteriormente deseamos hacer un análisis univariante de la variable num_cargos por el num_productos. En c:\temp\web podemos ver 4 páginas, para verlas empleamos la página «frame» contenido.htm, veamos más ejemplos que nos permitan conocer mejor el funcionamiento:

```r
ods noresults;
ods output Chisq=testchi;
proc freq data=uno;
tables num_productos*num_cargos/chisq;
quit;
ods results;

ods html
	path='C:\temp\web'
	body='test_chi2.htm';
title "Test chi cuadrado:";
proc print data=testchi noobs;
run;
title;
ods html close;
```


Creamos una tabla con el test de la Chi cuadrado para dos variables y la escribimos en la ubicación de nuestras páginas con el nombre test_chi2. Importante reseñar que el resultado de nuestros informes será «el BODY». Podemos emplear múltiples procedimientos para mejorar nuestros informes:

```r
ods html
	style=printer
	path='C:\temp\web'
	body='resumen.htm';

proc format ;
value cargos
low-5='1 Hasta 4 cargos'
5-15='2 De 5 a 14 cargos'
15-high='3 Más de 15 cargos'
;quit;

proc format ;
value prod
low-6='1 Hasta 5 productos'
6-high='2 Más de 5 cargos'
;quit;

title "Resumen";
proc report data=uno nowd;
     column num_cargos num_productos importe;
	 define num_productos/group format=prod.;
	 define num_cargos/group format=cargos.;
	 define importe/ analysis sum format=commax32.0;
     break after num_cargos / ol summarize;
run;
title;
ods html close;
```


La información que vamos reportando se puede hacer más sofisticada y con el proc report damos formato a nuestras tablas y con la opción STYLE del ODS podemos emplear los distintos estilos que tiene SAS. Otro uso muy frecuente del ODS es la creación de PDF. Veamos un ejemplo de uso:

```r
ods pdf
	style=minimal
	file='c:\temp\estudio.pdf';

options nodate pageno=1 linesize=64 pagesize=60;

title "Cargos para clientes con 2 o menos productos";
proc univariate data=uno;
class num_productos;
var num_cargos;
where num_productos <=2;
quit;

title "Resumen: ";
proc report data=uno nowd;
     column num_cargos num_productos importe;
	 define num_productos/group format=prod.;
	 define num_cargos/group format=cargos.;
	 define importe/ analysis sum format=commax32.0;
     break after num_cargos / ol summarize;
run;
title;
ods pdf close;
```


En un mismo documento podemos introducir más de un informe. Los marcadores que genera cada parte de nuestro documento PDF nos permiten navegar por él. También podemos introducir comentarios y frases con ello podríamos realizar informes automáticos con comentarios personalizados. Espero que estos mensajes estén sirviendo de ayuda para conocer el uso del ODS, cuando empecemos a realizar estudios planteraré más ejemplos de su uso. Como siempre, para cualquier duda o sugerencia: rvaquerizo@analisisydecision.es