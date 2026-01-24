---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - r
date: '2022-01-01'
lastmod: '2025-07-13'
related:
  - estadistica-para-cientificos-de-datos-con-r-introduccion.md
  - video-introduccion-a-bookdown.md
  - mi-curriculum-con-rmarkdown-y-pagedown.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - el-ano-2010-para-analisisydecision.md
tags:
  - formación
  - libro estadística
  - r
title: Comienza la publicación del ensayo Introducción a la Estadística para Científicos de Datos con R
url: /blog/comienza-la-publicacion-del-ensayo-introduccion-a-la-estadistica-para-cientificos-de-datos/
---

En `Twitter` ya hice mención a la creación de un libro/ensayo de introducción a la `Estadística para científicos de datos con R`. Me preocupaba como compartir el libro y como podría ser útil a alguien que se está introduciendo en la ciencia de datos.

> Estoy escribiendo un libro: `Estadística para científicos de datos con R`.
>
> ¿Lo subo a `git`?
> ¿Lo acabo y hago la web?
> ¿Lo pongo en el blog por entregas?
>
> 🤔
>
> — Raúl Vaquerizo (`@r_vaquerizo`) [December 13, 2021](https://twitter.com/r_vaquerizo/status/1470387760976510981?ref_src=twsrc%5Etfw)

En realidad este trabajo es una ordenación de apuntes, presentaciones y cursos que he ido impartiendo durante mucho tiempo donde `R` es el protagonista. De hecho, sigo en ese proceso y he decidido ir compartiendo ese trabajo a la vez que se está completando. Como se indicaba en [mi cuenta de `Twitter`](https://twitter.com/r_vaquerizo) tenía dudas acerca de como realizar las entregas y al final el ensayo se publicará en `git`, tendrá su web correspondiente y se publicará en el blog.

El libro además de introducir a la estadística básica al científico de datos tiene una visión práctica que pretende introducir al uso de `R` y al **`universo tidyverse`** por este motivo `RStudio`, `rmarkdown`, los `notebooks` y sobre todo `bookdown` tienen gran relevancia. Se asume que el lector del libro tiene cierto conocimiento sobre `R` y el entorno de `RStudio` pero si se desconoce como trabajar con `bookdown` en el blog ya se hizo un [acercamiento a esta forma de publicar mediante `bookdown`](https://analisisydecision.es/video-introduccion-a-bookdown/) que os sugiero visualizar antes de empezar.

## Seguir el libro vía `git`

El libro será un proyecto de `RStudio` que se sube al directorio de `git` [https://github.com/rvaquerizo02/Estadistica-data-scientist](https://github.com/rvaquerizo02/Estadistica-data-scientist) clonáis el repositorio, podéis abrir directamente los `notebooks` desde vuestro `RStudio` y ejecutar vía `knitr-bookdown` por lo que os permite crear vuestros propios apuntes y reutilizar de forma sencilla el código que se emplea. En este sentido recordad que el trabajo se publica mediante una licencia **`Creative Commons`** el libro se puede utilizar libremente pero requiere las correspondientes menciones.

Un aspecto interesante de publicar en `git` es la posibilidad de que me corrigáis. Tened en cuenta que este libro es una ordenación de apuntes, en muchos casos pueden estar incorrectos o directamente incompletos. Un ejemplo, es posible que en el momento que haga mención al `t-test` directamente diga «No lo he usado en mi vida profesional, no tiene utilidad» Se me puede revatir y sugerir ejemplos de uso.

## Disponer directamente del libro

Los libros con `bookdown` se publican en formato HTML y este libro se publicará en la web del blog:

[**`Estadística para Cientificos de Datos`**](https://analisisydecision.es/estadistica-data-scientist/index.html)

También se podrá seguir el libro pero en un formato más estático pero de más fácil lectura.

## Seguir el libro a través del blog

Cada capítulo tendrá su correspondiente entrada en el blog, pero tened en cuenta que lo más actualizado siempre será `git` y el propio libro, es posible que haya una modificación y que ésta tarde en ser puesta en el blog. En este sentido si agradeceré los comentarios que vayáis poniendo en el blog.

Por último, disculpad lo que ponga en el contenido del libro porque habrá temas que puedan parecer relevantes y no aparecerán y habrá aspectos donde el punto de vista de un profesional de la estadística choque con el punto de vista más teórico.
