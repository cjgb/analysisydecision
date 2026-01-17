---
author: rvaquerizo
categories:
- Formación
- Modelos
- R
date: '2008-10-03T15:04:43-05:00'
lastmod: '2025-07-13T16:01:17.114446'
related:
- manual-curso-introduccion-de-r-capitulo-13-analisis-de-la-varianza-disenos-anidados.md
- manual-curso-introduccion-de-r-capitulo-12-analisis-de-la-varianza-disenos-bifactoriales.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-14-introduccion-al-diseno-de-experimentos.md
- monografico-analisis-de-factores-con-r-una-introduccion.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
slug: manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova
tags: []
title: 'Manual. Curso introducción de R. Capítulo 11: Introducción al análisis de
  la varianza (ANOVA)'
url: /blog/manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova/
---

Para realizar la introducción al análisis de la varianza (ANOVA) con R comenzaremos estableciendo unos conceptos básicos. Lo primero que hacemos es plantear una hipótesis que va a motivar un experimento, elegimos el diseño para nuestro experimento y recogemos los datos y los analizamos mediante el análisis de la varianza que consiste en descomponer la variabilidad total de los datos en sumandos cada uno de ellos asignable a una fuente de variación; posteriormente ya sacamos conclusiones. Lo que se expone a continuación viene recogido en los libros:

*MONTGOMERY, D.C.: Diseño y Análisis de Experimentos. Grupo Editorial Iberoamérica, 1991.

*PEÑA, D.: Estadística: Modelos y Métodos, vol. II: Modelos Lineales y Series Temporales, Alianza Universidad Textos, 1992

Conceptos y definiciones:

Variable repuesta: Variable cuantitativa sobre la que realizamos el estudio asociada al experimento.

Factor: Condiciones que se manipulan en un experimento que afectan a la variable respuesta.

Nivel de un factor: Maneras de presentarse un factor

Tratamientos: Condiciones bajo las cuales se realiza el experimento, son combinaciones de factores.

Unidades experimentales: Sujetos sometidos a los tratamientos sobre los que se mide la variable respuesta.

Réplica: observación adicional de un mismo tratamiento.

Para diseñar un experimento se tienen en cuenta como son las unidades experimentales y la asignación de tratamientos. Según esto tenemos estructuras de diseño y estructuras de tratamiento:

Estructuras de diseño:

* Diseño completamente aleatorizado.
* Diseño por bloques aleatorizados completos.
* Diseño de cuadrados latinos.

Estructuras de tratamiento:

* Diseño unifactorial.
* Diseño bifactorial.
* Diseño n factorial.
* Diseño 2^n.
* Diseño anidado.

En esta introducción comenzamos con el diseño más básico de todos:

Diseño unifactorial completamente aleatorizado:

Partimos de unidades experimentales homogéneas y queremos estudiar la influencia de un solo factor midiendo la variable respuesta. La tabla del análisis de la varianza (ANOVA) es:

![c111.JPG](/images/2008/10/c111.JPG)

Para realizar el análisis de la varianza con R hemos de determinar el modelo con el que queremos trabajar. Vamos a crear un modelo probabilístico Yij=media_i+e_ij donde la media_i es una constante conocida que es la respuesta media bajo el tratamiento i y e_ij es la parte probabilísitica que cumple una serie de condiciones. Sobre este modelo realizaremos el análisis de la varianza con la función aov(Y~X) donde Y es la variable respuesta que es la variable cuantitativa asociada al experimento y X es la condición bajo la cual mido la variable respuesta, X es el factor. Como siempre veamos como trabajar con R mediante un ejemplo.

Ejemplo 11.1:

En un tratamiento contra la hipertensión se seleccionaron 40 enfermos de características similares. A cada enfermo se le administró uno de los fármacos P, A, B, AB, al azar, formando 4 grupos. El grupo P tomó placebo (fármaco inocuo), el grupo A tomó un fármaco «A», el grupo B un fármaco «B» y el grupo AB una asociación entre «A» y «B». Para valorar la eficacia de los tratamientos, se registró el descenso de la presión diastólica desde el estado basal (inicio del tratamiento) hasta el estado al cabo de una semana de tratamiento. Los resultados, después de registrarse algunos abandonos, fueron los siguientes:
P: 10, 0, 15, -20, 0, 15, -5
A: 20, 25, 33, 25, 30, 18, 27, 0, 35, 20
B: 15, 10, 25, 30, 15, 35, 25, 22, 11, 25
AB: 10, 5, -5, 15, 20, 20, 0, 10

¿Tenemos diferencias entre los tratamientos?

```r
> options(prompt="") #modificamos el prompt presion<-c(10, 0, 15, -20, 0, 15, -5

+ ,20, 25, 33, 25, 30, 18, 27, 0, 35, 20

+ ,15, 10, 25, 30, 15, 35, 25, 22, 11, 25,

+ 10, 5, -5, 15, 20, 20, 0, 10 )

grupos<-c("P","P","P","P","P","P","P","A","A","A","A","A","A","A","A","A","A",

+ "B","B","B","B","B","B","B","B","B","B","AB","AB","AB","AB","AB","AB","AB","AB") grupos<-factor(grupos) #creamos factores

$ grupos

[1] P  P  P  P  P  P  P  A  A  A  A  A  A  A  A  A  A  B  B  B  B  B  B  B  B  B  B  AB AB AB AB

[32] AB AB AB AB

Levels: A AB B P
```

Hemos creado dos vectores presion que recoge la variable respuesta y grupos que recoge el factor, para su creación hemos de emplear la función factor con ella R reconoce el tipo de variable que contiene ese vector creando un vector de factores. Realicemos el análisis de la varianza, con él haremos el contraste de igualdad de medias para establecer si hay diferencias significativas entre las medias de los distintos grupos:

```r
unifact<-aov(presion~grupos) summary(unifact)

Df  Sum Sq Mean Sq F value    Pr(>F)

grupos       3 2492.61  830.87  8.5262 0.0002823 ***

Residuals   31 3020.93   97.45

---

Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Se rechaza la hipótesis nula de igualdad de medias en *** que planteamos con el test F así pues hay diferencias entre los tratamientos. Para ver cual de estos tratamientos son diferentes contamos con métodos de test de recorrido estudentizado y con métodos de contrastes múltiples. Con R podemos programar el test que nos interese, pero el módulo base tiene test de recorrido estudentizado. En este caso vamos a ver el test de Tuckey que compara todas las posibles medias dos a dos y basándose en una distribución q alfa(k,n) del rango estudentizado determina una diferencia mínima significativa para que dos medias sean distintas. En R el test de Tukey se realiza con la función TuckeyHSD:

```r
$ TukeyHSD(unifact)

Tukey multiple comparisons of means

95% family-wise confidence level
```

```r
$ (qtukey(0.05,4,31))*sqrt(97.45/7)

[1] 2.819698
```

Este es el valor referencia, valores absolutos por encima de éste ya consideramos diferencias significativas. De nuevo repetir como se halla este número: qtukey(0.05,4,31) calcula el valor de la distribución q de Tukey para 0.05 ya que estamos con una confianza del 95%, 4 niveles y 31 grados de libertad; sqrt(97.45/7) 97.5 es la estimación de la varianza (el cuadrado medio del error) que se encuentra en la tabla ANOVA y 7 el mínimo número de tratamientos que son los pacientes que tomaron placebo. El valor de de 2.82 luego sólo la diferencia entre A y B se puede considerar que no es significativa, no hay diferencias entre los pacientes que tomaban A o B, sin embargo si hay diferencias entre todos los demás.

En resumen se puede determinar que los pacientes que han tomado placebo o la combinación entre ambos medicamentos AB han tenido una mayor reducción de la presión diastólica desde el estado basal (inicio del tratamiento) hasta el estado al cabo de una semana de tratamiento, siendo el placebo el tratamiento que más ha hecho reducir dicha presión.