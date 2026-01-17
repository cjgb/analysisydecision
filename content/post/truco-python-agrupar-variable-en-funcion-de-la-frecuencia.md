---
author: rvaquerizo
categories:
- Formación
- Python
- Trucos
date: '2018-05-18T03:43:45-05:00'
lastmod: '2025-07-13T16:07:44.488848'
related:
- macros-sas-agrupando-variables-categoricas.md
- data-management-basico-con-pandas.md
- creacion-de-ranking-con-r.md
- trucos-sas-variables-dummy-de-una-variable-continua.md
- truco-sas-categorizar-variables-continuas.md
slug: truco-python-agrupar-variable-en-funcion-de-la-frecuencia
tags: []
title: Truco Python. Agrupar variable en función de la frecuencia
url: /blog/truco-python-agrupar-variable-en-funcion-de-la-frecuencia/
---

Me ha surgido la necesidad de crear una nueva variable en un data frame a partir de la frecuencia de otra, es decir, quedarme con los valores más frecuentes y aplicar una categoría resto para aquellos valores que no estén en los más frecuentes. Para realizar esto se me ha ocurrido la siguiente función en Python:

```r
def agrupa_frecuencia (var_origen, var_destino, df, grupos, valor_otros):
df_grp= df[var_origen].value_counts()
list_grp = list(df_grp.iloc[0:grupos,].index)
df[var_destino] = df[var_origen].map(lambda x: x if x in list_grp else valor_otros, na_action='ignore')
```


Es una función con más parámetros que líneas, pero necesitamos una variable de origen, una variable de destino que será la que calcularemos, el data frame sobre el que realizamos la tarea, el número de grupos más otro que será el «resto» y dar un valor a ese «resto». La función lo que hace es una tabla de frecuencias ordenada descendentemente con .value_counts() y creamos una lista con el número de grupos que deseamos. Por último mediante lambdas si la variable origen está en la lista generada anteriormente le asignamos el mismo valor, en caso contrario asignamos el valor «resto». Es una programación sencilla, seguramente haya una función específica en sckitlearn para agrupar variables en base a la frecuencia, pero no la he encontrado y he tardado más en buscarla que en hacerla.

Como es habitual os pongo un ejemplo de uso para que podáis ver como funciona:

```r
personas = 1000
grupo = pd.DataFrame(np.random.poisson(15,personas))
grupo['clave']=0
valor = pd.DataFrame(np.random.uniform(100,10000,personas))
valor['clave']=0
df = pd.merge(grupo,valor,on='clave')
del df['clave']
df.columns = ['grupo', 'valor']
df['grupo'].value_counts()
```


Vemos que grupo crea muchos valores y vamos a agrupar la variable del data frame de forma que los 10 más frecuentes toman su valor y los demás serán un resto:

```r
agrupa_frecuencia('grupo', 'grupo_nuevo', df, 10, 99)
df['grupo_nuevo'].value_counts()
```


Parece que funciona, si mejoráis, actualizáis o encontráis pegas…