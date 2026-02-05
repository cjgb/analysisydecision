---
author: rvaquerizo
categories:
  - formación
  - r
  - sas
date: '2010-04-01'
lastmod: '2025-07-13'
related:
  - macros-sas-dataset-a-data-frame-r.md
  - trucos-sas-envio-de-email-con-data.md
  - curso-de-lenguaje-sas-con-wps-ejecuciones.md
  - truco-sas-como-leer-pc-axis-con-sas.md
  - lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r.md
tags:
  - conectar sas y r
  - file
  - put
title: Comunicar SAS con R creando ejecutables Windows
url: /blog/comunicar-sas-con-r-creando-ejecutables-windows/
---

Quiero trabajar hoy con la función `put` de SAS para la creación de ficheros ejecutables de Windows (`.BAT`) y también quiero comunicar SAS con `R`. Mato dos pájaros de un tiro y para ello vamos a crear un *script* de `R` que llamaremos desde SAS a partir de un archivo `.BAT`. Un ejemplo típico y muy sencillo que espero poder ir sofisticando con el paso del tiempo hasta llegar a paquetizarlo. Tiene los siguientes pasos:

1. Creamos un fichero con datos aleatorios en SAS:

```sas
data uno;
  do i = 1 to 2000;
    x = rannor(34);
    output;
  end;
run;
```

2. Exportamos la tabla SAS a `.csv` para poder ser leído por `R`:

```sas
proc export data=WORK.Uno
  outfile="C:\raul\trabajo\SAS_R\uno.csv"
  dbms=CSV REPLACE;
run;
```

3. Creamos el *script* de `R` en SAS a través de un `fileref` y la sentencia `put`; sugiero el “abuso” de los puntos y coma:

```sas
filename pgm 'C:\raul\trabajo\SAS_R\pgm.R';

data _null_;
  file pgm;
  put "uno = read.csv('C:\\raul\\trabajo\\SAS_R\\uno.csv'); summary(uno);";
  put "jpeg('C:\\raul\\trabajo\\SAS_R\\histograma.jpg'); hist(uno$x); dev.off()";
  put " ";
run;
```

Vemos que el código `R` lo hemos metido a través de un paso `data` + `file` + `put` en un *script* de `R` `\pgm.R`; este *script* lee el fichero de texto exportado previamente, realiza una sumarización y genera un fichero `.jpg` en la misma ubicación en la que trabajamos. Este fichero tiene un simple histograma de la variable `x` que hemos gestado con SAS.

4. Creamos un fichero de lotes de Windows que nos permite ejecutar `R` y el código previamente generado:

```sas
filename open 'C:\raul\trabajo\SAS_R\ejecucion.bat';

data _null_;
  file open;
  put '"C:\Archivos de programa\R\R-2.10.0\bin\R.exe" CMD BATCH "C:\raul\trabajo\SAS_R\pgm.R"';
  call sleep(150);
run;
```

Con este paso `data` solo producimos un ejecutable que llama a `R` en modo *batch* y ejecuta el *script* de `R` previamente creado con SAS.

5. Por último ejecutamos todo el proceso:

```sas
options noxwait noxsync;
x '"C:\raul\trabajo\SAS_R\ejecucion.bat"';
```

La forma más simple de comunicar SAS con `R` y un buen ejemplo de creación de ficheros ejecutables. Puede ser muy práctico si tenemos en cuenta lo limitado del motor de gráficos de SAS. Por este motivo parece interesante paquetizar todo este proceso. Un *bridge to R* de andar por casa y a vuestra disposición de forma gratuita.
