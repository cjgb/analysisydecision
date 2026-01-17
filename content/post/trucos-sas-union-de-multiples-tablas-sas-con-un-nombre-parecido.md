---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-12-07T07:48:41-05:00'
lastmod: '2025-07-13T16:10:36.153290'
related:
- trucos-sas-lista-de-datasets-en-macro-variable.md
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
- truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
- trucos-sas-macrovariable-a-dataset.md
slug: trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido
tags:
- dictionary
- into
- proc sql
- separated by
- union datasets
title: Trucos SAS. Unión de múltiples tablas SAS con un nombre parecido
url: /blog/trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido/
---

Ha llegado una búsqueda y ponemos el truco. Creo que ya lo puse pero no está mal de recordarlo.

1\. Creamos 20 datasets aleatorios con 10 observaciones cada uno:

```r
%macro doit;

%do i=1 %to 20;

data zzdatos_&i.;

do i=1 to 10;

output;

end;

run;

%end;

%mend;
```

Un bucle fácil de macros ha generado 20 dataset que se llaman ZZDATOS_n. Recomiendo siempre emplear nombres «absurdos» para el trabajo con esta metodología.

2\. Empleamos un PROC SQL sobre la librería DICTIONARY, en concreto sobre la tabla tables.

```r
proc sql noprint;

select memname into:lista_tablas separated by " "

from dictionary.tables

where index(memname,"ZZDATO")>0;

quit;
```

Recordemos que en SASHELP tenemos vistas de estas tablas, el SEPARATED BY es el que indica que hacemos una selección múltiple.

3\. Realizamos la unión:

```r
data tablon;

set &lista_tablas.;

run;

proc delete data=&lista_tablas.;run;
```

Sólo tenemos que emplear la macrovariable _& lista_tablas. _y podemos realizar cualquier operación con esta lista. Sé que soy un poco pesado con esta metodología pero me parece importante usarla porque puede ayudarnos a ahorrar código y automatizar procesos. Por supuesto si alguien tiene dudas sugerencias o un trabajo sin «over time» (ahora se llama así a echar más horas que un tonto) ya sabe [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)