---
author: rvaquerizo
categories:
- Formación
- Monográficos
- Python
date: '2017-12-25T17:10:42-05:00'
lastmod: '2025-07-13T15:54:27.920460'
related:
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
- los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
- leer-y-representar-datos-de-google-trends-con-r.md
- analisis-de-textos-con-r.md
- el-ano-2010-para-analisisydecision.md
slug: beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir
tags:
- Beatifulsoup
- web scraping
title: Beatifulsoup. Web scraping con Python o como las redes sociales pueden estar
  cambiando la forma de escribir
url: /blog/beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir/
---

[![Boxplot_BeatifulShop](/images/2017/12/Boxplot_BeatifulShop.png)](/images/2017/12/Boxplot_BeatifulShop.png)

Desde hace tiempo mis frases son más cortas. Creo que es un problema de las redes sociales, sobre todo twitter, que está cambiando mi comportamiento. Para analizar si esto está pasando se me ha ocurrido analizar la longitud de las frases de este blog desde sus inicios y de paso aprovechar para hacer web scraping con la librería Beatifulshop de Python. La idea es recorrer el blog y calcular la longitud de las frases y representar gráficamente como ha ido evolucionando esa longitud.

Podía haber trabajado directamente con la base de datos de wordpress pero he preferido leer las páginas de la web. Hay un problema, si véis el nombre de las páginas no tiene un orden cronológico, son el nombre de la propia entrada [https://analisisydecision.es/los-bancos-lo-llaman-transformacion-digital-yo-lo-llamo-me-da-miedo-facebook/] pero es cierto que se almacena una vista por mes de las entradas publicadas [<https://analisisydecision.es/2017/02/>] vamos a emplear esas vistas que no recogen la entrada entera pero si las primeras frases, con estas limitaciones vamos a medir la longitud de las frases.

Luego la analizamos paso a paso pero la función de Python que voy a emplear es:

```r
import pandas as pd
from bs4 import BeautifulSoup
import requests
import re
import time
import string

def extrae (anio, mes):
url = "https://analisisydecision.es/" + anio + "/" + mes + "/"
print (url)
# Realizamos la petición a la web
pagina = requests.get(url)
soup = BeautifulSoup(pagina.content, 'html.parser')
m = str(soup.find_all('p'))
m = BeautifulSoup(m)
m = str(m.get_text())
frases = pd.DataFrame(m.split("."),columns=['frase'])
frases['largo'] =  frases['frase'].str.len()
frases['mes'] = anio + mes
frases['frase'] = frases['frase'].apply(lambda x:''.join([i for i in x if i not in string.punctuation]))
frases = frases.loc[frases.largo>10]
time.sleep(60)
return frases
```


Os comento paso a paso, a la función le vamos a pasar el mes y el año y esa será la url que lee https://analisisydecision.es/2017/02/ esa es la web sobre la que vamos a hacer el scraping. Vía request obtenemos la web y BeatifulSoup sólo para quedarnos con el contenido en HTML de la web cargada:

```r
# Realizamos la petición a la web
pagina = requests.get(url)
soup = BeautifulSoup(pagina.content, 'html.parser')
```


En este punto tenemos un HTML y debemos saber que nos interesa, para el ejercicio nos interesan los párrafos, las etiquetas P, ojo que puede interesarnos guardar alguna tabla u otro elemento, en nuestro estudio estamos analizando la longitud de las frases que hay en los párrafos luego buscaremos las etiquetas P:

```r
m = str(soup.find_all('p'))
m = BeautifulSoup(m)
```


Hemos pasado de un completo código HTML a sólo quedarnos con los párrafos, ahora con limpiar el resto de código HTML tendremos algo que podamos usar:

```r
m = str(m.get_text())
```


Soy un principiante en esto de Python y por ese motivo me encuentro más cómodo trabajando con data frames:

```r
frases = pd.DataFrame(m.split("."),columns=['frase'])
frases['largo'] =  frases['frase'].str.len()
frases['mes'] = anio + mes
frases['frase'] = frases['frase'].apply(lambda x:''.join([i for i in x if i not in string.punctuation]))
frases = frases.loc[frases.largo>10]
time.sleep(60)
```


Creamos un data frame con una sola variable que contendrá las frases extraídas en el proceso de scraping y le añadimos una variable largo que será la que al final analicemos, además le añadimos la fecha en la que estamos extrayendo los datos para luego graficar por esa fecha. Ahora sólo hacemos una burda limpieza de texto mediante lambdas eliminando los signos de puntuación y borramos las frases con una longitud menor de 10, en la función se ha añadido un retardo de 1 minuto que no tiene mucha utilidad, luego veremos su motivación. Ahora con esta función realizamos un bucle que lea distintas fechas y nos genere un data frame con las frases de las vistas por fecha de analisisydecision.es:

```r
anios = ['2008','2009','2010','2011','2012','2013','2014','2015','2016','2017']
#meses = ['01','02','03','04','05','06','07','08','09','10','11','12']
meses = ['11']

df = extrae('2008','02')
for i in anios:
for j in meses:
if (i + j != '200802'):
m = extrae(i,j)
df = pd.concat([df,m])
```


En este punto pediros que no ejecutéis el bucle entero porque el servidor os echará de la web, a mi me ha saltado el firewall en repetidas ocasiones y de nada ha servido que haya puesto retardos, creo que me ha permitido un máximo de 24 descargas, en cualquier caso solo descargamos unos meses y podemos hacer un boxplot.

```r
import matplotlib.pyplot as plt
df.boxplot(column='largo', by=['mes'])
plt.show()
```


Vemos que no parece que las redes sociales estén afectando a la longitud de mis frases, yo diría que si…