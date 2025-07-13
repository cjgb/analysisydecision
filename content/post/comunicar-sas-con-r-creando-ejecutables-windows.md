---
author: rvaquerizo
categories:
- Formación
- R
- SAS
date: '2010-04-01T17:36:22-05:00'
lastmod: '2025-07-13T15:55:12.902139'
related:
- macros-sas-dataset-a-data-frame-r.md
- trucos-sas-envio-de-email-con-data.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
- truco-sas-como-leer-pc-axis-con-sas.md
- lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r.md
slug: comunicar-sas-con-r-creando-ejecutables-windows
tags:
- ''
- conectar SAS y R
- file
- put
title: Comunicar SAS con R creando ejecutables Windows
url: /comunicar-sas-con-r-creando-ejecutables-windows/
---

Quiero trabajar hoy con la función _put_ de SAS para la creación de ficheros ejecutables de Windows (.BAT) y también quiero comunicar SAS con R. Mato dos pájaros de un tiro y para ello vamos a crear un script de R que llamaremos desde SAS a partir de un archivo .BAT. Un ejemplo típico y muy sencillo que espero poder ir sofisticando con el paso del tiempo hasta llegar a paquetizarlo. Tiene los siguientes pasos:

1\. Creamos un fichero con datos aleatorios en SAS:  

```r
data uno;

do i=1 to 2000;

x=rannor(34);

output;

end;

run;
```

2\. Exportamos la tabla SAS a csv para poder ser leído por R:  

```r
PROC EXPORT DATA= WORK.Uno

OUTFILE= "C:\raul\trabajo\SAS_R\uno.csv"

DBMS=CSV REPLACE;

RUN;
```

3\. Creamos el _script_ de R en SAS a través de un _fileref_ y la sentencia _put_ , sugiero el “abuso” de los punto y coma:  

```r
filename pgm 'C:\raul\trabajo\SAS_R\pgm.R';

data _null_;

file pgm;

put "uno=read.csv('C:\\raul\\trabajo\\SAS_R\\uno.csv');summary(uno);";

put "jpeg('C:\\raul\\trabajo\\SAS_R\\histograma.jpg');hist(uno$x);dev.off()";

put " ";

run;
```

Vemos que el código R le hemos metido a través de un paso _data+file+put_ en un _script_ de R \pgm.R, este _script_ lee el fichero de texto exportado previamente, realiza una sumarización y genera un fichero ._jpg_ en la misma ubicación que trabajamos. Este fichero tiene un simple histograma de la variable x que hemos gestado con SAS.

4\. Creamos un fichero de lotes de Windows que nos permite ejecutar R y el código previamente generado:

```r
filename open 'C:\raul\trabajo\SAS_R\ejecucion.bat';

data _null_;

file open;

put '"C:\Archivos de programa\R\R-2.10.0\bin\R.exe"  CMD BATCH "C:\raul\trabajo\SAS_R\pgm.R"';

call sleep (150);

run;
```

Con este paso data solo producimos un ejecutable que llama a R en modo _batch_ y ejecuta el _script_ de R previamente creado con SAS.

5\. Por ultimo ejecutamos todo el proceso:  

```r
options noxwait noxsync;

x '"C:\raul\trabajo\SAS_R\ejecucion.bat"';
```

La forma más simple de comunicar SAS con R y un buen ejemplo de creación de ficheros ejecutables. Puede ser muy practico si tenemos en cuenta lo limitado del motor de gráficos de SAS. Por este motivo parece interesante paquetizar todo este proceso. Un _bridge to R_ de andar por casa y a vuestra disposición de forma gratuita.