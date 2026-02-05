---
author: rvaquerizo
categories:
  - formación
  - modelos
  - sas
date: '2012-05-07'
lastmod: '2025-07-13'
related:
  - test-de-bondad-de-ajuste-con-sas.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - truco-sas-categorizar-variables-continuas.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - determinar-el-mimino-tamano-muestral-para-detectar-un-cambio-en-la-fraccion-no-conforme.md
tags:
  - proc glm
  - sas procs
title: Test de Levene con SAS
url: /blog/test-de-levene-con-sas/
---

El test de Levene se aplica para contrastar la igualdad de varianzas. Es un análisis de la varianza de las desviaciones de los valores muestrales respecto a una medida de tendencia central. Parte de la hipótesis nula de igualdad de varianzas. Para realizar este test en SAS emplearemos el `PROC GLM` en combinación con la opción `HOVTEST`. En la línea habitual, vemos un ejemplo:

```sas
data datos;
  input presion @@;
  if _n_ <= 5 then grupo = 1;
  else if _n_ <= 10 then grupo = 2;
  else if _n_ <= 15 then grupo = 3;
  else if _n_ <= 20 then grupo = 4;
  else grupo = 5;
  datalines;
180 172 163 158 147 173 158 170
146 152 175 167 158 160 143 182
160 162 171 155 181 175 170 155 160
;
run;

proc glm data=datos;
  class grupo;
  model presion = grupo;
  means grupo / hovtest;
  ods select HOVFTest;
quit;
```

Vemos que se trata de un código sencillo donde modelizamos con GLM la variable dependiente con la variable grupo y en `MEANS` indicamos con `HOVTEST` que deseamos que se realice el test de Levene; con ODS seleccionamos sólo esa salida. Este código podemos parametrizarlo y crear una macro que nos permita replicarlo:

```sas
%macro Levene(datos, grupo, variable);
  proc glm data=&datos;
    class &grupo;
    model &variable = &grupo;
    means &grupo / hovtest;
    ods select HOVFTest;
  quit;
%mend Levene;

%Levene(datos, grupo, presion);
```

Espero que sea de vuestra utilidad. Saludos.