---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-07-17'
lastmod: '2025-07-13'
related:
  - trucos-sas-mas-usos-de-infile-y-pipe-directorios-en-tablas-sas.md
  - truco-sas-dataset-con-los-ficheros-y-carpetas-de-un-directorio.md
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
  - comunicar-sas-con-r-creando-ejecutables-windows.md
  - trucos-sas-macrovariable-a-dataset.md
tags:
  - sin etiqueta
title: Truco SAS. Uso de filename y pipe
url: /blog/truco-sas-uso-de-filename-y-pipe/
---

Hoy presento una de las utilidades de FILENAME para interactuar con los _file systems_ en los que creamos tablas SAS. Consiste en emplear FILENAME con la opción PIPE. Lo que hacemos es asignar una referencia a una ejecución del sistema operativo. Por ejemplo en Windows:

```r
filename dir pipe "dir c:\";data uno;

 infile dir;

 input datos $50.;

run;
```

Creamos una tabla SAS temporal que contiene el resultado de la ejecución en MS DOS de \_dir c:\_ muy simple. Pero donde de verdad puede sernos de utilidad el uso de PIPE es en ejecuciones con UNIX. A continuación planteo algunos ejemplos:

Informe sobre estado de un filesystem del servidor:

```r
%let unidad=; *DEFINE AQUI TU FILESYSTEM;

filename df pipe "df -k /&unidad.";

data uno;

      retain nombre dato;

      infile df pad;

      input pepin $100.; drop pepin;

      if _n_=1 then delete;

      dato=scan(pepin,1," ")*1;

      if _n_=2 then nombre="Espacio libre    ";

      if _n_=3 then nombre="Espacio utilizado";

      if _n_=4 then nombre="% ocupado";

run;

proc print data=uno;

proc delete data=uno; run;
```

Tenemos una salida que nos premite conocer el espacio libre, el espacio ocupado y el %. Por otro lado si deseamos listar aquellos ficheros que tienen un tamaño mayor a 1GB podemos hacer los comandos UNIX _ls -ltr|sort +4nr_ :

```r
filename tam pipe "ls -laR| sort +4nr";

x "cd /&unidad.";

data dos;

      infile tam pad;

      input pepin $ 200.; drop pepin;

      usuario=scan(pepin,3," ");

      tam=scan(pepin,5," ")*1;

      tam=round((tam/1024)/1000000,.01);

      dia=put(scan(pepin,6," ")*1,z2.);

      mes=scan(pepin,7," ");

      anio=scan(pepin,8," ");

      if index(anio,":")>0 then anio=year(date());

      fich=scan(pepin,9," ");

      if tam>=1;

run;
```

El uso del FILENAME y el PIPE puede ser tremendamente práctico para realizar pequeños informes sobre la situación de nuestro servidor y en función de estos informes podremos lanzar nuestros procesos. También podemos eliminar con SAS ficheros antiguos, identificar que usuario llena un filesystem,…

Espero que os sea de utilidad y por supuesto si teneís dudas: rvaquerizo@analisisydecision.es
