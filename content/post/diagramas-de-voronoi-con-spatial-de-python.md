---
author: rvaquerizo
categories:
- big data
- consultoría
- python
date: '2017-12-08'
lastmod: '2025-07-13'
related:
- representar-poligonos-de-voronoi-dentro-de-un-poligono.md
- identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
- machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion.md
- adyacencia-de-poligonos-con-el-paquete-spdep-de-r.md
- un-peligro-del-analisis-cluster.md
tags:
- cdktree
- spatial
- voronoi
title: Diagramas de Voronoi con spatial de python
url: /blog/diagramas-de-voronoi-con-spatial-de-python/
---
En breve «mis cachorros», como llamo a un grupo de los mejores Data Scientist de Europa (de los que tengo que hablar algún día) se van a enfrentar a un problema que probablemente tengan que resolver con análisis geométricos muy complejos. Para despertarles la curiosidad (sé que me leen) hoy traigo al blog una entrada que nos aproxima al método de interpolación geométrica más sencillo, [al diagrama de Voronoi](http://www.abc.es/ciencia/abci-diagrama-voronoi-forma-matematica-dividir-mundo-201704241101_noticia.html). Con [spatial de scipy](https://docs.scipy.org/doc/scipy-0.18.1/reference/generated/scipy.spatial.Voronoi.html) podemos trabajar con estos diagramas:

```r
seed(89)
df = pd.DataFrame(np.random.uniform(1,100,size=(20, 2)), columns=list('XY'))
plt.scatter(df.X, df.Y,marker=".")
show()
```


[![voronoi_python1](/images/2017/12/voronoi_python1.png)](/images/2017/12/voronoi_python1.png)

Estos puntos aleatorios en el espacio de 2 dimensiones pueden generar regiones por interpolación y representarlas con voronoi_2d_plot:

```r
from scipy.spatial import Voronoi, voronoi_plot_2d
vor = Voronoi(df)
voronoi_plot_2d(vor)
```


[![voronoi_python2](/images/2017/12/voronoi_python2.png)](/images/2017/12/voronoi_python2.png)

Ahora si queremos determinar si un punto de espacio está dentro de una de las celdas que delimitan los diagramas de Voronoi que hemos creado podemos hacerlo por vecinos cercanos con la función cKDTree:

```r
from scipy.spatial import cKDTree
vor_kdtree = cKDTree(df)
puntos = [[1,100],[100,1]]
test_point_dist, test_point_regions = vor_kdtree.query(puntos,k=1)
test_point_regions
```


Y ahora viene lo único interesante de esta entrada, ¿cómo identificamos las regiones? No empleéis .regions, emplead:

```r
pd.concat([df,pd.DataFrame(vor.point_region)],axis=1)
```


Los puntos (1,100) y (100,1) aparecen en la región que nos identifica la posición 19 y 9… Me ha costado tiempo entenderlo, me hago viejo. Saludos.