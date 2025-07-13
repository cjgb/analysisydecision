---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2013-04-23T10:55:06-05:00'
slug: mosaic-plot-con-r
tags: []
title: Mosaic plot con R
url: /mosaic-plot-con-r/
---

![](/images/2013/04/mosaic-plot-R.png)

Los gráficos de mosaico (mosaic plot) me gustan cada vez más. Hoy quería confesaros una cosa, no me gustan los gráficos. Sé que en esta bitácora electrónica hay muchos ejemplos de gráficos y muchos trucos referente a ellos. Pero siempre prefiero un dato representado en una tabla. Después de esta confesión voy a rebatirme a mí mismo. Es muy complicado ver algo en una tabla de contingencia cuando tenemos 3 o cuatro dimensiones. Sin embargo con un mosaic plot como el que tenemos arriba somos capaces de estudiar cruces de frecuencia para 3-4 dimensiones. Para hacerlo empleamos R, en concreto el [paquete vcd](http://cran.r-project.org/web/packages/vcd/index.html). Para ilustrar el ejemplo con datos nos vamos a la web de un [conocido libro para el uso de GLM en seguros](http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data). No entramos en muchos detalles, el código es muy simple, si tengo ocasión lo complicaré:

```r
library(vcd)

sini = read.csv("http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/claimslong.csv")

tabla = ftable(siniagecat, sinivaluecat, sini$period,

dnn = c("Edad", "Valor", "Antiguedad"))

tabla

mosaic( ~Edad+Valor+Antiguedad, data=tabla)
```

En este caso pintamos un objeto _ftable_. Podríamos pintar directamente los datos o un objeto _table_ , esto es importante porque podemos cocinar nuestros datos directamente con SAS, Excel, WPS,… y pasarlos a R para realizar el gráfico de mosaico. Seguramente conocíais este tipo de gráficos, pero el ahora escribiente no y se ha quedado prendado de ellos.