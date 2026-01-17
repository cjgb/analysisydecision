---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2019-02-27T08:12:44-05:00'
lastmod: '2025-07-13T16:00:21.403594'
related:
- analisis-de-textos-con-r.md
- beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir.md
- comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
- descubriendo-ggplot2-421.md
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
slug: longitud-de-las-frases-del-quijote-con-rstats
tags: []
title: 'Longitud de las frases del Quijote con #rstats'
url: /blog/longitud-de-las-frases-del-quijote-con-rstats/
---

Siempre he querido hacer cosas con Rstats y el Quijote y ayer se me ocurrió medir la longitud de las frases del Quijote y crear un histograma que describa esta longitud. Aunque confieso que no me lo he leído, me he quedado en el capítulo 7 u 8 (no recuerdo) el caso es que me pareció hipnótico con sus ritmos, es musical. Además tengo muchas ganas de meter mano al proyecto Gutemberg porque esos ritmos, esa musicalidad, el uso de palabras esdrújulas,… me llama la atención.
Bueno, al lío, todo el código está subido al repositorio por si lo queréis, pero hay algunas funciones y algunas ideas que me parecen interesantes.

```r
library(dplyr)
library(ggplot2)
library(plotly)

#Leemos el fichero desde proyecto Gutemberg
ubicacion <- "https://www.gutenberg.org/cache/epub/2000/pg2000.txt"
quijote <- read.table (ubicacion,sep="\r", encoding="UTF-8")
quijote <- data.frame(quijote)
names(quijote) <- 'linea'

#Transformaciones e identificar el inicio del libro.
quijote <- quijote %>%
  mutate(linea = toupper(linea),
         inicio = grepl("EN UN LUGAR DE LA MANCHA",linea)>0)
```


Leemos directamente un txt desde Gutemberg y prefiero transformarlo en data frame para usar dplyr. Todas las palabras las pongo en mayúsculas e identifico donde empieza el Quijote, para evitar prólogos y demás. Ya tengo unos datos con los que poder trabajar:

```r
#Marcamos lo que vamos a leer
desde <- which(quijote$inicio)
hasta <- nrow(quijote)

#Texto de trabajo
texto <- quijote[desde:hasta,1]

#El texto lo transformamos en una lista separada por espacios
texto_split = strsplit(texto, split=" ")

#Deshacemos esa lista y tenemos el data.frame
texto_col = as.character(unlist(texto_split))
texto_col = data.frame(texto_col)
names(texto_col) = 'palabra'
```


En este caso los datos los quiero de tal forma que disponga de un data frame con una sola variable que sea cada palabra del Quijote. Ahora voy a medir las frases identificando donde hay puntos en esas palabras:

```r
#Identificamos donde tenemos puntos y un autonumérico del registro
texto_col <- texto_col %>% filter(!is.na(palabra)) %>%
  mutate(punto = ifelse(grepl('.',palabra,fixed=T),"FIN","NO"),
         posicion = row_number())
```


¿Qué se me ha ocurrido? Trabajar con autonuméricos, tengo identificados los puntos, ahora tengo que fijar una posición inicial y una posición final:

```r
#Si unimos las posiciones con puntos con lag podemos calcular la longitud
pos_puntos1 <- filter(texto_col,punto=="FIN") %>%
  select(posicion) %>% mutate(id = row_number())

pos_puntos2 <- pos_puntos1 %>% mutate(id = id + 1) %>%
  rename(posicion_final = posicion)

pos_puntos <- left_join(pos_puntos1,pos_puntos2) %>%
  mutate(longitud = ifelse(is.na(posicion_final), posicion, posicion - posicion_final))
```


Como no soy un tipo muy brillante opto por una opción sencilla de cruzar una tabla consigo misma, como me ponen los productos cartesianos “con talento”. La idea es seleccionar solo los registros que marcan el final de la frase, un autonumérico me marca cual es cada frase, ahora si hago una left join por el id de la frase y el id + 1 de la frase creo una especie de lag. La longitud de la frase será donde está el punto menos donde estaba el final de la anterior frase. Creo que me he explicado de pena, pero si veis el data frame final lo entenderéis mejor. Ahora ya pinto un histograma:

```r
#GRaficamos la longitud
plot_ly(data = pos_puntos, x = ~longitud, type = "histogram") %>%
  layout(title = "Longitud de las frases del Quijote",
         xaxis = list(title = "Longitud"), yaxis = list(title = ""))
```


Y queda una gamma perfecta, yo diría que hasta bonita. Ahora quedaría identificar los parámetros de esta gamma y compararlos con otros libros, e incluso comparar lenguas. Pero esas tareas se las dejo a los “buenos”.

![](/images/2019/02/frases_quijote_rstats.png)