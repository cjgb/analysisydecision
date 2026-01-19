---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2014-12-18'
lastmod: '2025-07-13'
related:
  - macros-faciles-de-sas-eliminar-outliers-en-una-variable.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - monograficos-call-symput-imprescindible.md
  - test-de-bondad-de-ajuste-con-sas.md
tags:
  - formación
  - sas
title: Determinar el mímino tamaño muestral para detectar un cambio en la fracción no conforme
url: /blog/determinar-el-mimino-tamano-muestral-para-detectar-un-cambio-en-la-fraccion-no-conforme/
---

Este año he aprendido algo sobre metodología 6 sigma para el control de la calidad, me gustó mucho lo que aprendí. Para la realización de algunos ejercicios cree libros Excel y algún proceso SAS. Hoy quería traeros al blog una macro de SAS que nos permite determinar el tamaño mínimo muestral para detectar un cambio en la fracción no conforme con una determinada probabilidad. El programa es un bucle de SAS que crea los límites de control para la fracción no conforme y estandariza la diferencia del límite superior con la nueva fracción no conforme. Se calcula la probabilidad que deja este dato estandarizado y el paso del bucle será el número mínimo de muestras. Es más sencillo el código que la definición:

```r
%macro determina_tamanio(p0,p1,prob);
/*DETERMINAMOS LIMITES PARA CADA N*/
data _NULL_;
do n=1 to 5000;
/*LIMITE SUPERIOR*/
lsc=&p0.*n + 3*sqrt(&p0.*(1-&p0.)*n);
/*LINEA CENTRAL*/
lc=&p0.*n;
/*LIMITE INFERIOR, SIN NEGATIVOS*/
lic=max(&p0.*n - 3*sqrt(&p0.*(1-&p0.))*n,0);
/*DIFERENCIA CON RESPECTO AL LIMITE SUPERIOR*/
z=(lsc-(n*&p1.))/sqrt(n*&p1.*(1-&p1.));
prob=probnorm(z);
if round(prob,0.01)=&prob. then put n= prob=;
end;
run;
%mend;

%determina_tamanio(0.1,0.2,0.25);
```

Definimos el límite superior, la línea central y el límite inferior para la fracción p0. Sólo necesitamos el límite superior para el ejemplo que estamos tratando pero ahí lo tenéis. Entonces determinamos la diferencia con la nueva fracción de no conformes p1 y estandarizamos. Calculamos la probabilidad que deja la normal del dato estandarizado y si es parecida a la que nos pide el proceso la mostramos en la ventana log. En el ejemplo que he puesto determina el tamaño muestral mínimo para detectar un cambio en la fracción de no conformes de 0.1 a 0.2 con una probabilidad del 25%. Espero que a alguien le sea de utilidad. Saludos.
