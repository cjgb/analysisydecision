---
author: rvaquerizo
categories:
- big data
- consultoría
- formación
- monográficos
date: '2021-01-11'
lastmod: '2025-07-13'
related:
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
- lectura-de-archivos-csv-con-python-y-pandas.md
- mapa-de-codigos-postales-con-r-aunque-el-mapa-es-lo-de-menos.md
- beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir.md
- mapa-estatico-de-espana-con-python.md
title: youtube-dl para descargar videos y mplayer para pasar esos vídeos a imágenes
url: /blog/youtube-dl-para-descargar-videos-y-mplayer-para-pasar-esos-videos-a-imagenes/
tags:
- sin etiqueta
---
Si deseamos [descargar vídeos de Youtube tenemos youtube-dl](https://youtube-dl.org/) pero podemos descargar de otras web y en esta entrada vamos a ver como. Además podemos transformar esas entradas en fotogramas, esto es útil a la hora de analizar imágenes, podríamos estudiar la presencia de una marca en un partido de fútbol, identificar las matrículas que pasan delante de determinada cámara u otros casos de uso. Y en uno de esos casos precisamente [J.L. Cañadas](https://twitter.com/joscani) del [blog hermano Muestrear no es Pecado](https://muestrear-no-es-pecado.netlify.app/) me ha descubierto la librería youtube-dl y la creación de scripts para tranformar videos en imágenes que posteriormente podemos analizar. El caso de mplayer es distinto, lo conocía, Cañadas me ha descubierto el ffmpeg que ofrece más posibilidades.

### shell scripting

El scripting no es habitual en el blog, pero en este «nuevo ecosistema del data sciense» el shell scripting ha tomado mucho más peso. Hace años fui bueno pero poco a poco entendí que esos _pipelines_ tenían que hacerse con herramientas como Kettle, Enterprise Guide, Emblem, Rate Assesor,… Ahora me toca volver a retomar estos scripts y lo primero es indicar donde instalo y ejecuto para que se pueda replicar. En este caso, al trabajar con una librería de python como es youtube-dl, empleo un terminal de Anaconda y el enviroment que uso habitualmente con R y reticulate (por si acaso necesito automatizar el script). Lo primero instalar youtube-dl:

```bash
# Instalar youtube-dl
pip install -U youtube-dl
```

Una vez instalado tenemos que seleccionar el vídeo que deseamos descargarnos y listar los formatos disponibles para la descarga:

```bash
# Ubicación de trabajo
cd ./Escritorio/wordpress

# Listar formatos
youtube-dl --list-formats "https://www.youtube.com/watch?v=fhQPB8GHtqo"
```

En este caso tenemos un video del piloto de motocross español Jorge Prado que grabó por aquí cerca en 2015, cuando era un chaval, ahora tiene 2 títulos mundiales y va a ser el mejor piloto del mundo en 2-3 años. Tiene relevancia la salida obtenida:

```text
format code  extension  resolution note
139          m4a        audio only DASH audio   49k , m4a_dash container, mp4a.40.5@ 48k (22050Hz)
249          webm       audio only DASH audio   52k , webm_dash container, opus @ 50k (48000Hz)
250          webm       audio only DASH audio   68k , webm_dash container, opus @ 70k (48000Hz)
140          m4a        audio only DASH audio  127k , m4a_dash container, mp4a.40.2@128k (44100Hz)
251          webm       audio only DASH audio  133k , webm_dash container, opus @160k (48000Hz)
278          webm       256x144    DASH video   95k , webm_dash container, vp9, 25fps, video only
160          mp4        256x144    DASH video  108k , mp4_dash container, avc1.4d400b, 25fps, video only
242          webm       426x240    DASH video  220k , webm_dash container, vp9, 25fps, video only
133          mp4        426x240    DASH video  242k , mp4_dash container, avc1.4d400c, 25fps, video only
243          webm       640x360    DASH video  405k , webm_dash container, vp9, 25fps, video only
134          mp4        640x360    DASH video  627k , mp4_dash container, avc1.4d401e, 25fps, video only
244          webm       854x480    DASH video  752k , webm_dash container, vp9, 25fps, video only
135          mp4        854x480    DASH video 1155k , mp4_dash container, avc1.4d4014, 25fps, video only
247          webm       1280x720   DASH video 1505k , webm_dash container, vp9, 25fps, video only
136          mp4        1280x720   DASH video 2310k , mp4_dash container, avc1.4d4016, 25fps, video only
248          webm       1920x1080  DASH video 2646k , webm_dash container, vp9, 25fps, video only
137          mp4        1920x1080  DASH video 4201k , mp4_dash container, avc1.640028, 25fps, video only
22           mp4        1280x720   720p    3k , avc1.64001F, 25fps, mp4a.40.2@192k (44100Hz)
18           mp4        640x360    360p  698k , avc1.42001E, 25fps, mp4a.40.2@ 96k (44100Hz), 13.38MiB (best)
```

Tenemos todos los formatos disponibles y tienen un _code_ , éste será necesario cuando le indiquemos a youtube-dl lo que deseamos descargar. Observad que también tenemos los archivos de audio. En este caso vamos a descargarnos el 136 video en formato mp4, si posteriormente queremos trabajar con mplayer podemos acostumbrarnos a bajarnos siempre el mp4. Entonces hacemos:

```bash
# Descargar
youtube-dl -f 136 https://www.youtube.com/watch?v=fhQPB8GHtqo
```

Ya tenemos disponible el vídeo en nuestro equipo.

### Descarga con youtube-dl de otras web

Un paréntesis, no sólo es posible descargar de Youtube, de nuevo Cañadas se puso a curiosear y encontró lo siguiente. Imaginemos que deseamos descargarnos un vídeo de Televisión Española. Por ejemplo el [vídeo en el que se anunció que Jorge Prado iba a ser campeón del mundo de motocross en 2018](https://www.rtve.es/alacarta/videos/motociclismo/jorge-prado-campeon-del-mundo-motocross/4758017/). En ese caso abrimos la web y buscamos el link al vídeo inspeccionando los elementos de la web. En el caso de Chrome:

![](/images/2021/01/Captura-de-pantalla-de-2021-01-08-14-26-50.png)

Copiando el elemento ya tendríamos la dirección del vídeo y sólo tenemos que saber el código y ejecutar la descarga:

```bash
youtube-dl --list-formats  https://www.rtve.es/alacarta/videos/motociclismo/jorge-prado-campeon-del-mundo-motocross/4758017/
youtube-dl -f hls-1672 https://www.rtve.es/alacarta/videos/motociclismo/jorge-prado-campeon-del-mundo-motocross/4758017/
```

Del mismo modo podremos descargar con youtube-dl de cualquier otra web como Vimeo o un vídeo incrustado, inspeccionar elementos y en dos líneas descargamos el video. También podemos hacer una lista y descargar los vídeos que deseamos o la música de esos vídeos.

### Obtener imágenes del video con mplayer

Cerramos paréntesis y volvemos al primer vídeo que ya tenemos en nuestra carpeta y ahora queremos obtener una sucesión de archivos de imágenes de ese vídeo para realizar nuestro análisis de imágenes. Para ello vamos a emplear mplayer en ese mismo entorno conda donde estamos trabajando.

```bash
mplayer -vf framestep=60 -framedrop -nosound video1.mp4 -speed 100 -vo jpeg:outdir=video1
```

Tenemos un vídeo de 2 minutos 40 segundos resumido en 67 imágenes jpg como esta:

![](/images/2021/01/00000063.jpg)

En framestep = indicamos el número de frames hasta obtener la imagen, si ponemos un número bajo almacenaremos un gran número de imágenes, es necesario tenerlo en cuenta si sintetizamos un video de gran tamaño. Para no alargar más la entrada en otro momento veremos ffmpeg como opción más apropiada para sintetizar vídeos en imágenes.
