---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - r
date: '2023-02-19'
lastmod: '2025-07-13'
related:
  - primeros-pasos-con-regresion-no-lineal-nls-con-r.md
  - manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales.md
  - los-parametros-del-modelo-glm-como-relatividades-como-recargos-o-descuentos.md
  - regresion-con-redes-neuronales-en-r.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - formación
  - libro estadística
  - r
title: Introducción a la Estadística para Científicos de Datos. Capítulo 13. Regresión lineal
url: /blog/introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-13-regresion-lineal/
---

En el capítulo 11 dedicado al análisis bivariable se indicó que el inicio de la relación entre dos variables era la correlación, pues la regresión lineal es el principio de la modelización estadística. Evidentemente no es lo mismo pero establecer una analogía entre ambos conceptos permite entender los objetivos de la regresión lineal:

![](/images/2023/02/wp_editor_md_7b9c707bc0b1203c627b7794f374e005.jpg)

[ En este enlace de la recomendada web de Joaquín Amat](https://www.cienciadedatos.net/documentos/24_correlacion_y_regresion_lineal) se trata con mayor detenimiento esta relación. Como se indica en la figura ahora es una variable la que afecta a otra y es necesario crear una recta de regresión que exprese como se modifica una variable dependiente en función de otra variable independiente o regresora, si sólo hay una variable independiente se trata de un modelo de regresión lineal simple, si hay más de una variable es un modelo de regresión lineal múltiple.

## Modelo de regresión lineal simple

La variación de una variable afecta a otra según una función lineal por lo que será necesario crear esa función, calcular los parámetros más adecuados para esa función, decidir si esos parámetros se adecuan o no y medir si el modelo es correcto. Es decir, para plantear un modelo de regresión lineal simple es necesario seguir los siguientes pasos:

- Escribir el modelo matemático

- Estimación de los parámetros del modelo

- Inferencia sobre los parámetros del modelo

- Diagnóstico del modelo

Es el modelo más sencillo ya que gráficamente se puede _intuir_ como va a ser esa relación lineal. En este caso, no es posible seguir el ejemplo de trabajo que sirve de hilo conductor del ensayo y por ello es necesario emplear otros datos.

```r
# install.packages("skimr")
library(skimr)
library(tidyverse)

cost_living <- read.csv("./data/Cost_of_living_index.csv")

skim(cost_living)
```

![](/images/2023/02/wp_editor_md_0383e3977c3493ac8f49dfe25abe2765.jpg)

Se trata de un [ conjunto de datos extraído de Kaggle ](https://www.kaggle.com/datasets/debdutta/cost-of-living-index-by-country?select=Cost_of_living_index.csv)que dispone de un índice del coste de la vida para 536 ciudades donde Nueva York es la base que relativiza el índice, es decir, si una ciudad tiene un valor de 120 en un dato este está un 20% por encima de Nueva York. No se realiza un análisis `EDA`, en su lugar se emplea la librería `skim` para obtener los estadísticos básicos que permitan describir las variables disponibles que se definen del siguiente modo:

- `Rank`: posición de la ciudad
- `Cost.of.Living.Index`: (excluido el alquiler) es un indicador relativo de los precios de los bienes de consumo, incluidos comestibles, restaurantes, transporte y servicios públicos. El `Cost.of.Living.Index` no incluye gastos de alojamiento como alquiler o hipoteca.
- `Rent.Index`: es una estimación de los precios de alquiler de apartamentos en la ciudad en comparación con la ciudad de Nueva York.
- `Cost.of.Livin.Plus.Rent.Index`: El `Cost.of.Livin.Plus.Rent.Index` es una estimación de los precios de los bienes de consumo, incluido el alquiler, en comparación con la ciudad de Nueva York.
- `Groceries.Index`: El `Groceries.Index` es una estimación de los precios de los comestibles en la ciudad en comparación con la ciudad de Nueva York. Para el cálculo se usan pesos de artículos en la sección «Mercados» para cada ciudad.
- `Restaurant.Price.Index`: El `Restaurant.Price.Index` es una comparación de precios de comidas y bebidas en restaurantes y bares en comparación con la ciudad de Nueva York.
- `Local.Purchasing.Power.Index`: muestra el poder adquisitivo relativo en la compra de bienes y servicios en una ciudad dada por el salario promedio en esa ciudad. Si el poder adquisitivo doméstico es 40, esto significa que los habitantes de esa ciudad con el salario promedio pueden permitirse comprar en promedio un 60% menos de bienes y servicios que los residentes de la ciudad de Nueva York con un salario promedio.

En este ejercicio se pretende crear un modelo de regresión lineal simple que permita estimar el indicador del costo de la vida en función del precio del alquiler. Siguiendo los pasos necesarios para realizar el modelo se tiene:

Modelo matemático. El modelo será $$Y = \\beta_0 + \\beta_1X + \\epsilon$$ Esta fórmula que recuerda a la ecuación punto pendiente de una recta es el principio de la modelización estadística y tiene en pocos componentes todo lo necesario para comenzar a entender como funciona. Se desea estimar el valor de `Y` que es la variable dependiente costo de la vida por ciudad, para estimar ese valor se crea una recta de regresión que _empieza_ , que corta el eje desde un punto inicial $\\beta_0$ y tiene una pendiente $\\beta_1$ que modifica linealmente `X`, la variable independiente pero no es posible que el modelo describa perfectamente la variable dependiente y por ello aparece el término error $\\epsilon$. En el ejemplo de trabajo la función sería $$Cost.of.Living.Index = \\beta_0 + \\beta_1 \\cdot \\text{Rent.Index} + \\epsilon$$

Este modelo matemático implica que la variable dependiente se modifica en función de una variable independiente de forma aditiva, recordando temas anteriores, ¿que distribución se modificaba de forma aditiva? La distribución normal, la variable `Cost.of.Living.Index` ha de distribuirse normally. Para comprobar si una variable sigue una distribución normal se puede emplear el gráfico de densidad:

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_cf9b737a96ad6bbad035db4d22a77272.jpg)

No se distribuye normally y para corroborarlo se disponen de gráficos `QQ` que compara los cuantiles de la distribucion normal frente a los cuantiles de la distribución de una variable.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_5c66b2d879a47a99fb581d72af04e846.jpg)

Más que evidente que no se distribuye normally ya que los muchos puntos de la distribución están alejados de la recta que marca los cuantiles teóricos de la distribución normal. Entonces, **¿no es posible realizar un modelo lineal?**. Se calcula el coeficiente de correlación lineal entre las variables:

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

¿Con un coeficiente de correlación lineal superior a 0.8 no va a ser posible crear un modelo de regresión lineal? **Si es posible** , porque el científico de datos busca separar el azar de lo estadísticamente significativo, en su trabajo diario no va a realizar modelos teóricos ideales.

Estimación de los parámetros del modelo. Los parámetros son esos elementos $\\beta$ presentes en la definición del modelo. Esta labor se realiza mediante mínimos cuadrados que es el proceso de modelización estadística más sencillo y para entender como funciona se parte del gráfico de pares de puntos `(Rent.Index, Cost.of.Living.Index)`.

```r
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point()
```

![](/images/2023/02/wp_editor_md_76170b5018700fbb15a99a43f1fa0d96.jpg)

El método de mínimos cuadrados traza una función lineal que minimiza la distancia de todos los puntos presentes en los datos a esa función. No se entra en los matices algebraicos para la obtención de la recta de regresión ya que en `R` está implementado el método mediante la función `lm`.

```r
modelo.1 <- lm(data = cost_living, formula = Cost.of.Living.Index ~ Rent.Index)
```

Esta función es importante para conocer como se realizan los modelos en `R`. Evidentemente es necesario indicar los `data` de entrada pero también es necesario indicar la `formula`, de ahí la importancia de conocer como será el modelo matemático. Las `formula`s siempre son de la forma variable dependiente `~` variable/s independientes, en este caso es el modelo más sencillo posible `Cost.of.Living.Index ~ Rent.Index` pero se puede complicar y permitir crear modelos más complejos. Para describir el modelo se emplea la función `summary` sobre el objeto `modelo.1` creado con la función `lm`

```r
summary(modelo.1)
```

Esta salida es relevante. Contiene información sobre la `formula`, los residuos y los coeficientes del modelo generado, en este caso, los parámetros estimados crear una función de regresión:

$$Y = 32.28 + 0.99 \\cdot \\text{Rent.Index} + \\epsilon$$

¿Estos parámetros son adecuados?

Inferencia sobre los parámetros. En el apartado de la inferencia se parte con el `test F` de regresión que está en la última línea del `summary`, de hecho siempre se comenzará con esa última línea. Esa prueba `F` parte de la hipótesis nula de igualdad de medias y se obtiene un `p-valor` de 0 por lo que se puede rechazar la hipótesis nula, las medias son distintas, **se puede dar un modelo de regresión lineal**. Una vez comprobada la posibilidad de que exista un modelo de regresión la estimación de los parámetros tienen asociados una prueba `t` cuya $H_0$ es $\\beta_i=0$, es decir, el parámetro no aporta nada al modelo. Como es un modelo aditivo cuanto más próximo a 0 sea ese parámetro $\\beta$ menos aporta, en el caso concreto que está ilustrando este apartado se tiene que el `(intercepto)`, el $\\beta_0$, tiene un `p-valor` asociado al `test` de 0, por lo que se rechaza la hipótesis de «el parámetro no aporta al modelo», igual sucede con el parámetro asociado a `Rent.Index`, el $\\beta_1$. Ambos parámetros están aportando al modelo pero, además, hay otro elemento en la salida que tiene importancia, el `Adjusted R-squared` el $R^2$ que es una medida sobre la calidad del modelo que se verá más adelante.

Diagnóstico del modelo. Además del $R^2$ es necesario validar y diagnosticar si se cumplen todas las hipótesis del modelo lineal:

- Linealidad. Para estudiar esta situación en el modelo de regresión lineal simple puede servir el gráfico de puntos visto con anterioridad. En este primer ejemplo se va a emplear directamente la recta de regresión creada con el modelo. Para representar gráficamente esa recta es necesario `predict`, saber que valores está arrojando la recta de regresión y para ello en `R` está la función `predict` sobre el objeto `modelo.1` con la variable que participa en el modelo.

```r
estimacion.modelo.1 <- predict(object = modelo.1, data = cost_living)
estimacion.modelo.1 <- data.frame(prediccion_Cost.of.Living = estimacion.modelo.1)
estimacion.modelo.1$Rent.Index = cost_living$Rent.Index
head(estimacion.modelo.1)
```

Esta tarea de generar los datos estimados por la función matemática es **escorear unos datos** , es decir, escorear es obtener las estimaciones del modelo para unos datos. En el ejemplo es aplicar la función $$Y = 32.28 + 0.99 \\cdot \\text{Rent.Index} + \\epsilon$$ a una serie de datos que permita crear un _scoring_ o una variable predicha. En este caso se han escoreado los propios datos participantes en el modelo y permiten visualizar la recta de regresión en los gráficos de dispersión.

```r
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point() +
  geom_line(data = estimacion.modelo.1,
            aes(x = Rent.Index, y = prediccion_Cost.of.Living), color = "red") +
  ggtitle("Estudio de la linealidad")
```

![](/images/2023/02/wp_editor_md_76853c33cc19ab714608c10c0c693ed6.jpg)

¿Una recta describe esta nube de puntos? No lo parece, será necesario buscar una manera de salvar esa «no linealidad». Con una sola variable independiente es sencillo comprobar la linealidad, si se tienen más variables no será tan sencillo y por eso son fundamentales los dos siguientes supuestos que se basan en los **residuos del modelo de regresión**. Los residuos son la distancia entre esa recta de regresión y el dato real, son la diferencia entre lo obtenido por el modelo y lo observado. Si esa distancia no es normal y si no hay independencia entre los residuos es que el modelo lineal no está describiendo el comportamiento. Por lo que los otros supuestos a tener en cuenta son:

- Homocedasticidad. La varianza de los residuos ha de ser 0.

- Normalidad de residuos. Los residuos producidos por el modelo se distribuyen normally, nada afecta en mayor medida a un residuo.

- Independencia de residuos. No existe correlación entre los residuos producidos por el modelo.

Para diagnosticar los residuos se tienen los gráficos de diagnóstico de los residuos:

```r
par(mfrow = c(2, 2))
plot(modelo.1)
```

![](/images/2023/02/wp_editor_md_bfb0e6fac8ef4e919d40880b6c4c59aa.jpg)

En estos gráficos los datos deben estar en el entorno de esas líneas discontinuas sin que exista un patrón específico, no se entra en mayor profundidad porque es evidente que no se cumple, esta es una situación que suele dar lugar cuando se estudian teóricamente estos modelos.

La variable dependiente no sigue una distribución normal y no se cumplen los supuestos, no hay modelo. Esta impostura teórica hace que el científico de datos «huya» de los modelos lineales. Pero el coeficiente de correlación es 0.8, el $R^2$ es 0.66 y los parámetros son significativos, **hay modelo** , lo que sucede es que no está recogiendo el total del efecto lineal de la variable dependiente, el modelo es claramente mejorable.

## El coeficiente de determinación o $R^2$

El $R^2$ ha salido en varias ocasiones en el apartado anterior, es necesario conocer como funciona y las limitaciones que tiene a la hora de medir la capacidad predictiva del modelo. El coeficiente de determinación o $R^2$ es una **medida de la varianza** de la la variable dependiente que recoge la recta de regresión. Es un valor que va desde 0 a 1 donde 0 indica que el modelo es incapaz de medir la variabilidad de la variable dependiente y 1 significa que está recogiendo la totalidad de la variabilidad. Evidentemente, cuanto más próximo a 1 sea ese coeficiente más varianza recoge el modelo, mejor será ese modelo. El $R^2$ mide lo alejadas que están las observaciones de una recta, no indica que no exista relación lineal, nubes de puntos con mucha varianza pueden arrojar coeficientes de determinación menores para rectas de regresión adecuadas y eso no implica que el modelo sea malo.

El siguiente código está sacado del [blog de Carlos Gil, riguroso divulgador de temas estadísticos](https://www.datanalytics.com/2021/02/16/hay-mil-motivos-para-criticar-una-regresion-trucha-pero-una-r2-baja-no-es-uno-de-ellos/).

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_27aa7088505c0be990f2e6626c2821e4.jpg)

![](/images/2023/02/wp_editor_md_ba14629e0e5a0d63e5528780dcc3c253.jpg)

Para datos análogos el $R^2$ se reduce en función de la varianza de la nube de puntos. Un $R^2$ bajo no implica un mal modelo de regresión, puede implicar que la variable dependiente tenga una gran varianza. Sin embargo, un $R^2$ alto si implica que el modelo es aceptable, ¿umbrales para establecer que es alto? Dependerá del analista y el problema.

En el `summary` del modelo se tiene el `Multiple R-squared` y el `Adjusted R-squared`. El primero es el $R^2$ y el segundo es el $R^2$ ajustado por el número de variables presentes en el modelo. Se acostumbra a usar el ajustado por el número de variables del modelo. Se van a parecer mucho, sobre todo si se aplica el principio de parsimonia a los modelos que tendrá un apartado posterior.

## Transformaciones de variables

Una variable se puede transformar para mejorar un modelo de regresión lineal, se puede transformar tanto la variable respuesta como la variable independiente. Qué es transformar una variable, se ilustran ejemplos.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_c0c4f292f83dea53ba01f262f820d139.jpg)

Un dato lineal, si se transforma ya no es lineal, el científico de datos debe saber que un modelo lineal es una función lineal de su respuesta, pero no es lineal frente a sus parámetros. Puede recoger situaciones no lineales y no es necesario emplear complejos algoritmos para aislar esos comportamientos sin linealidad. Viendo los gráficos anteriores y aplicando una transformación al ejemplo de trabajo.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

La prueba `F` indica que hay modelo, el $R^2$ ahora se sitúa en 0.74 mejorando el dato anterior y ambos parámetros son significativos. Se realiza el `scoring` para pintar la recta en la nube de puntos.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_8f97959fc46ba93ceb4017a2a0b7b074.jpg)

Se aprecia que la transformación recoge ese comportamiento sin linealidad, ¿lo recoge por completo? Para ello se dispone del estudio de los residuos.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_bfb0e6fac8ef4e919d40880b6c4c59aa.jpg)

El primer gráfico recoge los residuos frente al ajuste, en estimaciones superiores a un índice de 80, -20% con respecto a `NYC`, hay un patrón que el modelo lineal no recoge. Lo corrobora el siguiente gráfico que estudia la normalidad de los residuos, falla en ambos extremos de la estimación pero más en estimaciones superiores. El gráfico de **scale – location** estudia la homocedasticidad, los residuos estudentizados deberían situarse sobre una línea central para asumir igualdad de varianza y esto no sucede. El último gráfico permite estudiar si hay residuos que estén influyendo sobre los resultados del modelo, se identifican la observación 12 y 14:

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

La propia Nueva York y San Francisco con un precio disparatado de los alquileres están afectando al modelo. Teóricamente el modelo no sirve porque no se cumplen las hipótesis, pero no es un mal modelo, el problema es que hay ciertas situaciones que no recoge. **Pero el modelo no se puede descartar** da igual lo que diga la teoría, el científico de datos tiene que separar la señal del ruido y es evidente que una simple función matemática está aislando el funcionamiento de la variable en estudio.

## Tramificación de variables en modelos lineales

Además de transformar una variable también es posible tramificarla para recoger mejor el comportamiento de una variable que dependa de ella. A lo largo de todo el ensayo se ha hecho mención a la importancia que tiene esta labor y los modelos lineales no son una excepción. A continuación se realiza ese ejercicio.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

De un modo muy rápido se ha trameado la variable respuesta en 5 tramos y el modelo ha generado 4 parámetros más el término independiente con un $R^2$ de 0.68 que mejora incluso al que se obtenía con el modelo inicial. Se realiza el `scoring` de modelo para ver como es el modelo resultante sobre la nube de puntos.

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_2ac5c719b375e997873d0843df022a08.jpg)

La mera tramificación de la variable, convertir una variable numérica en un factor, está salvando la linealidad pero se está trabajando con más de un parámetro, concretamente con 4 más el término independiente. Ya no se tiene una regresión linea simple ahora se tiene una **regresión lineal múltiple** y un parámetro ha pasado a crear 4, pero, ¿por qué la salida de `R` ofrece 4 parámetros cuando se ha tramificado la variable en 5 partes? Porque 4 parámetros son suficientes.

El modelo planteado tendría la siguiente forma:

$$Y = \\beta_0 + \\beta_1 \\cdot \\text{Rent.Index}_{1 \\le 15} + \\beta_2 \\cdot \\text{Rent.Index}_{16-30} + \\beta_3 \\cdot \\text{Rent.Index}_{31-45} + \\beta_4 \\cdot \\text{Rent.Index}_{46-60} + \\beta_5 \\cdot \\text{Rent.Index}\_{\\text{mas de 60}}$$

Donde cada $X_i$ es una variable que toma valores 0 y 1 en función del nivel del factor que tiene cada observación. Pero la salida de `R` es:

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

¿Dónde está el nivel `fr_Rent.Index1. <=15`? En realidad no hace falta, porque los modelos lineales que incluyen variables divididas en categorías crean variables «dummy», es decir, si la observación pertenece a esa categoría toma un 1 en caso contrario 0. De ese modo, si la ciudad del conjunto de datos tiene un `Rent.Index` de 18 estaría en la categoría «2. 16-30» y el `scoring` (la predicción) para ese valor sería `Y=36+24.77*1=60.77` porque pertenece a la categoría 2 luego se multiplica por su parámetro, si pertence a la categoría 1 `fr_Rent.Index1. <=15` que no tiene parámetro entonces se le aplica el término independiente 36 (como aparece en el gráfico anterior).

Como se ha esbozado con anterioridad, al transformar la variable a tramos, una variable en un modelo de regresión clásico es capaz de recoger efectos no lineales, pero está sacrificando algo: **sencillez**. Un modelo, cuantos más parámetros tenga más aumenta su complejidad y esto no es siempre positivo como se verá en capítulos posteriores.

## Factores en modelos de regresión

Este apartado es análogo a lo anteriormente tratado, pero se insiste en ello para que el científico de datos interprete correctamente los parámetros de un modelo de regresión. ¿Es distinto el valor del índice de costo en ciudades de `EEUU`, España y el resto del mundo?

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_67852b2a62c748b1d04c1b91a6bbcb35.jpg)

Se crea la variable empleando la función `grepl` que pertenece a las funciones de las _regular expressions_ y que sirven para la manipulación de texto, en este caso busca la existencia de patrones en cadenas de texto. Se aprecian comportamientos distintos para las distribuciones, ¿dónde se sitúan las medias?

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_43f5d22fc40191f192c8efe42cd3aeeb.jpg)

Con los datos disponibles, ¿son distintas las medias? ¿A qué recuerda esta cuestión? El modelo lineal ayuda a resolver estos análisis y además, los parámetros dicen mucho acerca de las variables.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_148dc4613a87ce9fce31ec5a37fa29b4.jpg)

Como se intuía la agrupación de paises del Resto del mundo no es un parámetro significativo, sin embargo, las ciudades de `EEUU` si tienen una media distinta estableciendo el `p-valor` habitual. Evidentemente el $R^2$ es muy bajo, pero este ejercicio también sirve al científico de datos para crear nuevas variables a partir de las disponibles y no ser un mero ejecutor de funciones informáticas.

## Modelo de regresión lineal múltiple

Ya se vio en el capítulo anterior que el modelo de regresión lineal múltiple es $$Y = \\beta_0 + X_1\\beta_1 + X_2\\beta_2 + \\dots + X_i\\beta_i + \\epsilon$$ con las mismas consideraciones teóricas que tiene el modelo de regresión simple:

- Escribir el modelo matemático

- Estimación de los parámetros del modelo

- Inferencia sobre los parámetros del modelo

- Diagnóstico del modelo

Pero hay que añadir una nueva, la **no relación lineal entre las variables independientes**. Cuando esto no se produce, es decir, hay relación lineal entre las variables independientes, entonces se tiene **multicolinealidad**. Esto es debido a la propia solución algebraica del modelo lineal múltiple, matricialmente se define como $$Y=\\beta X + \\epsilon$$ la estimación de los parámetros es $$\\beta = [X^tX]^{-1}$$ si existe alguna relación lineal entre alguna de las variables independientes `X` entonces $[X^tX]=0$ y una división por 0 es un problema. Por los motivos antes expuestos uno de los primeros pasos a la hora de hacer un modelo de regresión lineal múltiple será estudiar las correlaciones.

Continuando con el ejemplo anterior se plantea el mismo modelo de regresión lineal pero se van a añadir nuevas variables entre las disponibles por lo que ahora la variable `Cost.of.Living.Index` irá en función del resto de indicadores disponibles. El primer paso será estudiar gráficamente la relación lineal de la variable dependiente frente a las variables regresoras:

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_22c68d30af266820d41484d473be61ce.jpg)

Estos gráficos ya anticipan problemas. El índice está muy relacionado con todas las variables que se van a emplear en la regresión, no parece mala noticia, sin embargo, esa relación es muy parecida para todas las variables por lo que es imprescindible analizar si existe correlación entre las variables independientes. Para estudiar las correlaciones se dispone del coeficiente de correlación al que se hizo mención en el capítulo 11. Pero, se va a presentar una visualización que permite estudiar la correlación entre todas las variables que van a participar en el estudio, el **gráfico de correlaciones**.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_c1de7aa2fda5e8006b28ec9597b9b41a.jpg)

Este gráfico se obtiene con la librería `corrplot` y sólo es necesario crear previamente la matriz de correlaciones con todas las variables. Se observa que la variable `Cost.of.Living.Index` tiene una correlación muy alta con muchas de las variables que van a explicar su comportamiento pero es que estas variables entre sí también tienen una alta correlación. Esto ya da pistas sobre la posible existencia de la multicolinealidad. Además, se va a prescindir de la variable `Cost.of.Livin.Plus.Rent.Index` porque es el propio índice más `Rent.Index` y puede distorsionar el modelo. Con estas advertencias y consideraciones, se plantea el modelo:

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

Se dispone de un modelo con un excepcional $R^2$ donde la variable `Rent.Index` es la única que no supera el test de $\\beta_i=0$ algo que lo indica el propio valor del parámetro, muy próximo a 0. El resto de variables si superan el test. Con estas consideraciones es necesario replantear el modelo:

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

Ya se dispone de un modelo con todos los parámetros significativos, aunque `Local.Purchasing.Power.Index` no sería significativa si se fija un umbral más bajo de 0.002 ya que quedaría fuera de la región de aceptación. Con el primer modelo y teniendo en cuenta el anterior estudio de la correlación se torna necesario analizar la posible presencia de multicolinealidad. Hay diversos métodos para realizar esta tarea y se opta por ilustrar el ejemplo con el método `VIF` (`Variance Inflation Factor`). Si hay multicolinealidad $[X^tX]=0$ está «inflando» la varianza, ¿cuánto infla la varianza una variable dentro del modelo? Para determinar como está afectando se va a utilizar la librería de `R` `car`

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

La función `vif` calcula cuanto está inflando la varianza del modelo cada variable, valores por encima de 8 indican un problema, valores por encima de 4 indican la necesidad de analizar las variables en el modelo. En este modelo sólo `Restaurant.Price.Index` está causando problemas, está en manos del científico de datos eliminar la variable del modelo o transformarla para evitar problemas pero, como siempre, tiene que argumentar su eliminación. En este caso se opta por dejar el `modelo.5` como modelo definitivo y por último es necesario estudiar el comportamiento de los residuos.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_32d2183e23632c5098177565e3d21408.jpg)

Desde el punto de vista teórico se dispone de un modelo aceptable, **hay linealidad** , pero los residuos «pierden» normalidad y pierden homogeneidad de varianza en valores altos. Se pueden identificar los registros, las ciudades que están causando problemas en el modelo.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

Muchas ciudades suizas están causando problemas en el modelo, parece que la estimación siempre está por encima probablemente debido al alto coste de la alimentación. En este caso el análisis de los residuos está ofreciendo un comportamiento interesante en los datos y por este motivo el científico de datos debe estudiar esta diferencia entre lo estimado y lo real porque las observaciones que no ajustan correctamente también pueden ofrecer información al análisis.

## Métodos de selección de variables

En el apartado anterior se han introducido los modelos de regresión con múltiples variables, la selección de éstas se ha llevado a cabo en base a los criterios del analista. Se recomienda que el científico de datos participe en todo el proceso de modelización pero existen situaciones en las que se disponen de multitud de variables y ese análisis pormenorizado puede convertirse en ardua tarea. Por ello, es necesario conocer los métodos automáticos de selección de variables. En los modelos de regresión se plantean 3 formas de seleccionar variables, el método `fordward`, método `backward` y método `stepwise`.

En este ensayo se van a ilustrar los tres métodos basando la capacidad predictiva de cada método en el **criterio de información de Akaike** conocido como `AIC`. Al igual que el $R^2$ el `AIC` es una medida de lo correcto que es el ajuste pero está ponderado por el número de parámetros del modelo, sin entrar en aspectos teóricos cuanto menor es el `AIC` mejor es el modelo y si una variable no disminuye el `AIC`, no lo mejora sustancialmente, esta variable será prescindible.

### Método `fordward`

Se parte del modelo más sencillo posible y a éste se le irán introduciendo variables que vayan mejorando el `AIC`. La fórmula del modelo más sencillo posible será:

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

La fórmula del modelo más completo posible será:

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

Partiendo del inicio paso a paso se llegará al modelo seleccionado mediante la dirección `fordward`. Para realizar esta tarea se emplea la librería `MASS`.

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

Con `trace = T` se indica que se puedan ver los pasos seguidos en el proceso, inicialmente entra la variable `Groceries.Index`, seguida de `Restaurant.Price.Index` que reduce lo suficiente el `AIC` y por último `Local.Purchasing.Power.Index` con una reducción del `AIC` mucho menor que la anterior pero el modelo cada vez era más completo. El modelo resultante es análogo al planteado de forma manual con anterioridad.

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

### Método `backward`

El sentido contrario al método `fordward`, se parte del modelo completo y se determina que variable es candidata a salir porque el `AIC` del modelo no se ve alterado.

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

Se aprecia que el `AIC` sin la variable `Rent.Index` se queda en 1189.3 por lo que es candidata a ser eliminada. En el segundo paso ninguna variable es candidata a salir por lo que se paran las iteraciones y se crea un modelo final igual a los obtenidos con anterioridad.

### Método `stepwise`

Este método de selección de variables es una combinación de los dos anteriores, se parte del modelo y se evalúa que variable es candidata a salir y de las variables eliminadas se vuelve a evaluar si es candidata a entrar en el modelo.

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

El primer paso es igual al empleado en el modelo `backward` saliendo `Rent.Index` pero no hay más candidatas a salir o a entrar por lo que se llega al mismo resultado.

Se recomienda que el científico de datos genere sus propias herramientas para la selección argumentada de variables, pero es necesario conocer estos métodos porque se presentarán situaciones en las que se tenga cientos de variables regresoras y una selección automática de variables puede ser el primer paso para elegir las variables presentes en el modelo. En cualquier caso, se recomienda no incluir un gran número de variables en los modelos de regresión.

## El principio de parsimonia

El principio de parsimonia en los modelos de regresión consiste en buscar modelos con el menor número posible de parámetros ya que la presencia de múltiples parámetros puede hacer que existan relaciones lineales debidas al azar. Para ilustrar esta situación se realiza una simulación.

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
```

Partiendo de datos completamente aleatorios el `test F` está muy próximo a 0.05 por lo que existe modelo y por si fuera poco hay variables significativas, esto sucede porque hay un gran número de parámetros y la regresión lineal no maneja bien esta situación, por este motivo, no se recomienda realizar modelos de regresión lineal con más de 10 variables independientes ya que pueden aparecer relaciones debidas al puro azar.

```
```
