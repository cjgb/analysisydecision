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
title: 'Manual. Curso introducción de R. Capítulo 14: Introducción al cálculo matricial
  con análisis de componentes principales'
url: /blog/manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales/
---
Para el trabajo con matrices vamos a emplear un análisis de componentes principales. El análisis de componentes principales puede encuadrarse dentro del conjunto de técnicas multivariantes conocidas como métodos factoriales (también se incluyen el análisis de factores y el análisis de correspondencias). Pretendemos sintetizar un gran conjunto de datos, crear estructuras de interdependencia entre variables cuantitativas para crear unas nuevas variables que son función lineal de las originales y de las que podemos hacer una representación gráfica. El objetivo del análisis de componentes principales será el reducir la dimensión de un conjunto de p variables a un conjunto m de menor número de variables para mejorar la interpretabilidad de los datos.

Las nuevas variables, las componentes principales, determinan lo esencial de las variables originales, son una combinación lineal de ellas que además tienen unas propiedades interesantes:

  1. son ortogonales (cada componente representa una dirección del espacio de las variables originales)
  2. cada puntuación está incorrelada con la anterior
  3. la primera componente es la que más varianza contiene y la j-ésima tiene más varianza que la j-1 ésima…
  4. las primeras j componentes dan la solución de mínimos cuadrados del modelo Y=X B+E

Si hay relaciones estocásticas entre las p variables originales entonces podíamos condensar esa información en otras m variables que explican sólo la variación del sistema descartando la información redundante. Geométricamente, el subespacio que creamos con las m primeras componentes da el mejor ajuste posible al conjunto de datos medido mediante la suma de los cuadrados de las distancias perpendiculares desde cada punto al subespacio. El subespacio de menor dimensionalidad sería m=1 componente podíamos hacer la representación en un sólo eje pero el conjunto inicial se podía distorsionar, así introduciríamos un nuevo eje para definir un subespacio m=2, perderíamos menos información. Si m=p tendríamos el mismo número de variables, no reduciríamos la dimensión, sólo haríamos una rotación rígida del conjunto de datos.

No voy a entrar en el algoritmo matemático para la obtención de las componentes, si haré alguna reseña en algún momento. Veamos un ejemplo de cálculo de componentes principales mediante cálculo matricial:

Ejemplo 14.1:

Partimos del siguiente conjunto de datos: Se trata de datos de coches de importación y nacionales [Douglas Montgomery and David Friedman, «Prediction Using Regession Models with Multicollinear Predictor Variables» IIE Transactions (Mayo, 1993) vol. 25 nº 3, 73-85, Montgomery D.C. & Peck E.A., Introduction to Linear Regression Analysis, 2ª edición, J. Wiley and Sons, N.Y. (1992)]. Este conjunto de datos contiene las siguientes variables:

```r
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
> options(prompt="") datos<-read.table(url("https://es.geocities.com/r_vaquerizo/Conjuntos_datos/GAS.TXT"))
attach(datos) conjunto<-data.frame(V1,V2,V3,V8,V9,V10,V12) #seleccionamos un subconjunto
detach(datos) nombres<-c("desplazamiento","potencia","par","longitud","anchura","peso","recorrido")
$ names(conjunto)<-nombres
```


Hemos variado el prompt de la línea de comandos con la función options para evitar problemas a la hora de editar mensajes en el blog. Leemos el conjunto de datos colgado en una dirección web mediante la función _read.table_ con la opción _url_ . Empleamos la función _attach_ para «atacar» un conjunto de datos y generamos un subconjunto con las 6 variables que participarán en nuestro análisis que llevaremos a cabo a partir de la matriz de correlaciones y a partir de la matriz de covarianzas. En esta entrega obtendremos las componentes principales a partir de la matriz de correlaciones y este ejemplo nos serviran para realizar una aproximación al cálculo matricial con R.

**Componentes principales a partir de la matriz de correlaciones** :

```r
$ matriz.correlaciones<-cor(conjunto)
$ matriz.correlaciones
  desplazamiento potencia par longitud anchura
desplazamiento 1.0000000 0.9406456 0.9895851 0.8670281 0.8001582
potencia 0.9406456 1.0000000 0.9643592 0.8042467 0.7105117
par 0.9895851 0.9643592 1.0000000 0.8662469 0.7881284
longitud 0.8670281 0.8042467 0.8662469 1.0000000 0.8828869
anchura 0.8001582 0.7105117 0.7881284 0.8828869 1.0000000
peso 0.9531800 0.8879129 0.9435772 0.9559969 0.8994470
recorrido -0.8718188 -0.7965605 -0.8493416 -0.7552211 -0.7624550
  peso recorrido
desplazamiento 0.9531800 -0.8718188
potencia 0.8879129 -0.7965605
par 0.9435772 -0.8493416
longitud 0.9559969 -0.7552211
anchura 0.8994470 -0.7624550
peso 1.0000000 -0.8526911
recorrido -0.8526911 1.0000000
```


Aunque worpress no nos facilite mucho la lectura se aprecian unas altas correlaciones entre las variables, se detectan relaciones lineales entre variables lo que nos permite establecer patrones que unen las diferentes variables para crear unas nuevas variables que nos describan de forma más simple el conjunto de datos de coches con el que estamos trabajando. Ahora queda obtener las componentes, éstas son las combinaciones lineales de las variables que hacen máxima su varianza y esto se consigue obteniendo los autovalores y los autovectores de la matriz de correlaciones, podéis consultar en la red el razonamiento matemático, lo explican con bastante detalle. Veamos como obtenemos autovalores y auto vectores en R:

```r
$ componentesI<-eigen(matriz.correlaciones)
$ componentesI
$values
[1] 6.193181539 0.400764875 0.244830693 0.094091951 0.046951262 0.015094646
[7] 0.005085034</code><code>$vectors
  [,1] [,2] [,3] [,4] [,5] [,6]
[1,] -0.3926641 -0.2475231 0.05234234 0.03567111 -0.61407897 -0.01657661
[2,] -0.3733929 -0.4647583 0.29963669 0.28335837 0.65342114 0.11954685
[3,] -0.3914349 -0.2911694 0.16717164 0.11038560 -0.28865783 -0.44120895
[4,] -0.3744302 0.3980948 0.31799457 -0.64622375 0.22495520 -0.33416791
[5,] -0.3560523 0.6557118 -0.12419209 0.63919813 0.04914155 -0.11797501
[6,] -0.3965847 0.1523398 0.09815214 -0.17000242 -0.15186737 0.81350329
[7,] 0.3590553 0.1621960 0.86795951 0.22620880 -0.19115713 0.05826262
  [,7]
[1,] 0.63495457
[2,] 0.18235333
[3,] -0.66624254
[4,] 0.14256169
[5,] 0.05420171
[6,] -0.31004382
[7,] 0.01766344
```


Vemos que la función _eigen_ nos crea un objeto con los autovalores y los autovectores. El número de autovalores no nulos proporciona la dimensión del espacio en el que se encuentran las observaciones; un autovalor nulo revelaría la existencia de una dependencia lineal entre las variables originales. Pues si Z es la matriz de **datos** **tipificados** y R es la matriz de correlaciones con pares de autovalores y autovectores (l1,e1),(l2,e2),…,(lp,ep) entonces la i-ésima componente muestral viene dada por y=ei Z=e1i z1+…+epi zp donde los autovalores son una observación genérica de las variables Z1,Z2,…Zp. La varianza total es la suma de los autovalores, y la varianza que explica la j-ésima componente es el autovalor j-ésimo dividido por el número de variables:

```r
$ componentesI$values[1]/7 #Variabilidad explicada por la primera componente
[1] 0.8847402
$ (componentesI$values[1]+componentesI$values[2])/7 #variabilidad por la segunda componente
[1] 0.9419923
```


Vemos que una sóla componente ya explica un 88.5%, con dos componentes este porcentaje sube al 94,2%. El número de componentes a emplear irá en función de la variabilidad que desemos explicar. En este caso un 88,5% es más que suficiente, luego nos quedamos con la primera componente, veamos cual es:

```r
$ componentesI$vectors[1:7]
[1] -0.3926641 -0.3733929 -0.3914349 -0.3744302 -0.3560523 -0.3965847 0.3590553
```


Pues aquí tenemos la componente principal: Z1=-0.3926desplazamiento-0.3734potencia-0.3914par-0.3744longitud-0.356anchura-0.3966peso+0.359recorrido; toma valores muy parecidos para todas las variables excepto recorrido que es positiva esto se puede interpretar como a menor valor tome la variable componente mejor será el coche aunque hay que tener en cuenta que los coches buenos hacen un recorrido menor que los coches pequeños. Para ver como se comporta la componente hemos de introducir esta variable en el conjunto de datos de forma que veamos que valor toma para cada observación, esto lo podemos hacer con cálculo matricial:

```r
$ x<-as.matrix(conjunto) #x es la matriz del conjunto de datos 30x7
$ y<-as.matrix(componentesI$vectors[1:7])#y es la matriz 7x1 con los valores de la componente
$ x %*% y #multiplicamos matrices y obtenemos una matriz 30x1 con los valores de la componente
  [,1]
 [1,] -2110.7416
 [2,] -2143.4584
 [3,] -1928.3765
 [4,] -2107.2210
.......
```


Ahora vamos a unir esta componente a nuestro conjunto de datos de partida:

```r
$ componente.datos<-as.matrix(x %*% y )
$ conjunto.final<-cbind(conjunto,componente.datos) #unimos horizontalmente matrices con la función cbind
$ conjunto.final
  desplazamiento potencia par longitud anchura peso recorrido componente.datos
1 318.0 140 255 215.3 76.3 4370 19.7 -2110.7416
2 440.0 215 330 184.5 69.0 4215 11.2 -2143.4584
3 351.0 143 255 199.9 74.0 3890 18.3 -1928.3765
4 360.0 180 290 214.2 76.3 4250 21.5 -2107.2210
5 140.0 83 109 168.8 69.4 2700 20.3 -1280.0348
6 85.3 80 83 160.6 62.2 2009 36.5 -961.7679
7 350.0 165 260 200.3 69.9 3910 18.9 -1944.5619
8 96.9 75 83 162.5 65.0 2320 30.4 -1091.6923
9 351.0 148 243 215.5 78.5 4540 13.9 -2192.3495
10 440.0 215 330 231.0 79.7 5185 14.9 -2548.0378
11 171.0 109 146 170.4 66.9 2655 21.5 -1297.8304
12 302.0 129 220 199.9 74.0 3890 17.8 -1890.3878
13 350.0 155 250 196.7 72.2 3910 17.8 -1936.7795
14 318.0 145 255 197.6 71.0 3666 16.4 -1826.0833
15 231.0 110 175 179.3 65.4 3050 23.5 -1491.8465
16 96.9 75 83 165.2 61.8 2275 31.9 -1073.1790
17 500.0 190 360 224.1 79.8 5290 14.4 -2613.2788
18 231.0 110 175 179.3 65.4 3020 22.1 -1480.4516
19 350.0 170 275 199.6 72.9 3860 17.0 -1933.9594
20 250.0 105 185 196.7 72.2 3510 20.0 -1693.9764
21 225.0 95 170 194.0 71.8 3365 20.1 -1615.8603
22 89.7 70 81 155.7 64.0 1905 34.7 -917.1865
23 350.0 155 250 195.4 74.4 3885 16.5 -1927.6283
24 258.0 110 195 171.5 77.0 3375 19.7 -1641.7412
25 460.0 223 366 228.0 79.8 5430 13.3 -2669.6199
26 360.0 195 295 209.3 77.4 4215 13.8 -2102.2203
27 262.0 110 200 179.3 65.4 3180 21.5 -1566.0791
28 350.0 165 255 185.2 69.0 3660 16.5 -1838.3459
29 351.0 148 243 216.1 78.5 4715 13.3 -2262.1919
30 133.6 96 120 171.5 63.4 2535 23.9 -1218.8272
```


Vemos que los coches menos potentes tienen un valor menor en la componente, sin embargo recorren muchos más kilometros que aquellos que tienen mucho más tamaño y motor. En la siguiente entrega veremos este mismo ejemplo pero a partir de la matriz de covarianzas. Comentar que en el paquete _stats_ de R disponemos de la función _princomp_ para el análisis de componentes principales. En este caso el código que habríamos de emplear sería:

```r
$ ejemplo.14.1 <- princomp(conjunto,cor=TRUE)
$ summary(ejemplo.14.1)
Importance of components:
Comp.1 Comp.2 Comp.3 Comp.4 Comp.5
Standard deviation 2.4886104 0.63305993 0.49480369 0.30674411 0.216682399
Proportion of Variance 0.8847402 0.05725213 0.03497581 0.01344171 0.006707323
Cumulative Proportion 0.8847402 0.94199234 0.97696816 0.99040987 0.997117189
Comp.6 Comp.7
Standard deviation 0.122860272 0.0713094214
Proportion of Variance 0.002156378 0.0007264334
Cumulative Proportion 0.999273567 1.0000000000
```


En la función princomp hemos de emplear la opción cor = TRUE para realizar el análisis con la matriz de correlaciones ya que por defecto emplea la matriz de covarianzas. Los resultados son los mismos (evidentemente).