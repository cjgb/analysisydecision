---
author: rvaquerizo
categories:
- Big Data
- Machine Learning
date: '2018-03-11T06:02:57-05:00'
slug: notebook-para-empezar-y-probar-en-spark-y-scala
tags:
- notebook
- scala
- spark
title: Notebook para empezar (y probar) en spark y scala
url: /notebook-para-empezar-y-probar-en-spark-y-scala/
---

No debo enseñar Spark a nadie, no soy ni un usuario avanzado, ni le veo mucho recorrido. Sin embargo tengo que hacer diversos procesos con dataframes en spark y realizar modelos con MLlib y tengo que «perder tiempo» probando cosas, necesitaba un entorno sencillo en casa. En un primer momento exploré máquinas virtuales y alguna sandbox. Ninguna me convencía y le pedí a un compañero mío, Juanvi, que sabe mucho que me montara un entorno con un notebook de spark para poder jugar con scala y MLlib de modo sencillo. En vez de montarme el entorno en 20 minutos me escribió un correo con 3 direcciones que me están siendo de mucha utilidad y quería compartirlas con vosotros.

La primera dirección es el repositorio donde está alojado este desarrollo del notebook de spark: [https://github.com/spark-notebook/spark-notebook ](https://github.com/spark-notebook/spark-notebook) Lo primero que [debemos estudiar es la documentación](https://github.com/spark-notebook/spark-notebook/blob/master/docs/quick_start.md) y por último [generar o seleccionar el notebook que deseamos](http://spark-notebook.io/). Aquí me gustaría hacer una anotación, no he sido capaz de hacer funcionar en Windows ninguna distribución que no sea de [docker](https://www.docker.com/), sin ningún problema las dos distribuciones que he probado en Ubuntu y en el Apple sin problema con docker, al final, por temas profesionales, he optado por una versión con Hive-parquet y spark 2.0.1:

[code] docker pull andypetrella/spark-notebook:0.7.0-scala-2.10.6-spark-2.0.1-hadoop-2.7.2-with-hive  
docker run -p 9001:9001 andypetrella/spark-notebook:0.7.0-scala-2.10.6-spark-2.0.1-hadoop-2.7.2-with-hive  
[/code]

Instalado y arrancado el servicio nos conectamos a http://localhost:9001/ y ya tienes un entorno de pruebas más que digno que funciona mejor que las sandbox que he probado. Un tema, si alguien puede aportar más sobre la distribución del Notebook en Windows que comente la entrada. Espero que pueda ser de utilidad, saludos.