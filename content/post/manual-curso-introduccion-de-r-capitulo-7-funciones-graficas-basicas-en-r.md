---
author: rvaquerizo
categories:
- Formación
- R
date: '2008-04-16T08:59:34-05:00'
slug: manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r
tags: []
title: 'Manual. Curso introducción de R. Capítulo 7: Funciones gráficas básicas en
  R'
url: /manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r/
---

R dispone de múltiples posibilidades a la hora de realizar gráficos. De hecho, bajo mi punto de vista, puede ser una de las herramientas estadísticas más potentes al respecto, además es gratuita y existe una comunidad detrás que pone a nuestra disposición múltiples manuales y documentación. Debido al gran material existente este capítulo sólo será una pequeña introducción a sus posibilidades en sucesivas entregas veremos nuevas funciones y nuevos gráficos más aplicados a ejemplos reales.

Como inicio de nuestro ejemplo vamos a crear dos veectores de datos:

```r
> ejex<-c(1,2,3,4,5)

> ejey<-c(2,3,4,5,8)

> plot(ejey,ejex)
```

Generamos un gráfico muy básico de dos ejes. Con ello podremos pintar funciones por ejemplo f(x)=x**3:

```r
> ejex<-seq(-10,10,lenght=20)

> cubo<-function(x)(x**3)

> plot(ejex,(outer=cubo(ejex)),type="l")
```

Con la función _seq_ generamos un vector secuencial de longitud 20 que va desde -10 a 10. Creamos la función _cubo_ que simplemente eleva al cubo un parámetro. Con _plot_ para cada valor de x vemos su valor elevado a 3, con _type=»l»_ indicamos que el gráfico ha de representar líneas. Obtenemos el siguiente gráfico:

![Uso de plot en R](/images/2008/04/grafr1.jpg)

Podemos obtener gráficos en 3 dimensiones:

`> persp(ejex,ejey, outer(ejex,ejey, fun=cubo))`

![Ejemplo de funcion persp en R](/images/2008/04/grafr2.jpg)

Hemos creado un gráfico de 3 dimensiones con la función _persp_ con parámetros, eje x, eje y y función.

Las funciones gráficas más empleadas en R serán:

```r
> datos<-c(1,34,56,5,43,76,6,53,63,12)

> piechart(datos)

> pie(datos)

> hist(datos,nclass=3)

> barplot(datos)

> boxplot(datos)
```

A estos gráficos podemos añadirles títulos, pies, modificarles los colores,… Para descubir todas las posibilidades de cada función recordad que tenéis la ayuda  _?-función-_ Y por supuesto, si tenéis cualquier duda o sugerencia [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)