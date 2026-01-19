---
author: rvaquerizo
categories:
  - formación
  - modelos
  - sas
date: '2016-03-21'
lastmod: '2025-07-13'
related:
  - modelos-gam-dejando-satisfechos-a-los-equipos-de-negocio.md
  - obteniendo-los-parametros-de-mi-modelo-gam.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-15-modelos-glm-regresion-logistica-y-regresion-de-poisson.md
  - los-parametros-del-modelo-glm-como-relatividades-como-recargos-o-descuentos.md
  - manual-curso-introduccion-de-r-capitulo-18-modelos-de-regresion-de-poisson.md
tags:
  - genmod
title: Interpretación de los parámetros de un modelo GLM
url: /blog/interpretacion-de-los-parametros-de-un-modelo-glm/
---

Muchos estudiantes terminarán trabajando con GLM que siguen buscando relaciones lineales en multitud de organizaciones a lo largo del planeta. Y hoy quería ayudar a esos estudiantes a **interpretar los parámetros resultantes de un GLM** , más concretamente los resultados de un **PROC GENMOD de SAS** aunque lo que vaya a contar ahora se puede extrapolar a otras salidas de SAS o R. En la línea de siempre no entro en aspectos teóricos y os remito a [los apuntes del profesor Juan Miguel Marín](http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/Categor/Tema3Cate.pdf). Con un GLM al final lo que buscamos (como siempre) es distinguir lo que es aleatorio de lo que es debido al azar a través de relaciones lineales de un modo similar a como lo hace una regresión lineal, sin embargo los GLM nos permiten que nuestra variable dependiente no sólo siga una distribución normal, puede seguir otras distribuciones como Gamma, Poisson o Binomial. Además un GLM puede trabajar indistintamente con variables categóricas y numéricas pero yo recomiendo trabajar siempre con variables categóricas y en la práctica cuando realizamos un modelo de esta tipo siempre realizaremos agrupaciones de variables numéricas. Si disponemos de variables agrupadas, de factores, los parámetros de los modelos nos servirán para saber **como se comporta nuestra variable dependiente a lo largo de cada nivel del factor**.

El modelo siempre fija un nivel base del factor, un nivel que promedia nuestros datos y el resto de niveles corrigen el promedio en base al coeficiente estimado. Imaginemos que modelizamos el número de abandonos en 3 carreras de coches, cuando la carrera se disputa en un circuito A el número de abandonos es 5, sin embargo en el circuito B son 10 y en el circuito C son 15. Si fijamos como nivel base de nuestro factor circuito el B tendríamos un modelo de este modo abandonos = 10 + 0.5*es circuito A + 1*es circuito B + 1.5\*es circuito C + Error. El nivel base promedia nuestro modelo por lo que va multiplicado por 1 y el resto de niveles se corrigen por su multiplicador. Esta es la base de la modelización multivariante en el sector asegurador. Veamos en un ejemplo como se articulan los parámetros de estos modelos. Simulamos unos datos con la probabilidad de tener un siniestro por edad, zona y edad:

_data datos_aleatorios;_
_do idcliente = 1 to 2000;_
_if ranuni(1) >= 0.75 then sexo = «F»;_
_else sexo=»M»;_
_edad = ranpoi(45,40);_
_if ranuni(8) >=0.9 then zona=1;_
_else if ranuni(8) >0.7 then zona=2;_
_else if ranuni(8) >0.4 then zona=3;_
_else zona=4;_
_output;end;_
_run;_

_data datos_aleatorios;_
_set datos_aleatorios;_
_if zona=1 then incremento_zona = 0.1+(0.5-0.1)\*ranuni(8);_
_if zona=2 then incremento_zona = 0.1+(0.7-0.1)\*ranuni(8);_
_if zona=3 then incremento_zona = 0.1+(0.2-0.1)\*ranuni(8);_
_if zona=4 then incremento_zona = 0.1+(0.9-0.1)\*ranuni(8);_

_incremento_edad=exp(1/edad\*10)-1;_

_sini = (ranuni(9) – sum(incremento_zona, -incremento_edad)) >0.8 ;_
_run;_

Se da una probabilidad aleatoria de tener un siniestro que se ve incrementada o decrementada por la zona y la edad, el sexo, aunque aparece, no influye. El número de siniestros suponemos que sigue una distribución de poisson. Para entender mejor como funciona un GLM vamos a agregar los datos por los factores en estudio y contamos el número de clientes sumando el número de siniestros:

_proc sql;_
_create table datos_agregados as select_
_sexo,_
_case_
_when edad \<= 30 then «1 menos 30»_
_when edad \<= 40 then «2 31-40»_
_when edad \<= 50 then «3 41-50»_
_else «4 mas 50» end as edad,_
_zona,_
_log(count(idcliente)) as exposicion,_
_sum(sini) as sini_
_from datos_aleatorios_
_group by 1,2,3;_
_quit;_

Nuestros datos tienen que ir ponderados por el logaritmo del número de clientes, será nuestro _offset_ , ya que no es lo mismo tener un siniestro en un grupo de 2 clientes que un siniestro en un grupo de 20 clientes. Ponderados por el logaritmo porque siempre cuesta menos trabajar con números pequeños y además tienen unos superpoderes de los que no somos conscientes hasta que trabajamos con ellos. Ahora estos datos son los que emplearemos para el modelo:

_proc genmod data=datos_agregados;_
_class sexo edad zona;_
_model sini = sexo edad zona / dist = poisson_
_link = log_
_offset = exposicion;_
_run;_

GENMOD como todos los procedimientos de SAS necesita que le indiquemos las variables categóricas, en model especificamos el modelo y las opciones son los aspectos más interesantes. En dist especificamos la distribución de nuestra variable dependiente en link la función de enlace que vamos a emplear y como offset para ponderar la variable exposición que hemos creado a la hora de agregar los datos. Y los parámetros que estima este modelo son:

![parametros_modelo_GENMOD1](/images/2016/03/parametros_modelo_GENMOD1-300x109.png)

El intervalo de confianza de algunos estimadores contiene el valor 0, esos factores no son significativos como es el caso del sexo o bien puede haber agrupación de niveles de factores como es el caso de la edad entre 31 y 50 años o la zona 2 que puede unirse con otra zona. Vemos que el estimador del nivel base siempre es el último nivel del factor (esto puede cambiarse) y toma valores 0 y no 1 como habíamos usado en el ejemplo, para transformarlo en 1 sólo hemos de realizar el exponencial:

**Parameter** | \*\*\*\* | **Estimate**
---|---|---
**Intercept** | | 0.062
**sexo** | F | 0.932
**sexo** | M | 1.000
**edad** | 1 menos 30 | 2.951
**edad** | 2 31-40 | 2.062
**edad** | 3 41-50 | 1.494
**edad** | 4 mas 50 | 1.000
**zona** | 1 | 1.854
**zona** | 2 | 1.218
**zona** | 3 | 3.091
**zona** | 4 | 1.000
**Scale** | | 1.000

Vemos que la zona 3 tiene casi el triple de siniestralidad que la zona 4 y lo mismo sucede con las edades jóvenes frente a las mayores edades, en cuanto al sexo que no fue significativo tenemos que las mujeres tienen un 7% menos de siniestralidad. Algunos resultados, aunque no salgan estadísticamente significativos, es evidente que pueden interesarnos comercialmente ya que mi producto puede dar un descuento a las mujeres y aunque sea pequeño se puede mantener, igual razonamiento para algunas zonas o grupos de edad susceptibles de unirse entre ellos. Este ejemplo es muy burdo pero aquellos que empiecen a trabajar con GLM se van a encontrar situaciones de este tipo, es necesario interpretar los parámetros estimados para describir como funciona el modelo pero igual de importante es la agrupación de factores y el posterior suavizado de los parámetros.
