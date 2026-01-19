---
author: rvaquerizo
categories:
  - formación
date: '2016-11-03'
lastmod: '2025-07-13'
related:
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - macros-sas-limpiar-una-cadena-de-caracteres.md
  - macros-faciles-de-sas-normaliza-un-texto-rapido.md
  - trucos-sas-eliminacion-de-espacios-en-blanco.md
  - truco-sas-limpiar-un-fichero-de-texto-con-sas.md
tags:
  - sin etiqueta
title: Truco SAS. Limpieza de tabuladores con expresiones regulares
url: /blog/truco-sas-limpieza-de-tabuladores-con-expresiones-regulares/
---

Un lector necesita eliminar tabuladores de una cadena de texto y no le están funcionando las funciones habituales, sugiero emplear expresiones regulares, en mi entorno de SAS si está funcionando:

[source languaje=»SAS»]
data ejemplo;
input frase 50.;
cards;
Hola este es un ejemplo""""""
Hola es te es un ejemplo\_\_\_\_\_\_\_
Hola este es un ejemplo++++++++
;
run;

data ejemplo;
set ejemplo;
call prxchange(prxparse(‘s/([A-ZÑa-zñ 0-9]*)([^A-Za-zÑñ 0-9]*)/1/’),-1,frase);
run;
[/source]

Como se ve en el ejemplo también se carga los caracteres especiales, tened en cuenta eso. Saludos.
