---
author: rvaquerizo
categories:
- Formación
date: '2016-11-03T03:53:10-05:00'
slug: truco-sas-limpieza-de-tabuladores-con-expresiones-regulares
tags: []
title: Truco SAS. Limpieza de tabuladores con expresiones regulares
url: /truco-sas-limpieza-de-tabuladores-con-expresiones-regulares/
---

Un lector necesita eliminar tabuladores de una cadena de texto y no le están funcionando las funciones habituales, sugiero emplear expresiones regulares, en mi entorno de SAS si está funcionando:

[source languaje=»SAS»]  
data ejemplo;  
input frase 50.;  
cards;  
Hola este es un ejemplo""""""  
Hola es te es un ejemplo_______  
Hola este es un ejemplo++++++++  
;  
run;

data ejemplo;  
set ejemplo;  
call prxchange(prxparse(‘s/([A-ZÑa-zñ 0-9]*)([^A-Za-zÑñ 0-9]*)/1/’),-1,frase);  
run;  
[/source]

Como se ve en el ejemplo también se carga los caracteres especiales, tened en cuenta eso. Saludos.