---
author: rvaquerizo
categories:
  - big data
  - formación
  - monográficos
  - python
  - r
date: '2020-11-26'
lastmod: '2025-07-13'
related:
  - trabajando-con-r-y-julia-desde-rstudio.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
  - analisis-de-textos-con-r.md
tags:
  - big data
  - formación
  - monográficos
  - python
  - r
title: R + Python = reticulate
url: /blog/r-python-reticulate/
---

![](https://rstudio.github.io/reticulate/images/reticulated_python.png)

He sido reticente a usar reticulate con R porque no me gusta R markdown y si he trabajado con Python no he necesitado R y viceversa. Ahora tengo en mente algún juego/proyecto de esos que se quedan siempre en el tintero por falta de tiempo o interés pero me están sirviendo para elaborar unos apuntes sobre R markdow y Python que voy a sintetizaros en esta entrada por si a alguien le fuera de utilidad.

Todo comenzará con `remotes::install_github("rstudio/reticulate")` yo, a pesar de tener varios entornos de Python Anacoda, dejé que se instalara el Miniconda y trabajo con el entorno rstudio. Estoy habituado a que esta labor la realicen los ingenieros (para eso están) y la verdad es que no he tocado nada de la instalación, he dejado a R que lo configure. Si tenéis problemas con Rtools y Windows [id a este enlace y lo resolvéis como indica](https://cran.r-project.org/bin/windows/Rtools/index.html). Al hacer esto partimos de un entorno sin los paquetes habituales y por ello, una vez ejecutemos `library(reticulate)`, tenemos que instalar los paquetes de Python en el entorno de rstudio de Miniconda con `py_install('pandas')`. De este modo nos podemos ir configurando un entorno con los paquetes que necesitemos.

Disponiendo del entorno requerido ya podemos abrir nuestro notebook en markdown y ejecutar código R o Python, según necesitemos. Un ejemplo a lo ‘mecagüen’ que podéis ejecutar tal cual (si disponéis de los paquetes) en vuestro notebook:

[![](/images/2022/05/wp_editor_md_96b8e92c89a914639571e2ecbc8d0e94.jpg)](/images/2022/05/wp_editor_md_96b8e92c89a914639571e2ecbc8d0e94.jpg)

Vemos como movemos un data frame de R a Python.

[![](/images/2022/05/wp_editor_md_e01020b96dbd6dab708a5831daa6cd44.jpg)](/images/2022/05/wp_editor_md_e01020b96dbd6dab708a5831daa6cd44.jpg)

Con \`\`\`\`{python}`podéis ejecutar código en Python y si necesitáis llamar a un data frame de R para trabajar con pandas hacéis`r.df_R\` y ya disponéis de los datos en python, el paso contrario de Python a R es:

[![](/images/2022/05/wp_editor_md_d35f8fc83125d1cf52d8eed538741b48.jpg)](/images/2022/05/wp_editor_md_d35f8fc83125d1cf52d8eed538741b48.jpg)

No es complicado y funciona bien, el problema que he encontrado está en los entornos, son un dolor de muelas. Espero que sea de utilidad.
