---
author: rvaquerizo
categories:
- Excel
- Formación
- Python
date: '2021-10-18T04:44:19-05:00'
slug: creando-archivos-excel-desde-python-con-pandas-y-excelwriter
tags: []
title: Creando archivos Excel desde Python con Pandas y ExcelWriter
url: /creando-archivos-excel-desde-python-con-pandas-y-excelwriter/
---

Crear archivos Excel desde un data frame de Python Pandas nos va a servir para tener unos breves apuntes de ExcelWriter y algunos ejemplos de manipulación de archivos Excel desde Python. Para este ejemplo vamos a trabajar con un archivo que está en el blog y por ello el primer paso será descargar el Excel para crear el data frame de trabajo:

```r
import requests
import pandas as pd

arch = /images/2021/10/ejemplo_python.xlsx
resp = requests.get(arch)

salida = open('c:/temp/ejemplo_python.xlsx', 'wb')
salida.write(resp.content)
salida.close()
```
 

En este punto ya podemos crear nuestro data frame leyendo directamente el Excel con Pandas:

```r
df = pd.read_excel('c:/temp/ejemplo_python.xlsx', sheet_name='Hoja1')
df.describe()
```
 

La forma más sencilla de crear un archivo Excel desde Python es:

```r
df2 = df[['Var1','Var2']]
df2.to_excel("c:/temp/ejemplo_python2.xlsx",
             sheet_name='Parte1')
```
 

Pero como os decía vamos a aprovechar para hacer algunas tareas adicionales con ExcelWriter. Por supuesto, lo más sencillo crear el mismo Excel con ExcelWriter:

```r
df2.to_excel('c:/temp/ejemplo_python2.xlsx', engine='xlsxwriter')
```
 

Pero queremos dividir nuestro data frame en múltiples hojas de Excel:

```r
df2 = df[['Var1','Var2']]
df3 = df[['Var3','Var4']]
df4 = df[['Var5']]

writer = pd.ExcelWriter('c:/temp/ejemplo_python2.xlsx', engine='xlsxwriter')

df2.to_excel(writer, sheet_name='Parte1', index=False)
df3.to_excel(writer, sheet_name='Parte2', index=False)

columna_inicio = df2.shape[0]
df4.to_excel(writer, sheet_name='Parte1', index=False, startcol=columna_inicio)
writer.save()
```
 

Además de crear varias hojas de Excel con nombre Parte para cada data frame eliminamos los índices de la salida y el último de los data frames lo añadimos tras la última columna en la hoja de Excel Parte1, es como añadir horizontalmente datos y esta labor la realizamos con la opción startcol, simplemente tenemos que controlar donde añadimos. Por el contrario, si deseamos anexar verticalmente:

```r
df2 = df[['Var1','Var2']]
df3 = df[['Var3','Var4']]
df4 = df[['Var5']]

writer = pd.ExcelWriter('c:/temp/ejemplo_python2.xlsx', engine='xlsxwriter')

df2.to_excel(writer, sheet_name='Parte1', index=False)
df4.to_excel(writer, sheet_name='Parte1', index=False, startrow=len(df.index)+1, header=False)
writer.save()
```
 

Es análogo al código anterior pero necesitamos la opción header = False para evitar poner el encabezado del data frame en el Excel resultante. Un par de apuntes que, espero, sean de utilidad.