---
author: rvaquerizo
categories:
  - excel
  - formación
  - mapas
  - monográficos
date: '2017-03-23'
lastmod: '2025-07-13'
related:
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - trucos-excel-mapa-de-espana-por-comunidades-autonomas.md
  - mapa-estatico-de-espana-con-python.md
  - mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
  - creando-un-mapa-en-excel-con-archivos-svg.md
tags:
  - qgis
  - mapas
title: Mapas municipales de España con Excel y QGIS
url: /blog/mapas-municipales-de-espana-con-excel-y-qgis/
---

![mapa_españa_municipal7](/images/2017/03/mapa_espa%C3%B1a_municipal7.png)
Un tweet a `@r_vaquerizo` me preguntaba por mapas para representar `datos` a `nivel municipal` en España. Estas cuestiones las suelen plantear porque los mapas en `Excel` que hay publicados en el `blog` están muy extendidos y quieren herramientas similares pero a otro `nivel`, ya sea comarcal, municipal, `código postal`… Hacer estos mapas con `Excel` es muy complicado porque estos mapas no dejan de ser un gran rompecabezas que colocamos en `Excel`. Sin embargo podemos emplear `QGIS` para realizar este tipo de mapas, `QGIS` es libre, tiene muchas posibilidades y ‘comunica’ a la perfección con `Excel` y como ejemplo de ello vamos a realizar un mapa con la `población total` de la provincia de `Zaragoza`. Para esta tarea [el mejor mapa que he encontrado es este](`https://www.arcgis.com/home/item.html?id=2e47bb12686d4b4b9d4c179c75d4eb78`), no tiene restricciones de uso pero sobre todo es muy simple y tiene un campo `código de municipio` que nos permite cruzar a la perfección con los `datos` del `INE`. Comencemos a trabajar.

Descargado el mapa vemos que tenemos 7 archivos que contienen información sobre el mapa, los dejamos en una carpeta y abrimos `QGIS`, aquí creamos un nuevo proyecto y añadimos una `capa vectorial` entonces nos pide seleccionar un archivo a abrir y de ese mapa que nos hemos descargado seleccionamos el archivo `.shp` y obtendremos:

![mapa_españa_municipal1](/images/2017/03/mapa_espa%C3%B1a_municipal1.png)

Tenemos un mapa de `municipios` de toda España pero necesitamos seleccionar `Zaragoza`, sobre el `panel` de `capas` duplicamos esa `capa Municipios ETRS89_30N` y con el `botón derecho` del `ratón` podemos realizar un `filtro`:

![mapa_españa_municipal2](/images/2017/03/mapa_espa%C3%B1a_municipal2.png)

A través de `menús` es muy sencillo realizar la consulta y en este caso nos hemos quedado con la provincia de `Zaragoza`:

![mapa_españa_municipal3](/images/2017/03/mapa_espa%C3%B1a_municipal3.png)

Podemos seleccionar la `capa` que deseamos ver e incluso cambiar el `nombre` para facilitarnos el trabajo. Como ya habréis visto `QGIS` trabaja con `proyectos` no guarda los mapas, considero importante reseñarlo porque es muy cómo a la hora de tener cierto orden con las `librerías` de `mapas`. Tenemos ya la provincia y ahora hay que pintar la [población total para 2016 de la provincia que hemos sacado del `INE`](`http://www.ine.es/jaxiT3/Tabla.htm?t=2907&L=0`). En el ejemplo me he descargado los `datos` en formato `Excel xls` y he realizado un tratamiento a los `datos` porque no tienen un formato adecuado para cruzar `datos`, no entiendo porque es así, pero así es; se eliminan `cabeceras` creamos el `_id_municipio_` como un valor numérico, **aunque lo generéis con fórmulas pegad el valor y que tenga `formato número` para poder realizar el `cruce`** que es un error muy común, ahora tenemos algo así en nuestro `Excel`:

![mapa_españa_municipal4](/images/2017/03/mapa_espa%C3%B1a_municipal4.png)

Ahora añadimos a nuestro proyecto ese nuevo elemento del mismo modo que hemos añadido el `shape` del mapa, `Añadir capa vectorial` y seleccionamos el archivo `Excel` que hemos creado con el `total` de la `población` por `municipio`, podemos cruzar ambas `capas` porque hay un campo que nos lo permite, el `id_municipio`, si pulsamos `botón derecho` sobre esta nueva `capa` con nuestro objeto `Excel` y damos `Abrir tabla de atributos` tenemos que ver esto:

![mapa_españa_municipal4_2](/images/2017/03/mapa_espa%C3%B1a_municipal4_2.png)

Ya estamos en disposición de unir `datos` con `QGIS` esto lo hacemos con `botón derecho` en la `capa Zaragoza` –> `propiedades` –> `Uniones` y rellenamos el `formulario` del siguiente modo:

![mapa_españa_municipal5](/images/2017/03/mapa_espa%C3%B1a_municipal5.png)

Aceptamos y ahora nuestro proyecto tiene unidos dos elementos, para representar la `población` en el mapa pulsamos el `botón derecho` sobre la `capa` que contiene el mapa nos vamos a `Estilo` seleccionamos `graduado` porque es una `variable discreta` y podemos seleccionar el `número` de `clases`, el `tipo` de `clasificación`, la `paleta de colores`,…

![mapa_españa_municipal6](/images/2017/03/mapa_espa%C3%B1a_municipal6.png)

Si seleccionamos `clasificaciones` por `igual intervalo` la provincia de `Zaragoza` está muy sesgada por la capital, así que podemos emplear `intervalos` por `cortes naturales` y tendríamos algo así:

![mapa_españa_municipal7](/images/2017/03/mapa_espa%C3%B1a_municipal7.png)

Ahora nos quedaría mostrar la `leyenda`, pero eso lo dejo para otro día porque la entrada está quedando demasiado larga, en cualquier caso hay mucho escrito sobre ello en la `red`. Espero que haya quedado claro como hacer este `tipo` de gráficos y que haya acercado `QGIS` a más personas. Saludos.