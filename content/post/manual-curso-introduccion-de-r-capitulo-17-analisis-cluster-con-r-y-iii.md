---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-06-08'
lastmod: '2025-07-13'
related:
  - un-peligro-del-analisis-cluster.md
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i.md
  - analisis-cluster-con-sas-la-importancia-de-las-semillas-en-las-k-medias.md
  - knn-con-sas-mejorando-k-means.md
tags:
  - sin etiqueta
title: 'Manual. Curso introducción de R. Capítulo 17: Análisis Cluster con R (y III)'
url: /blog/manual-curso-introduccion-de-r-capitulo-17-analisis-cluster-con-r-y-iii/
---

Ante el exito de los mensajes dedicados al análisis cluster la nueva entrega del manual de R la dedicaremos de nuevo al análisis de agrupamiento. Como es habitual trabajaremos con un ejemplo que podéis desgargaros [aquí](/images/2009/06/alimentos2.txt). Partimos de un archivo de texto delimitado por tabuladores con 46 frutas y la información que disponemos es:

- Nombre
- Intercambio de hidratos de carbono por gramo
- Kilocalorías
- Proteinas
- Grasas

(información obtenida de www.diabetesjuvenil.com)

El primer paso será crear un objeto en R que recoja los datos en el análisis. Para ello vamos a emplear la función read.table que deberá tener los parámetros adecuados al fichero de texto que deseamos leer:

```r
frutas<-read.table("c:\\datos\\alimentos.txt",header=FALSE,sep="\t")

nombres<-c("nombre","inter_hidratos","kcal","proteinas","grasas")

names(frutas)<-nombres
```

El archivo de texto lo tenemos en una ubicación de nuestra máquina c:\\datos, pero lo he subido y también podemos leerlo directamente de la web:

```r
frutas<-read.table(url("/images/2009/06/alimentos2.txt"),header=FALSE,sep="\t")

nombres<-c("nombre","inter_hidratos","kcal","proteinas","grasas")

names(frutas)<-nombres
```

Lo leemos sin cabeceras y como separador indicamos el tabulador con el parámetro de _read.table sep=»\\t»_. Ya disponemos del objeto para el análisis. Como vimos en capítulos anteriores el primer paso es crear la matriz de distancias, realizar el cluster con ella y seleccionar el número de grupos. Para crear la matriz de distancias entre observaciones hemos de especificar un método de cálculo, en este punto vamos a aprobechar para comparar 4 métodos de obtención de distancias:

```r
distancias1<-dist(frutas,method="manhattan")

cluster1<-hclust(distancias1)

distancias2<-dist(frutas,method="euclidean")

cluster2<-hclust(distancias2)

distancias3<-dist(frutas,method="maximum")

cluster3<-hclust(distancias3)

distancias4<-dist(frutas,method="canberra")

cluster4<-hclust(distancias4)

#Realizamos la comparativa gráfica

op <- par(mfcol = c(2, 2)) #Nos permite presentar

par(las =1)                #el gráfico en 4 partes

plot(cluster1,main="Método Manhatan")

plot(cluster2,main="Distancia euclídea")

plot(cluster3,main="Distancia por máximos")

plot(cluster4,main="Método Camberra")
```

Disponemos de 4 gráficos en la pantalla que nos permiten comparar los distintos métodos empleados para las distancias. Vemos que tanto la distancia euclídea, como máximos y Manhatan ofrecen resultados parecidos, parece que se forman 4 grupos y las observaciones 41 y 1 son muy distintas al resto. El método Camberra es el que ofrece otros resultados diferentes pero este método es adecuado para datos estandarizados y no es el caso. En nuestro ejemplo vamos a emplear la distancia euclídea por lo que emprearemos el objeto cluster2. Si observamos el dendograma que nos ofrece R de cluster2 parece que podemos formar 4 grupos y hay observaciones muy distintas del resto. Para determinar mejor el número de clusters a seleccionar vamos a emplear el algoritmo PAM (Partitioning Around Medoids):

```r
library(cluster)

paso1<-pam(distancias2,2)

paso2<-pam(distancias2,3)

paso3<-pam(distancias2,4)

paso4<-pam(distancias2,5)

par(mfrow=c(2,2))

plot(paso1)

plot(paso2)

plot(paso3)

plot(paso4)
```

El resultado de la ejecución de este código lo tenemos en la siguiente figura:

[![cluster4.JPG](/images/2009/06/cluster4.thumbnail.JPG)](/images/2009/06/cluster4.JPG "cluster4.JPG")

Viendo las 4 siluetas parece más adecuado elegir los k=4 grupos porque son más homogéneos. De todos modos procede un análisis del tamaño de los grupos porque a la vista de las siluetas y los dendogramas anteriores parece que algunas observaciones distorsionan el agrupamiento:

```r
cluster.final<- kmeans(distancias2,3)

cluster.finalsize #Obtenemos el tamaño de los cluster

[1] 13  2 31

cluster.final<- kmeans(distancias2,4)

cluster.finalsize #Obtenemos el tamaño de los cluster

[1] 16 17  2 11

cluster.final<- kmeans(distancias2,5)

cluster.final$size #Obtenemos el tamaño de los cluster

[1] 13 11 17  2  3
```

Nos quedamos con 4 grupos aunque vemos que uno de ellos tiene sólo dos frutas. Estudiemos como se han agrupado observando las 46 frutas en estudio directamente sobre los datos, para ello creamos un _data.frame_ que sea la unión del objeto frutas y los cluster el análisis final:

```r
cluster.final<- kmeans(distancias2,4)

grupos<-data.frame(frutas)

clus<-as.factor(cluster.final$cluster)

grupos<-cbind(data.frame(frutas),clus)
```

Para estudiar como se forman los cluster directamente sobre los datos es necesaria una ordenación de los datos. Para ordenar _data.frame_ vamos a emplear el módulo _reshape_ que incluye la función _sort_df_ :

```r
install.packages("reshape")
```

Vemos que también se ha instalado el paquete _plyr_ porque es necesario para el funcionamiento de _reshape_. Ahora estamos en disposición de emplear la función _sort_df_ para la ordenación de _data.frame_ :

```r
library(reshape)

grupos<-sort_df(grupos,vars='clus')

grupos

V1  V2     V3    V4    V5 clus

2                 ALBARICOQUE 105   41.8  0.84   0.1    1

8                    CIRUELAS  91   40.9  1.00   0.1    1

10                  FRAMBUESA 125   48.8  1.00   0.8    1

12                    GRANADA 133   42.4  1.00   0.1    1
```

______________________________________________________________________

```r
nombres<-c("nombre","inter_hidratos","kcal","proteinas","grasas","clus")

names(grupos)<-nombres
```

Observemos que el data.frame no nos ha respetado los nombres por ese motivo se emplea de nuevo names.

Es recomendable para conocer el funcionamiento del agrupamiento realizar un análisis de las variables dentro de cada cluster. Para ello vamos a emplear la función aggregate que nos realiza sumarizaciones por factores de un data.frame:

```r
aggregate(gruposinter_hidratos,list(gruposclus),mean)

Group.1        x

1       1 102.5294

2       2 509.5000

3       3 168.8182

4       4  54.6250

aggregate(gruposkcal,list(gruposclus),mean)

Group.1          x

1       1   41.97059

2       2 1453.95000

3       3   46.44545

4       4   40.40625

aggregate(gruposproteinas,list(gruposclus),mean)

Group.1        x

1       1 0.637647

2       2 6.000000

3       3 1.263636

4       4 0.362500

aggregate(gruposgrasas,list(gruposclus),mean)

Group.1          x

1       1  0.6588235

2       2 53.2500000

3       3  0.4727273

4       4  0.1437500
```

Vemos que las frutas del cluster 2 (aguacate y ruibardo) tienen un aporte calórico, protéico y de grasas muy alto; equivalen a comer carne. El grupo 3 destaca por hidratos y proteinas, todo lo contrario que el grupo 4. El grupo 1 se aleja de los grupos 3 y 4 debido a su aporte en hidratos y grasas.

Con este nuevo ejemplo damos por finalizados los capítulos dedicados al análisis cluster. Estos casos están teniendo un gran éxito en la web, además, por el tiempo de permanencia en ellos deben de estar siendo muy útiles. Por supuesto para cualquier duda o sugerencia estamos a vuestra disposición.
