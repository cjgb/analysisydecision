---
author: rvaquerizo
categories:
  - excel
  - formación
  - r
date: '2020-10-09'
lastmod: '2025-07-13'
related:
  - trucos-simples-para-rstats.md
  - los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
  - porque-me-gusta-r.md
  - macros-sas-dataset-a-data-frame-r.md
  - estadistica-para-cientificos-de-datos-con-r-introduccion.md
tags:
  - sin etiqueta
title: Evita problemas con Excel desde R. De tocar el dato a un proceso
url: /blog/evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso/
---

En estos días hemos vivido una situación con Excel y los datos de COVID de UK peculiar. Hemos aparecido todos en las redes sociales para reírnos de Excel y de los que usan Excel. De nuevo partidarios de Matlab, R, Python,… ¡a la gresca! [Mi opinión la podéis leer en Twitter](https://twitter.com/r_vaquerizo) y creo que sobre este tema puedo opinar. En mi vida profesional me he especializado en cambiar equipos de negocio, por ese motivo tanto ir y venir de compañía. Uno de esos cambios consiste en transformar super usuarios de Excel a usuarios de herramientas más apropiadas para la gestión de la información.

Mi carrera en el sector de la gestión de la información comenzó introduciendo SAS allí donde Business Objects y Access ya eran insuficientes. Continué con SAS durante muchos años, siempre con guiños al software libre porque R me permitía llegar allá donde SAS n€c€sitaba otromódulo. En los últimos años estoy alternando el uso de Python con R. Sin embargo, mis ponencias y mis presentaciones de servicios están incluyendo el siguiente gráfico:

[![](/images/2020/10/Porque_R.png)](/images/2020/10/Porque_R.png)

Soy partidario de SAS, es la mejor herramienta, de SPSS no opino porque no he trabajado lo suficiente (~~¿sigue existiendo Clementine?~~) pero no son gratis, una PYME no puede permitirse un alto gasto en software. Python con sus IDE y Pandas son muy duros para personas acostumbradas a las fórmulas de Excel. Ahí aparece R y sobre todo el **universo tidyverse y RStudio** , es la clave del cambio y lo que debe hacer que todos esos super usuarios de Excel miren hacía R. Por eso se me ocurrió ese dibujo y ahí estoy.

No usemos Excel como motor de BBDD, no toquemos manualmente los datos, empecemos a entender que la gestión de datos no es un buscar objetivo, la gestión de datos es un proceso que, además, puede ser usado por otro y se puede reproducir no es estático. Se trata de evitar fórmulas que solo entiende el autor, programas de Visual Basic que no entiende ni el autor y yo sugiero crear un flujo de este modo: chimpún %>% chimpún %>% chimpún. No es difícil y no se trata de prescindir de Excel, porque a Excel ya irán tus datos preparados, nunca podrás tocar un dato previo ya que pasamos del dato en bruto guardado en una BBDD o repositorio al dato final que si usarás en Excel.

Si soy yo el que te ayuda ese proceso prefiero usar R:

1. Es gratuito, te instalas R y RStudio y los paquetes que necesites.
1. Es sencillo, unas instrucciones te permiten hacer con dplyr el 90% del trabajo que haces en Excel con cientos de fórmulas.

### Un ejemplo práctico, pasando datos de R a Excel

Por último me gustaría ilustrar este trabajo con un ejemplo para poder evaluar la complejidad y como podrías plantear este trabajo, necesitamos leer diariamente [los datos de COVID que publica Datadista](https://github.com/datadista/datasets) para disponer de un Excel con esos datos y pintar nuestro seguimiento, también sería interesante obtener un pequeño resumen que nos permita localizar datos atípicos en la serie que se publica. Vamos a emplear la librería _openxlsx_ para generar un Excel con este propósito. El primer paso será leer los datos de Datadista (incluyen los programas para facilitar la cosa) y crear nuestros objetos en R:

```r
library(dplyr)
library(ggplot2)
library(gridExtra)
library(grid)

data <-
  read.csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/nacional_covid19.csv",
           check.names=FALSE)

colnames(data)[1] = 'fecha'

datafecha <- as.Date(datafecha, "%Y-%m-%d")
dataCasos.nuevos <- c( NA, diff(datacasos_pcr))
dataAltas.nuevas <- c( NA, diff(dataAltas))
dataFallecimientos.nuevos <- c( NA, diff(datafallecimientos))
dataUCI.nuevos <- c(NA, diff(dataingresos_uci))
```

Un ejemplo claro, por algún motivo en Windows el nombre de la variable fecha contiene algún carácter extraño, modifico el nombre con colnames, esta acción queda reflejada en un proceso. Si se producen cambios en los campos de la tabla quedan recogidos en un código que puede ser reproducible por cualquier persona de la organización, podemos (es conveniente) llevar un control de versiones del código por si se produjeran cambios. Las fórmulas empleadas no distan de las que usamos en Excel y si se desconoce que fórmula usar R tiene una comunidad de usuarios por detrás que estarán dispuestos a ayudar, eso no pasa con SAS (por ejemplo).

Continuamos y deseamos realizar un gráfico con los casos nuevos por día para buscar posibles anomalías:

```r
p1 <- ggplot(data,aes(x=fecha,y=Casos.nuevos),na.rm = TRUE) +
  geom_line() +
  geom_smooth() + ggtitle("Casos nuevos") + theme_minimal()

p2 <- ggplot(data,aes(x=fecha,y=Fallecimientos.nuevos),na.rm = TRUE) +
  geom_line() + geom_smooth() + ggtitle("Fallecimientos nuevos") + theme_minimal()

p3 <- ggplot(data,aes(x=fecha,y=UCI.nuevos),na.rm = TRUE) + geom_line() +
  geom_smooth() + ggtitle("UCI nuevos") + theme_minimal()

p <- grid.arrange(p1, p2, p3, ncol=2)
```

Este paso puede ser más duro, hacer gráficos en R ya no es seleccionar datos y tipo de gráfico pero en dos líneas hemos hecho un gráfico, es el mismo para las tres variables que deseamos analizar y deseamos unir todos los gráficos de ggplot en uno lo hacemos con una función que se llama grid.arrange. Esto lo haces una vez, no lo repites siempre y si lo intentas hacer con Visual Basic lo conseguirás pero otro compañero no podrá abrir las macros, a otro no le funciona,… -¿esto quién lo hizo? -¡pero si ya está jubilado!

Ahora lo que hacemos es poner estos datos en un Excel para hacer nuestros resúmenes, nuestro cuadro de mando con tablas dinámicas,… lo que sea para lo que Excel si es una gran herramienta (si, he puesto cuadros de mando). Este código también es más complejo pero siempre es el mismo:

```r
library(openxlsx)

excel <- createWorkbook()
addWorksheet(excel, sheetName = "DatosCOVID")

print(p)
writeDataTable(excel,sheet = "DatosCOVID", x=data)
insertPlot(excel, sheet = "DatosCOVID", startRow = 2, startCol = length(data) + 2, )

saveWorkbook(excel, "C:/temp/datos_covid.xlsx")
remove(excel)
```

[![](/images/2020/10/ejemplo_excel_R.png)](/images/2020/10/ejemplo_excel_R.png)

Creamos un «entorno excel» con createWorkbook al que podemos añadir hojas con addWoksheet y en esas hojas añadimos elementos, una tabla con writeDataTable y un gráfico, que necesitamos imprimir previamente, con insertPlot. Vemos que los datos que publica el Ministerio sobre el Covid tienen anomalías, parece ser que un día concreto resucitaron 1.900 personas, podríamos ir al código y eliminarlo.

Para un usuario de Excel pueden parecer complicadas las fórmulas sin embargo podemos evitar problemas referenciando celdas, modificando celdas, borrando elementos,… Y no es más complejo que una fórmula de Excel.
