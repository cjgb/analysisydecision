---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2008-11-27'
lastmod: '2025-07-13'
related:
  - truco-sas-transformaciones-de-variables-con-arrays.md
  - trucos-sas-informes-de-valores-missing.md
  - trucos-sas-lista-de-variables-missing.md
  - macro-sas-crear-variables-dummy-desde-una-variable-categorica.md
  - macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
tags:
  - formación
  - sas
  - trucos
title: Macros SAS. Hacer 0 los valores missing de un dataset
url: /blog/macros-sas-hacer-0-los-valores-missing-de-un-dataset/
---

La siguiente macro de SAS nos permite transformar los valores perdidos (missing) en valor 0 para todas las variables de un dataset. Para todas, para todas las numéricas. Esto es muy importante porque en ocasiones es necesario distinguir el valor 0 del valor missing(.). Pero puede ser muy práctica si vamos a emplear procedimientos que han de distinguir valores perdidos o, simplemente, si deseamos que nuestra tabla tenga otro aspecto.

La metodología del ejemplo que copiáis y pegáis en SAS para examinar los resultados y el log es la más apropiada, o así me lo han trasmitido algunos. Como siempre, planteemos un ejemplo. Lo primero es crear un dataset con valores missing:

```r
*EJEMPLO DE DATASET CON VALORES PERDIDOS;

data uno;

 do i=1 to 100;

  x=ranpoi(8,45)/(rand("uniform")>0.25)*100;

  y=ranbin(5,5,.7)/(rand("uniform")>0.60)/10;

  output;

 end;

run;
```

Generamos un dataset aleatorio con 100 observaciones y 3 variables numéricas donde dos de ellas pueden tener valores perdidos. La macro que modifica estos valores para transformarlos a 0 crea un array con todas las variables numéricas, se lo recorre y si encuentra un missing lo cambia a 0:

```r
%macro hazceros;

drop _i_;

array _c_(*) _numeric_;

do _i_=1 to dim(_c_);

 if _c_(_i_)=. then _c_(_i_)=0;

end;

%mend;
```

```r
*EJEMPLO DE USO;

data uno;

 set uno;

 %hazceros;

run;
```

Vemos que nuestra macro no necesita parámetros y es sólo un array con todas las variables numéricas del dataset. Esta macro es muy práctica y seguro que os ahorra gran cantidad de código, pero insisto, transforma todas las variables numéricas y un valor perdido no es lo mismo que un valor 0.

Por supuesto, dudas, sugerencias, un trabajo excelentemente retribuido,… rvaquerizo@analisisydecision.es
