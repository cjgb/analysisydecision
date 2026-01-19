---
author: rvaquerizo
categories:
- formación
- sas
- wps
date: '2013-09-12'
lastmod: '2025-07-13'
related:
- macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
- trucos-r-de-string-a-dataframe-de-palabras.md
- trucos-sas-particionar-y-exportar-a-texto-un-dataset.md
- macros-sas-limpiar-una-cadena-de-caracteres.md
- truco-sas-funcion-para-contar-caracteres.md
tags:
- sin etiqueta
title: Dividir en palabras un texto con SAS
url: /blog/dividir-en-palabras-un-texto-con-sas/
---
Una duda que planteó una lectora del blog acerca de separar una cadena de caracteres separados por comas y crear observaciones en otra variable:
Hola! he buscado por toda la página, necesito ayuda urgente. Mi problema es el siguiente.

Necesito separar una cadena de texto en una fila en varias filas, por ejemplo

cadena1,cadena2,cadena3

en

cadena1
cadena2
cadena3

para encontrar la ‘ , ‘ utilizo scan, aunque podría ocupar anypunct para que encuentre la primera ‘ , ‘ luego la segunda ‘ , ‘ etc y cortar con substr, longth … pero bueno, ya que tengo un metodo de separar el texto de la fila como hago para que cada palabra este en una nueva fila? ojala me hayan entendido y me den una idea de como hacer eso en un proc sql, con una macro o como sea, solo una pequeña orientación me serviria mucho, gracias!!!!!

En realidad teníamos una entrada que podía haberte servido de referencia:

<https://analisisydecision.es/el-debate-politico-o-como-analizar-textos-con-wps/>

Con esta idea podemos proponer hacer:

```r
data frase;
frase = "cadena1,cadena2,cadena3";
run;

data palabras;
set frase end=fin;
drop i letra;
length palabra $50;
palabra="";
do i = 1 to length(frase);
letra=substr(frase,i,1);
if letra not in (",") then palabra=compress(palabra||letra);
else do;
output;
palabra="";
end;end;
if fin then output;
run;
```


Se trata de ir caracter a caracter y volcarlo a una nueva variable en el momento que encuentra la coma y realizar un output en ese momento. Saludos.