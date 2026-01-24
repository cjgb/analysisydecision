---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - machine learning
  - modelos
  - monográficos
  - r
date: '2022-12-08'
lastmod: '2025-07-13'
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-6-descripcion-numerica-de-variables.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-15-modelos-glm-regresion-logistica-y-regresion-de-poisson.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
  - monografico-analisis-de-factores-con-r-una-introduccion.md
  - monografico-regresion-logistica-con-r.md
tags:
  - formación
  - libro estadística
  - machine learning
  - modelos
  - monográficos
  - r
title: Introducción a la Estadística para Científicos de Datos. Capítulo 11. Análisis bivariable
url: /blog/introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-11-analisis-bivariable/
---

De nuevo se retoma el ejemplo que está sirviendo de hilo conductor para este ensayo, la campaña de marketing de venta cruzada en el sector asegurador [que está disponible en Kaggle](https://www.kaggle.com/anmolkumar/health-insurance-cross-sell-prediction). Una aseguradora española que opera en múltiples ramos quiere ofrecer seguro de automóviles a sus clientes del ramo de salud. Para ello se realizó un cuestionario a los clientes de forma que se marcó quienes de ellos estarían interesados en el producto de automóviles y quienes no. Se identificaron posibles tareas:

- Describir la cartera de clientes.
- **Identificar que características de nuestros clientes pueden ser eficaces a la hora de crear una campaña comercial.**
- Sugerir unas reglas para la elaboración de la campaña.

```r
library(tidyverse)
library(formattable)

train <- read.csv("./data/train.csv")
formattable(head(train,5))
```

Hasta el momento se ha descrito el conjunto de datos, se han determinado que roles juegan las variables dentro de ese conjunto de datos donde se estableció que la variable más relevante es `Response` ya que juega el rol de **variable target**. Esta variable toma valores `0 – no interesa 1 – interesa el producto`, es decir, se distribuye según una binomial con parámetros n = 381.000 clientes y p = 0.1223 interesados, conocer la distribución ayuda a afrontar el análisis.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

En este capítulo el científico de datos comienza a estudiar la relación entre dos variables que pueden ser cuantitativas o factores. Esta categorización da lugar a 3 tipos de relaciones entre dos variables:

- Variable numérica frente a variable numérica
- Variable numérica frente a factor
- Factor frente a factor

## Variable numérica frente a variable numérica

El inicio de la relación entre dos variables es la **correlación**. Esta medida bivariable pretende medir como la variación de una variable cuantitativa influye en otra variable cuantitativa. La cuestión fundamental es, a medida que se incrementa x, ¿qué sucede con y? Por ejemplo, a medida que una persona crece en altura, ¿cómo se incrementa el peso? Para ilustrar se realiza una simulación y un **gráfico de dispersión** para estudiar como se distribuyen los pares de variables (peso, altura)

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_9cb1d779101c9ecefe0d9ea6befb5278.jpg)

Aunque sean datos simulados es evidente, por como se ha hecho la simulación, que a medida que aumenta la altura aumenta el peso. Hay una medida estadística para describir esta situación, el coeficiente de correlación que en R se calcula mediante la función `cor`.

```r
cor(peso, altura)
```

Esta medida de 0.8 (aprox) indica que peso y altura se relacionan positivamente, a medida que aumenta uno aumenta el otro pero no es una medida de graduación, sólo mide la **fuerza** de esa relación. El coeficiente de correlación es un valor que toma valores entre -1 y 1 donde -1 significa total correlación negativa (aumenta una implica que disminuye la otra variable), 0 significa que no existe ningún tipo de correlación y 1 la correlación positiva (aumenta una aumenta otra variable).

Simulando y representando las distintas formas de correlación se tiene:

```r
library(gridExtra)

# Correlación positiva
observaciones <- 1000
x <- rnorm(observaciones, 0, 1)
y <- x/5 + rnorm(observaciones, 0, 0.1)

p1 <- data.frame(x,y) %>%  ggplot(aes(x , y)) +
  geom_point() + ggtitle(paste0("Correlación: ", round(cor(x,y),3)))

# Correlación negativa
x <- rnorm(observaciones, 0, 5)
y <- rpois(observaciones, 3) - x

p2 <- data.frame(x,y) %>%  ggplot(aes(x , y)) +
  geom_point() + ggtitle(paste0("Correlación: ", round(cor(x,y),3)))

# Sin correlación
x <- rnorm(observaciones, 0, 5)
y <- runif(observaciones)

p3 <- data.frame(x,y) %>%  ggplot(aes(x , y)) +
  geom_point() + ggtitle(paste0("Correlación: ", round(cor(x,y),3)))

# Aparentemente sin correlación
x <- rnorm(observaciones, 0, 1)
y <- x^2 + runif(observaciones, -1,1 )

p4 <- data.frame(x,y) %>%  ggplot(aes(x , y)) +
  geom_point() + ggtitle(paste0("Correlación: ", round(cor(x,y),3)))

grid.arrange(p1,p2,p3,p4)
```

![](/images/2022/12/wp_editor_md_fd2ebcce92641750bc4231d1edf45753.jpg)

Se simulan 4 tipos distintos de correlación, correlación positiva, negativa (vistas con anterioridad); en el tercer caso no hay correlación, cuando ésta no existe los gráficos de dispersión generan polígonos como cuadrados, rectángulos o circunferencias ya que la disposición de los pares de puntos se debe a un comportamiento azaroso (una variable no afecta a otra). Sin embargo, se ilustra otro tipo de situación, el cuarto gráfico, donde es evidente que hay una relación entre las variables pero ésta no es lineal y por ello el coeficiente de correlación no es suficiente para identificar esta situación.

En el ejemplo de trabajo que hace de hilo conductor del ensayo no se realiza el análisis de correlaciones puesto que la variable principal para realizar un análisis bivariable es la variable target, la variable `Response`, que toma valores 0 si el cliente no está interesado en el seguro de automóviles y 1 si muestra interés en el producto. Por este motivo será más conveniente un análisis bivariable con un factor.

## Factores frente a variables numéricas

Una de las variables es un factor, cada nivel de ese factor representa una categoría, ya no es un punto. Será necesario estudiar como son los valores que toma la variable numérica para cada nivel del factor. En el capítulo 7, en la descripción gráfica de datos se estudiaban los posibles valores que toma una variable mediante histogramas, gráficos de densidades y boxplot. En este caso se puede hacer uno de esos análisis gráficos para cada nivel del factor y así comparar ambas variables.

En el ejemplo de trabajo se tiene una variable target que toma valores 0 y 1, a continuación se estudia esa variable objetivo `Response` frente a la variable `Age` que indica la edad de los asegurados encuestados.

```r
train %>% ggplot(aes(x=Age, group=as.factor(Response), fill=as.factor(Response))) + geom_histogram()
```

![](/images/2022/12/wp_editor_md_baac73cc7882219c932d64e04c75dbd1.jpg)

Es necesario especificar que la variable es un factor, en este caso `Response` es numérica y a efectos prácticos se sigue manteniendo como numérica. Si no se especifica que es un factor se tendría la siguiente situación:

```r
train %>% ggplot(aes(x=Age, group=Response, fill=Response)) +
  geom_histogram()
```

![](/images/2022/12/wp_editor_md_9acfcec9d61962270e0e5980bbc1055e.jpg)

No tiene sentido realizar una escala continua de un factor, es un problema habitual cuando se trabaja con factores en R. En cualquier caso, emplear un histograma de este tipo no sirve porque se están contando registros y si una de las categorías del factor tiene menos observaciones no se podrá comparar su comportamiento. Pero se dispone de los gráficos de densidad que permiten estudiar mediante una función continua la distribución de los valores.

```r
train %>% ggplot(aes(x=Age, group=as.factor(Response), fill=as.factor(Response))) + geom_density()
```

![](/images/2022/12/wp_editor_md_a942ed16a4605560ff38faecd136d288.jpg)

Se aprecian comportamientos distintos para la edad en la respuesta pero se sugiere jugar con la transparencia de los gráficos para conocer mejor las distribuciones, simplemente se añade el parámetro `alpha`.

```r
train %>% ggplot(aes(x=Age, group=as.factor(Response), fill=as.factor(Response))) +  geom_density(alpha = 0.3)
```

![](/images/2022/12/wp_editor_md_cc340456a9a69182b33ddf69e0038aeb.jpg)

Hay claramente dos distribuciones en función de la variable respuesta, estas distribuciones no son conocidas y tampoco es relevante porque es la distribución de la variable respuesta la que tiene importancia. La variable respuesta toma dos posibles valores y suponiendo cada cliente como independiente se tiene una distribución binomial como se ha indicado con anterioridad. Si el objetivo del ejercicio es establecer que características hacen que los clientes sean más propensos a adquirir un seguro de automóviles parece que la edad es una de esas características. A la vista del gráfico es más evidente que a mayor edad mayor interés, mayor probabilidad de adquirir un seguro de automóviles en la compañía. Cuando se tiene una variable respuesta es necesario estudiar esta variable frente a las variables que se consideren relevantes en su comportamiento, frente a todas las **variables input**. Por ejemplo, se repite el ejercicio contra `Vintage` que hace referencia a la antigüedad como cliente.

```r
train %>% ggplot(aes(x=Vintage, group=as.factor(Response), fill=as.factor(Response))) + geom_density(alpha = 0.3)
```

![](/images/2022/12/wp_editor_md_e67b9187e87af57dbbe47d7235ffbfa8.jpg)

En este caso la forma de la variable tanto para los que afirman estar interesados en el seguro de automóviles como para aquellos que no lo están es prácticamente la misma. De forma gráfica no parece que la antigüedad como cliente esté afectando a la variable respuesta. Para este tipo de análisis también se puede emplear el boxplot.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

![](/images/2022/12/wp_editor_md_7c39ad4169e5ea594c980783a3e7aa06.jpg)

Se aprecia como edades mayores muestran mayor propensión y como la antigüedad no está afectando al interés por el seguro de automóviles. Es importante reseñar que cualquier de los dos gráficos ofrece la forma, la distribución de las variables para cada nivel de la variable respuesta. Es necesario reseñar que en ningún momento aparece el número de observaciones ni se dispone de ningún mecanismo para identificar el peso que tiene cada grupo en estudio.

Como se ha indicado este análisis es necesario llevarlo a cabo con todas las variables input pero no es posible emplearlo cuando se comparan factores frente a factores, en esa situación es necesario emplear otro análisis gráfico.

## Factores frente a factores

En el capítulo 7 los factores se estudiaban mediante gráficos de barras y en el análisis bivariable se puede seguir la misma tónica pero será necesario apilar en la barra los niveles del otro factor en estudio para poder comparar. Se recomienda apilar el factor que haga de variable respuesta.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

![](/images/2022/12/wp_editor_md_77de95b2cab469f0e6374b9b4de46bf9.jpg)

Es un gráfico apilado con un problema, no se puede determinar si el target es mayor para un sexo u otro, es necesario **relativizar** , es necesario estudiar los porcentajes de respuesta por nivel del factor input para no sacar conclusiones erróneas.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

![](/images/2022/12/wp_editor_md_3cfa186cbd913be93b260dc0ad00bcfa.jpg)

Al emplear % para comparar se pierde el número de observaciones pero facilita la comparación. Se van añadiendo posibilidades gráficas a `ggplot`, en este caso se incluyen los valores porcentuales mediante `geom_text` el ejemplo de uso no se complica mucho el código. También tiene interés en el anterior código el uso de `transmute` que permite crear porcentajes de grupos como una nueva variable a partir de `summarise`:

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

En el ejemplo de trabajo parece que los hombres encuestados muestran mayor interés por el producto de automóviles. Este mismo análisis se debe replicar para todos los factores input presentes en el conjunto de datos. Por ejemplo, la variable `Region_Code`

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

![](/images/2022/12/wp_editor_md_d1e60a487683c9511f7fa5b31196afd7.jpg)

En este gráfico aparecen dos problemas que el científico de datos tiene que tener en cuenta cuando trabaje con factores.

- El factor tiene demasiados niveles
- El factor puede tener pocas observaciones y se están sacando conclusiones con pocos registros

Al primer problema ya se hizo mención al inicio del ensayo, se sugiere realizar una agrupación de niveles para facilitar su interpretación. Además, es posible que se obtengan conclusiones sobre niveles del factor que puedan llevar al error debido a la escasa **prevalencia**. La prevalencia tiene diversas definiciones pero en este caso se define como el divisor en el cálculo del porcentaje dentro del nivel del factor.

$$pct-interesados\_{nivel-i}= \\frac {interesados\_{nivel-i}}{observaciones\_{nivel-i}} = \\frac {interesados\_{nivel-i}}{prevalencia\_{nivel-i}}$$

Es relevante porque es **sentido común** no dar el mismo valor al % de la variable respuesta en una provincia donde se tiene una cartera de 80.000 clientes que en una provincia donde se tienen 80 clientes. El % de clientes interesados en un caso se calcula con un denominador de 80.000 y en otro caso con un denominador de 80 y **en los gráficos presentados hasta el momento no es posible estudiar correctamente la prevalencia**.

Cuando el científico de datos se encuentre situaciones de baja prevalencia o alto número de niveles de un factor ha de pensar una estrategia para abordar el problema. Siempre se debe priorizar la realización de «agrupaciones con sentido de negocio». En este caso, si se conoce la división territorial, agrupar por comunidades autónomas, por zonas, territoriales o separar las provincias más relevantes frente al resto. Por ejemplo:

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

![](/images/2022/12/wp_editor_md_a9cb47a8f73d29a2db2164b2b1188cfc.jpg)

> Se sugiere que aquellas variables del conjunto de datos que estén analizadas o clasificadas empiecen por un prefijo o se las pueda distinguir de algún modo dentro del tablón de datos, en este caso y a lo largo de todo el trabajo, se emplea el prefijo `fr_` para indicar `f`actor `r`eclasificado. Esto facilitará la automatización de análisis y los procesos de modelización como se verá con posterioridad.

Parece más alto el interés en Madrid, sin embargo, el % de interesados en Barcelona y el resto de España es similar. No es una agrupación convincente pero puede interesar a un equipo de negocio. Otro mecanismo de unión de factores puede basarse en la propia variable respuesta, que sea ese % el que agrupe la variable. A continuación se plantea una agrupación en buenos, regulares y malos, agrupación de niveles de un factor simplista basada en el % de respuesta.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

La librería `formattable` además de permitir presentar de forma elegante data frames, puede añadir mayor vistosidad a las tablas como ilustra el ejemplo. Para facilitar el análisis se suma la variable `Response`, motivo por el cual no se transforma (aun) en factor, en ocasiones facilita el trabajo mantenerla como numérica. Se crea un `agregado_clientes` para determinar el % de clientes que se van agrupando. Mediante la función `lag` que permite extraer el anterior registro de un data frame se busca si la acumulación de clientes de la anterior región ya ha superado el 10% de las observaciones, de esa forma se crean grupos de provincias en función de la tasa de respuesta.

La primera agrupación de provincias será aquella que supere el 10% de las observaciones.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

Se vuelve a recalcular el agregado de clientes eliminando las provincias ya clasificadas y el siguiente corte se establece cuando se supere otro 10% de observaciones.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

Este proceso se plantea de forma iterativa en distintos data frames para entender el proceso y así se crean los grupos _muy bueno, bueno, regular, malo, muy malo_ de provincias en base a la variable target.

```r
formattable(train %>% group_by(Response) %>%
              summarise(clientes = n(),pct_clientes=n()/nrow(train)))
```

Es útil ver paso a paso que regiones se van uniendo por si existe algún criterio de negocio o se encuentra algún indicador que pueda mejorar esta agrupación ya que este trabajo no tiene ningún sentido práctico más allá de unir regiones con similares tasas de respuesta, al científico de datos puede interesarle llevar estos datos a una hoja de cálculo y realizar sus propias agrupaciones. Si se trabaja con un gran número de variables existen librerías en R que realizan esta labor de forma automática tanto con variables numéricas como con factores pero se recomienda controlar como se producen estas agrupaciones.

Ya se dispone de un data frame auxiliar que es necesario unir al tablón de trabajo.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

Se repite el gráfico de barras apiladas.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_de0df86e05ea581c95bbeb265dfe1cac.jpg)

Para facilitar la labor y no trabajar con recodificación de factores se opta por numerar cada nivel del factor algo que ayuda en las visualizaciones, es necesario recordar que hay factores con orden (como es el caso). La agrupación de provincias garantiza que tiene en cada nivel al menos un 10% de observaciones, además parece que esa agrupación discrimina la variable respuesta, pero este análisis gráfico es claramente mejorable.

## Propuesta de análisis gráfico para el análisis bivariable

El científico de datos ha de elaborar sus propias herramientas y sus propias funciones gráficas para mostrar estos análisis iniciales sobre sus datos. Estas aproximaciones son fundamentales para el trabajo de documentación y modelización y en ocasiones el científico de datos tendrá que exponer estos resultados previos a equipos que no están familiarizados con la visualización de datos. Por este motivo, una buena o mala visualización no la establece la literatura sobre la realización de gráficos, la establece la capacidad de comprensión que tengan las áreas usuarias de las visualizaciones.

En este caso se propone un análisis gráfico de uso en el ámbito actuarial donde la ciencia de datos tiene múltiples casos de éxito. Se trata de un gráfico de doble eje y donde el eje y de la izquierda representará el % de observaciones del nivel del factor (prevalencia) y permitirá dar un peso a la información que suministra ese nivel del factor. En el eje y de la derecha se pondrá la proporción, la tasa de respuesta del target en estudio.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_b0dc23c102c488501f3ffe35d8c6dc4e.jpg)

Tabularmente sería complejo de ver al tener un gran número de niveles, pero el gráfico permite estudiar como se distribuye la población para cada nivel del factor y como es su comportamiento frente a la variable target. En este caso `ggplot` representa en forma de línea continua la tasa de respuesta (`geom_line`) y en barra el % de observaciones (`geom_col`), se añade el valor del % de clientes interesados mediante `geom_text` mejorando el formato y es `scale_y_continuous` junto con `sec_axis` lo que permite crear un gráfico de doble eje a `ggplot`. Pero es necesario que ambos ejes estén en la misma escala, por eso se añade un ajuste en `sec_axis`. En el anterior gráfico se aprecia que pasa si se deja ese ajuste a 1, para mejorar la visualización se puede jugar con ese ajuste para el eje y de la derecha.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_312043a585ac063d7fd05693bcf24dcb.jpg)

Se aprecia como el eje y de la izquierda es la mitad del eje y de la derecha, se produce un ajuste del 0.5. Los clientes encuestados son mayoritariamente jóvenes entre 24-30 años que no muestran interés en el producto, sin embargo, hay una serie de clientes entre 35 y 50 años que sí tienen interés, a medida que se avanza en la edad ese mismo interés en el producto de automóviles va cayendo.

Entendido este gráfico habría de ser replicado para todos los factores presentes en el análisis, cuando se repita un código en múltiples ocasiones es recomendable crear una función.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_34c60ad23556f55de27910bb55eddad8.jpg)

Este código automatiza el gráfico anterior y se puede aplicar para más variables, además sirve de ejemplo de uso de **símbolos** en funciones con `dplyr` ya que en funciones puede ser un problema pasar cadenas de caracteres. Se pueden emplear funciones como `group_by_at` para evitar esta situación pero en esta función se transforma en símbolo y se referencia mediante `!!` Como se puede comprobar esta función `bivariable` se puede replicar con todos los factores en estudio.

```r
grid.arrange(ncol=2,
bivariable(train, 'Response', 'fr_region2', 1.5),
bivariable(train, 'Response', 'Gender', 1),
bivariable(train, 'Response', 'Driving_License', 1),
bivariable(train, 'Response', 'Vehicle_Damage', 1),
bivariable(train, 'Response', 'Policy_Sales_Channel', 1),
bivariable(train, 'Response', 'Previously_Insured', 1),
bivariable(train, 'Response', 'Vehicle_Age', 1))
```

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_9a61750d55d697cc50f5bdbe85acc6df.jpg)

Esta salida que se obtiene con la función `CrossTable` de la librería `gmodels`, se trata de una tabla de contingencia, muy empleada en el ámbito estadístico. Como dice la descripción previa para el cruce de los dos factores se tiene el número de observaciones y la **Chi-square contribution** que es:

$$contribucion- \\chi^2 = \\frac {(Esperado – Observado)^2}{Esperado}$$

Esta es la idea que se emplea para definir si hay dependencia entre factores, ¿qué es el valor esperado? Es el producto de las frecuencias marginales entre el total de observaciones. En el ejemplo se espera para el género _Female_ no está interesado: 334399\*175020/381109 = 153569 frente a 156835 que es lo observado, entonces (153569 – 156835)^2/153569 = 69.46 que es un número, no una medida. Además no sabemos la validez estadística que tiene ese valor pero sí es conocido que esta diferencia tiene una distribución asociada llamada Chi-cuadrado que se verá en el siguiente capítulo. Esta prueba da lugar al estadístico de la $\\chi^2$ que está influenciado por el tamaño de la muestra y no da ninguna medida, por este motivo se le aplica una corrección por el número total de observaciones y las filas o columnas de la tabla de contingencia y ello permite dar una magnitud, esa corrección da lugar al estadístico V de Cramer. Para la obtención de la V de Cramer se emplea en este caso la librería `vcd`.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

En este caso la V de Cramer tiene un valor muy próximo a 0 lo que indica que hay poca relación entre los factores, valores próximos a 1 indican mucha relación. Cuando se trabaje con modelos lineales se verá la importancia que tiene esta medida para las variables input en los procesos de modelización.

En cualquier caso, se ha planteado una descripción gráfica para factores y un análisis de correlación para factores, no es aplicable a variables numéricas. Un factor nunca debe ser tratado como una variable numérica, sin embargo, si es posible agrupar variables numéricas y que se comporten como factores y todos los análisis planteados pueden tener cabida.

## Agrupación de variables cuantitativas

Para poder emplear un estadístico como el planteado en el apartado anterior las variables cuantitativas pueden estar **trameadas**. Como en ocasiones anteriores se sugiere que esos tramos tengan el sentido de negocio, pero si se desconoce o nunca se ha abordado un análisis de ese tipo se puede empezar por dividir la variable cuantitativa en N tramos de igual tamaño y estudiar como se comporta la variable respuesta en esos N tramos creados. En el ejemplo de trabajo se estudia el comportamiento de la variable `Annual_Premium` dividida en 10 tramos con el mismo número de observaciones.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

Esa agrupación es la definición de percentil, se ordena la variable a tramificar de menor a mayor y cada registro dividido por el total si es multiplicado por el número de grupos va a dar un número entre 1 y el número de grupos especificado que tendrán el mismo número de registros y cuyo total recoge el total de los registros. Esa variable grupo se trata como un factor reclasificado por lo que es susceptible de aplicar la función de descripción bivariable.

```r
personas <- 100
altura <- rnorm(personas, 170, 20)
peso <- altura/2.85 + rnorm(personas, 10, 5)

data.frame(altura=altura, peso=peso) %>%  ggplot(aes(x = altura, y = peso)) +
  geom_point()
```

![](/images/2022/12/wp_editor_md_2672fdb0c1a07094c1bb23090010bc67.jpg)

Cada tramo de `fr_prima` tiene el 10% del total de observaciones, cada corte es un decil de `Annual_Premium` y, a la vista del gráfico, no parece una buena opción de tramificación pero acerca al científico de datos a conocer mejor como se comporta la variable respuesta frente a una variable cuantitativa.

Existen técnicas para realizar la agrupación de variables como el **W**eight **O**f **E**vidence (WOE) pero la automatización pierden la perspectiva de conocer como se comportan las variables.

Todos los análisis planteados comienzan a ofrecer impresiones sobre la variable target, permiten aproximar a la tarea «identificar que características de nuestros clientes pueden ser eficaces a la hora de crear una campaña comercial». Pero no dejan de ser apreciaciones visuales y opiniones que **no tienen ningún sustento estadístico**. Es necesario determinar si esas impresiones son estadísticamente significativas y para ello el científico de datos debe tener nociones de muestreo e inferencia estadística.
