---
author: rvaquerizo
categories:
  - formación
  - mapas
  - monográficos
  - r
date: '2019-08-12'
lastmod: '2025-07-13'
related:
  - mapas-municipales-de-espana-con-excel-y-qgis.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
  - mapas-con-spatial-data-de-r.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
tags:
  - codigos postales
  - spatial data
  - tmap
  - mapas
title: Mapa de códigos postales con R. Aunque el mapa es lo de menos
url: /blog/mapa-de-codigos-postales-con-r-aunque-el-mapa-es-lo-de-menos/
---

![](/images/2019/08/codigos_postales_navarra.png)

Entrada para facilitar la realización de mapas de códigos postales de España con R. Todo parte del trabajo de [Íñigo Flores](https://github.com/inigoflores/ds-codigos-postales), al que [ya mencionamos en otra entrada](https://analisisydecision.es/archivos-shape-y-geojason-para-crear-un-mapa-de-espana-por-codigos-postales/). Íñigo descargó de Cartociudad y recopiló los objetos *shapefile* para realizar estos gráficos y los subió a su repositorio; están desactualizados, pero pueden ser suficientes para la realización de mapas de códigos postales. 

Íñigo subió en formato `.zip` todos los archivos necesarios provincia a provincia, como lo tenía Cartociudad. Podemos clonarnos el repositorio o leer directamente de `GitHub`; en cualquier caso, necesitamos una función en R que nos permita leer archivos comprimidos en formato `.zip` y, cuando lea el `.zip`, seleccionar que expresamente lea el archivo `.shp` que contiene el *spatial data*.

### Función para la lectura de archivos comprimidos `.zip` con R

```r
library(maptools)

leer.zip <- function(archivozip) {
  zipdir <- tempfile()
  dir.create(zipdir)

  unzip(archivozip, exdir = zipdir)

  archivos <- list.files(zipdir)

  archivo_shp <- archivos[grepl("shp$", archivos)]
  archivo_ruta <- paste(zipdir, archivo_shp, sep = "/")
  readShapeSpatial(archivo_ruta)
}
```

Esta función `leer.zip` permite leer archivos `.zip`, guardarlos en un directorio temporal y, posteriormente, sólo lee aquel archivo extraído que en su nombre contenga la extensión `.shp`. Función interesante que, modificada ligeramente, os permitirá descomprimir cualquier archivo y leer el elemento que deseéis, además de ser un buen ejemplo de uso de `unzip`. En este punto, como comentamos antes, podemos leer directamente de `GitHub` con R.

### Leer archivo `.zip` de `GitHub` con R

```r
url <- 'https://github.com/inigoflores/ds-codigos-postales/raw/master/archive/42605-NAVARRA.zip'

tf <- tempfile(tmpdir = tempdir(), fileext = ".zip")
download.file(url, tf)
navarra <- leer.zip(tf)
```

Creamos un archivo temporal para descargarnos el `.zip`, especificando la extensión. Descargamos de la `URL` correspondiente el archivo con los elementos comprimidos, y el objeto `navarra` será el resultado de la lectura del *shapefile* con los códigos postales de Navarra. La otra forma es clonar el repositorio y acceder directamente al directorio local:

```r
navarra <- leer.zip('C:\\temp\\personales\\wordpress\\ds-codigos-postales-master\\archive\\42605-NAVARRA.zip')
```

Otro de los motivos de esta entrada es mostraros cómo podemos realizar mapas de modo rápido con la librería `tmap`.

### Ejemplo de mapa *quick & dirty* con R

```r
library(tmap)

navarra <- leer.zip('C:\\temp\\personales\\wordpress\\ds-codigos-postales-master\\archive\\42605-NAVARRA.zip')
navarra@data$dato <- rpois(nrow(navarra@data), 2)
qtm(shp = navarra, fill = "dato", fill.palette = "Blues")
```

La función `qtm` se traduce como *Quick thematic plot*, y "quick" es muy "quick". El mejor balance entre rápido y sencillo que hay (bajo mi punto de vista). En el ejemplo se pinta un dato aleatorio, pero podéis hacer un `left_join` con vuestros datos. Y si queremos crear un objeto con cada uno de los elementos que preparó Íñigo, podemos hacer lo siguiente:

### Lectura de archivos y creación de *data frames* mediante un bucle

```r
trabajo <- 'C:/temp/personales/wordpress/ds-codigos-postales-master/archive/'
archivos_lista <- list.files(trabajo)
provincias <- data.frame(archivo = archivos_lista)
provincias$nombre <- substr(provincias$archivo, regexpr("-", provincias$archivo) + 1, nchar(as.character(provincias$archivo)))
provincias$nombre <- gsub('.zip', '', provincias$nombre)

for (i in 1:nrow(provincias)) {
  instruccion <- paste0(provincias$nombre[i], ' <- leer.zip("', trabajo, provincias$archivo[i], '")')
  eval(parse(text = instruccion))
}
```

Código rudimentario que crea un *data frame* a partir de los archivos de un directorio de trabajo; los archivos son los `.zip` que nos clonamos de `GitHub`, y con ellos vamos a crear 52 objetos para cada una de las provincias. El nombre de los archivos es `XXXX-provincia.zip`, por eso tenemos que usar algunas funciones de texto para obtener el nombre de la provincia, como `regexpr`, que nos permite encontrar la primera posición en la que se encuentra un patrón dentro de un texto; por otro lado, `gsub` nos sirve para sustituir un patrón de texto por otro. Así leemos desde el guion y, posteriormente, tenemos que eliminar el `.zip` para tener el nombre de cada provincia.

Y, por último, un clásico en mis programas de R (herencia de los tiempos en los que trabajaba con macros en SAS): tengo que recorrer ese *data frame* con los elementos del directorio, y el nombre del objeto será una columna del *data frame* y el archivo a leer otra columna. Para evaluar un texto, el mítico `eval(parse(text = ...))` nunca me falla; habrá formas más elegantes, pero ésta son dos líneas. Siempre hay que poner talento en la construcción de la instrucción y acordarse de cerrar paréntesis y demás. Ejecutando eso, tendríamos un objeto para cada provincia. Si queremos toda España:

### Creación de un mapa de España por códigos postales

```r
trabajo <- 'C:/temp/personales/wordpress/ds-codigos-postales-master/archive/'
archivos_lista <- list.files(trabajo)
provincias <- data.frame(archivo = archivos_lista)
provincias$nombre <- substr(provincias$archivo, regexpr("-", provincias$archivo) + 1, nchar(as.character(provincias$archivo)))
provincias$nombre <- gsub('.zip', '', provincias$nombre)

for (i in 1:nrow(provincias)) {
  instruccion <- paste0('borrar <- leer.zip("', trabajo, provincias$archivo[i], '")')
  eval(parse(text = instruccion))
  if (i == 1) {
    espania <- borrar
  } else {
    espania <- rbind(espania, borrar)
  }
  remove(borrar)
}

plot(espania)
```

![](/images/2019/08/Espa%C3%B1a_codigos_postales.png)

Otro bucle con la "marca de la casa" pero que funciona perfectamente: leemos uno a uno cada `.zip` con las provincias y con `rbind` podemos unir los objetos *spatial* para poder pintar el mapa de España. Cuidado, que esto genera un objeto de casi 120 MB. Podéis manejar los objetos *spatial data* y así reducir su tamaño.

El caso es que ya sabéis cómo hacer un mapa de España de códigos postales con R; incluso, si sois avezados, podéis guardar el objeto final resultante y utilizarlo con `QGIS` u otra herramienta que uséis para hacer mapas. Además, esta entrada es todo un compendio de malas prácticas en programación con R que funcionan a las mil maravillas: desde leer archivos `.zip` con R y seleccionar el que deseamos hasta funciones de texto para extraer con condiciones, ejemplo de gráfico de mapa rápido con `tmap` y un bucle que lee un *data frame* y genera objetos con él.

### Guardar objeto de R como *shapefile* (`.shp`)

```r
writeSpatialShape(espania, "C:/temp/personales/wordpress/espania.shp")
```

Por último, podemos guardar el objeto resultante de R para usarlo directamente con `QGIS`; se generan todos los archivos necesarios: el `.shp`, el `.dbf`… Saludos.