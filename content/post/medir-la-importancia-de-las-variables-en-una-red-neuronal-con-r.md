---
author: rvaquerizo
categories:
  - data mining
  - modelos
  - monográficos
  - r
  - trucos
date: '2014-09-29'
lastmod: '2025-07-13'
related:
  - regresion-con-redes-neuronales-en-r.md
  - representacion-de-redes-neuronales-con-r.md
  - medir-la-importancia-de-las-variables-con-random-forest.md
  - como-salva-la-linealidad-una-red-neuronal.md
  - monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
tags:
  - nnet
  - plot.nnet
  - plot
  - redes neuronales
  - r
title: Medir la importancia de las variables en una red neuronal con R
url: /blog/medir-la-importancia-de-las-variables-en-una-red-neuronal-con-r/
---

[![](/images/2014/09/importancia_variables-300x236.png)](/images/2014/09/importancia_variables.png)

Sigo a vueltas con [esta gran web](http://beckmw.wordpress.com/) y hoy vamos a **medir la importancia de las variables en una red neuronal**. Al igual que sucede en un modelo de regresión los parámetros obtenidos pueden servirnos para determinar la importancia de una variable dentro del modelo. En el caso de una red neuronal los pesos de la red pueden ser utilizados para determinar cómo influye una variable en el modelo. Para ilustrar este tipo de tareas el gran @beckmw realizó esta entrada:

<http://beckmw.wordpress.com/2013/08/12/variable-importance-in-neural-networks/>

El método que emplea para determinar esta importancia [fue propuesto por Garson en 1991](http://www.sagepub.com/booksProdDesc.nav?prodId=Book220714#tabview=google) y parte de la idea de buscar todas las conexiones que tiene una variable dentro de una red neuronal y se ponderan para obtener un valor único que describe el grado de asociación de nuestra variable dependiente con cada una de sus regresoras. Garson realizó este método para poder obtener un valor de 0 a 1, pero @beckmw lo ha modificado para que el signo tenga su importancia. La función que ha creado este genio [la tenéis en Github](https://gist.github.com/fawda123)

source(url(‘https://gist.githubusercontent.com/fawda123/6206737/raw/d6f365c283a8cae23fb20892dc223bc5764d50c7/gar_fun.r’))

Por cierto, qué manía tienen algunos con usar devtools. Haciendo sólo:

#Dejamos los nombres de los coeficientes de una forma más adecuada
tr=nnet.fitcoefnames
tr=substr(tr,16,30)
nnet.fitcoefnames=tr

#Pintamos la importancia de las variables
gar.fun(‘medv’,nnet.fit)

Obtenemos el gráfico con el que comienza esta entrada al blog. Ni se os ocurra comenzar a tocar este gráfico con los temas de ggplot2, somos gente productiva. Vemos como a la izquierda del gráfico se sitúan las variables con mayor peso negativo y a la derecha las variables con mayor peso positivo. Podemos eliminar algunas variables y seguramente el comportamiento predictivo del modelo no empeoraría.

Hay que dejar de pensar en las redes neuronales como una caja negra sin sentido. Saludos.
