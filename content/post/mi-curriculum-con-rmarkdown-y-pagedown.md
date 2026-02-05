---
author: rvaquerizo
categories:
  - consultoría
  - formación
  - r
date: '2020-12-21'
lastmod: '2025-07-13'
related:
  - comienza-la-publicacion-del-ensayo-introduccion-a-la-estadistica-para-cientificos-de-datos.md
  - estadistica-para-cientificos-de-datos-con-r-introduccion.md
  - ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - de-estadistico-a-minero-de-datos-a-cientifico-de-datos.md
tags:
  - markdown
  - rmardown
title: Mi curriculum con RMarkdown y pagedown
url: /blog/mi-curriculum-con-rmarkdown-y-pagedown/
---

![](/images/2020/12/CV_R2.png)

Me he puesto a actualizar mi currículum y a la vez estoy aprendiendo `markdown`; en ese proceso, [José Luis Cañadas](https://twitter.com/joscani) me dijo: «usa `pagedown`». No era yo fan de `RMarkdown`, pero me estoy reconvirtiendo. Me está pasando con `markdown` algo parecido a lo que me pasó con el picante: no me gustaba hasta que lo probé y, desde entonces, me encanta.

¿Por qué lo probé? Porque había decidido tomarme un tiempo sabático para elaborar una serie de cursos, *webinars* y actualizar la web, que son 12 años sin modificaciones. **Tras tres meses sabáticos estoy harto de no trabajar**: son 25 años seguidos trabajando, 20 gestionando datos y otros 5 en los que hice de todo (hasta servir en la Armada). No soy capaz de estar sin trabajar; el primer paso es elaborar un resumen de mi vida profesional y dar un nuevo formato, porque llevo con el mismo unos 12 años.

A la vez que estoy elaborando el `CV` estoy conociendo otras posibilidades de `markdown`; espero compartir en el blog esos conocimientos adquiridos. Lo primero es disponer de R, `RStudio`, instalar `rmarkdown`, `pagedown`… no es complicado sobre todo si trabajas con `Windows 10`. Ya lo tienes y, a la vez que te has instalado los paquetes, dispones de una serie de *templates*. Ahora haces en `RStudio`: **File > New File > R Markdown...**

![](/images/2020/12/CV_R1.png)

Seleccionas **HTML Resume** y, desde ese momento, dispones de un `markdown` que te permite elaborar tu `CV` a partir de ese boceto. Pero yo te voy a contar qué es cada elemento del `markdown` y te voy a sugerir algunos trucos.

## YAML

Vamos a definir esta parte como el elemento que define nuestro documento. Será con lo que comencemos y en mi `CV` es:

```yaml
---
title: "Raúl Vaquerizo"
author: rvaquerizo
date: "`r Sys.Date()`"
output:
  pagedown::html_resume:
    self_contained: true
---
```

En esta parte no pongáis caracteres especiales ni os vengáis arriba: es mero descriptivo. Aspectos importantes: `pagedown::html_resume` para especificar el *template* y `self_contained: true` para que el `HTML` generado tenga todos los elementos necesarios para imprimirse o compartirse.

## Marco derecho (Aside)

El marco derecho te lo define la sección `Aside`:

```markdown
Aside
================================================================================

![foto](https://ruta/a/mi/foto.png)

### Contacto {#contact}

- <i class="fa fa-envelope"></i> raul.vaquerizo@gmail.com
- <i class="fa fa-github"></i> github.com/rvaquerizo
- <i class="fab fa-linkedin-in"></i> LinkedIn
- <i class="fa fa-phone"></i> +34 656XXXXXX

### Capacidades {#skills}

- **Transformar datos en información**. 
- Experiencia en modelización estadística y `machine learning`.
- Experiencia en software comercial (`Emblem`, `Radar`) y libre (R, `Python`).
```

Un truco: para emplear iconos que no estén en el *template*, podéis ir a la [web de Font Awesome](https://fontawesome.com/icons?d=gallery) y saber cómo referenciar a los existentes. La forma en la que se referencian iconos es mediante la clase de la etiqueta `<i>`.

## Sección principal (Main)

En la sección `Main` podemos resumir nuestra vida profesional, empezando por el título:

```markdown
Main
================================================================================

Raúl Vaquerizo {#title}
--------------------------------------------------------------------------------

### Actualmente Data Scientist consultor/formador
```

Es lo primero que se va a ver, así que pones lo que más te interese: en mi caso, montar equipos, la automatización de procesos, modelización y migrar a entornos colaborativos. Luego pasamos a los apartados comunes. Cada sección dentro del apartado irá marcada con `###`:

```markdown
Educación {data-icon=graduation-cap data-concise=true}
--------------------------------------------------------------------------------

### Universidad Complutense de Madrid
Diplomado en Estadística
Madrid, España
2001
```

Tras `###` ponemos el título y luego siempre el mismo orden: subtítulo, ubicación, fecha y luego descripciones en párrafos. Un bloque especial es `::: concise`, que permite poner varias características en un espacio reducido.

```markdown
Experiencia Profesional {data-icon=suitcase}
--------------------------------------------------------------------------------

### Actuario
Mutua Madrileña
Madrid, España
2017

::: concise
- Tarifa de nueva producción Negocio de Autos.
- Creación de tablas de modelización `SQL Server/SAS`.
- Elaboración de modelos de riesgo en `Emblem`.
:::
```

El resultado del `CV` lo tenéis en estos enlaces:

- `HTML`: [CV Raúl Vaquerizo](/images/2020/12/CV2.html)
- `PDF`: [CV Raúl Vaquerizo](/images/2020/12/Raul_Vaquerizo.pdf)
- `Código Markdown`: [CV Raúl Vaquerizo](/images/2020/12/CV2.Rmd)

Espero seguir con más píldoras de `markdown`, como el currículum en modo póster y la automatización de `PowerPoint`. Saludos.