---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2014-09-24T02:32:47-05:00'
lastmod: '2025-07-13T15:58:24.450268'
related:
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- macros-sas-informe-de-un-dataset-en-excel.md
- trucos-sas-macrovariable-a-dataset.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
slug: haciendo-ventanas-con-window-en-sas
tags:
- '%window'
- pmenu
title: Haciendo ventanas con %WINDOW en SAS
url: /blog/haciendo-ventanas-con-window-en-sas/
---

No es habitual emplear SAS BASE para crear menús o ventanas, aunque con el PROC PMENU se han hecho maravillas. Hoy vamos a poner un ejemplo sencillo de uso de %WINDOW para hacer el menú más simple posible con SAS BASE, nuestro objetivo es consultar los datos de un cliente sobre una tabla. Creamos unos datos aleatorios para ilustrar el ejemplo y una macro para hacer consultas:

```r
data aleatorio(index=(id_cliente));
do id_cliente=1 to 11000;
	importe=ranuni(56)*450;
	output;
end;
run;
%macro selecciona(cli=);
proc sql;
select a.*
from aleatorio a
where id_cliente=&cli.;
quit;
%mend;
```


Partimos de una tabla con 2 variables id_cliente e importe y deseamos crear un menú en el que nos liste los datos para un id_cliente. Lo más sencillo que podemos hacer con SAS BASE es:

```r
%window consulta color=grey
  #2 @2 'Seleccionar id_cliente:'
  #3 @26 id 8 attr=underline ;
%display consulta;

%selecciona(cli=&id.);
```


Creamos la ventana consulta donde añadimos un texto en la línea (#) 2 posición (@) 2 y leemos la macro variable global id con longitud 8 en la línea 3 columna 26 ponemos un subrayado para que quede claro donde está. Posteriormente llamamos a la macro selecciona y como parámetro le pasamos el id. No es muy complicado pero tampoco podemos hacer grandes cosas. Saludos.