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

En el capítulo 11, dedicado al análisis bivariable, se indicó que el inicio de la relación entre dos variables era la correlación; pues la regresión lineal es el principio de la modelización estadística. Evidentemente no es lo mismo, pero establecer una analogía entre ambos conceptos permite entender los objetivos de la regresión lineal:

![](/images/2023/02/wp_editor_md_7b9c707bc0b1203c627b7794f374e005.jpg)

[En este enlace de la recomendada web de Joaquín Amat](https://www.cienciadedatos.net/documentos/24_correlacion_y_regresion_lineal) se trata con mayor detenimiento esta relación. Como se indica en la figura, ahora es una variable la que afecta a otra y es necesario crear una recta de regresión que exprese cómo se modifica una variable dependiente en función de otra variable independiente o regresora. Si sólo hay una variable independiente se trata de un modelo de regresión lineal simple; si hay más de una variable es un modelo de regresión lineal múltiple.

## Modelo de regresión lineal simple

La variación de una variable afecta a otra según una función lineal, por lo que será necesario crear esa función, calcular los parámetros más adecuados para esa función, decidir si esos parámetros se adecuan o no y medir si el modelo es correcto. Es decir, para plantear un modelo de regresión lineal simple es necesario seguir los siguientes pasos:

- Escribir el modelo matemático.
- Estimación de los parámetros del modelo.
- Inferencia sobre los parámetros del modelo.
- Diagnóstico del modelo.

Es el modelo más sencillo ya que gráficamente se puede *intuir* cómo va a ser esa relación lineal. En este caso, no es posible seguir el ejemplo de trabajo que sirve de hilo conductor del ensayo y por ello es necesario emplear otros datos.

```r
# install.packages("skimr")
library(skimr)
library(tidyverse)

cost_living <- read.csv("./data/Cost_of_living_index.csv")
skim(cost_living)
```

![](/images/2023/02/wp_editor_md_0383e3977c3493ac8f49dfe25abe2765.jpg)

Se trata de un [conjunto de datos extraído de Kaggle](https://www.kaggle.com/datasets/debdutta/cost-of-living-index-by-country?select=Cost_of_living_index.csv) que dispone de un índice del coste de la vida para 536 ciudades donde Nueva York es la base que relativiza el índice; es decir, si una ciudad tiene un valor de 120 en un dato, éste está un $20\%$ por encima de Nueva York. No se realiza un análisis EDA; en su lugar se emplea la librería `skim` para obtener los estadísticos básicos que permitan describir las variables disponibles, que se definen del siguiente modo:

- `Rank`: posición de la ciudad.
- `Cost.of.Living.Index`: (excluido el alquiler) es un indicador relativo de los precios de los bienes de consumo, incluidos comestibles, restaurantes, transporte y servicios públicos. No incluye gastos de alojamiento como alquiler o hipoteca.
- `Rent.Index`: es una estimación de los precios de alquiler de apartamentos en la ciudad en comparación con la ciudad de Nueva York.
- `Cost.of.Living.Plus.Rent.Index`: es una estimación de los precios de los bienes de consumo, incluido el alquiler, en comparación con la ciudad de Nueva York.
- `Groceries.Index`: es una estimación de los precios de los comestibles en la ciudad en comparación con la ciudad de Nueva York. Para el cálculo se usan pesos de artículos en la sección "Mercados" para cada ciudad.
- `Restaurant.Price.Index`: es una comparación de precios de comidas y bebidas en restaurantes y bares en comparación con la ciudad de Nueva York.
- `Local.Purchasing.Power.Index`: muestra el poder adquisitivo relativo en la compra de bienes y servicios en una ciudad dada por el salario promedio en esa ciudad. Si el poder adquisitivo doméstico es 40, esto significa que los habitantes de esa ciudad con el salario promedio pueden permitirse comprar en promedio un $60\%$ menos de bienes y servicios que los residentes de la ciudad de Nueva York con un salario promedio.

En este ejercicio se pretende crear un modelo de regresión lineal simple que permita estimar el indicador del costo de la vida en función del precio del alquiler. Siguiendo los pasos necesarios para realizar el modelo se tiene:

**Modelo matemático**: El modelo será $Y = \beta_0 + \beta_1 X + \epsilon$. Esta fórmula, que recuerda a la ecuación punto-pendiente de una recta, es el principio de la modelización estadística y tiene en pocos componentes todo lo necesario para comenzar a entender cómo funciona. Se desea estimar el valor de $Y$, que es la variable dependiente (costo de la vida por ciudad); para estimar ese valor se crea una recta de regresión que *empieza* (que corta el eje) desde un punto inicial $\beta_0$ y tiene una pendiente $\beta_1$ que modifica linealmente $X$ (la variable independiente), pero no es posible que el modelo describa perfectamente la variable dependiente y por ello aparece el término error $\epsilon$. En el ejemplo de trabajo la función sería: $\text{Cost.of.Living.Index} = \beta_0 + \beta_1 \cdot \text{Rent.Index} + \epsilon$.

Este modelo matemático implica que la variable dependiente se modifica en función de una variable independiente de forma aditiva. Recordando temas anteriores, ¿qué distribución se modificaba de forma aditiva? La distribución normal; la variable `Cost.of.Living.Index` ha de distribuirse normally. Para comprobar si una variable sigue una distribución normal se puede emplear el gráfico de densidad:

```r
cost_living %>% ggplot(aes(x = Cost.of.Living.Index)) + geom_density()
```

![](/images/2023/02/wp_editor_md_cf9b737a96ad6bbad035db4d22a77272.jpg)

No se distribuye normally y, para corroborarlo, se dispone de gráficos QQ que comparan los cuantiles de la distribución normal frente a los cuantiles de la distribución de una variable.

```r
qqnorm(cost_living$Cost.of.Living.Index)
qqline(cost_living$Cost.of.Living.Index)
```

![](/images/2023/02/wp_editor_md_5c66b2d879a47a99fb581d72af04e846.jpg)

Más que evidente que no se distribuye normally, ya que muchos puntos de la distribución están alejados de la recta que marca los cuantiles teóricos de la distribución normal. Entonces, **¿no es posible realizar un modelo lineal?**. Se calcula el coeficiente de correlación lineal entre las variables:

```r
cor(cost_living$Cost.of.Living.Index, cost_living$Rent.Index)
# [1] 0.8123
```

¿Con un coeficiente de correlación lineal superior a 0.8 no va a ser posible crear un modelo de regresión lineal? **Sí es posible**, porque el científico de datos busca separar el azar de lo estadísticamente significativo; en su trabajo diario no va a realizar modelos teóricos ideales.

**Estimación de los parámetros del modelo**: Los parámetros son esos elementos $\beta$ presentes en la definición del modelo. Esta labor se realiza mediante mínimos cuadrados, que es el proceso de modelización estadística más sencillo; para entender cómo funciona se parte del gráfico de pares de puntos `(Rent.Index, Cost.of.Living.Index)`.

```r
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point()
```

![](/images/2023/02/wp_editor_md_76170b5018700fbb15a99a43f1fa0d96.jpg)

El método de mínimos cuadrados traza una función lineal que minimiza la distancia de todos los puntos presentes en los datos a esa función. No se entra en los matices algebraicos para la obtención de la recta de regresión ya que en R está implementado el método mediante la función `lm`.

```r
modelo.1 <- lm(data = cost_living, formula = Cost.of.Living.Index ~ Rent.Index)
```

Esta función es importante para conocer cómo se realizan los modelos en R. Evidentemente es necesario indicar los `data` de entrada, pero también es necesario indicar la `formula`; de ahí la importancia de conocer cómo será el modelo matemático. Las `formula`s siempre son de la forma `variable dependiente ~ variable/s independientes`; en este caso es el modelo más sencillo posible: `Cost.of.Living.Index ~ Rent.Index`, pero se puede complicar y permitir crear modelos más complejos. Para describir el modelo se emplea la función `summary` sobre el objeto `modelo.1` creado con la función `lm`.

```r
summary(modelo.1)
```

Esta salida es relevante. Contiene información sobre la `formula`, los residuos y los coeficientes del modelo generado; en este caso, los parámetros estimados crean una función de regresión:

$$ Y = 32.28 + 0.99 \cdot \text{Rent.Index} + \epsilon $$

¿Estos parámetros son adecuados?

**Inferencia sobre los parámetros**: En el apartado de la inferencia se parte con el test $F$ de regresión que está en la última línea del `summary`; de hecho siempre se comenzará con esa última línea. Esa prueba $F$ parte de la hipótesis nula de igualdad de medias y se obtiene un p-valor de 0, por lo que se puede rechazar la hipótesis nula: las medias son distintas, **se puede dar un modelo de regresión lineal**. Una vez comprobada la posibilidad de que exista un modelo de regresión, la estimación de los parámetros tiene asociada una prueba $t$ cuya $H_0$ es $\beta_i = 0$, es decir, el parámetro no aporta nada al modelo. Como es un modelo aditivo, cuanto más próximo a 0 sea ese parámetro $\beta$, menos aporta. En el caso concreto que está ilustrando este apartado se tiene que el `(Intercept)`, el $\beta_0$, tiene un p-valor asociado al test de 0, por lo que se rechaza la hipótesis de "el parámetro no aporta al modelo"; igual sucede con el parámetro asociado a `Rent.Index`, el $\beta_1$. Ambos parámetros están aportando al modelo pero, además, hay otro elemento en la salida que tiene importancia: el `Adjusted R-squared`, el $R^2$, que es una medida sobre la calidad del modelo que se verá más adelante.

**Diagnóstico del modelo**: Además del $R^2$, es necesario validar y diagnosticar si se cumplen todas las hipótesis del modelo lineal:

- **Linealidad**: Para estudiar esta situación en el modelo de regresión lineal simple puede servir el gráfico de puntos visto con anterioridad. En este primer ejemplo se va a emplear directamente la recta de regresión creada con el modelo. Para representar gráficamente esa recta es necesario usar `predict`: saber qué valores está arrojando la recta de regresión. Para ello, en R está la función `predict` sobre el objeto `modelo.1` con la variable que participa en el modelo.

```r
estimacion.modelo.1 <- predict(object = modelo.1, newdata = cost_living)
estimacion.modelo.1 <- data.frame(prediccion_Cost.of.Living = estimacion.modelo.1)
estimacion.modelo.1$Rent.Index = cost_living$Rent.Index
head(estimacion.modelo.1)
```

Esta tarea de generar los datos estimados por la función matemática es **escorear unos datos**, es decir, escorear es obtener las estimaciones del modelo para unos datos. En el ejemplo es aplicar la función $Y = 32.28 + 0.99 \cdot \text{Rent.Index}$ a una serie de datos que permita crear un *scoring* o una variable predicha. En este caso se han escoreado los propios datos participantes en el modelo y permiten visualizar la recta de regresión en los gráficos de dispersión.

```r
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point() +
  geom_line(data = estimacion.modelo.1,
            aes(x = Rent.Index, y = prediccion_Cost.of.Living), color = "red") +
  ggtitle("Estudio de la linealidad")
```

![](/images/2023/02/wp_editor_md_76853c33cc19ab714608c10c0c693ed6.jpg)

¿Una recta describe esta nube de puntos? No lo parece; será necesario buscar una manera de salvar esa "no linealidad". Con una sola variable independiente es sencillo comprobar la linealidad; si se tienen más variables no será tan sencillo y por eso son fundamentales los dos siguientes supuestos, que se basan en los **residuos del modelo de regresión**. Los residuos son la distancia entre esa recta de regresión y el dato real; son la diferencia entre lo obtenido por el modelo y lo observado. Si esa distancia no es normal y si no hay independencia entre los residuos es que el modelo lineal no está describiendo el comportamiento. Por lo que los otros supuestos a tener en cuenta son:

- **Homocedasticidad**: La varianza de los residuos ha de ser constante.
- **Normalidad de residuos**: Los residuos producidos por el modelo se distribuyen normally; nada afecta en mayor medida a un residuo.
- **Independencia de residuos**: No existe correlación entre los residuos producidos por el modelo.

Para diagnosticar los residuos se tienen los gráficos de diagnóstico de los residuos:

```r
par(mfrow = c(2, 2))
plot(modelo.1)
```

![](/images/2023/02/wp_editor_md_bfb0e6fac8ef4e919d40880b6c4c59aa.jpg)

En estos gráficos los datos deben estar en el entorno de esas líneas discontinuas sin que exista un patrón específico; no se entra en mayor profundidad porque es evidente que no se cumple. Esta es una situación que suele darse cuando se estudian teóricamente estos modelos.

La variable dependiente no sigue una distribución normal y no se cumplen los supuestos: no hay modelo. Esta impostura teórica hace que el científico de datos "huya" de los modelos lineales. Pero el coeficiente de correlación es 0.8, el $R^2$ es 0.66 y los parámetros son significativos: **hay modelo**; lo que sucede es que no está recogiendo el total del efecto lineal de la variable dependiente, el modelo es claramente mejorable.

## El coeficiente de determinación o $R^2$

El $R^2$ ha salido en varias ocasiones en el apartado anterior; es necesario conocer cómo funciona y las limitaciones que tiene a la hora de medir la capacidad predictiva del modelo. El coeficiente de determinación o $R^2$ es una **medida de la varianza** de la variable dependiente que recoge la recta de regresión. Es un valor que va desde 0 a 1, donde 0 indica que el modelo es incapaz de medir la variabilidad de la variable dependiente y 1 significa que está recogiendo la totalidad de la variabilidad. Evidentemente, cuanto más próximo a 1 sea ese coeficiente más varianza recoge el modelo, mejor será ese modelo. El $R^2$ mide lo alejadas que están las observaciones de una recta; no indica que no exista relación lineal: nubes de puntos con mucha varianza pueden arrojar coeficientes de determinación menores para rectas de regresión adecuadas y eso no implica que el modelo sea malo.

El siguiente código está sacado del [blog de Carlos Gil, riguroso divulgador de temas estadísticos](https://www.datanalytics.com/2021/02/16/hay-mil-motivos-para-criticar-una-regresion-trucha-pero-una-r2-baja-no-es-uno-de-ellos/).

```r
set.seed(123)
x <- runif(100)
y <- 2 * x + rnorm(100, sd = 0.1)
modelo_alto <- lm(y ~ x)
summary(modelo_alto)$r.squared

y2 <- 2 * x + rnorm(100, sd = 0.5)
modelo_bajo <- lm(y2 ~ x)
summary(modelo_bajo)$r.squared
```

![](/images/2023/02/wp_editor_md_27aa7088505c0be990f2e6626c2821e4.jpg)

![](/images/2023/02/wp_editor_md_ba14629e0e5a0d63e5528780dcc3c253.jpg)

Para datos análogos, el $R^2$ se reduce en función de la varianza de la nube de puntos. Un $R^2$ bajo no implica un mal modelo de regresión; puede implicar que la variable dependiente tenga una gran varianza. Sin embargo, un $R^2$ alto sí implica que el modelo es aceptable. ¿Umbrales para establecer qué es alto? Dependerá del analista y el problema.

En el `summary` del modelo se tiene el `Multiple R-squared` y el `Adjusted R-squared`. El primero es el $R^2$ y el segundo es el $R^2$ ajustado por el número de variables presentes en el modelo. Se acostumbra a usar el ajustado por el número de variables del modelo. Se van a parecer mucho, sobre todo si se aplica el principio de parsimonia a los modelos, que tendrá un apartado posterior.

## Transformaciones de variables

Una variable se puede transformar para mejorar un modelo de regresión lineal; se puede transformar tanto la variable respuesta como la variable independiente. Qué es transformar una variable: se ilustran ejemplos.

```r
# Transformación logarítmica
cost_living %>% ggplot(aes(x = log(Rent.Index), y = Cost.of.Living.Index)) + geom_point()
```

![](/images/2023/02/wp_editor_md_c0c4f292f83dea53ba01f262f820d139.jpg)

Un dato lineal, si se transforma, ya no es lineal. El científico de datos debe saber que un modelo lineal es una función lineal de su respuesta, pero no es lineal frente a sus parámetros. Puede recoger situaciones no lineales y no es necesario emplear complejos algoritmos para aislar esos comportamientos sin linealidad. Viendo los gráficos anteriores y aplicando una transformación al ejemplo de trabajo:

```r
modelo.3 <- lm(data = cost_living, Cost.of.Living.Index ~ log(Rent.Index))
summary(modelo.3)
```

La prueba $F$ indica que hay modelo, el $R^2$ ahora se sitúa en 0.74, mejorando el dato anterior, y ambos parámetros son significativos. Se realiza el *scoring* del modelo para pintar la curva en la nube de puntos.

```r
estimacion.modelo.3 <- predict(modelo.3, newdata = cost_living)
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point() +
  geom_line(aes(y = estimacion.modelo.3), color = "red")
```

![](/images/2023/02/wp_editor_md_8f97959fc46ba93ceb4017a2a0b7b074.jpg)

Se aprecia que la transformación recoge ese comportamiento sin linealidad. ¿Lo recoge por completo? Para ello se dispone del estudio de los residuos.

```r
par(mfrow = c(2, 2))
plot(modelo.3)
```

El primer gráfico recoge los residuos frente al ajuste: en estimaciones superiores a un índice de 80 ($-20\%$ con respecto a NYC), hay un patrón que el modelo lineal no recoge. Lo corrobora el siguiente gráfico que estudia la normalidad de los residuos: falla en ambos extremos de la estimación, pero más en estimaciones superiores. El gráfico de *scale-location* estudia la homocedasticidad: los residuos estudentizados deberían situarse sobre una línea central para asumir igualdad de varianza, y esto no sucede. El último gráfico permite estudiar si hay residuos que estén influyendo sobre los resultados del modelo; se identifican las observaciones 12 y 14:

```r
cost_living[c(12, 14), ]
```

La propia Nueva York y San Francisco, con un precio disparatado de los alquileres, están afectando al modelo. Teóricamente el modelo no sirve porque no se cumplen las hipótesis, pero no es un mal modelo; el problema es que hay ciertas situaciones que no recoge. **Pero el modelo no se puede descartar**: da igual lo que diga la teoría, el científico de datos tiene que separar la señal del ruido y es evidente que una simple función matemática está aislando el funcionamiento de la variable en estudio.

## Tramificación de variables en modelos lineales

Además de transformar una variable, también es posible tramificarla para recoger mejor el comportamiento de una variable que dependa de ella. A lo largo de todo el ensayo se ha hecho mención a la importancia que tiene esta labor, y los modelos lineales no son una excepción. A continuación se realiza ese ejercicio.

```r
cost_living <- cost_living %>%
  mutate(fr_Rent.Index = case_when(
    Rent.Index <= 15 ~ "1. <=15",
    Rent.Index <= 30 ~ "2. 16-30",
    Rent.Index <= 45 ~ "3. 31-45",
    Rent.Index <= 60 ~ "4. 46-60",
    TRUE ~ "5. más de 60"
  ))

modelo.4 <- lm(data = cost_living, Cost.of.Living.Index ~ fr_Rent.Index)
summary(modelo.4)
```

De un modo muy rápido se ha tramificado la variable independiente en 5 tramos y el modelo ha generado 4 parámetros más el término independiente con un $R^2$ de 0.68, que mejora incluso al que se obtenía con el modelo inicial. Se realiza el *scoring* del modelo para ver cómo es el modelo resultante sobre la nube de puntos.

```r
estimacion.modelo.4 <- predict(modelo.4, newdata = cost_living)
cost_living %>% ggplot(aes(x = Rent.Index, y = Cost.of.Living.Index)) +
  geom_point() +
  geom_line(aes(y = estimacion.modelo.4), color = "red")
```

![](/images/2023/02/wp_editor_md_2ac5c719b375e997873d0843df022a08.jpg)

La mera tramificación de la variable, convertir una variable numérica en un factor, está salvando la linealidad pero se está trabajando con más de un parámetro, concretamente con 4 más el término independiente. Ya no se tiene una regresión lineal simple, ahora se tiene una **regresión lineal múltiple** y un parámetro ha pasado a crear 4. Pero, ¿por qué la salida de R ofrece 4 parámetros cuando se ha tramificado la variable en 5 partes? Porque 4 parámetros son suficientes.

El modelo planteado tendría la siguiente forma:

$$ Y = \beta_0 + \beta_1 X_{16-30} + \beta_2 X_{31-45} + \beta_3 X_{46-60} + \beta_4 X_{>60} $$

Donde cada $X_i$ es una variable que toma valores 0 y 1 en función del nivel del factor que tiene cada observación. Pero la salida de R es:

```text
Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)               36.000      1.145  31.429   <2e-16 ***
fr_Rent.Index2. 16-30     24.773      1.328  18.654   <2e-16 ***
...
```

¿Dónde está el nivel `fr_Rent.Index1. <=15`? En realidad no hace falta, porque los modelos lineales que incluyen variables divididas en categorías crean variables "dummy"; es decir, si la observación pertenece a esa categoría toma un 1, en caso contrario 0. De ese modo, si la ciudad del conjunto de datos tiene un `Rent.Index` de 18 estaría en la categoría "2. 16-30" y el *scoring* (la predicción) para ese valor sería $Y = 36 + 24.77 \times 1 = 60.77$. Si pertenece a la categoría 1 `fr_Rent.Index1. <=15`, que no tiene parámetro, entonces se le aplica el término independiente 36 (como aparece en el gráfico anterior).

Como se ha esbozado con anterioridad, al transformar la variable a tramos, una variable en un modelo de regresión clásico es capaz de recoger efectos no lineales, pero está sacrificando algo: **sencillez**. Un modelo, cuantos más parámetros tenga, más aumenta su complejidad, y esto no es siempre positivo como se verá en capítulos posteriores.

## Factores en modelos de regresión

Este apartado es análogo a lo anteriormente tratado, pero se insiste en ello para que el científico de datos interprete correctamente los parámetros de un modelo de regresión. ¿Es distinto el valor del índice de costo en ciudades de EEUU, España y el resto del mundo?

```r
cost_living <- cost_living %>%
  mutate(fr_zona = case_when(
    grepl(", United States", City) ~ "EEUU",
    grepl(", Spain", City) ~ "España",
    TRUE ~ "Resto mundo"
  ))

cost_living %>% ggplot(aes(x = Cost.of.Living.Index, fill = fr_zona)) + geom_density(alpha = 0.5)
```

![](/images/2023/02/wp_editor_md_67852b2a62c748b1d04c1b91a6bbcb35.jpg)

Se crea la variable empleando la función `grepl`, que busca la existencia de patrones en cadenas de texto. Se aprecian comportamientos distintos para las distribuciones. ¿Dónde se sitúan las medias?

```r
cost_living %>% group_by(fr_zona) %>% summarise(media = mean(Cost.of.Living.Index))
```

Con los datos disponibles, ¿son distintas las medias? ¿A qué recuerda esta cuestión? El modelo lineal ayuda a resolver estos análisis y, además, los parámetros dicen mucho acerca de las variables.

```r
modelo_zona <- lm(data = cost_living, Cost.of.Living.Index ~ fr_zona)
summary(modelo_zona)
```

Como se intuía, la agrupación de países del Resto del mundo no es un parámetro significativo (si se toma como base España, por ejemplo); sin embargo, las ciudades de EEUU sí tienen una media distinta. Evidentemente el $R^2$ es muy bajo, pero este ejercicio también sirve al científico de datos para crear nuevas variables a partir de las disponibles y no ser un mero ejecutor de funciones informáticas.

## Modelo de regresión lineal múltiple

Ya se vio que el modelo de regresión lineal múltiple es $Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \dots + \beta_i X_i + \epsilon$, con las mismas consideraciones teóricas que tiene el modelo de regresión simple:

- Escribir el modelo matemático.
- Estimación de los parámetros del modelo.
- Inferencia sobre los parámetros del modelo.
- Diagnóstico del modelo.

Pero hay que añadir una nueva: la **no relación lineal entre las variables independientes**. Cuando esto no se produce (hay relación lineal entre las variables independientes), se tiene **multicolinealidad**. Esto es debido a la propia solución algebraica del modelo lineal múltiple: matricialmente se define como $Y = X \beta + \epsilon$; la estimación de los parámetros es $\beta = [X^tX]^{-1} X^t Y$. Si existe alguna relación lineal entre algunas de las variables independientes $X$, entonces el determinante de $X^tX$ es 0 y no se puede invertir. Por los motivos antes expuestos, uno de los primeros pasos a la hora de hacer un modelo de regresión lineal múltiple será estudiar las correlaciones.

Continuando con el ejemplo anterior, se plantea el mismo modelo de regresión lineal pero se van a añadir nuevas variables entre las disponibles. El primer paso será estudiar gráficamente la relación lineal de la variable dependiente frente a las variables regresoras:

```r
pairs(cost_living[, 3:7])
```

![](/images/2023/02/wp_editor_md_22c68d30af266820d41484d473be61ce.jpg)

Estos gráficos ya anticipan problemas. El índice está muy relacionado con todas las variables que se van a emplear en la regresión; no parece mala noticia, sin embargo, esa relación es muy parecida para todas las variables, por lo que es imprescindible analizar si existe correlación entre las variables independientes. Se va a presentar una visualización que permite estudiar la correlación entre todas las variables que van a participar en el estudio: el **gráfico de correlaciones**.

```r
library(corrplot)
m_cor <- cor(cost_living[, 3:8])
corrplot(m_cor, method = "circle")
```

![](/images/2023/02/wp_editor_md_c1de7aa2fda5e8006b28ec9597b9b41a.jpg)

Se observa que la variable `Cost.of.Living.Index` tiene una correlación muy alta con muchas de las variables que van a explicar su comportamiento, pero es que estas variables entre sí también tienen una alta correlación. Esto ya da pistas sobre la posible existencia de multicolinealidad. Además, se va a prescindir de la variable `Cost.of.Living.Plus.Rent.Index` porque es una combinación del propio índice y `Rent.Index` y puede distorsionar el modelo. Con estas advertencias y consideraciones, se plantea el modelo:

```r
modelo.5 <- lm(data = cost_living, Cost.of.Living.Index ~ Rent.Index + Groceries.Index + Restaurant.Price.Index + Local.Purchasing.Power.Index)
summary(modelo.5)
```

Se dispone de un modelo con un excepcional $R^2$, donde la variable `Rent.Index` es la única que no supera el test de $\beta_i = 0$. Con estas consideraciones, es necesario replantear el modelo eliminando esa variable:

```r
modelo.6 <- lm(data = cost_living, Cost.of.Living.Index ~ Groceries.Index + Restaurant.Price.Index + Local.Purchasing.Power.Index)
summary(modelo.6)
```

Ya se dispone de un modelo con todos los parámetros significativos. Con el primer modelo y teniendo en cuenta el anterior estudio de la correlación, se torna necesario analizar la posible presencia de multicolinealidad mediante el método **VIF** (*Variance Inflation Factor*).

```r
library(car)
vif(modelo.5)
```

La función `vif` calcula cuánto está inflando la varianza del modelo cada variable; valores por encima de 8 indican un problema, valores por encima de 4 indican la necesidad de analizar las variables en el modelo. En este caso, sólo `Restaurant.Price.Index` podría estar causando ciertos problemas. En este caso se opta por dejar el `modelo.6` como modelo definitivo y, por último, estudiar el comportamiento de los residuos.

```r
par(mfrow = c(2, 2))
plot(modelo.6)
```

![](/images/2023/02/wp_editor_md_32d2183e23632c5098177565e3d21408.jpg)

Desde el punto de vista teórico se dispone de un modelo aceptable (hay linealidad), pero los residuos "pierden" normalidad y pierden homogeneidad de varianza en valores altos. Se pueden identificar los registros que están causando problemas en el modelo (ciudades suizas, por ejemplo). El análisis de los residuos está ofreciendo un comportamiento interesante: las observaciones que no ajustan correctamente también pueden ofrecer información al análisis.

## Métodos de selección de variables

Existen situaciones en las que se dispone de multitud de variables y el análisis pormenorizado puede convertirse en ardua tarea. Por ello, es necesario conocer los métodos automáticos de selección de variables: `forward`, `backward` y `stepwise`.

Se van a ilustrar basando la capacidad predictiva de cada método en el **criterio de información de Akaike** (AIC). Cuanto menor es el AIC, mejor es el modelo; si una variable no disminuye el AIC, es prescindible.

### Método `forward`

Se parte del modelo más sencillo posible y se van introduciendo variables:

```r
library(MASS)
base <- lm(Cost.of.Living.Index ~ 1, data = cost_living)
completo <- lm(Cost.of.Living.Index ~ Rent.Index + Groceries.Index + Restaurant.Price.Index + Local.Purchasing.Power.Index, data = cost_living)

modelo_forward <- stepAIC(base, direction = "forward", scope = list(lower = base, upper = completo), trace = TRUE)
```

### Método `backward`

Se parte del modelo completo y se eliminan variables:

```r
modelo_backward <- stepAIC(completo, direction = "backward", trace = TRUE)
```

### Método `stepwise`

Combinación de los dos anteriores:

```r
modelo_stepwise <- stepAIC(base, direction = "both", scope = list(upper = completo), trace = TRUE)
```

Se recomienda que el científico de datos genere sus propias herramientas para la selección argumentada de variables, pero es necesario conocer estos métodos para cuando se tengan cientos de variables regresoras.

## El principio de parsimonia

Consiste en buscar modelos con el menor número posible de parámetros, ya que la presencia de múltiples parámetros puede hacer que existan relaciones lineales debidas al azar.

```r
# Simulación con datos aleatorios
n_vars <- 50
df_azar <- data.frame(replicate(n_vars, rnorm(100)))
df_azar$y <- rnorm(100)
summary(lm(y ~ ., data = df_azar))
```

Partiendo de datos aleatorios, si hay muchos parámetros, pueden aparecer variables significativas por puro azar. Por este motivo, no se recomienda realizar modelos de regresión lineal con excesivas variables independientes.

```