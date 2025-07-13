---
author: rvaquerizo
categories:
- Consultoría
- Formación
- R
date: '2017-10-09T07:58:14-05:00'
lastmod: '2025-07-13T16:04:55.439491'
related:
- de-estadistico-a-minero-de-datos-a-cientifico-de-datos.md
- twitter-con-r-el-hashtag-rstats.md
- ayd-2300-visitas-mensuales.md
- contenidos-para-octubre-de-ayd.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-9-analisis-exploratorio-de-datos-eda.md
slug: puede-la-informacion-de-twitter-servir-para-tarificar-seguros
tags:
- twitter
title: ¿Puede la información de Twitter servir para calcular el precio de tu seguro?
url: /puede-la-informacion-de-twitter-servir-para-tarificar-seguros/
---

[![rvaquerizo](/images/2017/10/rvaquerizo.png)](/images/2017/10/rvaquerizo.png)

Debemos de ir introduciendo el concepto de **Social Pricing** en el sector asegurador, si recordamos el año pasado [Admirall y Facebook tuvieron un tira y afloja](https://www.theguardian.com/money/2016/nov/02/facebook-admiral-car-insurance-privacy-data) por el uso de la información de Facebook para el ajuste de primas de riesgo. Facebook alegaba a la sección 3.15 de su privacidad para no permitir emplear esta información a Admirall. Probablemente es un tema más económico. El caso es que tanto Facebook, como Instagram, como Twitter, como LinkedIn, como xVideos,… tienen información muy interesante acerca de nosotros, información que se puede emplear para el cálculo de primas en el sector asegurador (por ejemplo). No voy a decir como hacer esto, este blog no es el lugar, el que quiera conocer mis ideas que se ponga en contacto conmigo. Yo soy alguien “público”, no tengo problema en dejar mis redes sociales abiertas y este caso me sirve de ejemplo para analizar que dice Twitter de mí y también sirve de ejemplo para refrescar el manejo de información con Twitter con #rstats. Esta entrada es una combinación de entradas anteriores de esta bitácora así que [recordemos como empezábamos a hacer scrapping de Twitter](https://analisisydecision.es/twitter-con-r-el-hashtag-rstats/):

[sourcecode lang=»R»]  
library(twitteR)  
library(base64enc)

consumer_key="XXXXXXXXXxxxxXXXXXXXxx"  
consumer_secret="xxXXXXXXXXxxXXXXXXXXXxxXXxxxxx"  
access_token="81414758-XXxXxxxx"  
access_secret="XXXxXXxXXxxxxx"

setup_twitter_oauth(consumer_key, consumer_secret, access_token=access_token, access_secret=access_secret)  
[/sourcecode]

Vía Oauth ya podemos trabajar con el paquete twitteR desde nuestra sesión de R y ahora lo que vamos a crear es un objeto R del tipo “user” con la información que tiene el [usuario r_vaquerizo](https://twitter.com/r_vaquerizo) (yo mismo):

[sourcecode lang=»R»]  
rvaquerizo <\- getUser(‘r_vaquerizo’)  
rvaquerizo_seguidos <\- rvaquerizo$getFriends(retryOnRateLimit=120)  
seguidos <\- do.call("rbind", lapply(rvaquerizo_seguidos, as.data.frame))  
[/sourcecode]

El objeto rvaquerizo tiene mucha información sobre mí

, pero nos interesan los usuarios que sigo y para ello se emplea el método getFriends con el que creamos un data frame. Ahora vamos a seleccionar las descripciones de los usuarios de Twitter a los que sigo, el campo descrition tiene esa información. Ahora ya podemos trabajar con las palabras que describen a mis seguidores con [un código que será familiar a los seguidores más antiguos](https://analisisydecision.es/analisis-del-discurso-de-navidad-del-rey-de-espana-2013/):

[sourcecode lang=»R»]  
#La lista la transformamos en un texto  
texto <\- toString(seguidosdescription)  
#El texto lo transformamos en una lista separada por espacios  
texto_split = strsplit(texto, split=" ")  
#Deshacemos esa lista y tenemos el data.frame  
texto_col = as.character(unlist(texto_split))  
texto_col = data.frame(toupper(texto_col))  
names(texto_col) = c("V1")  
#Eliminamos algunos caracteres regulares  
texto_colV1 = gsub("([[:space:]])","",texto_colV1)  
texto_colV1 = gsub("([[:digit:]])","",texto_colV1)  
texto_colV1 = gsub("([[:punct:]])","",texto_colV1)  
#Creamos una variable longitud de la palabra  
texto_collargo = nchar(texto_colV1)  
#Quitamos palabras cortas texto_col = subset(texto_col,largo>4&largo<=10)  
[/sourcecode]

Ahora sólo queda pintar las palabras que describen a los usuarios que sigo:

[sourcecode lang=»R»]  
install.packages(‘wordcloud’)  
library(wordcloud)  
library(RColorBrewer)  
pesos = data.frame(table(texto_colV1))

#Paleta de colores  
pal = brewer.pal(6,"RdYlGn")

#Realizamos el gráfico  
png(‘C:\\\temp\\\rvaquerizo.png’, width=500, height=500)  
wordcloud(pesosVar1,pesosFreq,scale=c(4,.2),min.freq=2,  
max.words=Inf, random.order=FALSE,colors=pal,rot.per=.15)

dev.off()  
[/sourcecode]

Analytics es el término más repetido, aparecen Big Data, scientist,… ¿describen esos términos a un buen conductor o a alguien que cuida mucho su hogar? Yo sé la repuesta pero sería necesario realizar un análisis con mayor número de expuestos. ¿Alguien se atreve a hacerlo?

Por cierto, yo quiero ser el Data Scientist de xVideos, como se tiene que reir.