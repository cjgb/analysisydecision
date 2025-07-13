---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2009-07-02T08:38:20-05:00'
lastmod: '2025-07-13T16:06:26.030599'
related:
- curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
- trucos-sas-ordenar-las-variables-de-un-dataset.md
- trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
- truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
- trucos-sas-variables-dummy-de-una-variable-continua.md
slug: subconjuntos-de-variables-con-dropkeep
tags:
- drop keep
title: Subconjuntos de variables con DROP/KEEP
url: /subconjuntos-de-variables-con-dropkeep/
---

Me han llegado algunas cuestiones sobre el uso de DROP/KEEP y a raiz de ello me he decidido a hacer un mensaje sencillo para que los usuarios menos avanzados de SAS puedan entender su funcionamiento. Sé que muchos lectores son expertos programadores pero también es necesario tener un rincón con código SAS menos avanzado para aquellos que se estén acercando a esta programación. En este caso partimos de una tabla de datos aleatorios con 102 variables y 10.000 observaciones que generamos mediante el siguiente programa SAS:

```r
data uno;

array variab (100);

do j=1 to 10000;

do i=1 to 100;

variab(i)=rand("uniform")*100;

end;

output;

end;

run;
```

La idea es quedarnos sólo con las _variables j variab1, variab10_ hasta _variab19_ y _variab100_. Lo más habitual es emplear keep como una instrucción dentro de paso DATA:

```r
data sub1;

 set uno;

 keep j variab1 variab10--variab19 var100;

run;
```

Con — indicamos un rango de variables dentro del dataset para ahorrarnos escribirlas todas, además añadimos las restantes variables necesarias. Pero _keep_ también puede aparecer como una opción de lectura o de escritura de un conjunto de datos SAS. Como opción de escritura:

```r
data sub3 (keep=j variab1 variab10--variab19 variab100);

 set uno;

run;
```

Esto nos permite optimizar el espacio a la hora de generar un dataset, pero como más podemos optimizar nuestra ejecución de SAS es empleando _keep_ o _drop_ como opción de lectura:

```r
data sub2;

 set uno (keep=j variab1 variab10--variab19 variab100);

run;
```

Sólo leeremos de UNO las variables que nos interesan, esto puede hacer que un programa SAS sea mucho más rápido y nosotros mucho más eficientes para que nuestro responsable nos pida mucho más trabajo. Otra forma de seleccionar variables que tienen un nombre con una raiz similar es emplear en _DROP/KEEP_ el signo de puntuación : con ello indicamos a SAS que deseamos todas las variables que empiecen por un sufijo, por ejemplo:

```r
data sub4;

 set uno;

 keep j variab1:;

run;
```

Esto equivale a los códigos anteriormente vistos ya que nos quedamos con todas las variables que empiezan por _variab1_. Además del — contamos con los : para ahorrarnos mucho código y ser eficientes. Y si somos más eficientes podemos trabajar más o visitar esta magnífica web. Por supuesto todo lo anterior se puede aplicar a DROP para eliminar variables. Cualquier duda o sugerencia estoy en rvaquerizo@analisisydecision.es