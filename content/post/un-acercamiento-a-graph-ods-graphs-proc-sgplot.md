---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2010-05-28T07:38:01-05:00'
slug: un-acercamiento-a-graph-ods-graphs-proc-sgplot
tags:
- ''
- GRAPH
- ODS GRAPHS
- SGPLOT
title: Un acercamiento a GRAPH. ODS GRAPHS PROC SGPLOT
url: /un-acercamiento-a-graph-ods-graphs-proc-sgplot/
---

[](/images/2010/05/sgplot18.png "BOXPLOT SGPLOT")[![BOXPLOT SGPLOT](/images/2010/05/sgplot22.thumbnail.png)](/images/2010/05/sgplot22.png "BOXPLOT SGPLOT") [![HISTOGRAMAS SGPLOT](/images/2010/05/sgplot34.thumbnail.png)](/images/2010/05/sgplot34.png "HISTOGRAMAS SGPLOT")[![BARRAS CON GRUPOS SGPLOT](/images/2010/05/sgplot46.thumbnail.png)](/images/2010/05/sgplot46.png "BARRAS CON GRUPOS SGPLOT")

[![REGRESION CON SGPLOT](/images/2010/05/sgplot59.thumbnail.png)](/images/2010/05/sgplot59.png "REGRESION CON SGPLOT")[![GRAFICO BARRAS LINEAS SGPLOT](/images/2010/05/sgplot180.thumbnail.png)](/images/2010/05/sgplot180.png "GRAFICO BARRAS LINEAS SGPLOT")[![BARRAS HORIZONTALES SGPLOT](/images/2010/05/sgplot40.thumbnail.png)](/images/2010/05/sgplot40.png "BARRAS HORIZONTALES SGPLOT")

[](/images/2010/05/sgplot18.png "BARRAS LINEAS SGPLOT")[](/images/2010/05/sgplot18.png "BARRAS LINEAS SGPLOT")[](/images/2010/05/sgplot18.png "BARRAS LINEAS SGPLOT")No todos los procedimientos gráficos de SAS son tan malos y tan complejos. Hay una serie de procedimientos como el **PROC SGPLOT** que nos permiten realizar gráficos muy vistosos y con una sintaxis más sencilla. Estos procedimientos son los que vamos a denominar **ODS GRAPHS**. Como siempre, en estas líneas, sólo os voy a acercar a algunas de las posibilidades que ofrece el PROC SGPLOT (a futuro veremos más) y despertar vuestra curiosidad. Hay documentación muy completa en la red al respecto, además, y sin que sirva de precedente, la ayuda de SAS es muy correcta.

El punto de partida habitual, un dataset de ejemplo:

```r
data aleatorio;

do i=1 to 2000;

if ranuni(6)>.6 then do;

altura=10*rannor(5)+174;

peso=5*rannor(4)+70;

sexo="Hombre";

end;

else do;

altura=10*rannor(5)+168;

peso=5*rannor(4)+60;

sexo="Mujer";

end;

output;

end;

run;
```

Ejemplo rebuscado; peso, altura y sexo. Algunos posibilidades:

Gráficos de cajas, imprescindibles:

```r
ods html style=minimal;

title "Cajas horizontales con línea de referencia";

proc sgplot data=aleatorio;

  hbox peso / category=sexo ;

  refline 65/axis=x;

run; quit;

*;

title "Cajas horizontales con línea de referencia";

proc sgplot data=aleatorio;

  vbox peso / category=sexo ;

  refline 65/axis=y;

run; quit;
```
`Código sencillo para unos gráficos vistosos y muy prácticos, no perdáis de vista el uso de ODS. Veamos histogramas:`
```r
ods html style=statistical;

title "Histograma de altura con densidades";

proc sgplot data=aleatorio;

histogram altura/nooutline scale=count;

density altura;

density altura/type=kernel ;

run;quit;
```
`Importante el uso de densidades, en mi caso particular un gráfico muy habitual. Barras verticales y horizontales:`

```r
ods html file="h-barras.html" path="C:\temp";

proc sgplot data=aleatorio;

hbar sexo/response=altura stat=mean datalabel;

quit;

*;

proc format;

value alt

low-180="Bajos"

180-high="Altos";

quit;

*;

ods html file="v-barras.html" path="C:\temp";

proc sgplot data=aleatorio;

format altura alt.;

vbar sexo/response=peso stat=sum datalabel group=altura;

quit;
```

Guardamos los resultados como html, las agrupaciones son bastante útiles en este tipo de gráficos. Código muy sencillo (insisto) han hecho algo bien. Dispersiones con **SCATTER** :

```r
title "Dispersones con elipse";

proc sgplot data=aleatorio;

scatter x=peso y=altura;

ellipse x=peso y=altura/;

run;

*;

title "Ajuste de recta de regresión";

proc sgplot data=aleatorio;

scatter x=peso y=altura/group=sexo;

reg x=peso y=altura/group=sexo cli clm;

run;

*;

title "Ajuste por regresión local";

proc sgplot data=aleatorio;

scatter x=peso y=altura/group=sexo;

loess x=peso y=altura/group=sexo;

run;
```

Añadimos al gráfico una predicción por elipse. También podemos hacer ajustes por regresión, espectaculares los intervalos de confianza que obtenemos. Podemos añadir una predicción por **LOESS** aunque en este ejemplo no tiene mucho sentido. SCATTER podría tener una entrada para él sólo. Ahora un gráfico de barras y líneas:

```r
proc format;

value alt

low-160="Bajos"

160-180="Medios"

180-high="Altos";

quit;

title "Líneas y barras por categorías";

proc sgplot data=aleatorio;

format altura alt.;

vline altura/response=peso stat=mean y2axis;

vbar altura/ transparency=0.3;

xaxis offsetmax=0.1 offsetmin=0.1;

run;
```

Alguno está pensando en mandar muy lejos el **PROC GBARLINE**. Yo tengo una entrada preparada al 80% y nunca verá la luz. Me dejo muchos gráficos y muchas posibilidades. Aunque estoy convencido que he cumplido mi objetivo con este mensaje, acercaros a uno de los pocos procedimientos gráficos de SAS que merecen la pena, así poco a poco váis dejando Excel. Por supuesto si tenéis dudas o sugerencias… [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)

Saludos.