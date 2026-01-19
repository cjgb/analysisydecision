---
author: rvaquerizo
categories:
  - formación
  - r
date: '2020-03-11'
lastmod: '2025-07-13'
related:
  - mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
  - seguir-los-datos-del-coronavirus-en-espana-con-rstats.md
  - mi-breve-seguimiento-del-coronavirus-con-r.md
tags:
  - sin etiqueta
title: Seguimiento del coronavirus en España por Comunidad Autónoma. Extraer información de un PDF con R
url: /blog/seguimiento-del-coronavirus-en-espana-por-comunidad-autonoma-extraer-informacion-de-un-pdf-con-r/
---

Una entrada anterior del blog ha dado lugar a una conversación interesante en twitter:

> Evolución del número de casos de [#coronavirusEspana](https://twitter.com/hashtag/coronavirusEspana?src=hash&ref_src=twsrc%5Etfw) una analogía con Italia <https://t.co/GhWtlFL3Df>
>
> — Raul Vaquerizo (@r_vaquerizo) [March 11, 2020](https://twitter.com/r_vaquerizo/status/1237643443687632896?ref_src=twsrc%5Etfw)

Es necesario obtener los datos del Ministerio y estos datos se hayan en un pdf (<https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov-China/documentos/Actualizacion_41_COVID-19.pdf>) Bien, tendremos que leer el pdf y crear un data frame para poder trabajar con estos datos. Para leer el pdf vamos a emplear el paquete de R tabulizer y la función extract_table pero necesitamos «algo de talento».

La función extract_tables nos permite extraer información de un archivo pdf con R pero es necesario especificar la página que deseamos leer (fácil) y el área que deseamos leer. ¿El área de la hoja del pdf que deseamos leer? ¿Eso qué es? Pues ese es el «talento» que necesitamos, con la función locale_areas vamos a encontrar ese área. Veamos el código necesario:

```r
library(tidyverse)
library(tabulizer)

ministerio = "https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov-China/documentos/Actualizacion_41_COVID-19.pdf"

area <- locate_areas(ministerio, pages = 2)
```

Al ejecutar ese código podemos seleccionar a mano alzada el área que deseamos seleccionar de la página específica del pdf:

[![](/images/2020/03/coronavirus4.png)](/images/2020/03/coronavirus4.png)

Ya estamos en disposición de ver el área a leer:

```r
area[[1]]
```

Un poco complicado, pero una vez sabemos el área crear un objeto con R que contenga la información actualizada por Comunidad Autónoma de los datos del coronavirus en España con R es así de sencillo:

```r
pdf_lista <- extract_tables(
  ministerio,
  output = "data.frame",
  pages = c(2),
  area = list(
    c(337.89431,  90.69972, 684.23597, 510.25186)
  ),
  guess = FALSE,
  encoding = "UTF-8"
)

datos <- data.frame(pdf_lista[1])
```

Ahora ya tenéis los datos por Comunidad Autónoma actualizados, solo queda que alguien los tabule por día y haga representaciones gráficas. Ahora a esperar que el Ministerio no cambie el pdf. Mañana haremos algo con ellos.
