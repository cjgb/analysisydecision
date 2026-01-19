---
author: rvaquerizo
categories:
- sas
- trucos
date: '2008-04-07'
lastmod: '2025-07-13'
related:
- truco-sas-sas-y-dde-aliados-de-excel.md
- truco-sas-crear-ficheros-excel-sin-proc-export-i.md
- macros-sas-informe-de-un-dataset-en-excel.md
- truco-sas-unir-todos-los-excel-en-uno-solo.md
- truco-sas-leer-datos-de-excel-con-sas-con-dde.md
tags:
- sin etiqueta
title: Truco SAS. Crear ficheros Excel sin PROC EXPORT (II)
url: /blog/truco-sas-crear-ficheros-excel-sin-proc-export-ii/
---
Con [anterioridad ](https://analisisydecision.es/truco-sas-crear-ficheros-excel-sin-proc-export-i/)hemos visto el manejo del ODS y como nos sirve para generar archivos HTML que podemos usar con Excel sin necesidad de emplear el PROC EXPORT. Pero el lenguaje SAS empleado era complicado y requería muchas líneas de código. Pues esto podemos evitarlo si creamos nuestra propia macro para exportar nuestras tablas SAS a tablas Excel.

«Simplemente» hemos de parametrizar el código que vimos en la [primera parte del truco SAS](https://analisisydecision.es/truco-sas-crear-ficheros-excel-sin-proc-export-i/). Pero realizaremos diversas modificaciones para que nuestro código sea más práctico:

```r
%macro excel(ubicacion,dataset);option missing="";

title;

/*ELIMINAMOS LA LIBRERIA SAS DEL NOMBRE*/

 %let aux1=%scan("&dataset.",2,".");

/*LAS VARIABLES NUMERICAS IRAN CON FORMATO EUROPEO*/

 proc contents data=&dataset.

 			  out=_temporal_ (where=(type=1) keep=name type) noprint ;

 run;

/*CREAMOS UNA INSTRUCCION PARA DAR EL FORMATO EUROPEO*/

 proc sql noprint;

 	select "format "||compress(name)||" commax12.6" into:_instruccion separated by "; "

 	from _temporal_;

 quit;

proc delete data=_temporal_; run;

/*EMPLEAMOS EL PROC PRINT JUNTO CON ODS*/

 filename _temp_ "&ubicacion.\&aux1..xls";

title ;

 ods noresults;

 ods listing close;

 ods html file=_temp_ rs=none style=minimal;

 	proc print data=&dataset. noobs;

 	&_instruccion.;

 	run;

 ods html close;

 ods results;

 ods listing;

option missing=".";

%mend excel;
```


Con esta macro ya disponemos de una función que nos exporta nuestras tablas SAS a Excel. Por ejemplo:

```r
data uno;
 do i=1 to 100;
  j=ranpoi(23,3);
  k=ranpoi(123,3);
  l=ranpoi(2,3);
  m=ranpoi(3,3);
  n=l/j;
  uno="hola";
  y=ranuni(89)*100;
 output;
 end;
run;
%excel(C:\,work.uno);
```


Interesante macro la que os planteo, puede sernos de gran utilidad a la hora de realizar validaciones de ficheros, tabular información, análisis exploratorios,… La interactuación entre SAS y Office nos facilitará nuestro trabajo.

Si tenéis más dudas o sugerencias… [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)