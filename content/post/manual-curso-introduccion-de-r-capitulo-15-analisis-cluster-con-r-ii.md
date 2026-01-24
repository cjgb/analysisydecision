---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-05-04'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i.md
  - manual-curso-introduccion-de-r-capitulo-17-analisis-cluster-con-r-y-iii.md
  - adyacencia-de-poligonos-con-el-paquete-spdep-de-r.md
  - un-peligro-del-analisis-cluster.md
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
tags:
  - análisis cluster
  - modelos
  - estadística
  - r
title: 'Manual. Curso introducción de R. Capítulo 16: Análisis Cluster con R (II)'
url: /blog/manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii/
---

En esta entrega seguimos trabajando con el análisis `Cluster` viendo más posibilidades que nos ofrece `R`. Para ello vamos a realizar un estudio de agrupamiento de países europeos en función de algunos indicadores básicos:

- Superficie
- Población
- PIB (en mil de $)
- Esperanza de vida
- Índice de desarrollo humano
- % Población en ciudad

Para este estudio contamos con [este archivo excel](/images/2009/05/paises.xls "paises.xls") . El primer paso por supuesto es crear un objeto en `R`:

```r
library(RODBC)

setwd("c:/raul")

tabla<-odbcConnectExcel("paises.xls")

datos<-sqlFetch(tabla,"Hoja1")

odbcClose(tabla)

detach(datos)

attach(datos)

datosdensi<-datospob/datos$sup

detach(datos)
```

Ya tenemos el objeto `datos` sobre el que realizaremos el análisis. Para evitar que tamaños de población o superficies muy grandes distorsionen el análisis hemos creado una nueva variable `densi` que nos mide la densidad de población Es necesario computar una matriz de distancias pero en este caso el agrupamiento se llevará a cabo con las medidas de disimilitud con base en la distancia euclidea. Es decir, lo contrario a una medida de similitud:

```r
library(cluster)

datos.estudio<-cbind(datosdensi,datospib,datosIDH,datosEspe_vida,datos$Pob_ciudad)

disimilar<-daisy(datos.estudio)
```

Necesitamos la librería `cluster` para emplear la función `daisy` que es la que nos calcula la matriz de disimilitudes. Con esta matriz ya podemos emplear la función `hclust` y crear un gráfico para estudiar como se agrupan los países en estudio:

```r
cluster.1<-hclust(disimilar)

plot(cluster.1)
```

![cluster2.JPG](/images/2009/05/cluster2.JPG)

Parece que tenemos 4 grupos muy claros, uno de ellos con sólo un elemento. Vamos a emplear una técnica por medios divisorios (Partitioning methods en terminología anglosajona) que sitúa cada observación en los alguno de los `cluster` de forma que se minimizara la suma de las disimilaridades:

```r
cluster.2<-pam(datos.estudio,4)

cluster.2
```

```text
Medoids:

ID

[1,] 22  56.66156  6656 0.803 71.8 68.4

[2,]  3  96.59071 25089 0.921 77.9 64.6

[3,] 16  80.32920 15414 0.881 78.1 59.9

[4,] 23 170.92034 42769 0.924 77.2 91.0

Clustering vector:

[1] 1 2 2 1 2 1 1 2 1 3 3 1 1 2 2 3 3 2 2 2 1 1 4 1 3 1 2 2 1 3 2 3 1 2 2 1

Objective function:

build     swap

1716.162 1710.430

Available components:

[1] "medoids"    "id.med"     "clustering" "objective"  "isolation"  "clusinfo"   "silinfo"    "diss"       "call"       "data"

size max_diss  av_diss diameter separation

[1,]   14 4619.601 1791.727 8554.028   839.0358

[2,]   14 3345.039 1789.240 6344.181  4017.4032

[3,]    7 3984.093 1634.563 6649.075   839.0358

[4,]    1    0.000    0.000    0.000 14336.8688
```

Se observa que el `cluster` identificado como 1 tiene los valores más bajos a excepción de la población rural que se sitúa en la media global. El `cluster` 2 tiene un PIB alto al igual que el ídice de desarrollo humano, la más alta esperanza de vida y uno de los menores porcentajes de personas en ciudades. El grupo 3 es parecido al grupo 1 pero su PIB no es muy bajo, aunque por debajo de la media, un 40% de su población vive en el medio rural. El grupo 4 recoge a un país muy potente y muy poblado donde nadie reside en el medio rural. Vemos como quedan los grupos:

```r
grupos<-data.frame(datospais)
grupos<-cbind(grupos,data.frame(cluster.2$clustering))
grupos
```

```text
datos.pais cluster.2.clustering
1          Albania                    1
2         Alemania                    2
3          Austria                    2
4          Belarús                    1
5          Bélgica                    2
6         Bulgaria                    1
7          Croacia                    1
8        Dinamarca                    2
9       Eslovaquia                    1
10       Eslovenia                    3
11          España                    3
12         Estonia                    1
13           Rusia                    1
14       Finlandia                    2
15         Francia                    2
16          Grecia                    3
17         Hungría                    3
18         Irlanda                    2
19        Islandia                    2
20          Italia                    2
21         Letonia                    1
22        Lituania                    1
23      Luxemburgo                    4
24       Macedonia                    1
25           Malta                    3
26         Moldova                    1
27         Noruega                    2
28         Holanda                    2
29         Polonia                    1
30        Portugal                    3
31     Reino Unido                    2
32 República Checa                    3
33         Rumania                    1
34          Suecia                    2
35           Suiza                    2
36         Ucrania                    1
```

Parece claro que el grupo 1 engloba a los países del este, el grupo 2 forma la Europa más desarrollada, el grupo 3 la Europa en vías de desarrollo y el grupo 4 es Luxemburgo. Veamos gráficamente como se agrupan:

```r
par(mfrow=c(2,1)) # 2x1 casillas gráficas

plot(cluster.2)
```

![cluster3.JPG](/images/2009/05/cluster3.JPG)

Tenemos 2 gráficos: uno de componentes principales y otro de distancias entre los centroides de los `cluster`. Con 2 componentes ya tendríamos el 85% de la variabilidad explicada. Espero que este ejemplo os sirva de referencia para conocer las posibilidades de `R` en el análisis `cluster`. Por supuesto si tenéis cualquier duda o sugerencia `rvaquerizo@analisisydecision.es`
