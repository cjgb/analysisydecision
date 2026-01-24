---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-01-17'
lastmod: '2025-07-13'
related:
  - regresion-pls-con-r.md
  - monografico-analisis-de-factores-con-r-una-introduccion.md
  - el-problema-de-la-multicolinealidad-intuirlo-y-detectarlo.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-11-analisis-bivariable.md
tags:
  - calculo matricial
  - componentes principales
  - matriz de correlaciones
  - r
title: 'Manual. Curso introducción de R. Capítulo 14: Introducción al cálculo matricial con análisis de componentes principales'
url: /blog/manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales/
---

Para el trabajo con matrices vamos a emplear un análisis de componentes principales. El análisis de componentes principales puede encuadrarse dentro del conjunto de técnicas multivariantes conocidas como métodos factoriales (también se incluyen el análisis de factores y el análisis de correspondencias). Pretendemos sintetizar un gran conjunto de datos, crear estructuras de interdependencia entre variables cuantitativas para crear unas nuevas variables que son función lineal de las originales y de las que podemos hacer una representación gráfica. El objetivo del análisis de componentes principales será el reducir la dimensión de un conjunto de `p` variables a un conjunto `m` de menor número de variables para mejorar la interpretabilidad de los datos.

Las nuevas variables, las componentes principales, determinan lo esencial de las variables originales, son una combinación lineal de ellas que además tienen unas propiedades interesantes:

1. son ortogonales (cada componente representa una dirección del espacio de las variables originales)
1. cada puntuación está incorrelada con la anterior
1. la primera componente es la que más varianza contiene y la `j-ésima` tiene más varianza que la `(j-1)-ésima`…
1. las primeras `j` componentes dan la solución de mínimos cuadrados del modelo $$Y=X B+E$$

Si hay relaciones estocásticas entre las `p` variables originales entonces podíamos condensar esa información en otras `m` variables que explican sólo la variación del sistema descartando la información redundante. Geométricamente, el subespacio que creamos con las `m` primeras componentes da el mejor ajuste posible al conjunto de datos medido mediante la suma de los cuadrados de las distancias perpendiculares desde cada punto al subespacio. El subespacio de menor dimensionalidad sería `m=1` componente podíamos hacer la representación en un sólo eje pero el conjunto inicial se podía distorsionar, así introduciríamos un nuevo eje para definir un subespacio `m=2`, perderíamos menos información. Si `m=p` tendríamos el mismo número de variables, no reduciríamos la dimensión, sólo haríamos una rotación rígida del conjunto de datos.

No voy a entrar en el algoritmo matemático para la obtención de las componentes, sí haré alguna reseña en algún momento. Veamos un ejemplo de cálculo de componentes principales mediante cálculo matricial:

Ejemplo 14.1:

Partimos del siguiente conjunto de datos: Se trata de datos de coches de importación y nacionales [Douglas Montgomery and David Friedman, «Prediction Using Regression Models with Multicollinear Predictor Variables» IIE Transactions (Mayo, 1993) vol. 25 nº 3, 73-85, Montgomery D.C. & Peck E.A., Introduction to Linear Regression Analysis, 2ª edición, J. Wiley and Sons, N.Y. (1992)]. Este conjunto de datos contiene las siguientes variables:

```
Variable....................Tipo................. Columnas................... Descripción añadida

Desplazamiento.........numérico......... 1-5.............................. en pulgadas cúbicas

Potencia.....................numérico.........7-9...............................en ft-lbs

par motor...................numérico......... 11-13...........................en ft-lbs

razón de compresión.. numérico.........15-17

razón árbol trasero.....numérico.........19-21

nº de carburadores......numérico.........23

velocidades.................numérico.........25

longitud del coche......numérico.........27-31...........................en pulgadas

anchura del coche.......numérico.........33-36...........................en pulgadas

peso del coche............numérico..........38-41...........................en lbs

tipo de transmisión.....numérico..........43...................0=manual 1=automático

recorrido gasolina.......numérico..........45-48....en millas por galón de gasolina
```

Disponemos de 12 variables, sólo seleccionaremos algunas de ellas. El primer paso es crear el objeto con los datos de trabajo y seleccionar las variables con las que vamos a trabajar:

```r
options(prompt="")
datos<-read.table(url("https://es.geocities.com/r_vaquerizo/Conjuntos_datos/GAS.TXT"))
attach(datos)
conjunto<-data.frame(V1,V2,V3,V8,V9,V10,V12) #seleccionamos un subconjunto
detach(datos)
nombres<-c("desplazamiento","potencia","par","longitud","anchura","peso","recorrido")
names(conjunto)<-nombres
```

Hemos variado el `prompt` de la línea de comandos con la función `options` para evitar problemas a la hora de editar mensajes en el blog. Leemos el conjunto de datos colgado en una dirección web mediante la función `read.table` con la opción `url`. Empleamos la función `attach` para «atacar» un conjunto de datos y generamos un subconjunto con las 6 variables que participarán en nuestro análisis que llevaremos a cabo a partir de la matriz de correlaciones y a partir de la matriz de covarianzas. En esta entrega obtendremos las componentes principales a partir de la matriz de correlaciones y este ejemplo nos servirá para realizar una aproximación al cálculo matricial con `R`.

**Componentes principales a partir de la matriz de correlaciones** :

```r
matriz.correlaciones<-cor(conjunto)
matriz.correlaciones
```

Aunque WordPress no nos facilite mucho la lectura, se aprecian unas altas correlaciones entre las variables, se detectan relaciones lineales entre variables lo que nos permite establecer patrones que unen las diferentes variables para crear unas nuevas variables que nos describan de forma más simple el conjunto de datos de coches con el que estamos trabajando. Ahora queda obtener las componentes, éstas son las combinaciones lineales de las variables que hacen máxima su varianza y esto se consigue obteniendo los autovalores y los autovectores de la matriz de correlaciones, podéis consultar en la red el razonamiento matemático, lo explican con bastante detalle. Veamos cómo obtenemos autovalores y autovectores en `R`:

```r
componentesI<-eigen(matriz.correlaciones)
componentesI
```

Vemos que la función `eigen` nos crea un objeto con los autovalores y los autovectores. El número de autovalores no nulos proporciona la dimensión del espacio en el que se encuentran las observaciones; un autovalor nulo revelaría la existencia de una dependencia lineal entre las variables originales. Pues si `Z` es la matriz de **datos** **tipificados** y `R` es la matriz de correlaciones con pares de autovalores y autovectores `$(l_1,e_1),(l_2,e_2),	ext{…},(l_p,e_p)$` entonces la `i-ésima` componente muestral viene dada por `$y=e_i Z=e_{1i} z_1+	ext{…}+e_{pi} z_p$` donde los autovalores son una observación genérica de las variables `$Z_1,Z_2,	ext{…},Z_p$`. La varianza total es la suma de los autovalores, y la varianza que explica la `j-ésima` componente es el autovalor `j-ésimo` dividido por el número de variables:

```r
componentesI$values[1]/7 #Variabilidad explicada por la primera componente
(componentesI$values[1]+componentesI$values[2])/7 #variabilidad por la segunda componente
```

Vemos que una sola componente ya explica un 88.5%, con dos componentes este porcentaje sube al 94,2%. El número de componentes a emplear irá en función de la variabilidad que deseemos explicar. En este caso un 88,5% es más que suficiente, luego nos quedamos con la primera componente, veamos cuál es:

```r
componentesI$vectors[1:7]
```

Pues aquí tenemos la componente principal: `$Z_1=-0.3926 	ext{· }desplazamiento-0.3734 	ext{· }potencia-0.3914 	ext{· }par-0.3744 	ext{· }longitud-0.356 	ext{· }anchura-0.3966 	ext{· }peso+0.359 	ext{· }recorrido$.` Toma valores muy parecidos para todas las variables excepto `recorrido` que es positiva. Esto se puede interpretar como a menor valor tome la variable componente mejor será el coche, aunque hay que tener en cuenta que los coches buenos hacen un recorrido menor que los coches pequeños. Para ver cómo se comporta la componente hemos de introducir esta variable en el conjunto de datos de forma que veamos qué valor toma para cada observación, esto lo podemos hacer con cálculo matricial:

```r
x<-as.matrix(conjunto) #x es la matriz del conjunto de datos 30x7
y<-as.matrix(componentesI$vectors[1:7])#y es la matriz 7x1 con los valores de la componente
x %*% y #multiplicamos matrices y obtenemos una matriz 30x1 con los valores de la componente
```

Ahora vamos a unir esta componente a nuestro conjunto de datos de partida:

```r
componente.datos<-as.matrix(x %*% y )
conjunto.final<-cbind(conjunto,componente.datos) #unimos horizontalmente matrices con la función cbind
conjunto.final
```

Vemos que los coches menos potentes tienen un valor menor en la componente; sin embargo, recorren muchos más kilómetros que aquellos que tienen mucho más tamaño y motor. En la siguiente entrega veremos este mismo ejemplo pero a partir de la matriz de covarianzas. Comentar que en el paquete `stats` de `R` disponemos de la función `princomp` para el análisis de componentes principales. En este caso el código que habríamos de emplear sería:

```r
ejemplo.14.1 <- princomp(conjunto,cor=TRUE)
summary(ejemplo.14.1)
```

En la función `princomp` hemos de emplear la opción `cor=TRUE` para realizar el análisis con la matriz de correlaciones ya que por defecto emplea la matriz de covarianzas. Los resultados son los mismos (evidentemente).
