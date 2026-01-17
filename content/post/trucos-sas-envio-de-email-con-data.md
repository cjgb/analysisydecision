---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-06-28T10:12:43-05:00'
lastmod: '2025-07-13T16:09:56.658482'
related:
- trucos-excel-crear-un-borrador-de-correo-con-excel.md
- enviar-correos-electronicos-con-rstats-libreria-emayili.md
- comunicar-sas-con-r-creando-ejecutables-windows.md
- trucos-sas-macrovariable-a-dataset.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
slug: trucos-sas-envio-de-email-con-data
tags:
- email
- filename
title: Trucos SAS. Envío de email con DATA
url: /blog/trucos-sas-envio-de-email-con-data/
---

Si deseamos **enviar un email con SAS** hemos de realizar un proceso similar al que os presento a continuación. Es una duda que me ha llegado a través de correo electrónico, la resolución la comparto con todos por si vuelve a surgir. No quiero plantear macros complicadas ni parametrizaciones «extrañas». Esto se hace a través de FILENAME EMAIL:

```r
filename outbox email "rvaquerizo@analisisydecision.es";

data _null_;

file outbox

to=("rvaquerizo@analisisydecision.es")

cc=("rvaquerizo@analisisydecision.es")

subject="Prueba "

attach="c:\temp\borra.sas";

*CUERPO DEL MENSAJE;

put " Este es un mensaje automático. ";

put " ";

put " ";

run;
```

En outbox ponemos el correo de salida, después hacemos un DATA _NULL_ que escribe en el buzón de salida, en TO ponemos los destinatarios entre comillados, en CC las copias, en SUBJECT ya sabéis y en ATTACH también. Después si queremos escribir en el cuerpo del mensaje empleamos PUT. Una sintaxis muy sencilla, comentaros que este proceso al final está limitado por la aplicación que nos gestiona el correo. Al final requiere que pulsemos un botón, de hecho si alguien solventa este problema que me comente como lo ha hecho.

Saludos.