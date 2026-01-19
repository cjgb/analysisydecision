---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2013-09-11'
lastmod: '2025-07-13'
related:
- trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
- truco-sas-identificar-el-proceso-en-unix-con-sysjobid.md
- monograficos-call-symput-imprescindible.md
- abreviar-codigo-en-enterprise-guide.md
- truco-excel-y-sas-ejecutar-sas-desde-macro-en-excel.md
tags:
- enterprise guide
title: Truco SAS. SYSECHO para controlar las ejecuciones en Enterprise Guide
url: /blog/truco-sas-sysecho-para-controlar-las-ejecuciones-en-enterprise-guide/
---
Un truco SAS que envió una lectora del blog. Se emplea en **Enterprise Guide** y nos permite conocer en que punto del código está nuestra ejecución. En Enterprise Guide si no somos muy ordenados con nuestros códigos podemos tener algún problema, en la pantalla de estado de las tareas tenemos un nombre de la tarea un estado, la posición en cola el servidor desde el que se ejecuta y el tipo de servidor para los momentos en los que trabajamos con múltiples servidores. Con _**sysecho** _lo que hacemos es ver el estado de la tarea. Ejemplo práctico a ejecutar:

```r
data uno;
sysecho "Bucle 1";
do i=1 to 2000000000;
end;
run;

data dos;
sysecho "Bucle 2";
do i=1 to 2000000000;
end;
run;
```


Truco muy práctico para grandes ejecuciones en Enterprise Guide. Saludos.