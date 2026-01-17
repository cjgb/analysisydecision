---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
- Trucos
date: '2012-10-17T09:32:22-05:00'
lastmod: '2025-07-13T15:59:25.631077'
related:
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- trucos-sas-macrovariable-a-dataset.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
- macros-sas-agrupando-variables-categoricas.md
slug: la-macro-iterlist-para-automatizar-codigo-sas
tags: []
title: La macro iterlist para automatizar código SAS
url: /blog/la-macro-iterlist-para-automatizar-codigo-sas/
---

Impresionante macro de SAS que nos puede ahorrar picar mucho mucho código SAS. La macro se llama **iterlist** y la he encontrado en [este enlace](http://www.wuss.org/proceedings08/08WUSS%20Proceedings/papers/cod/cod06.pdf). Es código SAS muy avanzado:

```r
%macro iterlist(code =,list =);
%*** ASSIGN EACH ITEM IN THE LIST TO AN INDEXED MACRO VARIABLE &&ITEM&I ;
%let i = 1;
%do %while (%cmpres(%scan(&list., &i.)) ne );
%let item&i. = %cmpres(%scan(&list., &i.));
%let i = %eval((&i. + 1);
%end;
%*** STORE THE COUNT OF THE NUMBER OF ITEMS IN A MACRO VARIABLE: &CNTITEM;
%let cntitem = %eval((&i. - 1);
%*** EXPRESS CODE, REPLACING TOKENS WITH ELEMENTS OF THE LIST, IN SEQUENCE;
%do i = 1 %to &cntitem.;
%let codeprp = %qsysfunc(tranwrd(&code.,?,%nrstr(&&item&i..)));
%unquote(&codeprp.)
%end;
%mend iterlist;
```


El funcionamiento es muy complejo, destacaría el uso de %qsysfunc. El caso es que nos permite poner listas de código. Imaginemos que tenemos que hacer la siguiente tarea:

```r
data importes sasuser.importes;
drop i j;
array importe(10) ;
do i=1 to 20000;
do j=1 to 10;
importe(j)=ranuni(8)*1000;
end;
grupo=ranpoi(4,5);
output;
end;
run;

proc summary data=importes nway;
class grupo;
output out = agr_grupo (drop=_type_ _freq_)
mean(importe1)=media_importe1
mean(importe2)=media_importe2
...
mean(importe10)=media_importe10
sum(importe1)=suma_importe1
...
sum(importe10)=suma_importe10;
quit;
```


Necesitamos hacer un _proc summary_ de 10 variables y de ellas vamos a calcular media y suma, tendremos que poner _sum_ y _mean_ por tantas variables como correspondan. Estamos repitiendo un código. Pues bien, esta macro nos permite repetir el código dada una lista, en este caso la lista se la pasamos como una macro:

```r
%let lista = importe1 importe2 importe3 importe4 importe5
			importe6 importe7 importe8 importe9 importe10;

proc summary data=importes nway;
class grupo;
output out = agr_grupo (drop=_type_ _freq_)
%iterlist(list = &lista., code = %str( mean(?)=media_? ))
%iterlist(list = &lista., code = %str( sum(?)=suma_? ));
quit;
```


Impresionante. Donde ponemos ? la macro pone los elementos de la lista y en el parámetro code ponemos el código que se repite con %str. A este que escribe ahora mismo se le han caído los pantalones ante semejante genialidad. Impresionante.