---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-08-27T07:32:24-05:00'
slug: truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql
tags: []
title: Truco SAS. Transponer tablas con PROC TRANSPOSE, DATA o PROC SQL
url: /truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql/
---

Para transponer datasets disponemos en SAS del PROC TRANSPOSE. El ahora escribiente no es muy partidario de emplearlo. Prefiero otras metodologías para transponer conjuntos de datos SAS. Voy a trabajar con un ejemplo que os servirá para aproximaros al TRANSPOSE y para entender mejor las opciones de lectura de un PASO DATA y el funcionamiento del PROC SQL. La idea es, partiendo de una tabla de hechos por meses, transponer un campo importe. Vamos a simular una tabla con esa estructura:

```r
data hc_mes_importe;

do idcliente=1 to 1000000;

do mes=200901 to 200903;

importe=rand("uniform")*ranpoi(3,10000);

output;

end;end;

run;
```

Tenemos 3 registros por cada _idcliente_ correspondientes a los meses de 200901 a 200903. La idea es transponer la tabla de forma que el importe que ahora está en filas pase a ser columnas y tengamos un solo registro para cada idcliente. El primer método que tenemos es el uso del TRANSPOSE:

```r
proc transpose data=hc_mes_importe prefix=imp

out=t_mes_importe (drop=_name_);

id mes;

by idcliente;

quit;
```

Esta es la estructura más simple del TRANSPOSE. En _prefix_ indicamos el prefijo que deseamos para la nueva variable. En el dataset de salida eliminamos la variable nombre que genera SAS por defecto. Evidentemente transponemos por _idcliente_ y en la instrucción ID ponemos el campo que identifica las columnas. Esta es la sintaxis más habitual del TRANSPOSE, a continuación os planteo como transponer mediante un paso DATA:

```r
data t_mes_importe;

merge hc_mes_importe (rename=importe=imp200901 where=(mes=200901))

hc_mes_importe (rename=importe=imp200902 where=(mes=200902))

hc_mes_importe (rename=importe=imp200903 where=(mes=200903));

by idcliente;

run;
```

Esta forma de transponer es la unión horizontal de una tabla consigo misma tantas veces como meses disponemos por _idcliente_. Necesitamos renombrar la variable para no quedarnos con sólo una columna. Otro modo de transponer tablas y que a mi me gusta particularmente es el uso del PROC SQL:

```r
proc sql;

create table t_mes_importe as select

idcliente,

sum(importe*(mes=200901)) as imp200901,

sum(importe*(mes=200902)) as imp200902,

sum(importe*(mes=200903)) as imp200903

from hc_mes_importe

group by 1;

quit;
```

Lo que hacemos es sumarizar por el campo del que deseamos un registro único y operamos con los campos que vamos a transponer. Esta operación es el importe multiplicado por una condición.

Si ejecutáis los códigos que os propongo encontraréis que el paso DATA es el más eficiente, el PROC SQL tarda un 75% más y el TRANSPOSE un 250% más. Por otro lado el TRANSPOSE podría ser mejor en códigos automáticos ya que no necesitamos parámetros, pero si trabajamos con macros al final el paso DATA es más efectivo. A futuro empezaremos a parametrizar este tipo de sentencias SAS.

Por supuesto si tenéis cualquier duda o sugerencia… rvaquerizo@analisisydecision.es