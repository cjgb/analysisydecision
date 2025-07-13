---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2010-04-05T13:52:21-05:00'
lastmod: '2025-07-13T16:10:52.327393'
related:
- un-acercamiento-a-graph-sentencias-graficas.md
- un-acercamiento-a-graph-primeros-graficos-con-sas.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- un-acercamiento-a-graph-proc-ganno.md
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
slug: un-acercamiento-a-graph-proc-gchart
tags:
- GRAPH
- LEGEND
- PATTERN
- PROC GCHART
title: Un acercamiento a GRAPH. PROC GCHART
url: /un-acercamiento-a-graph-proc-gchart/
---

Uno de los procedimientos más importantes a la hora de graficar con SAS es el PROC GCHART. Además nos va a servir para trabajar con PATTERN y LEGEND sentencias que nos dejamos en el anterior capítulo. GCHART nos permite realizar gráficos de barras, de esos que siempre hacemos en Excel porque es mas sencillo y mas rápido. Sin embargo en muchas ocasiones necesitamos automatizar informes y estudios, para ello es recomendable emplear SAS en vez del habitual Excel por eso estas líneas que estáis leyendo. Para GCHART podemos emplear las sentencias habituales de GRAPH pero PATTERN es especialmente importante porque SAS nos deja cada barra del mismo color. Para ilustrar el capitulo simulo la cartera de una compañía de seguros, durante 2009, mensualmente, las pólizas de esta compañía pueden ser anuladas, renovadas (nuestra cartera) o nueva producción:

```r
data renovaciones;

do mes=200901 to 200912;

do i=1 to max(ranexp(3)*10000,ranpoi(8,10000));

if ranuni(8)<=0.17 then tipo="Anul";

else if ranuni(9)<=0.8 then tipo="Cartera";

else tipo="NP";

output;

end; end; drop i;

run;
```

Simulo un _dataset_ que tiene dos variables: mes (numérica) y tipo (alfanumérica). Estudiamos la distribución por meses:

```r
pattern1 color=gray ;

pattern2 color=blue ;

pattern3 color=salmon;

proc gchart;

vbar mes/ name='uno' ;

vbar mes/discrete name='dos' outside=freq;

vbar mes/discrete subgroup=tipo name='tres';

vbar tipo/group=mes name='cuatro';

run;quit;

*PONEMOS LOS GRAFICOS EN UNO SOLO;

proc greplay igout=work.gseg tc=sashelp.templt template=L2r2 NOFS ;

treplay 1:uno 2:dos 3:tres 4:cuatro; run; quit;
```

[](https://analisisydecision.es/un-acercamiento-a-graph-proc-gchart/ejemplo-de-uso-de-proc-gchart/ "Ejemplo de uso de PROC GCHART")

![Ejemplo de uso de PROC GCHART](/images/2010/04/graph31.thumbnail.jpg)

Con pattern vamos a definir el color de cada barra, por defecto SAS asigna a todas las barras el mismo color como nos pasa en el grafico cuatro. La opción **DISCRETE** tiene su importancia si representamos valores numéricos, _uno_ crea una escala y en _dos_ ya con la opción DISCRETE no aparece escala alguna y no representamos variable continua sino discreta. OUTSIDE nos sirve para indicar si queremos ver los valores asociados a las barras. El grafico _tres_ nos divide con SUBGROUP una barra en grupos, cada barra toma los colores que le hemos indicado con PATTERN. El grafico _cuatro_ nos crea tantas barras como grupos representemos en el eje X, vemos que no ha funcionado PATTERN y que las 3 barras tienen el mismo color. Mejoremos el grafico _cuatro_ :

```r
pattern1 color=gray ;

pattern2 color=blue ;

pattern3 color=salmon;

legend1

across=1 shape=bar(3,2)

label=("Tipo" h=11 pt)

position=(top inside left)

value=(h=9pt 'Anulaciones' 'Cartera'

'Nueva producción');

*GRAFICO EN 3D;

proc gchart;

vbar3d tipo/group=mes noframe shape=CYLINDER

legend=legend1 name='cinco' subgroup=tipo;

run;quit;
```

[](https://analisisydecision.es/un-acercamiento-a-graph-proc-gchart/ejemplo-de-uso-de-proc-gchart-2/ "Ejemplo de uso de PROC GCHART")

![Ejemplo de uso de PROC GCHART](/images/2010/04/graph32.thumbnail.jpg)

Es curioso, para que funcione PATTERN con GCHART tenemos que usar SUBGROUP (¿?) empezamos a sospechar porque muchos prefieren Excel. En este caso empleamos VBAR3D para obtener barras de 3 dimensiones, con SHAPE especificamos el tipo de barra que deseamos, por defecto es BLOCK. Con NOFRAME evitamos que SAS ponga un fondo poco estético. Dejo para el final LEGEND. Las leyendas en SAS tienen que venir predefinidas con la sentencia LEGEND fuera de los procedimientos, también dan motivos para usar Excel. En LEGEND podemos modificar:

  * across – numero de columnas
  * frame – cuadrado alrededor
  * label – Etiqueta de la leyenda
  * position – ubicación
  * shape – especificamos el tamaño y la forma
  * value – valores para las representaciones

En el ejemplo que nos ocupa indicamos una columna con el titulo Tipo, la posición es izquierda y arriba y damos 3 valores de tamaño (height) 9. Completo ejemplo. El resultado obtenido es:

Hay que darle una vuelta a los ejes con AXIS y VALUE, os lo dejo a modo de ejercicio. Saludos.