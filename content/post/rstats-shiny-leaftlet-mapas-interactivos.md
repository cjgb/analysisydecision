---
author: rvaquerizo
categories:
- Gráficos
- Mapas
- R
date: '2021-09-29T09:10:45-05:00'
lastmod: '2025-07-13T16:05:43.922926'
related:
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
- anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie.md
- leaflet-con-r-apuntes-de-mapas-de-coordenadas.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
slug: rstats-shiny-leaftlet-mapas-interactivos
tags:
- leaflet
- shiny
title: Rstats + Shiny + Leaftlet -> Mapas interactivos muy sencillos
url: /blog/rstats-shiny-leaftlet-mapas-interactivos/
---

[![](/images/2021/09/Leaflet_shiny.png)](/images/2021/09/Leaflet_shiny.png)

Entrada en la que os mostraré como hacer un mapa con Leaflet en R que además añadimos a un Shiny para poder filtrar datos de forma interactiva. Ya mostramos en el blog como [crear mapas marcando coordenadas con Leaflet](https://analisisydecision.es/leaflet-con-r-apuntes-de-mapas-de-coordenadas/) y R de forma muy sencilla y hoy damos una vuelta de tuerca a aquella entrada, las coordenadas que deseamos representar tienen además, algún factor por el que hay especial interés en realizar un filtrado del mapa. Para ilustrar el ejemplo nos vamos a ir al [Centro de descargas del Centro Nacional de Información Geográfica](https://centrodedescargas.cnig.es/CentroDescargas/catalogo.do?Serie=CAANE) y nos bajamos del servidor los datos municipales en concreto a Nomenclátor Geográfico de Municipios y Entidades de Población, descargamos el archivo y tenemos un zip que contiene un csv llamado MUNICIPIOS.CSV

El ejercicio va a consistir en lo más simple, marcar los municipios filtrando por provincia, nada más, pero el resultado será un Shiny que podréis aprovechar para sofisticar vuestros mapas. El programa total es:

```r
library(shiny)
library(shinyWidgets)
library(leaflet)

# Importación
ub <- "..\\MUNICIPIOS.csv"
municipios <- read.csv2(ub)

#Siempre tendremos latitud y longitud
municipioslatitud = as.numeric(municipiosLATITUD_ETRS89)
municipioslongitud = as.numeric(municipiosLONGITUD_ETRS89)

# Factores para filtros
filtro1 <- municipios %>% arrange(COD_INE) %>% select(PROVINCIA) %>% unique()

# Shiny

ui <- fluidPage(
  p(),
  titlePanel("Municipios"),
  fluidRow(
    column(width = 1,
           pickerInput("prov", "Seleccionar provincia", filtro1, choices=filtro1 , options = list(`actions-box` = TRUE),multiple = T)),

    mainPanel(leafletOutput("mapa", height = 800))))

server <- function(input, output, session) {

# Definimos los puntos a representar
  puntos <- eventReactive(c(inputprov),  {

        fil <- municipios %>% dplyr::filter(PROVINCIA %in% inputprov)
        cbind(fillongitud, fillatitud)},

        ignoreNULL = FALSE)

# Realizamos el mapa
  outputmapa <- renderLeaflet({
    leaflet() %>%  addTiles() %>%      setView( lng = -3.68444444,
               lat = 40.30861111, zoom = 7) %>%      addProviderTiles(providersCartoDB.Positron)  %>%
      addMarkers(data = puntos())

  })
}

shinyApp(ui, server)
```


Ahora vamos paso a paso.

### Datos de origen

```r
library(shiny)
library(shinyWidgets)
library(leaflet)

# Importación
ub <- "..\\MUNICIPIOS.csv"
municipios <- read.csv2(ub)

#Siempre tendremos latitud y longitud
municipioslatitud = as.numeric(municipiosLATITUD_ETRS89)
municipioslongitud = as.numeric(municipiosLONGITUD_ETRS89)
```


En nuestros datos con las coordenadas siempre tendremos el campo latitud y longitud como numéricos. Básico.

### Creación del filtro

```r
# Factores para filtros
filtro1 <- municipios %>% arrange(COD_INE) %>% select(PROVINCIA) %>% unique()
```


Muy simple, necesitamos los nombres de las provincias en un objeto al que luego llamaremos al crear el filtro, un truco, dad orden.

### Fluid layout

```r
ui <- fluidPage(
  p(),
  titlePanel("Municipios"),
  fluidRow(
    column(width = 1,
           pickerInput("prov", "Seleccionar provincia", filtro1, choices=filtro1 , options = list(`actions-box` = TRUE),multiple = T)),

    mainPanel(leafletOutput("mapa", height = 800))))
```


El formato más sencillo, título, fluidrow y mainPanel. En fluidrow vamos a poner los elementos del panel de la izquierda, a sólo una columna ponemos un pickerInput que es el tipo de filtro que he elegido y que suelo elegir habitualmente cuando puedo tener múltiples selecciones, podéis investigar más los filtros. El resultado de este filtro será nuestro input$prov y necesita datos y elecciones. Buscad documentación sobre pickerInput pero si no queréis complicaros la existencia tal cual. Si queréis añadir más filtros añadid más, en mi caso no complico mucho copiando y pegando. En mainPanel especificamos que tipo de output queremos ver en este caso leafletOutput y el nombre del mapa resultante será mapa, si destaco el uso de height = 800 para ajustarlo mejor en pantalla.

### server

```r
server <- function(input, output, session) {

# Definimos los puntos a representar
  puntos <- eventReactive(c(inputprov),  {

        fil <- municipios %>% dplyr::filter(PROVINCIA %in% inputprov)
        cbind(fillongitud, fillatitud)},

        ignoreNULL = FALSE)

# Realizamos el mapa
  outputmapa <- renderLeaflet({
    leaflet() %>%  addTiles() %>%      setView( lng = -3.68444444,
               lat = 40.30861111, zoom = 7) %>%      addProviderTiles(providersCartoDB.Positron)  %>%
      addMarkers(data = puntos())

  })
}

shinyApp(ui, server)
```


Vemos que _puntos_ será el conjunto de datos para presentar las coordenadas en el mapa, se creará en el momento en el que modifiquemos el filtro, por ello usamos eveReactive, si cambiamos se actualiza el dashboard. Añadimos el código necesario para crear un data frame con el filtrado

```r
filter(PROVINCIA %in% input$prov)
```


y siempre finalizamos con los elementos de nuestros «datos reactivos». El mapa será nuestra salida leaflet y el código es simple ya se vio en el blog y empleamos addMarkers(data=puntos()) que es el conjunto de datos «reactivo» donde tenemos siempre longitud, latitud. Si deseamos añadir más elementos en nuestros datos reactivos lo hacemos en

```r
cbind(fillongitud, fillatitud)
```


prefiero no complicarlo en esta ocasión.

Y el resultado de todo esto es ya le habéis visto. En fin, yo usando Shiny quien me ha visto y quien me ve defendiendo el mundo libre. Subiré el código a git y haré un vídeo porque sobre estos cimientos se pueden hacer maravillas.