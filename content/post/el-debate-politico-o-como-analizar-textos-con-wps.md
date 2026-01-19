---
author: rvaquerizo
categories:
- business intelligence
- data mining
- formación
- monográficos
- sas
- wps
date: '2011-02-04'
lastmod: '2025-07-13'
related:
- analisis-de-textos-con-r.md
- analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana.md
- comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
- curso-de-lenguaje-sas-con-wps-funciones-en-wps.md
tags:
- text mining
- sas
title: El debate político o como analizar textos con WPS
url: /blog/el-debate-politico-o-como-analizar-textos-con-wps/
---
¿Qué hacen los políticos españoles en el Congreso de los Diputados? Las tertulias radiofónicas están llenas de analístas políticos que podrán opinar sobre la labor del Congreso mejor que yo. Sin embargo yo tengo WPS, sé programar en SAS y en la [web del Congreso](http://www.congreso.es/portal/page/portal/Congreso/Congreso) están [todas las sesiones y todas las intervenciones](http://www.congreso.es/portal/page/portal/Congreso/Congreso/Intervenciones/Busqueda%20avanzada) de la democracia. Pues con estos elementos vamos a iniciar un proceso de _text mining,_ aunque no llegaremos a realizar ningún análisis complejo. Para comenzar, como siempre, necesito datos. Me he guardado [la sesión del Congreso de los Diputados del día 26/01/2011](http://www.congreso.es/portal/page/portal/Congreso/PopUpCGI?CMD=VERLST&BASE=puw9&FMT=PUWTXDTS.fmt&DOCS=1-1&QUERY=%28CDP201101260219.CODI.%29#%28P%C3%A1gina46%29) como web y posteriormente con Word la he salvado como fichero de texto (ojo con las codificaciones). De todos modos podéis [descargaros aquí](/images/2011/02/popupcgi.txt "popupcgi.txt") el fichero.

Comienza nuestro trabajo con WPS y lo primero es crear una tabla con la sesión:

```r
filename sesion "D:\raul\wordpress\text mining WPS\PopUpCGI.txt" ;

data sucio;

infile sesion RECFM=V LRECL=10000;

informat linea1 10000.;

format linea110000.;

input linea1 $10000. ;

run;
```

Comenzamos con lo más sencillo pero considero necesario realizar unos comentarios. Cuando hacemos el INFILE la longitud de registro es mejor que sea variable, así aprovechamos los saltos de línea, como longitud de registro 10000 caracteres me parecen suficientes, esto no tiene mucha ciencia pero considero que las intervenciones no habrían de tener más de 10000 caracteres. Ahora tenemos una tabla de frases y yo quiero llegar a una tabla de palabras, será necesario un bucle que recorra caracter a caracter y separe las palabras:

```r
data palabras;

set sucio end=fin;

drop linea1 i letra;

length palabra $20;

palabra="";

do i = 1 to length(linea1);

letra=substr(linea1,i,1);

if letra not in  (" ","-")  then palabra=compress(palabra||letra);

else do;

output;

palabra="";

end;end;

if fin then output;

run;
```

Este código no es sencillo pero lo puedo resumir en si hay un espacio en blanco o un guión eso implica separación entre palabras, es en ese momento cuando hago el OUTPUT, también lo tengo que hacer con la última palabra de la tabla. El proceso se realiza recorriendo caracter a caracter. El resultado es un dataset PALABRAS con las 29.903 palabras que se pronunciaron aquel día en el Congreso de los Diputados. Ahora necesitamos mejorar nuestros datos y quiero emplear [una macro que ya ha asomado en el blog en otras ocasiones](https://analisisydecision.es/macros-sas-limpiar-una-cadena-de-caracteres/). Además elimino tildes y algunas palabras que suelen usarse mucho:

``

Ya tenemos en nuestra sesión de WPS el dataset PALABRAS2 con la variable PALABRA2 con la que ya podemos hacer un pequeño análisis de que asuntos son los que más se tratan en las sesiones del congreso. ¿Y qué es lo primero que podemos hacer? Un ranking de palabras:

```r
proc sql;

create table cuenta as select

palabra2,

count(*) as frec

from palabras2

group by 1

order by 2 desc;

quit;

*Establecemos el ranking;

data cuenta;

set cuenta;

posicion = _n_;

run;
```

Ya podemos ver que los AEROPUERTOS despiertan el interés en nuestros representantes. Que el PARO o el EMPLEO parecen preocupar menos. En fin, empezamos a ver algunas cosas. Un trabajo sencillo con WPS nos permite realizar análisis muy interesantes. Os imagináis que tabulamos todas las intervenciones de la actual legislatura y analizamos que palabras son las que van despertando mayor interés en las sesiones. O por ejemplo, qué palabras son las que rodean a paro, ¿construcción, jóvenes? Qué diputados son los que más han intervenido, los que menos, la longitud de las palabras que emplean,… en fin mil cosas. No necesitamos software específico ni algoritmos complejos para realizar nuestros procesos de _text mining_. En poco menos de una hora he encontrado algunas cosas interesantes. Seguiré con ello.