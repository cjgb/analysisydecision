---
author: rvaquerizo
categories:
- Data Mining
- Formación
- Modelos
- SAS
date: '2009-04-08T05:22:13-05:00'
slug: macros-sas-tramificar-en-funcion-de-una-variable-respuesta
tags:
- macro
- regresión logística
- SAS
title: Macros SAS. Tramificar en función de una variable respuesta
url: /macros-sas-tramificar-en-funcion-de-una-variable-respuesta/
---

Sobre la idea de “dumificar” variables he ideado un proceso para agrupar variables cuantitativas en función de una variable respuesta. Los que disponéis de herramientas de análisis más complejas tipo Enterprise Miner o Clementine ya disponéis de algoritmos y funciones que realizan esta útil tarea, además los árboles pueden trabajar con variables continuas. Pero un modelo es bueno si las variables de entrada están bien elegidas y bien construidas y como paso previo al análisis multivariante el análisis univariable es imprescindible. Tramificar una variable continua en función de una variable respuesta no va más allá de un análisis univariante, igualmente podemos tener dependencia lineal entre variables, algo que sólo detectaremos con análisis multivariables. Pero este sencillo algoritmo puede ayudarnos a conocer mejor algunas variables que deseamos introducir en nuestro modelo.

La idea es muy fácil: dispongo de una variable continua y una variable respuesta, divido la variable continua en N variables dicotómicas y mediante una regresión logística determino una respuesta media de cada grupo y si la media de un grupo es muy parecida a la media de otro grupo cercano entonces los uno. Es como un análisis de la varianza en el que medimos que las medias por grupo no sean significativamente distintas de las de otros grupos cercanos. Y este criterio de distinción lo establecemos nosotros con unos criterios de corte basados en la diferencia relativa con la media del grupo más cercano esté dentro de un rango.

El proceso haría un bucle de la idea anterior con tantas iteraciones como deseemos, e iría agrupando la variable en función del peso de la variable respuesta dentro de cada grupo. Muy sencillo y vais a entenderlo con el ejemplo de SAS. Como siempre parto de un dataset aleatorio con un importe y una variable respuesta:

_*DATASET ALEATORIO;_  
_data uno;_  
_do i=1 to 20000;_  
_importe=ranuni(0)*10000;_  
_if rand(«uniform») <.04 then resp=1;_  
_else resp=0;_  
_if resp=0 and 200 <importe0.2);_  
_if resp=0 and 8000 <importe0.2);_  
_output;_  
_end;_  
_run;_

Es evidente que la variable respuesta está inflada para los importes entre 200 y 400 y para los importes entre 8000 y 9000. A continuación os planteo la macro que tramifica y analizaremos sus resultados:

%m _acro numobs(ds,mv);_  
_%global &mv.;_  
_data _null_;_  
_datossid=open(« &ds.»);_  
_no=attrn(datossid,’nobs’);_  
_call symput (« &mv.»,compress(no));_  
_datossid=close(datossid);_  
_run;_  
_%mend;_

_%macro rangea (datos,cuantitativa,respuesta);`%numobs(&datos.,obs);`_

_*CORTES QUE GENERAN GRUPOS PODEMOS SER MÁS LAXOS O NO;_  
_%let cortes=0.8 <=relativa<=1.2 ;_

_*ESPECIFICAMOS EL NÚMERO Y EL TAMAÑO DE LOS GRUPOS INICIALES;_  
_%let numero_de_grupos=30;_

_*ORDENAMOS POR LA VARIABLE QUE DESEAMOS CATEGORIZAR;_  
_proc sort data= &datos.; by &cuantitativa.; run;_

_*CREAMOS 30 GRUPOS INICIALES;_  
_data &datos.;_  
_set &datos.;_  
_*CREAMOS N GRUPOS;_  
_rango=ceil((_n_/ &obs.)*&numero_de_grupos.);_  
_run;_

_*CREAMOS VARIABLES DUMMY;_  
_data instruccion;_  
_do i=1 to &numero_de_grupos.;_  
_instruccion=»GR_»||compress(put(i,3.))||»=0; IF RANGO=»||put(i,3.)||» THEN GR_»||compress(put(i,3.))||»=1″;_  
_output;_  
_end;_  
_run;_

_proc sql noprint ;_  
_select instruccion into:instr separated by «;»_  
_from instruccion;_  
_quit;_  
_proc delete data=instruccion;_

_data &datos.;_  
_set &datos.;_  
_ &instr.;_  
_run;_

_*BUCLE QUE AGRUPA LAS DICOTOMICAS EN FUNCION DE LOGISTICA;_

_%let ejecuta=1;_

_*PUEDES MODIFICAR EL NUMERO DE ITERACCIONES;_  
_%do i=1 %to 10;_  
_%if &i.=1 %then %do; %let fin_variables=GR_30;%end;_

_%if &ejecuta. %then %do;_

_proc logistic data = &datos. noprint descending_  
_outest = paso &i. ;_  
_model &respuesta.=gr_1 — &fin_variables.;_  
_run;_

_proc transpose data=paso &i. out=paso&i. (where=(index(_name_,»GR»)>0) drop=_label_);_  
_quit;_

_*ESTA PARTE GENERA LOS NUEVOS RANGOS Y LAS NUEVAS DICOTOMICAS;_  
_data paso &i.;_  
_set paso &i. end=ultimo;_  
_*PROBLEMA DE PESO 0;_  
_ &respuesta.=&respuesta.+0.0000000001;_  
_retain rango 1;_  
_anterior=lag( &respuesta.);_  
_if anterior=. then anterior= &respuesta.;_  
_relativa=anterior/ &respuesta.;_  
_junta=0;_  
_if &cortes. then junta=1;_

_if junta=0 then rango=rango+1;_  
_rango_ant = compress(_name_,»GR_»);_

_instruccion=»GR_»||compress(put(rango,3.))||»=0; IF RANGO=»||rango_ant||» THEN DO; GR_»||compress(put(rango,3.))||»=1; RANGO=»||rango||»;END;»;_  
_if ultimo then call symput(‘fin_variables’,»GR_»||compress(put(rango,3.)));_  
_run;_

_proc sql noprint ;_  
_select instruccion into:instr separated by «;»_  
_from paso &i.;_  
_quit;_

_data &datos.;_  
_set &datos. (drop=gr:);_  
_ &instr.;_  
_run;_

_*SI YA NO HAY MODIFICACIONES NO TIENE SENTIDO SEGUIR CON EL PROCESO;_  
_proc sql noprint;_  
_select max(junta) into:ejecuta_  
_from paso &i.;_  
_quit;_

_proc delete data=paso &i.; run;_

_%end;_  
_%end;_

_data &datos.;_  
_set &datos.;_  
_drop gr:;_  
_run;_

_%mend;_

_%rangea(uno,importe,resp);_

Larga y compleja así a primera vista, pero muy sencilla de entender si se realizan ejecuciones y se comprueba su funcionamiento, recomiendo comentar el último PROC DELETE para ver como evoluciona cada paso de la iteración. Partimos de 30 grupos (suficiente de inicio) y realizamos una regresión logística de las 30 variables generadas, creamos un dataset en el que vemos si los grupos tienen similar peso. Vemos como sería la primera iteración:

![tramos1.JPG](/images/2009/04/tramos1.JPG)

Pesos dentro de nuestro criterio de corte (%let cortes=0.8<=relativa<=1.2) se unen gracias a que creamos una instrucción automática con PROC SQL. Así hasta 10 veces se ejecuta y al final el dataset de entrada de la macro tiene un campo rango que nos ha trameado la variable cuantiva en función de la respuesta. Si analizamos su comportamiento:

_proc sql;_  
_select rango, min(importe) as min_importe, max(importe) as max_importe,_  
_COUNT(*) AS OBS,sum(resp), sum(resp)/count(*) as peso_  
_from uno_  
_group by 1;_  
_quit;_

![tramos2.JPG](/images/2009/04/tramos2.JPG)

Ha encontrado perfectamente el tramo entre 8000 y 9000 y un poco peor con el tramo de 200 a 400 probablemente porque tiene menos registros. Podría hacer más uniones, pero si hace un análisis exploratorio bastante interesante. Queda pendiente estudiar que pasaría con este proceso si nos encontramos con valores muy frecuentes, por ejemplo el valor 0. Próximas entregas y como siempre dudas, sugerencias u ofertas de trabajo que me permitan ver a mis hijos desde las 4 de la tarde rvaquerizo@analisisydecision.es