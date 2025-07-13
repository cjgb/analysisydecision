---
author: rvaquerizo
categories:
- Business Intelligence
- Python
date: '2019-10-18T09:05:40-05:00'
slug: de-sql-server-a-python-pandas-dataframe
tags:
- SQL SERVER
title: Importar de SQL Server a Python Pandas dataframe
url: /de-sql-server-a-python-pandas-dataframe/
---

Nueva duda que me han planteado, cómo pasar la extracción de una consulta en BBDD SQL server a un dataframe de pandas. Es sencillo, pero siempre tenemos que tener configurado el origen de datos ODBC, doy por sentado que esa tarea ya está hecha. El paquete que vamos a usar es pip install pyodbc y el ejemplo de uso es el siguiente:

```r
import pyodbc
import pandas as pd

conexion = pyodbc.connect('Driver={ODBC Driver SQL Server};'
                      'Server=SERVIDOR;'
                      'Trusted_Connection=yes;')

frase = "SELECT * from tabla where campo=1"
consulta= pd.read_sql_query(frase, conexion)
consulta.head()
```
 

Creamos una conexión al origen ODBC, os recomiendo que directamente vayáis a ODBC Data Sources y miréis la definición y vamos a tener una frase que será nuestra consulta, también es aconsejable que esa consulta la probéis previamente en SQL Server para asegurar su correcto funcionamiento. En pandas empleamos read_sql_query( consulta , conexión ) y ya disponemos de un data frame directamente de la extracción de SQL Server y podemos hacer con él el [data management que necesitemos con pandas](https://analisisydecision.es/data-management-basico-con-pandas/).