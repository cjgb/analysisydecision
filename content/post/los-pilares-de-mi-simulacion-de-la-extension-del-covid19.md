---
author: rvaquerizo
categories:
- Monográficos
- Opinión
- R
date: '2020-03-23T09:48:20-05:00'
lastmod: '2025-07-13T16:00:30.963528'
related:
- mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
- mi-breve-seguimiento-del-coronavirus-con-r.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
slug: los-pilares-de-mi-simulacion-de-la-extension-del-covid19
tags: []
title: Los pilares de mi simulación de la extensión del COVID19
url: /blog/los-pilares-de-mi-simulacion-de-la-extension-del-covid19/
---

No debería publicar esta simulación de la extensión del CODVID10 o coronavirus porque puede disparar alarmas, provocar insultos, levantar ampollas,… el caso es que yo llevo 7 días de aislamiento más que el resto de España porque sólo había que ver los datos de Italia para saber lo que iba a pasar y no avisé a nadie para no disparar alarmas, provocar insultos, levantar ampollas… Y AL FINAL YO TENÍA RAZÓN. Así que os voy a exponer el motivo por el cual estoy muy asustado, bueno, hoy quiero mostraros el inicio de una simulación mala y sin fundamento que estoy realizando sobre la extensión en España del COVID19. Para hacerla vamos a emplear la siguiente información:

  * [Datos del padrón municipal](https://www.ine.es/censos2011_datos/cen11_datos_resultados_seccen.htm)
  * [Datos de la cartografía digital por sección censal](https://analisisydecision.es/cartografia-digitalizada-de-espana-por-seccion-censal/)

Y allá voy a comentaros que estoy montando. Se trata de poner a los 47 millones de españoles en una tabla, situarlos en unas coordenadas y dadas 5 personas iniciales ver como se propaga el virus municipio a municipio y, en 98 días, determinar cuantas personas pueden estar contagiadas, cuantas enfermas, cuantas sanas o cuantas desgraciadamente muertas. Esto no es que tenga lagunas, es que está inventado, pero no os creáis que las cifras oficiales son más fiables. Evidentemente, lo voy a hacer con R y dplyr. No lo subo a git porque el equipo que uso tiene un usuario de github que no es el adecuado, pero ya sabéis que el código está a vuestra disposición.

### Creación de la tabla de personas edad

```r
library(tidyverse)
library(pxR)
library(sqldf)

#detach("package:dplyr", unload=TRUE)

censo = "C:\\temp\\personales\\covid19\\0001.px"
datos <-  read.px(censo)
datos <- datos$DATA[[1]]
names(datos) = c("rango_edad", 'seccion', 'sexo', 'habitantes' )
datos <- data.frame(lapply(datos, as.character), stringsAsFactors=FALSE)

muestra <- datos %>% mutate(habitantes=round(as.numeric(habitantes)/10,0)) %>%
  filter(seccion != "TOTAL" & sexo == "Ambos Sexos" & rango_edad != "Total") %>% select(-sexo) %>%
  mutate(rango_edad = case_when(
    rango_edad %in% c('0-4', '5-9', '10-14', '15-19', '20-24') ~ '<25',
    rango_edad %in% c('80-84', '85-89', '90-94', '95-99', '100 y más') ~ '80 >',
    TRUE ~rango_edad  ))

muestra <- muestra %>% group_by(seccion,rango_edad) %>% summarise(habitantes=sum(habitantes))

espania <- muestra %>% group_by(seccion,rango_edad) %>% expand(count = seq(1:habitantes)) %>% as_tibble()
```


_Nota: si no funciona la creación de la muestra hacéis detach de dplyr_

Leemos los datos del censo que nos hemos descargado del INE, es un fichero px pero con el paquete pxR podemos manejarlo. Los datos que tenemos están a nivel de sección censal, rangos de edad, sexo y disponemos del número de habitantes. Con esta tabla de frecuencias generamos con expand una tabla que repite un registro tantas veces como digamos en una variable, es decir, repetirá la edad, el sexo, la sección censal tantas veces como habitantes tenga. Manejo una muestra del 10% porque el tema tiene un tiempo importante de procesamiento. Con esto también hago un llamamiento por si Amazon, Microsoft o Google pueden poner buenas máquinas en manos de los gestores de información (mal llamados científicos de datos ahora) de forma altruista. En fin, tenemos a todos los españoles, ahora vamos a ubicarlos con la cartografía por sección censal del INE.

### Creación de la tabla de centroides municipal

```r
library(maptools)
library(sf)
ub_shp = "C:\\temp\\mapas\\Seccion_censal\\SECC_CPV_E_20111101_01_R_INE.shp"
seccion_censal = readShapeSpatial(ub_shp)

mapa <- map_data(seccion_censal)

centroides <- mapa %>% group_by(OBJECTID = as.numeric(region)) %>%
  summarise(centro_long=mean(long), centro_lat=mean(lat))

ggplot(data = centroides, aes(x = centro_long, y = centro_lat, group = 1)) +
  geom_polygon()

secciones <- seccion_censal@data %>% mutate(seccion=as.character(CUSEC), municipio=as.character(CUMUN)) %>%
  select(OBJECTID,seccion,municipio)

municipios <- left_join(secciones,centroides) %>% group_by(municipio) %>%
  summarise(centro_long=mean(long), centro_lat=mean(lat)) %>%
  select(municipio, centro_long, centro_lat)

#Matriz de distancias
distancias <- sqldf(" select a.municipio, b.municipio as municipio2,
                    a.centro_long, a.centro_lat, b.centro_long as centro_long2, b.centro_lat as centro_lat2
                    from municipios a , municipios b where a.municipio != b.municipio")

distancias <- distancias %>% mutate(distancia=sqrt((centro_long - centro_long2)**2 + (centro_lat-centro_lat2)**2))
```


Os habéis desgarcado el shapefile con las secciones censales de España y con ella calculamos el centroide de cada municipio, también he calculado una matriz de distancias porque, como veréis más adelante, la distancia de desplazamiento puede ser interesante para determinar como se mueve y como se expande el virus. En este punto está mi otra de mis reclamaciones, las compañías de telefonía podían ofrecer datos de movilidad para ayudarnos y controlar el movimiento de personas.

> Aquellas personas cuyo teléfono móvil haya estado conectando con la antena próxima a su hogar y en el estado de alarma haya empezado a posicionar cerca de su segunda vivienda MULTA.
>
> Yo los inflaba a ostias pero la multa será más práctica
>
> — Raul Vaquerizo (@r_vaquerizo) [March 21, 2020](https://twitter.com/r_vaquerizo/status/1241478062300172288?ref_src=twsrc%5Etfw)

En fin, si cruzáis ambas tablas empieza la simulación (de mierda):

```r
#Proceso
indices <- sample( 1:nrow( espania ), nrow(espania)/2)
espania2 <- espania[indices,]
espania2 <- espania2 %>% left_join(secciones) %>%
  mutate(id_persona=row_number(),
         dia=0,contagiado=0, evolucion_dias=0)

sanos = espania2
contagiados = espania2[0,]
enfermos = espania2[0,]
curados = espania2[0,]
muertos = espania2[0,]

#Dia 1
#5 contagiados
dia <- sample_n(filter(espania2,seccion %in% c('2807908161','0810205003')) , 5)
contagiados <- inner_join(dia, select(sanos,id_persona)) %>%
  mutate(contagiado=1)
lista_contagiados = unique(contagiados$id_persona)
sanos <- sanos %>% filter(id_persona %notin% lista_contagiados)

max_distancia =max(distancias$distancia,na.rm = T)
```


Tenemos una tabla con la población española por edad y ubicación, son 5 personas al azar de Igualada y Madrid las que empiezan todo… Veré si me atrevo a seguir contando porque lo que sigue me lo he inventado completamente.