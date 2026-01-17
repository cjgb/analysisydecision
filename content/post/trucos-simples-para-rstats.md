---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2019-02-11T06:32:07-05:00'
lastmod: '2025-07-13T16:10:41.932964'
related:
- evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
- analisis-de-textos-con-r.md
- los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
- truco-r-eval-parse-y-paste-para-automatizar-codigo.md
- tablas-elegantes-en-rstats-y-formattable.md
slug: trucos-simples-para-rstats
tags: []
title: 'Trucos simples para #rstats'
url: /blog/trucos-simples-para-rstats/
---

En [mi cuenta de twitter](https://twitter.com/r_vaquerizo) suelo poner algunos trucos sencillos de R, cosas que me surgen cuando estoy trabajando y que no me cuesta compartir en 2 minutos, por si puedo ayudar a alguien. Me acabo de dar cuenta que de verdad son útiles y que tenerlos en twitter desperdigados es un problema, así que he pensado en recopilarlos en una entrada del blog para que sea más sencillo buscarlos (incluso para mi). Aquí van algunos de esos trucos:

Pasar los datos de un _data frame_ al portapapeles, útil cuando quieres mover datos de R a Excel sin complicaciones:

```r
write.table(borra,"clipboard", sep="\t", dec=",", row.names = F)
```


Pasar el nombre de los campos de un _data frame_ al _clipboard_ (hila con el anterior), útil cuando trabajas con un editor de texto o alguna hoja de cálculo para automatizar código:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```


Poner formato 00000 propio códigos postales:

```r
cp <- c(8080,29001)
cp <- sprintf("%05d", cp)
```


El mejor _subset_ para H2O:

```r
df.hex[df.hex$campo > 0,]
```


Texto a fecha en R:

```r
dffecha= as.Date (dffecha, "%d/%m/%Y")
```


Identificar registros repetidos en un _data frame_ , crea un data frame con los registros duplicados en una línea de código de **dplyr** :

```r
repetidos <- df %>% group_by(campo_ID) %>%
 summarise(repetido = n()) %>% filter(repetido>1)
```


Mi preferida y el motivo de la entrada, tramificar una variable cuantitativa en n grupos:

```r
grupos = 10
df <- df %>% arrange(campo) %>%
mutate(campo_tramos= as.factor(ceiling((row_number()/n())*grupos)))
```


Transformar nulos a 0 en 20 caracteres:

```r
df[is.na(df$V1)] <- 0
```


Transformar números separados por coma en formato texto a formato numérico:

```r
dfnumero <- as.numeric(sub(",",".",dftexto))
```


Todos los factores de mi data frame de R a carácter para evitar algún lío, uso de lapply:

```r
df <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)
```


Crear una secuencia de fechas en R y dar formato a la secuencia de fechas en R:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
0

Función para quedarnos sólo los números por los que comienza una cadena de textos de una cadena de textos en R:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
1

Uso de tidyr para extraer de un string sólo los números. Ojo que hay ocasiones en las que es necesario tener talento para hacer esta tarea:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
2

Función para exportar al portapapeles dataframes de mayor tamaño, ideal para mover dataframes a Excel pasando de formato americano a formato europeo:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
3

Secuencia de fechas con R:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
4

Función para quedarnos solo con números dentro de una cadena de textos en R, hay muchas, yo uso esta:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
5

El not in en R:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
6

Permitir a RStudio sacar todas las columnas del data frame:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
7

Reemplaza una variable con un valor nulo a un 0 con el ifelse:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
8

Operar con meses en formato YYYYMM, los típicos de las particiones, un truco que es probable que exista:

```r
write.table(colnames(DF),"clipboard", sep="\t", dec=",", row.names = F)
```
9

Espero que esta entrada pueda seguir creciendo, son tonterías (mis tonterías) y las tengo centralizadas en una sola entrada.