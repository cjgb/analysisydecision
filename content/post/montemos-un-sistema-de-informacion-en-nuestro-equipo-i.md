---
author: rvaquerizo
categories:
- Business Intelligence
- Formación
- Monográficos
date: '2010-11-27T12:16:23-05:00'
slug: montemos-un-sistema-de-informacion-en-nuestro-equipo-i
tags:
- pentaho
- postgres
- R
title: Montemos un sistema de información en nuestro equipo (I)
url: /montemos-un-sistema-de-informacion-en-nuestro-equipo-i/
---

Un poco de bricolaje. Se trata de crear un sistema de información sin coste y que nos permita almacenar nuestros datos con orden y coherencia, crear informes y realizar modelos matemáticos bajo Windows. Es perfectamente replicable para Linux. También estoy abierto a sugerencias ya que tampoco soy ningún experto en el tema y podemos crear un debate interesante. El sistema que planteo se va a sustentar en 3 pilares fundamentales que os podéis descargar de forma gratuita en los link creados:

  * [Postgres: ](http://www.postgresql.org/)

Será nuestro motor de BBDD relacionales. Seguramente no haremos un modelo de datos complicado e incluso nos dedicaremos a llenar la BBDD con tablas de todo tipo sin mucha conexión entre ellas pero es necesario tener una BBDD.

  * [Data integration de Pentaho:](http://sourceforge.net/projects/pentaho/files/)

Será la herramienta que empleemos para subir datos al servidor. También podremos emplearla para realizar informes.

  * [R:](http://www.r-project.org/)

Que puedo más puedo decir sobre R. El futuro.

Para la realización de informes he comentado la posibilidad de emplear Pentaho pero puede ser más adecuado emplear una hoja de cálculo. Para esto yo si me gasté dinero y dispongo de Excel, pero intentaré trabajar con [Google Spreadsheet](https://www.google.com/accounts/ServiceLogin?service=writely&passive=1209600&continue=http://docs.google.com/&followup=http://docs.google.com/&ltmpl=homepage). El primer paso es descargarse cada una de las herramientas que propongo. Tanto Postgres como R nos lo descargamos y lo instalamos, el Data Integration de Pentaho no requiere instalación, nos descargamos el archivo, lo descomprimimos y para arrancarlo tenemos el script spoon.bat R no plantea muchos problemas para instalarse en un equipo local de Windows y Postgres puede dar algún problema en Windows 7, si alguien los tiene que los reporte para ayudar a solventarlos y así quedan documentados en el blog. La instalación dePostgres nos pedirá la contraseña del admin, ojo con esta contraseña.

En la siguiente entrega comenzaremos a trabajar con Postgres y Pentaho. Por supuesto, como he comentado antes, cualquier aporte será bienvenido. Saludos