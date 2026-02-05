---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - monográficos
  - r
date: '2023-01-29'
lastmod: '2025-07-13'
related:
  - el-sobremuestreo-mejora-mi-estimacion.md
  - trucos-sas-muestreo-con-proc-surveyselect.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-16-modelizacion-estadistica-conociendo-los-datos.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-10-probabilidad-y-distribuciones.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
tags:
  - formación
  - libro estadística
  - monográficos
  - r
title: Introducción a la Estadística para Científicos de Datos. Capítulo 12. Muestreo e inferencia estadística
url: /blog/introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-12-muestreo-e-inferencia-estadistica/
---

En el capítulo anterior, dedicado al análisis bivariable, se crearon visualizaciones sencillas para describir la posible relación entre dos variables; pero más allá de impresiones visuales, no es posible asegurar que esa relación tiene validez estadística. Para establecer esa validez es necesario disponer de cierta dialéctica, de cierta base teórica básica para entender cómo se comporta un contraste estadístico o un intervalo de confianza. El científico de datos tiende a considerar que toda esa base teórica está obsoleta y que existe un cambio en el paradigma, pero los problemas a resolver con análisis estadísticos avanzados son similares a los que resuelve la estadística clásica. El trabajo del científico de datos en muchas ocasiones consiste en separar la señal del ruido, separar lo aleatorio de lo **estadísticamente significativo**. En los capítulos anteriores se han ido estableciendo los cimientos para realizar esta labor.

Todo problema y todo estudio parte de la **población**. En la RAE aparecen las siguientes definiciones de población:

1. f. Acción y efecto de poblar.
2. f. Conjunto de personas que habitan en un determinado lugar.
3. f. Conjunto de edificios y espacios de una ciudad. *Atravesó la población de una parte a otra*.
4. f. Conjunto de individuos de la misma especie que ocupan determinada área geográfica.
5. f. Sociol. Conjunto de los elementos sometidos a una **evaluación estadística mediante muestreo**.

Desarrollando esta quinta acepción, se tiene que la población es el conjunto de elementos sobre el que se estudia una característica, y es necesario tener claro cómo se compone porque es la herramienta a disposición del científico de datos para resolver el problema que le plantean los datos. Esa población no tiene por qué ser de individuos; en el ejemplo de trabajo que sirve de hilo conductor se tiene una población de clientes de una compañía de seguros, pero se pueden tener empresas, contratos, acciones deportivas… Además, la población no tiene por qué ser finita; de hecho, para estudiar a la población será necesario obtener muestras mediante técnicas de muestreo.

## Muestreo

Comprende las técnicas para la selección de elementos de una población. En ocasiones, por recursos o por definición, no se dispone del total de población para realizar análisis. En esos casos se trata de obtener una muestra representativa de la población, una muestra que tendrá las mismas características de la población y ello permite **inferir** información acerca de una característica de la población.

Se distinguen dos grandes tipos de muestreo:

- **Muestreo no probabilístico**: Es un método de selección de elementos de la población donde el analista selecciona los elementos en base a su propia experiencia o necesidad. Ejemplos: seleccionar a clientes con una característica para realizar un análisis cualitativo.
- **Muestreo probabilístico**: Cada elemento de la población tiene una probabilidad conocida *a priori* de ser seleccionado para el estudio.

El científico de datos trabaja habitualmente con muestreo probabilístico y, dentro de este tipo de muestreo, existen diversas técnicas encaminadas a garantizar la **representatividad** de la muestra (garantizan que la selección de elementos tenga el rigor requerido para el análisis).

Para entender mejor cómo se comportan las distintas técnicas de muestreo se recomienda leer el siguiente enlace al [blog de Anabel Forte donde se tratan poblaciones y muestras](http://anabelforte.com/2020/11/01/poblacion-y-muestra/). Se considera que el científico de datos debe conocer los siguientes tipos de muestreo, pero estas líneas son un atisbo sobre las posibilidades del muestreo estadístico (se pueden plantear diseños muy complejos).

### Muestreo aleatorio simple

Todos los elementos son elegidos al azar entre toda la población porque todos ellos **tienen la misma probabilidad de ser elegidos**. Será la técnica que más utilice el científico de datos, porque es habitual separar grupos de entrenamiento, grupos de test y grupos de validación cuando se realizan procesos de modelización. En R hay múltiples formas de realizar una muestra aleatoria mediante muestreo aleatorio simple; con `dplyr` se puede realizar del siguiente modo:

```r
library(tidyverse)
library(formattable)
library(gridExtra)

train <- read.csv("./data/train.csv")

set.seed(10)
muestra_aleatoria1 <- train %>% sample_n(size = 100, replace = FALSE)
```

Con la función `set.seed(10)` se fija la semilla, ya que en realidad R genera números *pseudoaleatorios*, y al fijar la semilla se obtiene siempre la misma muestra aleatoria, lo que garantiza que los trabajos puedan ser reproducibles. En este caso, con `sample_n` se obtiene una muestra de tamaño `size` observaciones y la opción `replace` indica si se hace con reemplazamiento de individuos o no. Si se quiere obtener una muestra que sea una proporción:

```r
muestra_aleatoria2 <- train %>% sample_frac(size = 0.1, replace = FALSE)
```

En el ejemplo se obtiene una muestra aleatoria de un $10\%$ de las observaciones mediante la instrucción `sample_frac`. Si el científico de datos desea dividir un `data.frame` en dos partes es habitual el empleo de índices:

```r
set.seed(10)
selecccionar <- sample(seq(1:nrow(train)), round(nrow(train) * 0.70))
datos_entrenamiento <- train[selecccionar, ]
datos_test <- train[-selecccionar, ]

# % de datos de entrenamiento
nrow(datos_entrenamiento) / nrow(train)
# % de datos de test
nrow(datos_test) / nrow(train)
```

De ese modo se han dividido los datos de partida en dos `data.frames` disjuntos, donde `datos_entrenamiento` tiene el $70\%$ de las observaciones y `datos_test` tiene el $30\%$ de observaciones restantes del conjunto de datos de partida.

### Muestreo aleatorio estratificado

Existe una población dividida en grupos homogéneos llamados estratos y se realiza un muestreo aleatorio dentro de cada uno de los estratos. Permite tomar muestras de mayor tamaño donde así fuera necesario. El científico de datos empleará este tipo de técnica cuando tenga que **balancear** una muestra para un modelo (por ejemplo).

En el ejemplo de trabajo se pretende balancear la muestra para equilibrar al $50\%$ aquellos clientes que están interesados y los que no están interesados en el seguro de automóviles. Habría dos formas de hacer esta tarea: aumentar el número de interesados o disminuir el número de no interesados, siempre artificialmente. Para ilustrar la situación:

```r
no_interesados <- nrow(train[train$Response == 0, ])
interesados <- nrow(train[train$Response == 1, ])

muestra_interesados <- train %>%
  filter(Response == 1) %>%
  sample_n(no_interesados, replace = TRUE)

muestra_aumentada <- train %>%
  filter(Response == 0) %>%
  bind_rows(muestra_interesados)

muestra_disminuida <- train %>%
  filter(Response == 1) %>%
  bind_rows(sample_n(train %>% filter(Response == 0), size = interesados))
```

Muestra con número de interesados incrementado artificialmente:

```r
formattable(muestra_aumentada %>% group_by(Response) %>% summarise(conteo = n()))
```

![](/images/2023/01/wp_editor_md_e42377b9dcf7795433545d1a7f03ecc2.jpg)

Muestra con número de interesados decrementado artificialmente:

```r
formattable(muestra_disminuida %>% group_by(Response) %>% summarise(conteo = n()))
```

![](/images/2023/01/wp_editor_md_eb8a1e4499db92f98ba3cb11158c3432.jpg)

En ambos casos la proporción es del $50\%$. Esta situación se la encontrará el científico de datos cuando tenga baja proporción de casos a investigar; por ejemplo, si únicamente un $1\%$ de los clientes estuviera interesado, cualquier modelo estadístico, con asegurar que nadie está interesado, acertaría el $99\%$ de las ocasiones (desde un punto de vista teórico sería un buen modelo). Mediante el balanceo de la muestra se procura que el modelo detecte esos patrones capaces de discriminar para que, en la práctica, el modelo cumpla su función.

Estos ejemplos se ilustran con la librería `dplyr`, pero se recomienda el uso de librerías específicas de muestreo como pueda ser `sampling`:

```r
library(sampling)
# Muestreo estratificado proporcional
# (En el ejemplo, fijamos tamaños iguales para Response 0 y 1)
indices_strat <- strata(train, stratanames = "Response", size = c(10000, 10000), method = "srswor")
muestra_balanceada <- getdata(train, indices_strat)
formattable(muestra_balanceada %>% group_by(Response) %>% summarise(conteo = n()))
```

### Muestreo por conglomerados

Supone seleccionar al azar todos los elementos de un grupo o un conglomerado. Si el científico de datos selecciona un colegio, una calle, una provincia… está realizando muestreo por conglomerados. En el ejemplo de trabajo se desean seleccionar 100 clientes de la provincia de Madrid y 100 clientes de la provincia de Barcelona.

```r
Barcelona <- train %>% filter(Region_Code == 8) %>% sample_n(100)
Madrid <- train %>% filter(Region_Code == 28) %>% sample_n(100)
```

El científico de datos ha de saber que, en el momento de realizar una selección de observaciones de cualquier tipo, está haciendo muestreo y, por ello, debe conocer y argumentar los motivos que le han llevado a realizar esa selección. Como se señaló con anterioridad, estos apuntes son un mínimo; el muestreo abarca técnicas y modelos más complejos.

## Inferencia estadística

Inferir significa extraer una conclusión a partir de hechos concretos hacia hechos generales. La inferencia estadística trata de extraer conclusiones sobre una característica, sobre un **parámetro de la población**, a partir de una muestra de ésta. Los parámetros a analizar se denominan estadísticos muestrales; además, si se conoce la distribución de dichos estadísticos (generalmente distribución normal) y se cumplen una serie de condiciones, se trata de inferencia paramétrica. La estadística paramétrica clásica plantea tres tipos de problemas:

- **Estimación puntual**, en la que se trata de dar un valor al parámetro a estimar (Ej.: valor esperado de una media).
- **Estimación por intervalos** (buscar un intervalo de confianza).
- **Contrastes de hipótesis**, donde se busca contrastar información acerca del parámetro.

Se parte de un experimento, repetido varias veces, y se obtiene una muestra con variables aleatorias independientes e idénticamente distribuidas y función de distribución conocida. Por ejemplo, se pretende estimar la altura media de los varones españoles; se recogen las alturas de 30 individuos y su media es de 1,74 metros. Ésa es una estimación puntual. Entonces, cualquier función de la muestra de 30 varones que no dependa del parámetro a estimar es un **estadístico muestral**, y esa media obtenida que nos sirve para conocer la altura media de los varones españoles es un **estimador del parámetro**. Ejemplos de estadísticos son el total muestral, la media muestral, la varianza muestral, la cuasivarianza muestral y los estadísticos de orden (que habitualmente se representan con letras griegas).

## Estimación de parámetros

Hay que determinar cuál es el mejor estimador de un parámetro para una población a partir de una muestra. ¿Cuál será el estadístico muestral que mejor representa ese parámetro poblacional? El mejor estadístico será el más creíble, el más verosímil, y por ello se denomina estimador de máxima verosimilitud; pero tiene que cumplir una serie de condiciones:

- Será aquel que tiene menor **sesgo**. Esto se cumplirá cuando el promedio de las distintas estimaciones es análogo al parámetro poblacional.
- Será el más **eficiente**. Cuando la desviación de las distintas estimaciones es la más baja (se minimiza la varianza de esas estimaciones).
- Será el más **consistente**. Si la muestra crece, también crece la probabilidad de que ese sea el estimador.
- Será **suficiente**. Ningún estadístico calculado sobre la muestra va a proporcionar información adicional sobre su valor.

A la hora de estimar el parámetro se plantea un dilema que el científico de datos deberá abordar en múltiples ocasiones: se trata del **dilema sesgo-varianza**.

![](/images/2023/01/wp_editor_md_1662d4cb461c8231a5d810b59aefbfd4.jpg)

Este dilema está presente siempre que se trabajan datos. Por ejemplo, aseverar que los inmigrantes cometen más delitos que los residentes de un país. Sin embargo, son más los hombres que cometen delitos que las mujeres. En ese caso, la solución para vivir con mayor seguridad no sería una sociedad sin extranjeros, sería una sociedad sin hombres. Para dar ambos datos se introduce sesgo: puede ser cierto que se acierte en mayor medida, pero introduciendo condiciones que interesan al analista.

> El científico de datos se verá en esta situación; la mejor solución es argumentar, motivar y consensuar el sesgo con los usuarios de los datos.

En el ejemplo de trabajo, las aproximaciones iniciales a los datos ya están planteando este dilema. Hay observaciones que deben ser eliminadas debido a que no aportan a la resolución del problema; mejorarán la estimación del número de respuestas positivas pero, ¿aportan algo al análisis?

```r
bivariable <- function(df, target, varib, ajuste = 1) {
  target_sym <- as.symbol(target)
  varib_sym <- as.symbol(varib)

  df %>%
    group_by(factor_analisis = as.factor(!!varib_sym)) %>%
    summarise(
      pct_clientes = round(n() * 100 / nrow(df), 1),
      pct_interesados = round(sum(!!target_sym) * 100 / n(), 1),
      .groups = 'drop'
    ) %>%
    ggplot(aes(x = factor_analisis)) + 
    geom_col(aes(y = pct_clientes), fill = "yellow", alpha = 0.5) +
    geom_line(aes(y = pct_interesados * ajuste), group = 1, color = "red") + 
    geom_text(size = 3, aes(y = pct_interesados * ajuste, label = paste(pct_interesados, ' %')), color = "red") + 
    scale_y_continuous(sec.axis = sec_axis(~ . / ajuste, name = "% interesados"), name = '% clientes') + 
    theme_light() +
    labs(title = paste0("Análisis de la variable ", varib))
}

grid.arrange(ncol = 2,
             bivariable(train, 'Response', 'Driving_License', 1),
             bivariable(train, 'Response', 'Vehicle_Damage', 1),
             bivariable(train, 'Response', 'Previously_Insured', 1))
```

![](/images/2023/01/wp_editor_md_93a577960a6d386196519869e8d3dcbe.jpg)

La estimación mejorará si se incluye la variable `Vehicle_Damage` y `Previously_Insured`, porque los clientes sin cobertura de daños no van a contratar, igual que aquellos que ya han estado asegurados; no deben de ser reglas, **deben ser condiciones** a la hora de seleccionar clientes, pero el analista debe tener claro, argumentar estas acciones y consensuar con los usuarios de los datos si son correctas las decisiones y los sesgos que está introduciendo en su análisis.

## Intervalos de confianza

El intervalo de confianza está presente en el lenguaje: si alguien pregunta sobre el precio de una vivienda, no es posible dar un número; se da un mínimo y un máximo que recoja el mayor número de viviendas. El intervalo de confianza será un rango que recoja un $X\%$ de los posibles valores que toma una variable. Y su creación se sustenta en el **Teorema Central del Límite**. Éste dice: si se suman variables aleatorias, sin importar la distribución que éstas tienen, el resultado final será una variable con distribución normal si se cumplen ciertas condiciones:

- Las variables aleatorias tienen varianza finita.
- Hay un número elevado de variables aleatorias.

Para entenderlo mejor, se lanza al aire una moneda 100 veces y se anota el número de caras; se repite el experimento 10 veces:

```r
set.seed(123)
lanzamientos <- 100
experimentos <- 10
resultados <- replicate(experimentos, sum(rbinom(lanzamientos, 1, 0.5)))
hist(resultados, main = "10 experimentos")
```

![](/images/2023/01/wp_editor_md_15eef2ce7c326c9d202aa648f3cd5390.jpg)

Si ese mismo experimento se repite 1000 veces:

```r
experimentos_v2 <- 1000
resultados_v2 <- replicate(experimentos_v2, sum(rbinom(lanzamientos, 1, 0.5)))
hist(resultados_v2, main = "1000 experimentos")
```

![](/images/2023/01/wp_editor_md_5e92d11d4045d428f004725977669008.jpg)

¿Qué forma empieza a tomar ese número de caras? Efectivamente, cuando hay un número elevado de variables, la distribución empieza a asemejarse a una distribución normal. Desde una distribución binomial (como es el lanzamiento de una moneda) se ha llegado a una distribución normal. Llevando este teorema al ejemplo de trabajo:

```r
# Muestreo repetido de la media de Response para una edad concreta (p. ej. 40 años)
data_40 <- train %>% filter(Age == 40)
medias_40 <- replicate(500, mean(sample(data_40$Response, 100, replace = TRUE)))
hist(medias_40, main = "Distribución de medias (n=100, 500 réplicas)")
```

![](/images/2023/01/wp_editor_md_803cfb531644ad57f9b6eff42b6a1.jpg)

Recuerda a la distribución normal con sólo 100 observaciones seleccionadas en cada muestra. En el capítulo 10 se demostró mediante simulación que en el espacio de 2 desviaciones típicas estaban el $95\%$ de los posibles valores:

```r
# Visualización del intervalo de confianza en la distribución de medias
plot(density(medias_40))
abline(v = mean(medias_40) + c(-2, 2) * sd(medias_40), col = "red")
```

![](/images/2023/01/wp_editor_md_88b8b091dc2268de2e44a4a7f342dd84.jpg)

El $95\%$ de los posibles valores que va a tomar la media de la respuesta para los clientes de 40 años está dentro de ese intervalo (de confianza). Si se lleva este trabajo teórico al total de los grupos de edad, para una confianza de $1 - \alpha$, se produce un error que se define como:

$$ \text{Error} = Z_{\alpha/2} \frac{\sigma}{\sqrt{n}} $$

De lo que se deduce que la media estará en un intervalo definido por ese error:

$$ \text{MediaEstimada} \pm Z_{\alpha/2} \frac{\sigma}{\sqrt{n}} $$

Para entenderlo mejor, se programa con R el intervalo sobre la variable `Age` del conjunto de datos de trabajo paso a paso:

```r
resumen_edad <- train %>%
  group_by(Age) %>%
  summarise(
    n = n(),
    media = mean(Response),
    sd = sd(Response),
    z = qnorm(0.975), # Para 95% de confianza
    error = z * (sd / sqrt(n)),
    li = media - error,
    ls = media + error
  )

ggplot(resumen_edad, aes(x = Age, y = media)) + 
  geom_line(color = "blue") + 
  geom_ribbon(aes(ymin = li, ymax = ls), alpha = 0.2, fill = "blue") + 
  theme_light() +
  labs(title = "Tasa de respuesta por edad con intervalos de confianza al 95%")
```

![](/images/2023/01/wp_editor_md_50981ea13ab2ef2af3d55dc39e5a60a7.jpg)

Se observa que grupos con gran número de observaciones crean intervalos muy estrechos, y grupos de edad con pocas observaciones crean intervalos enormes, incluso con posibles valores negativos que no se pueden dar. En la fórmula de cálculo del intervalo se tiene $\sqrt{n}$; la propia definición del intervalo está "ponderando" el tamaño del mismo con el número de observaciones; además, una mayor desviación también hará incrementar el tamaño del intervalo.

Una de las funciones de los intervalos de confianza reside en la utilidad a la hora de agrupar factores, algo que se trató en el capítulo 11. El intervalo de confianza puede servir al científico de datos para agrupar los niveles de un factor. Hay que reseñar que en `ggplot2` se puede emplear `geom_ribbon` sólo con variables numéricas; si se emplean factores, es necesario el uso de la función `geom_errorbar`:

```r
# Ejemplo con Género
resumen_genero <- train %>%
  group_by(Gender) %>%
  summarise(
    n = n(),
    media = mean(Response),
    sd = sd(Response),
    z = qnorm(0.975),
    error = z * (sd / sqrt(n)),
    li = media - error,
    ls = media + error
  )

ggplot(resumen_genero, aes(x = Gender, y = media)) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = li, ymax = ls), width = 0.2) + 
  theme_light()
```

![](/images/2023/01/wp_editor_md_60e831578bbbb0b929fabd8da653f339.jpg)

La estadística clásica es muy conservadora; se reitera que el intervalo es función de la raíz del tamaño del grupo. De este modo, por sexo el intervalo es mínimo porque el tamaño de los grupos es de centenares de miles de clientes.

## Contrastes de hipótesis

Para realizar contrastes de hipótesis es necesario conocer 3 distribuciones artificiales asociadas a la distribución normal que no se trataron en capítulos anteriores.

- **Chi-cuadrado ($\chi^2$):** Es una función similar a la gamma y se define como una suma de distribuciones normales al cuadrado; el número de distribuciones normales sumadas son los grados de libertad de la $\chi^2$.
- **t de Student:** Se crea a partir de una normal $N(0,1)$ y una chi-cuadrado con $n$ grados de libertad independientes. Una variable se distribuye bajo una t de Student si se puede definir como una $N(0,1)$ dividida por la raíz cuadrada de una chi-cuadrado partida por sus grados de libertad.
- **F de Snedecor:** Se crea a partir de dos chi-cuadrado independientes divididas por sus respectivos grados de libertad; así, la F de Snedecor tiene dos parámetros que indican sus grados de libertad.

¿Por qué es necesario conocer estas distribuciones? Porque los principales contrastes de hipótesis, bajo unos supuestos poblacionales (habitualmente que se distribuyen normally), se distribuyen según estas distribuciones artificiales. Y, al igual que en el intervalo de confianza, hay una región, una zona en la que tendríamos una seguridad de no equivocarnos a la hora de establecer que un valor inferido esté en esa región.

> Se tienen muchos supuestos, distribuciones y artificios estadísticos que dependen en gran medida del tamaño de la población. El científico de datos pretende trabajar en un "entorno Big Data" y con modelos de aprendizaje automático donde todos estos aspectos teóricos a veces parecen no tener cabida. **Pero todos estos conceptos y el método de trabajo son imprescindibles**.

El inicio de todo es la hipótesis, el pilar de una investigación: primero se establece y después se contrasta si es cierta o no. Se parte de una afirmación sobre un parámetro poblacional.

- **¿Un factor es independiente de otro?** ¿Es independiente la respuesta positiva a la encuesta del género del cliente encuestado? Éste es un **contraste de independencia** y se realiza mediante un test de la chi-cuadrado.
- **¿Hay diferencia de medias entre dos grupos?** ¿Es distinta la media de la antigüedad para la respuesta de los encuestados? Éste es un **contraste de igualdad de medias** que se realiza con la distribución t de Student.
- **¿Dos poblaciones tienen la misma varianza?** ¿Tiene sentido un modelo de regresión? Estos contrastes se realizan mediante un test con la F de Snedecor.

En general, el contraste de hipótesis es una cuestión del tipo: **¿Los datos de nuestras muestras respaldan las hipótesis de la población?** Y esa cuestión se resuelve del siguiente modo:

- Se parte de una hipótesis estadística ($H_0$) que es una proposición acerca de una característica de la población de estudio.
- Siempre hay dos hipótesis:
  - **Hipótesis nula ($H_0$):** Supone que el parámetro toma un valor determinado (o que no hay efecto); se supone cierta y se rechazará si no es compatible con la evidencia de la muestra. Se controla *a priori* el error de rechazarla con el nivel de significación del contraste (p-valor).
  - **Hipótesis alternativa ($H_1$):** Se formula como la negación de $H_0$.

Evidentemente es posible errar a la hora de realizar el contraste de hipótesis, pero se trata de controlar ese error:

![](/images/2023/01/wp_editor_md_4f5f2d2be001e3d903dfc9c3401f7eab.jpg)

- **Error de tipo I ($\alpha$):** Probabilidad de rechazar $H_0$ siendo $H_0$ cierta (falso positivo). Se puede controlar (habitualmente se fija en 0.05).
- **Error de tipo II ($\beta$):** Probabilidad de aceptar $H_0$ siendo $H_0$ falsa (falso negativo). Su complemento, $1 - \beta$, define la **potencia** del contraste.

Todas las aplicaciones estadísticas manejan el concepto **p-valor**, que es la probabilidad de observar un resultado tan extremo como el obtenido si $H_0$ fuera cierta. Si el p-valor es menor que el umbral $\alpha$, se rechaza $H_0$.

Retomando ejemplos anteriores: ¿depende la respuesta al cuestionario del sexo? Es necesario aplicar el test de la chi-cuadrado:

```r
tabla_contingencia <- table(train$Gender, train$Response)
chisq.test(tabla_contingencia)
```

Este contraste arroja un p-valor ínfimo ($< 2.2e-16$). De este modo, fijado un umbral de 0.05, se rechaza $H_0$ (la independencia) y se concluye que la respuesta depende del sexo del encuestado. Reduciendo el número de observaciones artificialmente pueden variar los resultados:

```r
set.seed(123)
muestra_pequena <- train %>% sample_n(100)
tabla_pequena <- table(muestra_pequena$Gender, muestra_pequena$Response)
chisq.test(tabla_pequena)
```

En este caso, es probable que el p-valor sea superior a 0.05, por lo que no se rechazaría la independencia. Es importante que el científico de datos no saque conclusiones erróneas en muestras pequeñas.

Por otro lado: ¿es distinta la media de la antigüedad para la respuesta de los encuestados?

```r
t.test(Vintage ~ Response, data = train)
```

En este caso, si el p-valor es alto (por ejemplo, 0.5), no es posible rechazar la hipótesis nula: con estos datos, la antigüedad como cliente no está influyendo en la respuesta al cuestionario. De hecho, se ha pedido el intervalo de confianza y se observa que el 0 estaría dentro de ese intervalo. También cabe reseñar que el contraste de diferencia de medias requiere una gran cantidad de supuestos, además el t-test está muy influido por el número de observaciones.

Al igual que sucedía con el muestreo, no es necesario que el científico de datos conozca de memoria todos los tipos de contrastes, pero ha de saber plantear una hipótesis, definirla correctamente y determinar qué datos se emplean para contrastarla.

> No se trata de resolver un problema mediante estadística clásica; se trata de que el científico de datos tenga esa dialéctica estadística que le va a permitir mejorar en sus procesos de modelización.
