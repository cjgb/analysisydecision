---
author: rvaquerizo
categories:
  - consultoría
  - fútbol
  - gráficos
  - r
date: '2023-08-28'
lastmod: '2025-07-13'
related:
  - datos-de-eventing-gratuitos-en-statsbomb.md
  - resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
  - los-porteros-del-espanyol-y-la-regresion-binomial-negativa.md
  - minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido.md
  - incluir-subplot-en-mapa-con-ggplot.md
tags:
  - sin etiqueta
title: 'Pintando campos de fútbol con #rstats y entendiendo funciones de densidad'
url: /blog/pintando-campos-de-futbol-con-rstats-y-entendiendo-funciones-de-densidad/
---

La librería de rstats ggsoccer permite representar campos de fútbol con un código bastante sencillo, a continuación se plantean una serie de ejemplos para empezar a ilustrar su uso y quiero que me de pie a escribir sobre la función de densidad de una variable, pero empezamos por el principio instalar el paquete y empezar a usar.

```r
# install.packages("remotes")
# remotes::install_github("torvaney/ggsoccer")
library(tidyverse)
library(ggsoccer)

# Lo pintamos en el campo
ggplot() +
  annotate_pitch() +
  ggtitle("Campo sin nada") +
  theme_pitch()
```

El código habla por si solo, muy sencillo a ggplot añadimos annotate_pitch() y theme_pitch(). Ahora sería necesario añadir información a este terreno de juego y para ello [recuperamos una entrada anterior donde podíamos disponer de datos de eventing de Statsbomb](https://analisisydecision.es/datos-de-eventing-gratuitos-en-statsbomb/) que nos van a permitir pintar mapas de calor o _heatmaps_ si nos molamos.

```r
messi_data <- readRDS('./data/messi_data.rds')
```

Ojo que no tenéis en el repositorio ese conjunto de datos, no lo he subido porque son más de 200 MB. Os lo habéis tenido que crear previamente con el código antes linkado y guardado en data, veo venir las preguntas porque si no das al botón y sale son todo problemas. Entonces, si por ejemplo deseamos ver por donde jugaba Jordi Alba en esas temporadas en las que jugó Messi en la Liga tendríamos que hacer:

```r
alba <- messi_data %>% filter(player.name=='Jordi Alba Ramos')

ubicacion <- alba$location
ubicacion <- do.call(rbind.data.frame, ubicacion)
remove(alba)
names(ubicacion)<- c('x','y')

# Lo pintamos en el campo
ubicacion %>%
  ggplot(aes(x=x, y=y) ) +
  annotate_pitch() +
  geom_bin2d(binwidth = c(2, 2), alpha=0.7) +
  scale_fill_gradient2(low="blue", high = "red") +
  ggtitle("Zona de juego de Jordi Alba") +
  theme_pitch()
```

[![](/images/2023/08/wp_editor_md_95442a2273c54d1584af2fd121c8f575.jpg)](/images/2023/08/wp_editor_md_95442a2273c54d1584af2fd121c8f575.jpg)

Además de los warning de R empezamos a encontrarnos otros warning con el resultado, _tenemos problemas de base con las coordenadas_. La librería ggsoccer tiene una base de coordenadas y Statsbomb tiene otras, además, hasta donde yo sé, Jordi Alba juega por la izquierda y no por la derecha por lo que es necesario cambiar la base si queremos que las coordenadas queden bien y que la dirección del campo sea de izquierda a derecha. Y para ello tenemos que conocer la base de Statsbomb y puede ayudar el punto de penalty:

```r
penalties <- messi_data %>% sample_frac(0.1) %>% filter(shot.type.name=='Penalty') %>%
  select(location)
```

El punto de penalty lo sitúa Statsbomb en el (108,40) con lo cual el campo es (119,80) y las coordenadas van de derecha a izquierda. En este caso ggsoccer asume 100,80 y va de izquierda a derecha por lo que es necesario el cambio de base para la coordenada x mientras que la coordenada y tenemos que hacer que vaya de izquierda a derecha (por lo menos yo lo prefiero así).

```r
# Los rangos van distintos. Cambiamos de base
ubicacionx = ubicacionx/(119/100)
ubicaciony = 100-ubicaciony/(80/100)

ggplot(ubicacion, aes(x=x, y=y) ) +
  annotate_pitch(fill = "#3ab54a") +
  geom_bin2d(binwidth = c(1, 1), alpha=0.3) +
  scale_fill_gradient2(low="blue", high = "red") +
  ggtitle("Zona de juego de Jordi Alba") +
  theme_pitch() +
  theme(panel.background = element_rect(fill = "#55B605")) +
  direction_label(x_label = 50)
```

[![](/images/2023/08/wp_editor_md_20230ada43144d74a583199d415337f6.jpg)](/images/2023/08/wp_editor_md_20230ada43144d74a583199d415337f6.jpg)

Ya es un _heatmap_ con mejor pinta aunque muy mejorable y se parece a lo que estamos esperando de Jordi Alba y es que es recomendable conocer como se mueve un jugador a la hora de usar ggsoccer para ajustar bien las bases. Sé que exite la función to_statsbomb en ggsoccer pero prefiero que se entienda la problemática de la base. Con direction_label añadimos la dirección de juego, pero nos lo especifica en inglés. Para editar una función en un paquete de R existente podemos hacer:

```r
trace(direction_label, edit=TRUE)
```

He cambiado label por «Direccion de juego» y he salvado la función, a partir de ahora lo pondrá en español.

[![](/images/2023/08/wp_editor_md_04884e0d1364d4b3edbf9dcc0ef651ce.jpg)](/images/2023/08/wp_editor_md_04884e0d1364d4b3edbf9dcc0ef651ce.jpg)

Podemos seguir mejorando el headmap de juego con funciones como stat_density_2d que sirve para mejorar esas densidades bivariables. En este caso se aplica por duplicado, una para hacer contornos y otra para hacer establecer las «zonas rojas». Además podemos eliminar leyendas, mejorar títulos,…

```r
ggplot(ubicacion, aes(x=x, y=y) ) +
  annotate_pitch(fill = "#3ab54a", colour = "white") +
  stat_density_2d(color='blue', alpha=0.5) +
  stat_density_2d(geom = "raster",
  aes(fill = after_stat(density)),
  contour = FALSE, alpha=0.5)+
  scale_fill_gradient2(low="blue", high = "red") +
  ggtitle("Zona de juego de Jordi Alba") +
  theme_pitch() +
  theme(panel.background = element_rect(fill = "#55B605"),
        legend.position='none',
        plot.title=element_text(size=20)) +
  direction_label(x_label = 50)
```

[![](/images/2023/08/wp_editor_md_41809f6d882ece7efb84ec2b7502b990.jpg)](/images/2023/08/wp_editor_md_41809f6d882ece7efb84ec2b7502b990.jpg)

El gráfico es raro pero yo quería saber en que lugares entra en contacto con la pelota y donde lo hace en mayor medida. Además, recomendar no poner caracteres especiales en las funciones (dirección lleva tilde). En este punto todos entendemos que las zonas más rojas es donde Jordi Alba tocaba más el balón en el Barcelona, es donde encontramos más observaciones, y es que los mapas de calor son gráficos de densidad bivariable (x,y), es decir, conocer como se distribuye las zonas de toque de un jugador dados 2 puntos y podemos ver esos puntos x e y de forma univariable:

```r
ubicacion %>% ggplot(aes(x=x)) + geom_density()
ubicacion %>% ggplot(aes(x=y)) + geom_density()
```

[![](/images/2023/08/wp_editor_md_e91f62174b203fcec982b77b0695ae43.jpg)](/images/2023/08/wp_editor_md_e91f62174b203fcec982b77b0695ae43.jpg)

[![](/images/2023/08/wp_editor_md_4f73260cbdfc87da772f616a279e4482.jpg)](/images/2023/08/wp_editor_md_4f73260cbdfc87da772f616a279e4482.jpg)

La coordenada x hace referencia a la zona de juego y se aprecia que Jordi Alba toca más en las zonas centrales, si bien es cierto, que el gráfico tiene cierta asimetría hacia la derecha, toca más el balón en campo rival. La otra coordenada y hace referencia a la posición de juego, Jordi Alba juega por la izquierda, por las coordenadas más altas por eso su distribución de juego es claramente asimétrica hacia la derecha, hacia los valores más altos de y porque siempre juega a la derecha. Y sin querer empezamos a entender que es la función de densidad de una variable, en realidad son todos los valores de la ubicación donde toca Jordi Alba pero ese número de toques se incrementa si es a la izquierda del terreno de juego y si es en la zona central del campo, pero estamos más seguros de que lo toca a la izquierda porque solo aparecen valores altos de y que de tocar el balón en la zona central ya que esa función de densidad no tiene picos tan pronunciados.

¿Tiene sentido estudiar solamente los heatmap? Bueno, un sólo eje también puede aportarnos información (o no). Si planteamos una hipótesis del tipo: ¿Se modifica la posición de juego de Jordi Alba durante el partido? Añadamos al código anterior el minuto de juego.

```r
alba <- messi_data %>% filter(player.name=='Jordi Alba Ramos')

ubicacion <- alba %>% select(location, minute) %>%
  filter(location != "NULL")

coordenadas <- do.call(rbind.data.frame, ubicacionlocation)
names(coordenadas)<- c('x','y')

ubicacionx <- coordenadasx; ubicaciony<-coordenadas$y
remove(coordenadas, alba)
```

Ahora tenemos un objeto que además de la ubicación tiene los minutos. Se puede ver como se extrae el vector del data frame y se le añade posteriormente evitando aquellos casos donde no hay vector, para que se pueda hacer el macheo correctamente. A continuación se propone una animación con los sucesivos gráficos de densidad para buscar diferencias o algún tipo de patrón entre ellos.

```r
library(gganimate)
library(transformr )

ubicacion <- ubicacion %>% mutate(minute=ifelse(minute>=90, 90, minute),
  rango_minutos = ceiling(minute/5)*5) %>%
  filter(rango_minutos>=5)

d <- ubicacion %>%
  ggplot(aes(x=x, fill=factor(rango_minutos))) +
  geom_density(alpha=0.9) +
  coord_cartesian(ylim=c(0, 0.02), xlim=c(0, 102)) +
  theme(legend.position='none')

d + transition_time(rango_minutos)

anim_save("animacion1.gif")
```

[![](/images/2023/08/animacion1.gif)](/images/2023/08/animacion1.gif)

Los minutos de juego se han tramificado de 5 en 5 minutos para realizar en menos tiempo la animación. Y no parece que esté diciendo mucho, cada vez que toca el balón, recordamos que son datos de eventing y éstos solo hacen referencia al momento en el que el jugador entra en juego y Jordi lo suele hacer más de medio campo hacia arriba pero parece que no suele bascular a lo largo del partido, algo que dice mucho de su físico.

Un comentario, es necesario llamar a la librería transformr para que funcione correctamente `transition_time` sino aparecerá un error. A partir de aquí esto es claramente mejorable pero sois vosotros los que tenéis que empezar a distinguir por resultado, temporada, alineación, esquema,…
