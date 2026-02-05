---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2019-02-27'
lastmod: '2025-07-13'
related:
  - analisis-de-textos-con-r.md
  - beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir.md
  - comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
  - descubriendo-ggplot2-421.md
  - ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
tags:
  - formación
  - monográficos
  - r
title: Longitud de las frases del `Quijote` con `rstats`
url: /blog/longitud-de-las-frases-del-quijote-con-rstats/
---

Siempre he querido hacer cosas con `rstats` y el `Quijote` y ayer se me ocurrió medir la `longitud` de las frases del `Quijote` y crear un `histograma` que describa esta `longitud`. Aunque confieso que no me lo he leído, me he quedado en el capítulo 7 u 8 (no recuerdo) el caso es que me pareció hipnótico con sus ritmos, es musical. Además tengo muchas ganas de meter mano al `proyecto Gutemberg` porque esos ritmos, esa musicalidad, el uso de palabras esdrújulas,… me llama la atención.
Bueno, al lío, todo el código está subido al `repositorio` por si lo queréis, pero hay algunas funciones y algunas ideas que me parecen interesantes.

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

Leemos directamente un `.txt` desde Proyecto Gutemberg y prefiero transformarlo in `data.frame` para usar `dplyr`. Todas las palabras las pongo in `toupper()` e identifico dónde empieza el «Quijote», para evitar prólogos y demás. Ya tengo unos datos con los que poder trabajar:

```r
# Marcamos lo que vamos a leer
desde <- which(quijote$inicio)
hasta <- nrow(quijote)

# Texto de trabajo
texto <- quijote[desde:hasta, 1]

# El texto lo transformamos in una lista separada por espacios
texto_split <- strsplit(as.character(texto), split = " ")

# Deshacemos esa lista y tenemos el data.frame
texto_col <- as.character(unlist(texto_split))
texto_col <- data.frame(texto_col)
names(texto_col) <- 'palabra'
```

In este caso los datos los quiero de tal forma que disponga de un `data.frame` con una sola variable que sea cada palabra del «Quijote». Ahora voy a medir las frases identificando dónde hay puntos in esas palabras:

```r
# Identificamos dónde tenemos puntos y un autonumérico del registro
texto_col <- texto_col %>%
  filter(!is.na(texto_col)) %>%
  mutate(punto = ifelse(grepl('.', texto_col, fixed = TRUE), "FIN", "NO"),
         posicion = row_number())
```

¿Qué se me ha ocurrido? Trabajar con autonuméricos; tengo identificados los puntos, ahora tengo que fijar una posición inicial y una posición final:

```r
# Si unimos las posiciones con puntos con lag podemos calcular la longitud
pos_puntos1 <- filter(texto_col, punto == "FIN") %>%
  select(posicion) %>%
  mutate(id = row_number())

pos_puntos2 <- pos_puntos1 %>%
  mutate(id = id + 1) %>%
  rename(posicion_final = posicion)

pos_puntos <- left_join(pos_puntos1, pos_puntos2, by = "id") %>%
  mutate(longitud = ifelse(is.na(posicion_final), posicion, posicion - posicion_final))
```

Como no soy un tipo muy brillante, opto por una opción sencilla de cruzar una tabla consigo misma, como me ponen los productos cartesianos «con talento». La idea es seleccionar solo los registros que marcan el final de la frase; un autonumérico me marca cuál es cada frase. Ahora, si hago una `left_join()` por el `id` de la frase y el `id + 1` de la frase, creo una especie de `lag`. La longitud de la frase será dónde está el punto menos dónde estaba el final de la anterior frase. Creo que me he explicado de pena, pero si veis el `data.frame` final lo entenderéis mejor. Ahora ya pinto un histograma:

```r
# Graficamos la longitud
plot_ly(data = pos_puntos, x = ~longitud, type = "histogram") %>%
  layout(title = "Longitud de las frases del Quijote",
         xaxis = list(title = "Longitud"),
         yaxis = list(title = ""))
```

Y queda una Gamma perfecta; yo diría que hasta bonita. Ahora quedaría identificar los parámetros de esta Gamma y compararlos con otros libros e incluso comparar lenguas. Pero esas tareas se las dejo a los «buenos». Saludos.

![frases_quijote_rstats.png](/images/2019/02/frases_quijote_rstats.png)
