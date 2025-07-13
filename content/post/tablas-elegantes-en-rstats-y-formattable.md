---
author: rvaquerizo
categories:
- Business Intelligence
- Formación
- R
date: '2020-10-20T11:28:21-05:00'
lastmod: '2025-07-13T16:06:27.472983'
related:
- mi-breve-seguimiento-del-coronavirus-con-r.md
- evolucion-del-numero-de-casos-de-coronavirus.md
- informes-con-r-en-html-comienzo-con-r2html-i.md
- evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
- trucos-simples-para-rstats.md
slug: tablas-elegantes-en-rstats-y-formattable
tags: []
title: 'Tablas elegantes en #rstats y formattable'
url: /tablas-elegantes-en-rstats-y-formattable/
---

Las salidas de la consola de R para muchos de nosotros son más que suficientes. Además en mi caso particular prefiero poner las cosas más elegantes en otras herramientas como Excel, Qlik Sense o Tableau. Pero me he dado cuenta que hay una librería que sí uso cuando directamente copio y pego salidas de R en correos, presentaciones o si empleo markdown (rara vez); esta librería es **formattable** , es posible que haya mejores librerías pero esta es la que yo uso desde hace un par de años.

Vamos a ilustrar algunos ejemplos de uso con un código ya conocido, extraemos la información de casos de COVID de Datadista y vamos a poner una tabla con la evolución de casos, UCI, altas y fallecimientos para el mes de octubre de 2020:

```r
library(tidyverse)
library(formattable)
library(lubridate)

data <- read.csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/nacional_covid19.csv",
         check.names=FALSE)

colnames(data)[1] = 'fecha'

dataFecha <- as.Date(datafecha, "%Y-%m-%d")
data`Casos nuevos` <- c( NA, diff(datacasos_pcr))
data`Altas nuevas`<- c( NA, diff(dataAltas))
data`Fallecimientos nuevos` <- c( NA, diff(datafallecimientos))
data`UCI nuevas` <- c(NA, diff(dataingresos_uci))

data_filtered <- data %>% filter(month(Fecha)==10 & `Casos nuevos`>0) %>%
  select(Fecha, `Casos nuevos`, `Altas nuevas`,  `Fallecimientos nuevos`, `UCI nuevas`)

formattable(data_filtered)
```
 

Y si queremos el HTML:

```r
format_table(data_filtered)
```
  Fecha | Casos nuevos | Altas nuevas | Fallecimientos nuevos | UCI nuevas  
---|---|---|---|---  
2020-10-01 | 9419 | NA | 182 | 88  
2020-10-02 | 11325 | NA | 113 | 59  
2020-10-05 | 23480 | NA | 139 | 83  
2020-10-06 | 11998 | NA | 261 | 71  
2020-10-07 | 10491 | NA | 76 | 49  
2020-10-08 | 12423 | NA | 126 | 102  
2020-10-09 | 12788 | NA | 241 | 90  
2020-10-12 | 27856 | NA | 195 | 85  
2020-10-13 | 7118 | NA | 80 | 38  
2020-10-14 | 11970 | NA | 209 | 80  
2020-10-15 | 13318 | NA | 140 | 73  
2020-10-16 | 15186 | NA | 222 | 86  
2020-10-19 | 37889 | NA | 217 | 147  
  
Copiando y pegando podemos incrustar en html. 

El elemento que más uso cuando hago este tipo de tablas es la inclusión de una barra de color. Esto se hace incluyendo una lista con las características columna a columna, en este caso la columna Altas nuevas solo tiene valores perdidos también la podemos eliminar del reporte:

```r
formattable(data_filtered, digits=2,align = c("r"),
            list(`Casos nuevos`=color_bar('red'),
                 `Altas nuevas`=FALSE,
                 `Fallecimientos nuevos`=color_bar('red'),
                 `UCI nuevas`=color_bar('red')))
```
  Fecha | Casos nuevos | Fallecimientos nuevos | UCI nuevas  
---|---|---|---  
2020-10-01 | 9419 | 182 | 88  
2020-10-02 | 11325 | 113 | 59  
2020-10-05 | 23480 | 139 | 83  
2020-10-06 | 11998 | 261 | 71  
2020-10-07 | 10491 | 76 | 49  
2020-10-08 | 12423 | 126 | 102  
2020-10-09 | 12788 | 241 | 90  
2020-10-12 | 27856 | 195 | 85  
2020-10-13 | 7118 | 80 | 38  
2020-10-14 | 11970 | 209 | 80  
2020-10-15 | 13318 | 140 | 73  
2020-10-16 | 15186 | 222 | 86  
2020-10-19 | 37889 | 217 | 147  
  
Algo que queda muy elegante son las celdas con flechas y colores en el caso de mejorar o empeorar los datos. En ese caso recomiendo crear un formato personalizado, imaginemos que calculamos el número de casos de COVID por día, si supone un incremento o un decremento:

```r
data`Incremento de casos` <- c(NA, diff(data`Casos nuevos`))
data_filtered <- data %>% filter(month(Fecha)==10 & `Casos nuevos`>0) %>%
  select(Fecha, `Casos nuevos`, `Incremento de casos`)

reduccion_formato <- formatter("span",
  style = x ~ style(font.weight = "bold",
  color = ifelse(x < 0, 'green', ifelse(x > 0, 'red', "black"))),
  x ~ icontext(ifelse(x<0, "arrow-up", "arrow-down"), x))

formattable(data_filtered, align = c("r"),
            list(`Casos nuevos`=color_bar('red'),
                 `Incremento de casos`=reduccion_formato) )
```
 

Para el ejemplo solo sacamos casos diarios e incrementos, en el caso que se produzca una reducción podremos una flecha hacia abajo y el color verde como algo positivo. Si se produce un incremento de casos pondremos una flecha roja hacia arriba. El resultado:

Fecha | Casos nuevos | Incremento de casos  
---|---|---  
2020-10-01 | 9419 |   
__  
-1597  
  
2020-10-02 | 11325 |   
__  
1906  
  
2020-10-05 | 23480 |   
__  
12155  
  
2020-10-06 | 11998 |   
__  
-11482  
  
2020-10-07 | 10491 |   
__  
-1507  
  
2020-10-08 | 12423 |   
__  
1932  
  
2020-10-09 | 12788 |   
__  
365  
  
2020-10-12 | 27856 |   
__  
27856  
  
2020-10-13 | 7118 |   
__  
-20738  
  
2020-10-14 | 11970 |   
__  
4852  
  
2020-10-15 | 13318 |   
__  
1348  
  
2020-10-16 | 15186 |   
__  
1868  
  
2020-10-19 | 37889 |   
__  
22703  
  
  
Estaréis pensando, vaya castaña de datos que ha seleccionado para ilustrar los ejemplos, no tienen sentido los fines de semana, no son diarios,… En este caso sólo se está ilustrando un ejemplo de uso, imaginad que hay que pilotar una pandemia con esta información.