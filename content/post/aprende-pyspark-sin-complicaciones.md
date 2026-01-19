---
author: rvaquerizo
categories:
- big data
- formación
date: '2018-09-07'
lastmod: '2025-07-13'
related:
- notebook-para-empezar-y-probar-en-spark-y-scala.md
- lectura-de-archivos-csv-con-python-y-pandas.md
- montemos-un-sistema-de-informacion-en-nuestro-equipo-ii.md
- r-python-reticulate.md
- de-sql-server-a-python-pandas-dataframe.md
tags:
- pyspark
title: Aprende Pyspark sin complicaciones
url: /blog/aprende-pyspark-sin-complicaciones/
---
Hace tiempo un gran data engineer me preparó una máquina virtual para hacer «pinitos» con pyspark y llevaba tiempo pensando en como poder publicar trucos y ejemplos con pyspark sin necesidad de máquinas virtuales y empleando notebooks. Ya he encontrado la mejor manera, los contenedores de docker. Cuanto más profundizo en docker más me gusta trabajar con contenedores y con esta entrada me váis a entender perfectamente.

El primer paso es instalar docker y arrancar el terminal. La idea de docker es ejecutar un contenedor en cualquier máquina independientemente del sistema operativo. Instalar spark en windows es un dolor de cabeza, si disponemos de una máquina virtual con linux es más sencillo, pero imaginad que, con dos líneas de código ya podéis trabajar con un notebook y pyspark, pues eso lo podemos hacer con docker.

Descargado e instalado docker abrimos el terminal de docker y hacemos pull sobre un contenedor, en este caso yo recomiendo:

`docker pull jupyter/all-spark-notebook`

Estamos descargando contenedores con pyspark y notebook, cuando el proceso haya finalizado (unos 5GB) en el terminal de docker podéis ejecutar:

`docker images`

Y podréis ver jupyter/all-spark-notebook con lo cual ya tenéis disponible un contenedor con un notebook que nos permite ejecutar pyspark. Ahora tenemos que arrancar el servicio:

`docker run -it --rm -p 8888:8888 jupyter/pyspark-notebook`

Y ahora si usáis win10 no hagáis mucho caso a lo que nos dice el terminal al servicio no lo llamamos en localhost, lo llamamos con http://192.168.99.100:8888/tree y nos pide el token y ahora si copiamos y pegamos el token del terminal al explorador, hacemos login y ya disponemos de un notebook para comenzar a trabajar con pyspark. Podemos probar:

```r
# SQLContext or HiveContext in Spark 1.x
from pyspark.sql import SparkSession
from pyspark import SparkContext

sc = SparkContext()

rdd = sc.parallelize([("a", 1)])
hasattr(rdd, "toDF")
## False

spark = SparkSession(sc)
hasattr(rdd, "toDF")
## True

rdd.toDF().show()
```


Podemos importar archivos csv con sitaxis sencilla:

```r
df = spark.read.csv("bank.csv", header=True, mode="DROPMALFORMED",sep=";")
```


El csv bank lo podéis encontrar en el repositorio UCI. Otro aspecto interesante es poder crear tablas Hive:

```r
from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession, HiveContext
SparkContext.setSystemProperty("hive.metastore.uris", "thrift://nn1:9083")

sparkSession = (SparkSession
.builder
.appName('trabajo_hive')
.enableHiveSupport()
.getOrCreate())
data = [('A', 1), ('B', 2), ('C', 3), ('D', 4)]
df = sparkSession.createDataFrame(data)

# Crear tabla Hive
df.write.saveAsTable('prueba')
# Realizamos la consulta
df_load = sparkSession.sql('SELECT * FROM example')
df_load.show()
```


Aspecto importante, no sé como hacerlo, pero pierdo los notebook, así que me los suelo descargar y ya los subo cada vez que hago algo. Ahora tengo que ir contando algún truco, saludos.