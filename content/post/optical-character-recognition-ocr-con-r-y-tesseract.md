---
author: rvaquerizo
categories:
- Formación
- Inteligencia Artificial
- R
date: '2020-06-15T10:07:23-05:00'
lastmod: '2025-07-13T16:04:04.490114'
related:
- r-python-reticulate.md
- analisis-de-textos-con-r.md
- tipos-de-uniones-join-de-tablas-con-python-pandas.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
- capitulo-4-uniones-de-tablas-con-r.md
slug: optical-character-recognition-ocr-con-r-y-tesseract
tags:
- OCR
title: Optical Character Recognition (OCR) con R y tesseract
url: /optical-character-recognition-ocr-con-r-y-tesseract/
---

Una pincelada sobre Optical Character Recognition con R. El paquete tesseract de R permite aplicar el [reconocimiento óptico de caracteres](https://es.wikipedia.org/wiki/Tesseract_OCR) con R de una forma bastante sencilla, es uno de los múltiples líos en los que me estoy metiendo, si llega a buen puerto pondré más. Tenemos esta imagen:

[![](/images/2020/06/prueba_OCR.png)](/images/2020/06/prueba_OCR.png)

Necesitamos tanto el paquete tesseract como el magick y ejecutando en R:

```r
library(tesseract)
library(magick)

img <- image_read("/images/2020/06/prueba_OCR.png")
str(img)
cat(image_ocr(img))
```
 
```r
Tipos de uniones (join) de tablas con Python Pandas

By rvaquerizo | 16/05/2020 | No hay comentarios | Formacién, Monogréticos, Python

Recopilacién de las uniones més habituales con Python Pandas en una sola entrada. No se realiza equivalencias con sal join, la intencién es tener de
‘forma resumida los cédigos para realizar left join inner join y concatenacién de data frames de Pandas. Hay amplia documentacion esto es una
sintesis. Los data frames empleados para ilustrar [..]
```
 

Fácil en principio y parece tener problemas con las tildes. Si llegan a buen puerto mis proyectos iré poniendo algunas posibilidades más. Saludos.