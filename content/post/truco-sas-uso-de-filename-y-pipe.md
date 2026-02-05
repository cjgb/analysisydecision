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
  - sas
  - trucos
title: Truco SAS. Uso de filename y pipe
url: /blog/truco-sas-uso-de-filename-y-pipe/
---

Hoy presento una de las utilidades de `FILENAME` para interactuar con los *file systems* en los que creamos tablas SAS. Consiste en emplear `FILENAME` con la opción `PIPE`. Lo que hacemos es asignar una referencia a una ejecución del sistema operativo. Por ejemplo, en `Windows`:

```sas
filename dir_pipe pipe "dir c:\";

data uno;
    infile dir_pipe;
    input datos $char50.;
run;
```

Creamos una tabla SAS temporal que contiene el resultado de la ejecución en `MS-DOS` de `dir c:\`; muy simple. Pero donde de verdad puede sernos de utilidad el uso de `PIPE` es en ejecuciones con `UNIX`. A continuación, planteo algunos ejemplos:

### Informe sobre estado de un *file system* del servidor

```sas
%let unidad = ; * DEFINE AQUÍ TU FILESYSTEM;

filename df_pipe pipe "df -k /&unidad.";

data uno;
    infile df_pipe pad;
    input line $char100.;
    if _n_ = 1 then delete;
    
    * Procesamiento de la línea para extraer datos;
    dato = scan(line, 1, " ") * 1;
    if _n_ = 2 then nombre = "Espacio libre    ";
    else if _n_ = 3 then nombre = "Espacio utilizado";
    else if _n_ = 4 then nombre = "% ocupado";
    
    retain nombre;
run;

proc print data=uno; 
run;
```

Tenemos una salida que nos permite conocer el espacio libre, el espacio ocupado y el %. Por otro lado, si deseamos listar aquellos ficheros que tienen un tamaño mayor a 1GB, podemos emplear comandos `UNIX` como `ls -laR | sort +4nr`:

```sas
filename tam_pipe pipe "ls -laR | sort +4nr";

data dos;
    infile tam_pipe pad;
    input pepin $char200.;
    
    usuario = scan(pepin, 3, " ");
    tam_bytes = scan(pepin, 5, " ") * 1;
    tam_gb = round((tam_bytes / 1024**3), .01);
    
    dia = put(scan(pepin, 6, " ") * 1, z2.);
    mes = scan(pepin, 7, " ");
    anio = scan(pepin, 8, " ");
    
    if index(anio, ":") > 0 then anio = put(year(date()), 4.);
    
    fich = scan(pepin, 9, " ");
    
    if tam_gb >= 1;
run;
```

El uso del `FILENAME` y el `PIPE` puede ser tremendamente práctico para realizar pequeños informes sobre la situación de nuestro servidor y, en función de estos informes, podremos lanzar nuestros procesos. También podemos eliminar con SAS ficheros antiguos, identificar qué usuario llena un *file system*…

Espero que os sea de utilidad y, por supuesto, si tenéis dudas: `rvaquerizo@analisisydecision.es`. Saludos.