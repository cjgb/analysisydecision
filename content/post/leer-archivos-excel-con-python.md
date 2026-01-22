---
author: rvaquerizo
categories:
  - monográficos
  - python
date: '2020-04-01'
lastmod: '2025-07-13'
related:
  - creando-archivos-excel-desde-python-con-pandas-y-excelwriter.md
  - leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
  - lectura-de-archivos-csv-con-python-y-pandas.md
  - proyecto-text-mining-con-excel-iv.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
tags:
  - pandas
  - xlrd
title: Leer archivos Excel con Python
url: /blog/leer-archivos-excel-con-python/
---

Entrada sobre la importación de Excel con Python, un aporte que sirve para mi documentación y que es posible que sea de ayuda para muchos que se estén iniciando en el uso de Python y Pandas, aunque en este caso para la lectura del Excel usaremos tanto `Pandas` como la librería `xlrd`.

#### Lectura de Excel con Pandas

Lo más sencillo para importarnos en Python un Excel y crearnos un data frame de `Pandas` es:

```python
import pandas as pd
archivo = 'C:/Users/Documents/ejemplo.xlsx'

df = pd.read_excel(archivo, sheet_name='Hoja1')

df.describe()
```

La función `read_excel` será suficiente en el 80% de las ocasiones que realicemos esta tarea. Como es habitual en la ayuda tenéis perfectamente descritas sus posibilidades.

#### Lectura de Excel con xlrd

Es posible que necesitemos realizar tareas más complejas a la hora de leer archivos Excel y podemos usar `xlrd`. Vemos algunas de las posibilidades:

```python
import xlrd

archivo = 'C:/Users/rvaquerizo/Documents/ejemplo.xlsx'

wb = xlrd.open_workbook(archivo)

hoja = wb.sheet_by_index(0)
print(hoja.nrows)
print(hoja.ncols)
print(hoja.cell_value(0, 0))
```

`open_workbook` nos abre el Excel para trabajar con él. Seleccionamos hojas por índice (empezando por el 0) y con la hoja seleccionada podemos ver el número de filas (`nrows`) o columnas (`ncols`). Seleccionar una celda lo hacemos con `cell_value` mediante índices (empezando por el 0). Otras posibilidades:

```python
archivo = 'C:/Users/rvaquerizo/Documents/ejemplo.xlsx'

wb = xlrd.open_workbook(archivo)

hoja = wb.sheet_by_name('Hoja1')
for i in range(0,hoja.nrows):
    print(hoja.cell_value(i,1))
```

Si por ejemplo deseamos saber las cabeceras, los nombres de las columnas:

```python
archivo = 'C:/Users/rvaquerizo/Documents/ejemplo.xlsx'

wb = xlrd.open_workbook(archivo)

hoja = wb.sheet_by_index(0)
nombres = hoja.row(0)
print(nombres)
```

Y mediante `xlrd` podemos crear data frames de pandas con lo que es posible realizar lecturas de rangos:

```python
archivo = 'C:/Users/rvaquerizo/Documents/ejemplo.xlsx'

wb = xlrd.open_workbook(archivo)

hoja = wb.sheet_by_index(0)

# Creamos listas
filas = []
for fila in range(1,hoja.nrows):
    columnas = []
    for columna in range(0,2):
        columnas.append(hoja.cell_value(fila,columna))
    filas.append(columnas)

import pandas as pd
df = pd.DataFrame(filas)
df.head()
```

Hay alguna librería que lo hace de forma más elegante pero la importación de rangos de Excel con `xlrd`, una vez te familiarizas, me parece bastante sencilla. Espero que sea de utilidad
