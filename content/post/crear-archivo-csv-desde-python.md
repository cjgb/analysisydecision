---
author: rvaquerizo
categories:
- consultoría
- python
- trucos
date: '2018-08-25'
lastmod: '2025-07-13'
related:
- lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r.md
- trucos-sas-particionar-y-exportar-a-texto-un-dataset.md
- truco-leer-sas7bdat-sin-sas.md
- truco-sas-como-leer-pc-axis-con-sas.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
tags:
- sas7bdat
title: Crear archivo csv desde SAS con Python
url: /blog/crear-archivo-csv-desde-python/
---
Con la librería [sas7bdat de Python](https://pypi.org/project/sas7bdat/) podemos leer archivos SAS y crear directamente un data frame, es la mejor librería para hacerlo, si la tabla SAS que deseáis leer está comprimida (compress=yes) con pandas no podréis hacerlo. Pero tengo que agradecer a mi compañero Juan que me haya descubierto la función convert_file para pasar directamente el archivo SAS a csv, es más eficiente y parece que consume menos recursos del equipo. La sintaxis es muy sencilla:

```r
import pandas as pd
from sas7bdat import SAS7BDAT

start_time = time.time()
path_file_sas = '/ubicacion/archivo/sas/tabla_SAS.sas7bdat'
path_file_csv = 'ubicacion/archivo/csv/archivo_CSV.csv'
f = SAS7BDAT(path_file_sas)

f.convert_file(path_file_csv, delimiter=',', step_size=10000)

end_time = time.time()
(end_time - start_time) / 60
```


La función convert_file realiza el proceso paso a paso, trozo a trozo, chunk to chunk. Si la tarea la realizas con un equipo esto te permite poder seguir usándolo. Me ha parecido un truco útil para poder importar tablas SAS a Python creando primero un csv, podéis agradecer a Juan.