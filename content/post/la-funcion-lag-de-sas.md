---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2010-10-01'
lastmod: '2025-07-13'
related:
- funciones-de-ventana-sas-y-bases-de-datos.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
- curso-de-lenguaje-sas-con-wps-funciones-en-wps.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- laboratorio-de-codigo-sas-vistas-proc-means-vs-proc-sql.md
tags:
- funciones sas
- lag
title: La función LAG de SAS
url: /blog/la-funcion-lag-de-sas/
---
La función LAG de SAS nos devuelve el valor de la observación _n_-n de la variable indicada. Me explico con un ejemplo:

```r
data lagn;

do i=1 to 10;

lag_1=lag(i);

lag_2=lag2(i);

lag_3=lag3(i);

lag_4=lag4(i);

lag_5=lag5(i);

lag_6=lag6(i);

output;end;

run;
```

Esto produce:

[![lag.PNG](/images/2010/10/lag.thumbnail.PNG)](/images/2010/10/lag.PNG "lag.PNG")
LAG(i) nos da el valor de i para la observación anterior, LAG2(i) nos da el valor de las 2 observaciones anteriores,… En el caso de encontrarnos en las primeras observaciones el valor que devuelve es el missing. Con ella podemos evitar trabajar con RETAIN a la hora de hacer sumas acumuladas:

```r
data lagn;

set lagn;

sum_acum=sum(i,lag(i));

run;
```

Calcular diferencias entre observaciones:

```r
data lagn;

set lagn;

if _n_=1 then dif=0;

dif=i-lag(i);

run;
```

Y por supuesto medias móviles:

```r
data lagn;

set lagn;

total_3=sum(i,lag(i),lag2(i));

if _n_<3 then divisor=_n_;

else divisor=3;

media_3=total_3/divisor;

run;
```

Hay formas más elegantes de obtener medias móviles, además podemos parametrizar este proceso. La función LAGn está limitada en n en función de la memoria. En la ayuda de SAS nos indica que necesitamos 100 bytes por el n deseado, de esta forma LAG10 requiere 1000 bytes de memoria. En mi caso nunca me he visto obligado a necesitar más de LAG12. Espero que este breve repaso os ayude a conocer mejor esta función.