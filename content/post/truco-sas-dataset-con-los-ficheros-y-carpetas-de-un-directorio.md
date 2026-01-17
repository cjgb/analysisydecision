---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-03-03T09:06:44-05:00'
lastmod: '2025-07-13T16:08:08.152298'
related:
- trucos-excel-archivos-de-un-directorio-con-una-macro.md
- trucos-sas-mas-usos-de-infile-y-pipe-directorios-en-tablas-sas.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- macros-sas-informe-de-un-dataset-en-excel.md
- truco-sas-un-vistazo-a-ficheros-planos-muy-grandes.md
slug: truco-sas-dataset-con-los-ficheros-y-carpetas-de-un-directorio
tags: []
title: 'Truco SAS: Dataset con los ficheros y carpetas de un directorio.'
url: /blog/truco-sas-dataset-con-los-ficheros-y-carpetas-de-un-directorio/
---

En ocasiones necesitamos listar los archivos de un directorio. En SAS se puede hacer así. Creamos una tabla en WORK archivos con los nombres de los archivos y subcarpetas de un directorio:

```r
/*PONE ARCHIVOS DE UN DIRECTORIO EN TABLA SAS*/
%macro archivos(directorio);
data archivos;
rc=filename('dir',"&directorio.");
dirid=dopen('dir');
numarchivos=dnum(dirid);
do i=1 to numarchivos;
nombrearchivos=dread(dirid,i);
output;
end;
rc=close(dirid);
drop rc i;
run;
%mend archivos; /*EJEMPLO SI QUEREMOS QUE NOS LISTE LAS TABLAS
SAS DEL WORK*/
proc sql noprint;
select path into:ub_work
from sashelp.vlibnam
where libname = "WORK";
quit;
%archivos(&ub_work.); data archivos;
set archivos;
where index(lowcase(nombrearchivos),"sas7bdat")>1;
run;
```


Puede sernos de gran utilidad cuando deseemos importar un gran número de ficheros de texto o si necesitamos manejarnos con archivos y _shell,_ empleamos las funciones de "archivo" de SAS (en breve pondré un artículo sobre las funciones SAS). El programa se puede sofisticar empleando extensiones, eliminando carpetas,... Espero vuestros comentarios y mejoras sobre el uso de esta macro.

Compartiendo conocimientos.