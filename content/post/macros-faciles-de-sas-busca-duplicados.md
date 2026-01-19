---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2010-10-07'
lastmod: '2025-07-13'
related:
- trucos-sas-identificar-registros-duplicados.md
- macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
- trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
tags:
- macros sas
title: Macros (fáciles) de SAS. Busca duplicados
url: /blog/macros-faciles-de-sas-busca-duplicados/
---
Una macro muy sencilla que ha aparecido en un programa de funcionalidades y que busca registros duplicados en tablas SAS. Es muy sencilla y a alguien puede serle útil y para eso estamos, para compartir conocimientos aunque sean sencillos. Pocos somos los que compartimos nuestro conocimiento y encima poniendo nuestro dinero, en fin, que me distraigo del tema.

```r
%macro busca_duplicados ( dataset, campo);

proc sql;

create table duplicados (where=(frec>1)) as select

&campo.,

count(*) as frec

from &dataset.

group by 1;

quit;

%mend;
```

No pongo ni ejemplo de uso, muy fácil. Pero ya verás como alguien le saca partido. Y todo esto de forma altruista, insisto, que si no me valoro yo no me valora nadie. Saludos.