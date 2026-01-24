---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2010-04-01'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
  - truco-sas-proc-contents.md
tags:
  - filename temp
  - macrovariables sas
  - w/source2
title: Trucos SAS. Macrovariable a dataset
url: /blog/trucos-sas-macrovariable-a-dataset/
---

En alguna ocasión he necesitado pasar el contenido de una macrovariable a un dataset SAS. Con el tiempo he ido refinando el código empleado para hacer esta tarea y, como es habitual, lo comparto con vosotros para que os ayude en vuestro trabajo diario en grandes bancos, aseguradoras, compañías energéticas y de telecomunicaciones en las que seguro que podéis encontrar un hueco para que podamos desarrollar proyectos de calidad (¡ejem!). Tras la publicidad veamos el ejemplo:

````r
```sas
*MACRO VARIABLE LISTA. TENED CUIDADO CON

LOS ESPACIOS EN BLANCO INNECESARIOS;

%let meses=enero febrero marzo

abril mayo junio julio agosto;

*ASIGNAMOS UN FILEREF TEMPORAL;

filename w temp;

*METEMOS EN EL FILEREF LA INSTRUCCION;

data _null_;

f="&meses.";

blancos=length(f)-length(compress(f));

put blancos;

do i=1 to blancos + 1;

file w;

put 'v'i'=scan("&meses.",' i '," ");';

end;

run;

*LLAMAMOS AL FILEREF;

data f;

%inc w/source2;

run;
````

Una metodología muy practica que ya [nos contó Dani Fernandez hace unos meses](https://analisisydecision.es/trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido/). Es una forma muy sencilla de automatizar codigo que se repite. En este ejemplo concreto tenéis que tener mucho cuidado con los espacios en blanco sobrantes porque puede dar algún problema. Por supuesto dudas, sugerencias o trabajo a media jornada `rvaquerizo@analisisydecision.es`
