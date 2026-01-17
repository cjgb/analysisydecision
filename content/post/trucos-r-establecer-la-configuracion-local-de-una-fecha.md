---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-09-02T08:10:28-05:00'
lastmod: '2025-07-13T16:09:34.669482'
related:
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- trucos-excel-tranformar-un-caracter-a-fecha.md
- trucos-sas-pasar-de-caracter-a-numerico-y-viceversa.md
- truco-sas-transformar-variable-caracter-a-fecha.md
slug: trucos-r-establecer-la-configuracion-local-de-una-fecha
tags: []
title: Trucos R. Establecer la configuración local de una fecha
url: /blog/trucos-r-establecer-la-configuracion-local-de-una-fecha/
---

Cuando manejamos datos las fechas nos producen muchos quebraderos de cabeza, por ejemplo cuando tenemos que **transformar un caracter a fecha**. En mi opinión R es una de las herramientas las flexibles y rápidas para trabajar con fechas, claro que acostumbrado a SAS cualquier otra herramienta me parece perfecta. A lo que vamos, imaginemos la siguiente situación :

```r
?as.Date

x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")

z <- as.Date(x, "%d%b%Y")

z

[1] NA NA "1960-03-31" "1960-07-30"
```

Se trata de transformar un texto a fecha en R. El formato del texto es d mes en inglés año con 4 cifras. Para transformar a fecha tenemos la función _as.Date_ que recibe como parámetros el objeto y el formato de la fecha, el más habitual sería %d/%m/%Y 10/09/1976. Para meses en formato nombre empleamos %b pero en este caso «1jan1960» nos produce un valor perdido sin embargo «31mar1960» si se transforma correctamente ¿Por qué motivo sucede esto?

```r
Sys.setlocale("LC_TIME")

[1] "Spanish_Spain.1252"
```

Nuestra configuración de fecha es spanish, luego january no es reconocido por R, tendremos que hacer:

```r
x <- c("1ene1960", "2ene1960", "31mar1960", "30jul1960")

z <- as.Date(x, "%d%b%Y")

z

[1] "1960-01-01" "1960-01-02" "1960-03-31" "1960-07-30"
```

Ya funciona correctamente. Si deseamos modificar nuestra configuración tendremos que hacer lo siguiente:

```r
Sys.setlocale("LC_TIME", "English")

x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")

z <- as.Date(x, "%d%b%Y")

z
```

Ya tenemos los datos como deseábamos. Muy sencillo y fácil de recordar. Saludos.