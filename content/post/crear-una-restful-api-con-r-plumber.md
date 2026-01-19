---
author: rvaquerizo
categories:
- machine learning
- monográficos
- r
date: '2018-11-07'
lastmod: '2025-07-13'
related:
- juego-de-modelos-de-regresion-con-r.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
- arboles-de-decision-con-sas-base-con-r-por-supuesto.md
- resolucion-del-juego-de-modelos-con-r.md
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
tags:
- plumber
- rest
- restful
title: Crear una RESTful API con R con plumber
url: /blog/crear-una-restful-api-con-r-plumber/
---
Podéis buscar info en la web acerca de lo que es una REST y una RESTful pero el objetivo de este trabajo es la creación de una API para «escorear» unos datos a partir de un modelo que hemos creado en R. Vamos a hacer lo más sencillo, un modelo de regresión lineal creado por R será guardado y una API con datos podrá llamar a este modelo mediante un cliente RESTful para obtener una predicción. Esta será la primera de una serie de entradas que le voy a dedicar a Carlos, un antiguo compañero mío y que me ha enseñado a desaprender y el primer guiño a Carlos será abandonar mi subversion local para conectar mi RStudio con GitHub, todo el trabajo que voy desarrollando lo tenéis en <https://github.com/analisisydecision/Modelo1>. Si echáis un vistazo al repositorio ya os podéis imaginar hacia donde irán encaminadas esta serie de entradas.

Bien, lo primero será crear y guardar el modelo con R:

```r
#Programa de creación del modelo
Altura <-c(175,180,162,157,180,173,171,168,165,165)
Peso <-c(80,82,57,63,78,65,66,67,62,58)

modelo1 <- lm(Peso~Altura)
summary(modelo1)
save(modelo1, file = "modelo1/modelo1.rda")
#rm(modelo1)
```


Modelo de regresión lineal simple de alturas y pesos que guarda en la carpeta modelo1 el objeto con el modelo. Ahora quiero crear una API que, dada una altura, me estime el peso. Para ello creo un nuevo programa en R que debería llamarse despliegue pero que llamo depliegue_modelo1.R debido a que es bastante tarde. Este programa es una función para realizar una predicción que tiene el siguiente contenido:

```r
library(jsonlite)

load("modelo1/modelo1.rda")

#* @post /prediccion
predict.peso <- function(Altura) {
data <- list(
Altura=Altura
)
prediccion <- predict.lm(modelo1, data )
return(prediccion)
}
```


Este código es el core de nuestra API a la que llamamos prediccion y que recibirá un json con ‘{«Altura»:XXX}’ y retornará la predicción del peso para esa altura. Y ahora viene [plumber](https://www.rplumber.io/) que es el «fontanero» que nos permite canalizar las llamadas a nuestra API prediccion. Esta llamada la hacemos con la función plumb:

```r
library(plumber)
r <- plumb("depliegue_modelo1.R")
r$run(port=8000)
```


Ejecutado este código nuestra API esta funcionando en el puerto 8000 y sólo nos queda probarla y para ello yo recomiendo añadir una extensión de RESTClient a nuestro navegador habitual, en mi caso concreto es Chrome y he añadido una extensión Cliente de servicios Web RESTful y al ejecutarla tengo que modificar:

[![](/images/2018/11/RESTful_R.png)](/images/2018/11/RESTful_R.png)

Como cuerpo de la solicitud pasamos un json con la altura y le damos a enviar, como respuesta debemos obtener [73.2291]. Lo que hemos hecho es una solicitud curl con la sintaxis:

`curl -i -H Accept:application/json -X POST http://127.0.0.1:8000/prediccion -H Content-Type: application/json -d '{"Altura":175} '`

Si ponéis esto en el terminal debe funcionar. ¿Qué os parece si empezamos a poner en producción modelos de R?