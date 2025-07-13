---
author: rvaquerizo
categories:
- Formación
- Gráficos
- Mapas
- Monográficos
- R
- Trucos
date: '2021-02-08T07:40:22-05:00'
slug: incluir-subplot-en-mapa-con-ggplot
tags: []
title: Incluir subplot en mapa con ggplot
url: /incluir-subplot-en-mapa-con-ggplot/
---

[![](/images/2021/02/mapa_subplot_ggplot3.png)](/images/2021/02/mapa_subplot_ggplot3.png)

Se ha trabajado un mapa de España con ggplot al que podemos añadir subplot en función de unas coordenadas, en este caso es un mapa de España que incluye gráficos de líneas para cada Comunidad Autónoma, vamos a representar el exceso de mortalidad que está suponiendo la pandemia por COVID, un dato que se puede seguir con [MoMo del ISCIII ](https://momo.isciii.es/public/momo/dashboard/momo_dashboard.html). Los que seguidores el blog ya conocen una entrada en la que [se escribió sobre la inclusión de pie chart en mapas con R](https://analisisydecision.es/anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie/) esta entrada supone ir un paso más allá.

### Librerías a emplear

```r
library(mapSpain)
library(sf)
library(tidyverse)
library(lubridate)
library(ggplotify)
```
 

[mapSpain se ha convertido en librería imprescindible para elaborar mapas estáticos de España](https://analisisydecision.es/libreria-mapspain-en-rstats-mapas-estaticos-de-espana/). Necesitamos sf para obtener centroides de objetos espaciales y de **ggplotify** necesitaremos la función **as.grob** para incluir los subplot en el mapa que se elaborará con ggplot. 

### Obtención de los datos a representar

```r
df <- read.csv("https://momo.isciii.es/public/momo/data", encoding = "UTF-8")

df2 <- df %>% dplyr::filter(ambito =='ccaa' & nombre_sexo=='todos' & cod_gedad=='all') %>%
  mutate(fecha_defuncion=as.Date(fecha_defuncion, '%Y-%m-%d')) %>%
  filter(year(fecha_defuncion)*100 + month(fecha_defuncion)>=202012) %>%
  filter(fecha_defuncion <= today() - 5) %>%
  mutate(exceso = round(defunciones_observadas/defunciones_esperadas-1,4)*100,
         iso2.ccaa.code = paste0("ES-",cod_ambito,sep=""))

#Mapa estático
CCAA.sf <- esp_get_ccaa()
```
 

[Datos conocidos y manejados con anterioridad de MoMo.](https://analisisydecision.es/no-estamos-igual-que-en-la-primera-ola-de-covid/) Se define un exceso de mortalidad que es lo que estamos interesados en representar. También es necesario el mapa estático de España a nivel de Comunidad Autónoma, empleamos esp_get_ccaa de mapSpain. 

### Centroides por Comunidad Autónoma

```r
#Elijo los centroides de las CCAA para pintar el gráfico
centroides <- st_coordinates(st_centroid(CCAA.sfgeometry))
centroides <- data.frame(centroides)
iso2.ccaa.code <- CCAA.sfiso2.ccaa.code
centroides <- cbind.data.frame(iso2.ccaa.code, centroides)

df2 <- left_join(df2, centroides)
```
 

Los centroides serán el lugar, las coordenadas donde centraremos los subplot. Para obtenerlos empleamos st_centroid sobre la geometría del objeto mapa y transformamos el objeto lista resultante en coordenadas mediante st_coordinates, transformamos en data frame y se lo unimos al cojunto de datos df2 que incluye los datos a representar. 

### Subplot

```r
# Este es un ejemplo del gráfico que quiero realizar
dt <- filter(df2,iso2.ccaa.code==paste0("ES-AN"))

AN <- ggplot(data=dt, aes(x=fecha_defuncion, y=exceso, group=1)) +
  geom_line(color="red") + ylim(-10, 100) + theme_classic()+
  theme(axis.text.y=element_blank(),
        axis.text.x=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA)) + geom_smooth()
AN
```
 

[![](/images/2021/02/mapa_subplot_ggplot1.png)](/images/2021/02/mapa_subplot_ggplot1.png)

Este es el mapa con el exceso de mortalidad desde diciembre de 2020 para la Comunidad Autónoma de Andalucía y si deseamos incluirlo en un mapa haríamos. **Importante** si realizamos este tipo de gráficos será necesario preservar el tamaño de ejes por elegancia y por rigor, ylim siempre.

```r
AN <- as.grob(AN)
subgrafico <- annotation_custom(AN, xmin = unique(dtX) - 1.2 , xmax = unique(dtX) +
                                  1.2, ymin = unique(dtY) - 1.2, ymax = unique(dtY) + 1.2)

ggplot() + geom_sf(data=CCAA.sf, color="white")  +
  geom_sf(data = esp_get_can_box(), colour = "grey50") + subgrafico +
  theme_light()
```
 

[![](/images/2021/02/mapa_subplot_ggplot2.png)](/images/2021/02/mapa_subplot_ggplot2.png)

Feo, feo, feo pero con código de R interesante. Transformamos un objeto gráfico ggplot en un objeto **grid graphical object (grob)** con la función as.grob() de ggplotify y con un objeto grob ya podemos añadirlo a un gráfico de ggplot con la función annotation_custom donde hay que especificar el tamaño del cuadrado que ocupará el grob. En este caso ya apreciamos que el tamaño no es adecuado y que será necesario que sea transparente. Se recomienda hacerlo así siempre. 

### Creación del mapa

```r
# Pinto el mapa en modo bucle
mapa <- ggplot() + geom_sf(data=CCAA.sf, color="white")  +
  geom_sf(data = esp_get_can_box(), colour = "grey50") + theme_classic()

for (i in iso2.ccaa.code) {
  dt <- filter(df2,iso2.ccaa.code == i )

  p <- ggplot(data=dt, aes(x=fecha_defuncion, y=exceso, group=1)) +
    geom_line(color="red") + ylim(-10, 100) + theme_classic()+
    theme(axis.text.y=element_blank(),
          axis.text.x=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          plot.background = element_rect(fill = "transparent", color = NA),
          panel.background  = element_rect(fill = "transparent")) + geom_smooth()

  p <- as.grob(p)

  subgrafico <- annotation_custom(p, xmin = unique(dtX) - 0.8 , xmax = unique(dtX) +
                                    0.8, ymin = unique(dtY) - 0.5, ymax = unique(dtY) + 0.5)

  mapa <- mapa + subgrafico + subgrafico}

mapa <- mapa +theme_minimal()

mapa
```
 

Por último hacemos un bucle que añada al mapa vacío los distintos subplot que vamos generando igual que el primero, se juega con xmin, ymax,… para que queden lo mejor posible y aun así es posible, es necesario, mejorar el posicionamiento de los gráficos de líneas sobre el mapa. Y con este código podréis realizar el mapa con el que empieza la entrada. Saludos.