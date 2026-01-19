---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
  - trucos
date: '2022-09-27'
lastmod: '2025-07-13'
related:
  - trucos-sas-envio-de-email-con-data.md
  - trucos-excel-crear-un-borrador-de-correo-con-excel.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
  - mi-curriculum-con-rmarkdown-y-pagedown.md
tags:
  - sin etiqueta
title: Enviar correos electrónicos con rstats. Librería emayili
url: /blog/enviar-correos-electronicos-con-rstats-libreria-emayili/
---

En este trabajo se va a enviar un correo electrónico automático mediante RStats, para ello se empleará la librería de R emayili. Esta librería evita el uso de Java. Además, se adjuntará un archivo Excel a un correo electrónico, ese archivo se genera mediante openxlsx que tampoco requiere Java lo que evita problemas cuando no se tiene bien configurado Java en el entorno de R (por diversos motivos). Para ilustrar el ejemplo se emplea el conocido data frame Iris y se enviarán vía email distintos subconjuntos de ese data frame.

```r
library(emayili)
library(openxlsx)
library(tidyverse)

data("iris")
```

Como se comenta el objetivo es enviar por correo un Excel adjunto que será un subconjunto de Iris.

```r
especie <- 'versicolor'
rds_envio <- iris %>% filter(Species==especie)
```

Ese data frame `rds_envio` es el que debemos adjuntar al correo de forma automática como xlsx, para ello se crea un archivo Excel temporal.

```r
path_xlsx <- tempfile(fileext = paste0("_", especie,".xlsx"))

write.xlsx(rds_envio, path_xlsx)
```

Tiene una limitación, el nombre del archivo temporal ya que precisamente toma un nombre «temporal», una cadena de números al que se le ha añadido la especie a seleccionar. Este aspecto es claramente mejorable. Ahora se va a acompañar al correo de un texto que también es posible paremetrizar.

```r
texto <- paste0("Hola, ", "\n",
                "Te envío las especies ", especie,"\n","\n",
                "Para cualquier duda o sugerencia estoy a tu disposición.")
```

Un texto muy sencillo al que se le añade saltos de línea con «\\n» y la típica frase con la que se finalizan correos. Ahora vía **emayili** se elabora el correo.

```r
email <- emayili::envelope() %>%
  emayili::from("raul.vaquerizo@gmail.com") %>%
  emayili::to("rvaquerizo@analisisydecision.es") %>%
  emayili::subject(paste0("CORREO DE PRUEBA. Especies filtradas ",especie)) %>%
  emayili::attachment(path_xlsx) %>%
  emayili::text(texto)

file.remove(path_xlsx)
```

La función envelope crea el mensaje que tiene un from, un to, el subject donde ponemos el texto que también podemos parametrizar y con attachment llamamos a ese path_xlsx temporal donde se ha creado el Excel a adjuntar al correo. Por último, se pone el texto que acompaña al correo con la función text. Ya está diseñado el correo ahora queda establecer los parámetros para conectar R al servidor de correo y enviar el email.

```r
smtp <- server(
  host = "smtp.gmail.com",
  port = 465,
  username = "raul.vaquerizo@gmail.com",
  password = "******"
)
```

En el objeto smtp se meten los elementos necesarios para conectar la sesión de R al **servidor smtp de correo** , se hace con la función server. En host se pone el servidor smtp, puerto, usuario y clave con la que se conecta el usuario en este caso a gmail. Si se emplea Outlook con ir a la ayuda de Outlook y buscar el término smtp se conoceran los parámetros. Ahora sólo es necesario enviar el correo con la función smtp.

```r
smtp(email, verbose = TRUE)
```

Con verbose = TRUE podemos ver toda la traza de conexión al servidor de correo y de envío del email.

## Pasos necesarios para enviar correos con R desde Google Gmail

Es necesario seguir los pasos indicados [en esta web para poder conectar nuestro correo](https://datawookie.dev/blog/2022/03/updated-gmail-authentication/ "conectar nuestro correo"). Necesitamos activar la doble autenticación y obtener la contraseña para la aplicación correo en el entorno en el que deseemos.

[![](/images/2022/09/wp_editor_md_10811b495eb218c87fe1e283dc210090.jpg)](/images/2022/09/wp_editor_md_10811b495eb218c87fe1e283dc210090.jpg)

Gracias a [Jose Luis Cañadas ](https://muestrear-no-es-pecado.netlify.app/ "Jose Luis Cañadas ") por el apunte.

## Enviar HTML en los correos automáticos con R

Es posible que se desee enviar una tabla dentro del mismo correo, enviar gráficos, bien dar formatos a nuestros envíos o elaborar correos más visuales. Esta labor se va a realizar con HTML incrustado en el cuerpo del correo, para ello se empleará la librería R2HTML.

```r
library(R2HTML)

rds_envio2 <- iris %>% filter(Species==especie & Sepal.Length>=6.5)

a <- ggplot(data=rds_envio, aes(x=Sepal.Length)) + geom_histogram()
ggsave('./grafico.png', a)
```

En el correo se va a añadir una tabla con datos que es un subconjunto y un histograma que previamente hemos guardado. Ahora es necesario dar forma a ese HTML, en este caso se crea un archivo temporal y se van añadiendo elementos con las funciones de R2HTML. [En este link tenéis ejemplos de uso de R2HTML](https://analisisydecision.es/informes-con-r-en-html-comienzo-con-r2html-i/)

```r
salida <- HTMLInitFile(outdir = tempdir(), filename="index", extension="html",
HTMLframe=FALSE, BackGroundColor = "FFFFFF", BackGroundImg = "",
Title = "Correo", useLaTeX=TRUE, useGrid=TRUE)

HTML("<div align=center>")
HTML("<p>Estos son los seleccionados</p>")
HTML(rds_envio2, file=salida)
HTML("<p align=center>La distribución es:</p>")
HTML("<img src='c:\\temp\\grafico.png'></img>")
HTML("<p>Cualquier duda o sugerencia...</p>")
HTML("</div>")

HTMLEndFile()
```

El correo va a ser feo de solemnidad pero se puede añadir el código HTML que deseemos. Ahora ya se está en disposición de elaborar el correo como se ha hecho con anterioridad pero añadiendo el html generado.

```r
email <- envelope() %>%
  from("raul.vaquerizo@gmail.com") %>%
  to("rvaquerizo@analisisydecision.es") %>%
  subject(paste0("CORREO DE PRUEBA 2. Trabajo con HTML ")) %>%
  html(salida)
```

En este punto se siguen los pasos anteriores y se puede enviar el email que previamente hemos automatizado, configurado o parametrizado desde R.
