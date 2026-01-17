---
author: rvaquerizo
categories:
- Big Data
- Formación
- Inteligencia Artificial
- Monográficos
- R
date: '2020-11-27T05:47:45-05:00'
lastmod: '2025-07-13T15:55:11.525489'
related:
- tratamiento-y-procesado-de-imagenes-con-r-y-magick.md
- inteligencia-arficial-frente-a-un-juego-de-ninos-la-particula-tonta-de-nicolas.md
- resolucion-del-juego-de-modelos-con-r.md
- truco-r-insertar-imagen-en-un-grafico.md
- machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion.md
slug: computer-vision-con-r-opencv-de-andar-por-casa
tags:
- openCV
title: Computer Vision con R. OpenCV de andar por casa
url: /blog/computer-vision-con-r-opencv-de-andar-por-casa/
---

Trabajando con Computer Vision aprecio que estamos muy limitados por las máquinas que usamos, o tiene mucho sentido montar GPUs en casa del tamaño del aire acondicionado y por supuesto no tiene sentido el consumo energético que implica. Aquí estoy yo montando una GPU para el análisis de imágenes.

[![](/images/2020/11/openCV_1.png)](/images/2020/11/openCV_1.png)

Este tema implica que la Computer Vision no lo podrá usar el común de los _data scientist_ , a los necesarios conocimientos técnicos y matemáticos se añade el disponer de unos recursos tecnológicos que no están al alance de cualquiera. Sin embargo, los conocimientos técnicos y matemáticos los puedes adquirir o puedes aprovecharte de los entornos colaborativos. Pero, podemos iniciarnos en el reconocimiento de imágenes con R y la librería openCV y si salen algunos temas en los que estoy enredando es posible que la reducción de dimensionalidad y la geometría nos ahorre máquinas y energía.

Vamos a emplear dos ejemplos para ver las posibilidades de openCV más R. Partimos de una primera imagen en la que hay 4 personas jugando al futbol y un balón está volando en el aire. Siento no saber de donde saqué esta foto, si tiene algún tipo de derecho hacédmelo llegar.

[![](/images/2020/11/futbol.png)](/images/2020/11/futbol.png)

```r
library(opencv)
library(tidyverse)

ub = "/images/2020/11/futbol.png"

futbol <- ocv_read(ub)
```


Tenemos la imagen cargada y empezar por `ocv_edges(futbol)` para ver los límites de las imágenes:

[![](/images/2020/11/ocv_edges.png)](/images/2020/11/ocv_edges.png)

Con `ocv_face(futbol)` podemos ver las caras que identifica:

[![](/images/2020/11/ocv_faces.png)](/images/2020/11/ocv_faces.png)

Una de las caras de perfil no la identifica el algoritmo, pero si ha funcionado con el balón. Y con `ocv_markers(futbol)` podemos trazar las marcas que es una de las vías en las que estoy trabajando para el reconocimiento de caras:

[![](/images/2020/11/ocv_markers.png)](/images/2020/11/ocv_markers.png)

Podemos combinar funciones pero siempre son sentido, por ejemplo, esto nos produciría un error `futbol %>% ocv_grayscale() %>% ocv_markers()` ¿por qué motivo?

Este trabajo lo podemos emplear para contar personas en fotografías. Otro ejemplo sería partiendo de una imagen de la selección española que tampoco tengo muy claro de donde salió:

[![](/images/2020/11/seleccion.png)](/images/2020/11/seleccion.png)

Vamos a contar personas y para ello propongo el uso de la función ocv_facemask:

```r
library(opencv)
library(tidyverse)
ub2 = "/images/2020/11/seleccion.png"
seleccion <- ocv_read(ub2)

personas <- ocv_facemask(seleccion)
nrow(attr(personas, 'faces'))
```


A la vista está que ha contado una persona de mas. Hay un pliegue en un pantalón que está llevando a error al algoritmo, sólo tenéis que ver el objeto personas. Para evitar el problema podríamos hacer:

```r
ocv_read(ub2) %>% ocv_blur() %>% ocv_face()
```


[![](/images/2020/11/ocv_blur.png)](/images/2020/11/ocv_blur.png)

Al difuminar la imagen con ocv_blur desaparece el problema en esta foto, pero no podemos generalizar, probad a hacer lo mismo en la foto anterior. El empleo de openCV con R no es complejo pero tiene sus limitaciones si queremos sofisticar nuestros análisis. Veremos que pasa con la geometría.