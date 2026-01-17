---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
- Trucos
date: '2010-11-12T04:17:18-05:00'
lastmod: '2025-07-13T16:03:58.540932'
related:
- laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
- la-importancia-del-parametro-hashexp.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- truco-sas-cruce-con-formatos.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
slug: objetos-hash-para-ordenar-tablas-sas
tags:
- ''
- hash
title: Objetos hash para ordenar tablas SAS
url: /blog/objetos-hash-para-ordenar-tablas-sas/
---

A partir de la versión 9.1 de SAS se incluyeron los **objetos HASH**. Hace [tiempo ya demostramos su eficiencia en el cruce de tablas ](https://analisisydecision.es/trucos-sas-porque-hay-que-usar-objetos-hash/)y hoy quería mostraros como se programa una ordenación empleando HASH. La verdad es que estoy saboreando mis últimos días con SAS v9.2, en breve volveré a una versión muy anterior. El codigo, en mi opinión, es muy sencillo y como es habitual tenemos ejemplo ilustrativo que comentaré a continuación:

```r
*DATASET DE PRUEBA;

data uno;

array v(10);

do i=1 to 5000000;

importe=ranuni(mod(time(),1)*1000)*10000;

do j=1 to 5;

v(j)=ranuni(34)*100;

end;output;end;

run;

*REALIZAMOS LA ORDENACION CON HASH;

data _null_;

if 0 then set uno;

declare hash obj (dataset:'uno',hashexp:20,ordered:'a') ;

obj.definekey ('importe');

obj.definedata(all:'YES');

obj.definedone () ;

obj.output(dataset:'dos');

stop;

run;
```

**Importante** : sólo funciona en versiónes posteriores a la 9.1

Empleamos _data _null__ y una sentencia condicional para que lea el dataset que deseamos ordenar. Con **DECLARE** creamos el objeto hash _OBJ_ del dataset uno e indicamos que ha de estar ordenado **‘a’** scendentemente, podríamos ordenar **‘d’** escendentemente. Al parámetro HASHEXP le vamos a llamar exponente hash y determina el número de cubos en el que vamos a repartir la tabla hash, en este caso 2**8=256 cubos, es un parámetro muy importante para que este proceso sea eficiente. Definimos la **KEY** con DEFINEKEY y así indicamos el campo por el que realizaremos la ordenación, pueden aparecer más variables. DEFINEDATA indica las variables que se recogen en el objeto en este caso empleamos _all:’YES’_ para quedarnos con todas, podría funcionar como un _keep_ pero necesitamos poner todas las variables entrecomilladas y separadas por comas, así que recomiendo usar esta sintaxis. Finalizamos las deficinciones con DEFINEDONE(). Por último en **OUTPUT** indicamos el conjunto de datos SAS que se genera, podría ser el mismo que se lee, no es un problema.

Estas 4 líneas sencillas de recordar son una forma eficiente de ordenar conjuntos de datos SAS. Pero hay que analizar cuánto es de eficiente. Como ya he comentado, en breve volveré a versiones anteriores de SAS y no sé si podré seguir desarrollando pruebas con objetos hash pero es muy importante estudiar el consumo de memoria y el consumo de espacio y por supuesto compararlo con el **PROC SORT**. Además tengo que elaborar unas reglas de uso del parámetro hashexp, fundamental para el algoritmo y sobre todo fundamental para que las ordenaciones sean lo más eficientes posibles. ¡Anda que no tengo trabajo! Y pocos días con 9.2

Lo que si puedo hacer es adelantaros algunas conclusiones. Hash consume más memoria, menos espacio y tarda menos pero hay que analizar ese consumo de memoria con mucho detenimiento. Saludos.