---
author: rvaquerizo
categories:
- Consultoría
- Formación
- R
date: '2020-12-21T03:30:26-05:00'
lastmod: '2025-07-13T16:02:28.336457'
related:
- comienza-la-publicacion-del-ensayo-introduccion-a-la-estadistica-para-cientificos-de-datos.md
- estadistica-para-cientificos-de-datos-con-r-introduccion.md
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
- evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
- de-estadistico-a-minero-de-datos-a-cientifico-de-datos.md
slug: mi-curriculum-con-rmarkdown-y-pagedown
tags:
- markdown
- rmardown
title: Mi curriculum con RMarkdown y pagedown
url: /blog/mi-curriculum-con-rmarkdown-y-pagedown/
---

[![](/images/2020/12/CV_R2.png)](/images/2020/12/CV_R2.png)

Me he puesto a actualizar mi curriculum y a la vez estoy aprendiendo markdown y en ese proceso [Jose Luis Cañadas](https://twitter.com/joscani) me dijo «usa pagedown». No era yo fan de Rmarkdown, pero me estoy reconvirtiendo. Me está pasando con markdown algo parecido a lo que me pasó con el picante, no me gustaba hasta que lo probé y desde entonces me encanta. ¿Por qué lo probé? Porque había decidido tomarme un tiempo sabático para elaborar una serie de cursos, webminar y actualizar la web que son 12 años sin modificaciones. **Tras 3 meses sabáticos estoy harto de no trabajar** , son 25 años seguidos trabajando, 20 gestionando datos, y otros 5 en los que hice de todo (hasta servir en la Armada). No soy capaz de estar sin trabajar, el primer paso es elaborar un resumen de mi vida profesional y dar un nuevo formato porque llevo con el mismo unos 12 años.

A la vez que estoy elaborando el curriculum estoy conociendo otras posibilidades de markdown espero compartir en el blog esos conocimientos adquiridos. Lo primero es disponer de R, RStudio, instalar rmardown, pagedown,… no es complicado sobre todo si trabajas con Windows 10, ¡R funciona muy bien en Win10! Ya lo tienes y a la vez que te has instalado los paquetes te has instalado una serie de _templates_. Ahora haces en RStudio File -> New File -> R Markdown y…

[![](/images/2020/12/CV_R1.png)](/images/2020/12/CV_R1.png)

HTML Resume y desde ese momento dispones de un markdown que te permite elaborar tu CV a partir de ese boceto. Pero yo te voy a contar que es cada elemento del markdown y te voy a sugerir algunos trucos. Empecemos:

## YAML

Vamos a definir esta parte como el elemento que define nuestro documento. Será con lo que comencemos y en mi CV es:

```r
---
title: "Raúl Vaquerizo"
author: rvaquerizo
date: "`r Sys.Date()`"
output:
  pagedown::html_resume:
    self_contained: true
---
```


En esta parte no pongáis caracteres especiales ni os vengáis arriba, mero descriptivo. Aspectos importantes pagedown::html_resume para especificar el template y self_contained: true para que el HTML generado tenga todos los elementos necesarios para imprimirse.

Ahora, si os fijáis en el CV, hay un marco derecho donde salgo yo bien guapo (tiene un par de años la foto), mis datos de contacto, un resumen de mis principales características y un disclaimer:

## Marco derecho

El marco te lo define la «sección aparte» Aside:

```r
Aside
================================================================================
```

```r
Contacto {#contact}
--------------------------------------------------------------------------------

- <i class="fa fa-envelope"></i> raul.vaquerizo@gmail.com
- <i class="fa fa-github"></i> [github.com](https://github.com/analisisydecision)
- <i class="fab fa-linkedin-in"></i> [Linkedin](https://www.linkedin.com/in/rvaquerizo/)
- <i class="fa fa-phone"></i> +34 656555555
- <i class="fab fa-blogger-b"></i>  [AnalisisyDecision](www.analisisydecision.es)
- Puede contactar por cualquiera de las vías.

Capacidades {#skills}
--------------------------------------------------------------------------------

* **Transformar datos en información**. Mejora de ingresos / reducción de costes.

* Experiencia en modelización estadística y _machine learning_.

* Experiencia en software comercial (SAS, Emblem, Radar) y software libre (R, Python).

* Automatización de procesos.

Disclaimer {#disclaimer}
--------------------------------------------------------------------------------

This resume was made with the R package [**pagedown**](https://github.com/rstudio/pagedown).

Actualizado `r Sys.Date()`.
```


Otro truco, para emplear iconos que no estén en el template podéis ir a la [web fontawesome ](https://fontawesome.com/icons?d=gallery) y descargar un icono o saber como referenciar a los existentes. No soy un experto pero la forma en la que se referencian iconos pero en class es fa- Fonts Awesome xx- tipo de icono y xxx nombre. Te lo puedes descargar e incrustarlo, en mi caso no tengo la suficiente paciencia y por ese motivo referencio al blog con el logo de blogger. No he modificado los apartados que aparecen en el template y respeto el disclaimer de pagedown ya que estoy usando ese elemento.

## Curriculum

En la sección Main:

```r
Main
================================================================================
```


Podemos resumir nuestra vida profesional, empezando por el título:

```r
Raúl Vaquerizo {#title}
--------------------------------------------------------------------------------
### Actualmente Data Scientist consultor/formador
```


Es lo primero que se va a ver (**title**) así que pones lo que más te interese, en mi caso montar equipos, la automatización de procesos manuales, modelización y migrar a entornos colaborativos. Así que ya sabéis si tenéis proyectos al respecto me dáis un toque. Luego pasamos a los apartados más comunes en un CV. En este caso empiezo por mi formación donde me he extendido para que la experiencia docente quede en la primera página, es donde quiero insistir mas, y termino con mi experiencia profesional. Cada uno de los apartados tienen la forma:

```r
Experiencia docente {data-icon=chalkboard-teacher}
--------------------------------------------------------------------------------
```


Título del apartado, icono empleado y líneas de separación. Cada sección dentro del apartado irá marcada con ###:

```r
### Universidad Complutense de Madrid

Diplomado en Estadística

Madrid, España

2001
```


Quien me iba a decir que me diplomaría en estadística mientras hacía rollos de tela asfáltica. Tras ### ponemos el título y luego siempre el mismo orden. Título, subtítulo, ubicación, fecha_superior – fecha_inferior para que haga la línea de tiempo y luego descripciones en párrafos. Una bloque especial es ::: concise que nos permite poner varias características en un espacio reducido y que me ha gustado mucho.

```r
### Actuario

Mutua Madrileña.

Madrid, España

2017

::: concise
- Tarifa de nueva producción Negocio de Autos.
- Creación de tablas de modelización SQL Server/SAS.
- Elaboración de modelos de riesgo, conversión y anulación Emblem/Radar.
- Modelos de segmentación geográfica de siniestralidad.
- Puesta en producción y pilotaje de tarifa.
- **Mejora nueva producción sin incremento siniestral**.
:::
```


No lo he comentado pero podemos emplear markdown en cualquier parte, en este caso poniendo letras en negrita. Y el resultado del CV lo tenéis en estos link siguiente link:

HTML: [CV Raúl Vaquerizo](/images/2020/12/CV2.html)
PDF: [CV Raúl Vaquerizo](/images/2020/12/Raul_Vaquerizo.pdf)
Código Markdown: [CV Raúl Vaquerizo](/images/2020/12/CV2.Rmd)

Espero seguir con más píldoras de markdown como el curriculum en modo poster y la automatización de Powerpoint. Saludos.