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

He sido reticente a usar `reticulate` con R porque no me gusta R Markdown y, si he trabajado con Python, no he necesitado R y viceversa. Ahora tengo en mente algún juego/proyecto de esos que se quedan siempre en el tintero por falta de tiempo o interés, pero me están sirviendo para elaborar unos apuntes sobre R Markdown y Python que voy a sintetizaros en esta entrada por si a alguien le fuera de utilidad.

Todo comenzará con `remotes::install_github("rstudio/reticulate")`. Yo, a pesar de tener varios entornos de Python (Anaconda), dejé que se instalara el Miniconda y trabajo con el entorno `rstudio-python`. Estoy habituado a que esta labor la realicen los ingenieros (para eso están) y la verdad es que no he tocado nada de la instalación; he dejado a R que lo configure. Si tenéis problemas con Rtools y Windows, [id a este enlace y lo resolvéis como indica](https://cran.r-project.org/bin/windows/Rtools/index.html). Al hacer esto partimos de un entorno sin los paquetes habituales y por ello, una vez ejecutemos `library(reticulate)`, tenemos que instalar los paquetes de Python en el entorno de `r-reticulate` de Miniconda con `py_install('pandas')`. De este modo nos podemos ir configurando un entorno con los paquetes que necesitemos.

Disponiendo del entorno requerido ya podemos abrir nuestro *notebook* en Markdown y ejecutar código R o Python, según necesitemos. Un ejemplo que podéis ejecutar tal cual (si disponéis de los paquetes) en vuestro *notebook*:

```r
library(reticulate)
library(tidyverse)

df_R <- data.frame(id = seq(1:10), x = rnorm(10, 10, 1))
```

Vemos cómo movemos un `data.frame` de R a Python:

```python
import pandas as pd

# Usamos el prefijo r. para acceder a objetos de R
print(r.df_R.head())

df_python = r.df_R
df_python['y'] = df_python['x'] * 2
```

Con Python podéis ejecutar código en Python y, si necesitáis llamar a un `data.frame` de R para trabajar con Pandas, hacéis `r.df_R` y ya disponéis de los datos en Python. El paso contrario, de Python a R, es:

```r
# Usamos el objeto py para acceder a objetos de Python
df_R_v2 <- py$df_python
head(df_R_v2)
```

No es complicado y funciona bien; el problema que he encontrado está en los entornos: son un dolor de muelas. Espero que sea de utilidad.