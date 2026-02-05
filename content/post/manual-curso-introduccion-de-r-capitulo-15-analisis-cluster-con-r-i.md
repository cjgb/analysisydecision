---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-04-23'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
  - manual-curso-introduccion-de-r-capitulo-17-analisis-cluster-con-r-y-iii.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-9-analisis-exploratorio-de-datos-eda.md
tags:
  - formación
  - modelos
  - r
title: 'Manual. Curso introducción de R. Capítulo 15: Análisis Cluster con R (I)'
url: /blog/manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i/
---

El propósito del análisis de conglomerados (*cluster* en terminología inglesa) es agrupar las observaciones de forma que los datos sean muy homogéneos dentro de los grupos (mínima varianza) y que estos grupos sean lo más heterogéneos posible entre ellos (máxima varianza). De este modo obtenemos una clasificación de los datos multivariante con la que podemos comprender mejor los mismos y la población de la que proceden. Podemos realizar análisis cluster de casos, un análisis cluster de variables o un análisis cluster por bloques si agrupamos variables y casos. El análisis cluster se puede utilizar para:

- La taxonomía: agrupar especies naturales.
- El marketing: clasificar consumidores tipo.
- Medicina: clasificar seres vivos con los mismos síntomas y características patológicas.
- Técnicas de reconocimiento de patrones.
- Formar grupos de píxeles en imágenes digitalizadas enviadas por un satélite desde un planeta para identificar los terrenos.
- …

Como siempre, la metodología del análisis y la programación con R la vamos a estudiar mediante un ejemplo.

**Ejemplo Cluster.1**:
Partimos de los precios de las viviendas en España desde el último trimestre de 2007 al último trimestre de 2008 por provincia y municipio; trataremos de agrupar ciudades. Los datos los tenemos en formato Excel y han sido descargados del [Ministerio de la Vivienda](http://www.mviv.es/es/index.php?option=com_content&task=blogsection&id=9&Itemid=35); por ello necesitamos leer los datos con el paquete `RODBC` (que no tenemos instalado):

```r
# instalamos el paquete si no lo tenemos
# install.packages("RODBC")
library(RODBC)   # llamamos al paquete instalado

setwd("c:/raul")  # establecemos el directorio de trabajo

tabla <- odbcConnectExcel("vivienda.xls")  # creamos el objeto tabla con el Excel de datos
datos <- sqlFetch(tabla, "Hoja1")          # objeto que contiene los datos de la Hoja1
odbcClose(tabla)                           # cerramos la conexión con el libro Excel
```

Un buen ejemplo para conocer cómo instalar paquetes en R con la función `install.packages`. Y un buen ejemplo para importar datos desde Excel a R. Con estos pasos ya tenemos un conjunto de datos con las siguientes variables:

- `Provincia`
- `Municipio`
- `Viv_2anios2007_1`
- `Viv_mas2anios2007_1`
- `Tas_2anios2007_1`
- `Tas_mas2anios2007_1`
- `Viv_2anios2008_1`
- `Viv_mas2anios2008_1`
- `Tas_2anios2008_1`
- `Tas_mas2anios2008_1`
- `Viv_2anios2008_2`
- `Viv_mas2anios2008_2`
- `Tas_2anios2008_2`
- `Tas_mas2anios2008_2`
- `Viv_2anios2008_3`
- `Viv_mas2anios2008_3`
- `Tas_2anios2008_3`
- `Tas_mas2anios2008_3`
- `Viv_2anios2008_4`
- `Viv_mas2anios2008_4`
- `Tas_2anios2008_4`
- `Tas_mas2anios2008_4`

Disponemos de la provincia, el municipio (municipios con más de 25.000 habitantes) y variables `VIV` que hacen referencia al precio de la vivienda en €/m² y variables `TAS` que hacen referencia al número de tasaciones. Estas variables a su vez pueden ser `2ANIOS` si tienen menos de 2 años (vivienda nueva) o `MAS2ANIOS` si son viviendas antiguas. No tiene mucho sentido agrupar por variables que miden un importe o un número; es más interesante realizar el análisis cluster sobre variaciones entre trimestres. Por esto, el conjunto de datos requiere un tratamiento previo para calcular el % de diferencia de precio y del número de tasaciones:

```r
attach(datos) # Creamos un objeto para cada diferencia y posteriormente unimos

dif_Viv_2anios_1 = Viv_2anios2007_1 / Viv_2anios2008_1 - 1
dif_Viv_2anios_2 = Viv_2anios2008_1 / Viv_2anios2008_2 - 1
dif_Viv_2anios_3 = Viv_2anios2008_2 / Viv_2anios2008_3 - 1
dif_Viv_2anios_4 = Viv_2anios2008_3 / Viv_2anios2008_4 - 1

dif_Viv_mas2anios_1 = Viv_mas2anios2007_1 / Viv_mas2anios2008_1 - 1
dif_Viv_mas2anios_2 = Viv_mas2anios2008_1 / Viv_mas2anios2008_2 - 1
dif_Viv_mas2anios_3 = Viv_mas2anios2008_2 / Viv_mas2anios2008_3 - 1
dif_Viv_mas2anios_4 = Viv_mas2anios2008_3 / Viv_mas2anios2008_4 - 1

dif_Tas_2anios_1 = Tas_2anios2007_1 / Tas_2anios2008_1 - 1
dif_Tas_2anios_2 = Tas_2anios2008_1 / Tas_2anios2008_2 - 1
dif_Tas_2anios_3 = Tas_2anios2008_2 / Tas_2anios2008_3 - 1
dif_Tas_2anios_4 = Tas_2anios2008_3 / Tas_2anios2008_4 - 1

dif_Tas_mas2anios_1 = Tas_mas2anios2007_1 / Tas_mas2anios2008_1 - 1
dif_Tas_mas2anios_2 = Tas_mas2anios2008_1 / Tas_mas2anios2008_2 - 1
dif_Tas_mas2anios_3 = Tas_mas2anios2008_2 / Tas_mas2anios2008_3 - 1
dif_Tas_mas2anios_4 = Tas_mas2anios2008_3 / Tas_mas2anios2008_4 - 1

detach(datos)
```

Ahora vamos a unir los 16 objetos creados con la provincia y el municipio empleando las funciones `subset` y `cbind`:

```r
datos <- data.frame(datos)
analisis <- subset(datos, select = c(Provincia, Municipio))

analisis <- cbind(analisis,
                  dif_Viv_2anios_1, dif_Viv_2anios_2, dif_Viv_2anios_3, dif_Viv_2anios_4,
                  dif_Viv_mas2anios_1, dif_Viv_mas2anios_2, dif_Viv_mas2anios_3, dif_Viv_mas2anios_4,
                  dif_Tas_2anios_1, dif_Tas_2anios_2, dif_Tas_2anios_3, dif_Tas_2anios_4,
                  dif_Tas_mas2anios_1, dif_Tas_mas2anios_2, dif_Tas_mas2anios_3, dif_Tas_mas2anios_4)
```

Ya tenemos una tabla de entrada para nuestro análisis pero nos encontramos con múltiples valores perdidos. Para este análisis no vamos a tener en cuenta los valores perdidos. Para eliminar aquellas observaciones que tienen `NA` empleamos la función `na.omit`:

```r
analisis.ok <- na.omit(analisis)
analisis.ok <- data.frame(analisis.ok)
nrow(analisis.ok) / nrow(analisis) # Estudiamos cuántas obs eliminamos
```

Es cierto que son muchas y deberíamos hacer un tratamiento con ellas, pero de momento es preferible eliminarlas. Ya disponemos de un `data.frame` adecuado para calcular la matriz de distancias sobre la que realizaremos el análisis cluster con R para determinar el número de grupos que formaremos:

```r
# Solo las variables numéricas para calcular distancias
distancias <- dist(analisis.ok[, -c(1, 2)])
cluster.1 <- hclust(distancias, method = "average")
plot(cluster.1)
```

Con la matriz de distancias realizamos el análisis jerárquico de conglomerados por el método de la media y necesitamos establecer el número de grupos a elegir y para ello la función `plot` nos imprime el dendrograma de nuestro análisis como vemos en la siguiente figura:

![cluster1.JPG](/images/2009/04/cluster1.JPG "cluster1.JPG")

He marcado manualmente el gráfico resultante y considero que 6 grupos son los adecuados. Aunque parece que 2 grupos son muy numerosos y el resto mucho menos, el corte queda sujeto a la interpretación del analista. Ya podemos realizar un análisis no jerárquico para asignar a cada observación un cluster:

```r
cluster.1.nojerar <- kmeans(analisis.ok[, -c(1, 2)], 6)
asignacion <- data.frame(cluster.1.nojerar$cluster)
```

Hemos creado el objeto `asignacion` que asigna a cada observación el cluster resultante del análisis no jerárquico. Este objeto lo unimos con `analisis.ok` y podemos analizar cómo se ha comportado el agrupamiento:

```r
analisis.ok <- cbind(analisis.ok, asignacion)
names(analisis.ok)[19] <- "cluster" # renombramos la última variable
```

Ahora trabajaremos con la variable `cluster` del objeto `analisis.ok`. Hemos cambiado con `names` el elemento 19 del vector de nombres del `data.frame` `analisis.ok`. Y procede estudiar una a una las variables con las que se ha realizado el agrupamiento no jerárquico. Pero lo principal es el tamaño de los grupos:

```r
tapply(analisis.ok$cluster, analisis.ok$cluster, length)
```

Es el grupo 2 el más numeroso en contraposición del 4 y el 3 que aglutinan muy pocas ciudades. Veamos las medias de las variables en estudio por cluster:

```r
tapply(analisis.ok$dif_Viv_2anios_4, analisis.ok$cluster, mean)
```

Vemos que los municipios del grupo 2 han seguido un precio al alza de la vivienda con menos de 2 años durante 2008. Destacar del grupo 3 el fuerte alza de los precios del metro cuadrado en el último trimestre de 2008.

Variaciones mucho menores para la vivienda antigua. Destacan las subidas del T4 de 2008 de los grupos 3 y 6. No parece ser el precio de la vivienda antigua una variable que agrupe los municipios. Comencemos con las tasaciones, altamente correlacionadas con el número de hipotecas concedidas:

El grupo 3 se diferencia por el increíble aumento en el número de las tasaciones ¿problemas de promotoras? Los grupos 4 y 6 hacen lo mismo pero en el último trimestre, siendo el grupo 4 el que tiene un aumento del $1300\%$. El grupo 1 el aumento lo sufre en T3 y el 5 aunque también tiene un pico en T3 permanece más lineal. Veamos las viviendas de segunda mano:

Fuerte aumento en T3 y T4 para todos, destaca el grupo 4 muy por encima del resto y que además ya sufrió subidas en T2 ¿embargos? Con estos resultados podemos describir los 6 grupos formados:

- **Cluster 1**: Municipios muy estables pero con alguna promoción en apuros.
- **Cluster 2**: El grupo más numeroso, es muy estable también pero no sufren un aumento espectacular de las tasaciones de vivienda nueva que pueden ser propias de promotores incapaces de hacer frente a la crisis.
- **Cluster 3**: Un grupo de 8 municipios donde sigue en aumento el precio de la vivienda y también tienen un aumento exponencial de las tasaciones de vivienda nueva, donde menos ha afectado la crisis.
- **Cluster 4**: El más pequeño de todos. Tiene un descomunal aumento de las tasaciones de vivienda antigua y bajaron sus precios en T4. Puede ser donde más daño hace la crisis.
- **Cluster 5**: Un grupo numeroso con un precio estable pero donde bajaron las tasaciones de viviendas nuevas. Son zonas donde el boom del ladrillo no fue tan intenso.
- **Cluster 6**: El grupo que comenzó 2008 con subidas de precios en viviendas nuevas y bajada en antiguas. Tuvo muchas tasaciones de antiguas en T3 pero las nuevas bajaron. Zona de fuerte parón en la construcción pero sin parón económico.

Con ejemplos podríamos estudiar las conclusiones. Hasta aquí este post que no va en la línea de post cortos de AyD pero que sirve de introducción al análisis cluster con R. Vamos a trabajar al menos 3 ejemplos más porque este tipo de trabajos engloba muchos usos de funciones imprescindibles de conocer y manejar en R. Como siempre para dudas o sugerencias… `rvaquerizo@analisisydecision.es`