---
author: rvaquerizo
categories:
- formación
- monográficos
- r
date: '2016-01-06'
lastmod: '2025-07-13'
related:
- puede-la-informacion-de-twitter-servir-para-tarificar-seguros.md
- paquete-opendataes-en-ropenspain-para-acceder-a-los-datos-de-datos-gob-es-con-r.md
- comienza-la-publicacion-del-ensayo-introduccion-a-la-estadistica-para-cientificos-de-datos.md
- leer-y-representar-datos-de-google-trends-con-r.md
- trucos-simples-para-rstats.md
tags:
- twitter
title: 'TwitteR con R. El hashtag #rstats'
url: /blog/twitter-con-r-el-hashtag-rstats/
---
El objetivo de la entrada es empezar a analizar _tweets_ con R y que mejor comienzo que usar el _hashtag_**#rstats** para ver usuarios que más lo utilizan. [no me gusta conjugar el verbo retwitear] El primer paso es **crear una _app_ con Twitter**, para ello nos dirigimos a <https://apps.twitter.com/> y creamos una aplicación. Crearla es muy sencillo, sólo necesitamos una descripción y un nombre. La aplicación será la que permitirá a R interaccionar con Twitter mediante [OAuth](https://es.wikipedia.org/wiki/OAuth) y para realizar esta interacción entre la aplicación y nuestra sesión de R es imprescindible:

  * Consumer key
  * Consumer secret
  * Access Token
  * Access Token secret

Para obtener estos 4 elementos una vez creada nuestra aplicación pulsamos el botón **Test OAuth** de la parte superior derecha de la pantalla y nos aparecerán. Y con estos elementos comenzamos a trabajar en R mediante el paquete **twitteR** :

```r
#install.packages("twitteR")
#install.packages("base64enc")
library(twitteR)
library(base64enc)

consumer_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
consumer_secret="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_token="81414758-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_secret="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

setup_twitter_oauth(consumer_key, consumer_secret, access_token=access_token, access_secret=access_secret)
```


Recuerdo, _consumer_key consumer_secret access_token y access_secret_ lo hemos obtenido cuando creamos nuestra aplicación en Twitter que va a interactuar con R mediante OAuth y por ello usamos la función _setup_twitter_oauth_ para que twitteR pueda obtener información de nuestra aplicación. Ya estamos en disposición de leer tweets:

```r
rstats<-searchTwitter("#rstats", n=9999, since='2015-11-01')
datos <- do.call("rbind", lapply(rstats, as.data.frame))
names(datos)
```


La función _searchTwitter_ será la que más uséis cuando trabajéis con R, en este caso buscamos el hashtag #rstats, limitamos la búsqueda a 9999 tweets desde el 01 de noviembre de 2015. Se genera una lista que transformamos en un data.frame mediante la función _do.call_ y ahora es más sencillo trabajar con estos datos (también podemos emplear _twListToDF_) Otro ejemplo, si deseamos ver los tweets del del usuario [@r_vaquerizo](https://twitter.com/r_vaquerizo) hacemos:

```r
vaquerizo <- userTimeline('r_vaquerizo',n=100)
vaquerizo2 <- do.call("rbind", lapply(vaquerizo, as.data.frame))
```


Pero volvamos con #rstats, ya tenemos un data frame y deseamos saber que usuarios son los que más han empleado el hashtag:

```r
usuarios <-subset(datos,isRetweet==FALSE)$screenName
usuarios<-sort(table(usuarios),decreasing=T)
head(usuarios)
usuarios[1:30]
```


El manejo de estos datos es más sencillo, eliminamos los retweet y nos quedamos sólo con los nombres de los usuarios que han escrito el tweet, los tabulamos y ordenamos. Podemos hacer un _head_ para ver los primeros o ver directamente los 30 iniciales. Evidentemente RBloggers está a la cabeza.

A ver si puedo ir poniendo algunas cosas que voy haciendo y si alguien está interesado en algún proyecto concreto que se ponga en contacto conmigo. Saludos.