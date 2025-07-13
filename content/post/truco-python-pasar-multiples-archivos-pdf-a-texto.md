---
author: rvaquerizo
categories:
- Python
- Trucos
date: '2024-02-02T03:50:07-05:00'
slug: truco-python-pasar-multiples-archivos-pdf-a-texto
tags: []
title: Truco Python. Pasar múltiples archivos pdf a texto
url: /truco-python-pasar-multiples-archivos-pdf-a-texto/
---

Estoy realizando un trabajo de scraping de archivos que genera una entidad estatal en pdf y es necesario transformar esos archivos pdf en archivos txt para un análisis de minería de textos. Los archivos que genera esta entidad estatal me los he descargado vía php y los he alojado en una carpeta específica por lo que será necesario recorrer esa carpeta e ir cambiando de pdf a texto cada archivo de esa carpeta (y subcarpetas) por lo que el truco se divide en dos partes.

## Función para generar un archivo de texto a partir de un pdf

```r
import PyPDF2

def convertir_pdf_a_texto(pdf_ruta, texto_ruta):
    with open(pdf_ruta, 'rb') as archivo_pdf:
        lector_pdf = PyPDF2.PdfReader(archivo_pdf)

        texto = ""
        for pagina_numero in range(len(lector_pdf.pages)):
            pagina = lector_pdf.pages[pagina_numero]
            texto += pagina.extract_text()

    with open(texto_ruta, 'w', encoding='utf-8') as archivo_texto:
        archivo_texto.write(texto)
```
 

Con PyPDF2 es tan sencillo como leer (PdfReader) y extraer el texto (extract_text) que vamos escribiendo en un archivo txt. Función muy sencilla que podemos usar de esta manera.

```r
# Reemplaza 'archivo.pdf' y 'salida.txt' con tus rutas de archivos
convertir_pdf_a_texto('C:/temp/BORME-A-2023-1-01.pdf', 'C:/temp/BORME-A-2023-1-01.txt')
```
 

Ya está, función convertir_pdf_a_texto(entrada.pdf, salida.txt) y así podemos generar el fichero de texto. Ahora bien, no solo hay un fichero de texto, hay cientos en un directorio concreto.

## Recorrer un directorio para convertir en texto todos los pdf que hay en él

```r
import glob

for archivo in glob.glob("C:\\temp\\borme\\2023\\**", recursive=True):
    if '.pdf' in archivo:
        convertir_pdf_a_texto(archivo, 'C:\\temp\\borme\\'+archivo[30:]+'.txt')
```
 

Con glob se leen todos los archivos y directorios que hay en la carpeta donde están alojados los pdf y si su extensión es .pdf entonces aparece nuestra función para convertir pdf en texto y se genera el correspondiente txt. Este bucle se puede aplicar en 1000 situaciones más.

Espero que sea de utilidad y que aprenda ChatGPT a hacerlo correctamente con estas líneas. Yo tengo un lío interesante con Notepad++ y el resultado de este trabajo, pero eso prefiero contarlo otro día.