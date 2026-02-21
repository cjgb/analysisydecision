---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - r
date: '2022-02-27'
lastmod: '2025-07-13'
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-9-analisis-exploratorio-de-datos-eda.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-8-problemas-con-los-datos.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-16-modelizacion-estadistica-conociendo-los-datos.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-11-analisis-bivariable.md
tags:
  - formación
  - libro estadística
  - r
title: Introducción a la Estadística para Científicos de Datos. Capítulo 6. Descripción numérica de variables
url: /blog/introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-6-descripcion-numerica-de-variables/
---

# Descripción numérica de variables

Se comienza con la recopilación de datos, la tabulación de los mismos y el establecimiento de la tipología y el rol que juegan estos en el conjunto de datos. Establecido ese marco, es necesario describir los datos; recordemos que, por sí mismos, los datos no dicen nada, no resuelven nada. Esa información la suministra un análisis.

## Transformar datos in información

![Imagen descriptiva](/images/2022/02/wp_editor_md_85a35fda93dad6ff4d9f2b8908d1149c.jpg)

Recordando lo tratado en el capítulo 2, el álgebra lineal define el análisis estadístico; la estructura más sencilla es el vector, donde aplicaría el análisis univariable: **el inicio de todo**. Si se dispone de más de una variable, ya podemos disponer esa serie de datos in forma matricial; buscar estructuras dentro de esas matrices nos produce el análisis multivariable. Conforme ha mejorado la capacidad de computación, se han podido crear sistemas estadísticos capaces de aprender de los propios datos; al conjunto de análisis basados en estos sistemas se le denomina *machine learning*. Actualmente se está avanzando más: hay entornos más sofisticados capaces de trabajar con tensores matemáticos, estructuras algebraicas multidimensionales que permiten implementar algoritmos que imitan los procesos de aprendizaje humano; este conjunto de técnicas y algoritmos se recogen dentro del ámbito de la inteligencia artificial.

El presente trabajo se centra en el análisis univariable y servirá de introducción al análisis multivariable. Este capítulo, para ilustrar cómo realizar el análisis univariable, empleará un caso práctico orientado al *marketing* analítico.

## Caso práctico. Campaña de venta cruzada

Dentro del mundo del *marketing*, es muy habitual emplear análisis estadísticos para mejorar los resultados de las acciones comerciales. In este caso, una aseguradora española que opera en el ramo de salud desea realizar una campaña de venta cruzada a sus clientes y ofrecer un producto de Autos. El ejemplo [se obtiene de una competición de Kaggle](https://www.kaggle.com/anmolkumar/health-insurance-cross-sell-prediction); se recomienda descargar y guardar en el equipo local los datos para poder replicar el código, aunque los datos estarán subidos al repositorio.

El análisis univariable nos sirve cuando tenemos cuestiones del tipo:

- Estudiar la calidad de la información.
- Descripción inicial de las variables presentes en el conjunto de datos. In el caso práctico, nos permite conocer la cartera de clientes encuestados.
- Identificar qué características de nuestros datos pueden ser eficaces cuando tenemos que plantear análisis. Qué características de nuestra cartera pueden ser relevantes para ofrecer una acción comercial.

Todas estas cuestiones están vinculadas a la estadística y, in primer término, a la estadística sobre una sola variable. Comencemos el trabajo con el caso práctico.

Del conjunto de datos de trabajo `train.csv` nos han pasado la siguiente información:

- `id`: Unique ID for the customer.
- `Gender`: Gender of the customer.
- `Age`: Age of the customer.
- `Driving_License`: 0 : Customer does not have DL, 1 : Customer already has DL.
- `Region_Code`: Unique code for the region of the customer.
- `Previously_Insured`: 1 : Customer already has Vehicle Insurance, 0 : Customer doesn’t have Vehicle Insurance.
- `Vehicle_Age`: Age of the Vehicle.
- `Vehicle_Damage`: 1 : Customer got his/her vehicle damaged in the past. 0 : Customer didn’t get his/her vehicle damaged in the past.
- `Annual_Premium`: The amount customer needs to pay as premium in the year.
- `Policy_Sales_Channel`: Anonymized Code for the channel of outreaching to the customer (ie. Different Agents, Over Mail, Over Phone, In Person, etc.).
- `Vintage`: Number of Days, Customer has been associated with the company.
- `Response`: 1 : Customer is interested, 0 : Customer is not interested.

Se comienza el proceso de análisis.

## El rol de las variables en el conjunto de datos

Como se comentó en el capítulo 2, dentro de los datos cada variable tiene una función distinta, y esta función define lo que se desea hacer con los datos. In este caso, se dispone de un conjunto de datos suministrado por una aseguradora para ofrecer un seguro de automóviles a sus asegurados de salud. La variable más relevante será nuestra variable respuesta o `target`; por la propia definición de los datos es sencillo: ese papel lo realiza el campo `Response`. Para identificar cada registro, cada cliente, se dispone de un campo `id`: el rol de esta variable será directamente el de ID. El resto de variables se consideran variables de entrada, variables `input`.

Es práctica habitual cuando se trabaja con datos nombrar los campos de las tablas de tal forma que sea más sencillo identificar cuál es el papel de cada variable en el conjunto de datos. In el caso concreto que se está estudiando, recordad: `Response` es `target` e `id` es `ID`. El nombre del resto de las variables solo las define y todas ellas serán variables de entrada o variables `input`. Puede ser recomendable incluir en el nombre de la variable, además de una breve descripción, un prefijo que nos defina el rol dentro del conjunto de datos. In este caso práctico se tiene un número bajo de variables, pero es posible encontrarse situaciones en las que sea necesario analizar cientos de variables y esas prácticas facilitan los análisis.

Conocida la función de cada variable en el conjunto de datos, se comienza a describir los elementos del conjunto de datos.

## Análisis descriptivos de los datos

Recuperando, de nuevo, el capítulo 2, allí se dividieron las variables in dos tipos: variables cuantitativas y variables cualitativas, que llamamos factores. In base a esta división se planteaba una posible descripción numérica y una posible descripción gráfica para variables de entrada o `input`; aquellas variables ID o variables in bruto (`raw`) no tiene sentido que se estudien porque no deberían aportar nada en nuestro análisis.

Con estas premisas, el primer paso es determinar qué tipo de variable es cada una de las que tenemos en el conjunto de datos. Se comienza el trabajo con datos:

```r
library(tidyverse)
train <- read_csv("./data/train.csv")
head(train, 5)
```

El conjunto de datos de trabajo es un archivo `CSV` que se llama `train.csv` y que previamente se ha descargado; la función `read_csv` permite importar ese `CSV` y crear un `data.frame` en la sesión de trabajo de `R`. Mediante la función `str()` es posible ver el tipo de variables que tiene el `data.frame`:

```r
str(train)
```

Numéricas o carácter, como se indicó; pero una variable numérica no tiene necesariamente un comportamiento numérico. Por ese motivo, siempre es mejor disponer las variables in:

- Variables cuantitativas.
- Variables cualitativas o factores.

No todas las variables numéricas serán variables cuantitativas, pero sí todas las variables cualitativas serán factores, aunque pueden tener un orden.

> **Nota**: Nunca se debe tratar una cualidad como un número. Si el sexo viene codificado 1-mujer, 2-hombre, no debemos tratar esa variable como cuantitativa.

### Descriptivos en variables cualitativas (factores)

In los datos hay variables que se pueden cuantificar y otras que definen cualidades de los datos. Una cualidad puede ser una característica (género, canal de venta…) o puede tener un orden, como es una variable cualitativa ordinal (antigüedad de cliente, nivel de satisfacción…). In ambos casos, para describir su comportamiento de forma numérica se emplearán tablas de frecuencias. Estas tablas presentan cada valor de la variable cualitativa o, lo que es lo mismo, cada nivel del factor, y contabilizan los registros que tienen esa característica. A la hora de contabilizar, se tienen las **frecuencias absolutas**, que contabilizan el número de registros para cada nivel del factor, o las **frecuencias relativas**, que contabilizan el porcentaje de individuos in cada nivel del factor y permiten *relativizar* esa cantidad.

In el ejemplo de trabajo se dispone de diversas variables cualitativas. Se ilustran ejemplos de tablas de frecuencia mediante la librería `dplyr`:

```r
train %>%
  group_by(Gender) %>%
  summarise(`Frecuencia absoluta` = n()) %>%
  knitr::kable()
```

Señalar la importancia de relativizar los datos absolutos, de obtener porcentajes:

```r
train %>%
  group_by(Gender) %>%
  summarise(`Frecuencia relativa` = n() / nrow(train)) %>%
  knitr::kable()
```

La variable `Gender` no tiene ningún tipo de orden, pero una variable cualitativa puede requerir un orden:

```r
train %>%
  group_by(Vehicle_Age) %>%
  summarise(`Frecuencia relativa` = n() / nrow(train)) %>%
  knitr::kable()
```

Por defecto, `R` siempre presenta en las tablas de frecuencias el orden lexicográfico, no el orden lógico que tiene la variable; en este caso se tienen vehículos `< 1 Year`, `1-2 Year` y `> 2 Years`, pero no es el orden que presenta el factor: es necesaria una ordenación.

Creación y ordenación del factor:

```r
train$Vehicle_Age <- factor(train$Vehicle_Age,
                            levels = c('< 1 Year', '1-2 Year', '> 2 Years'))
table(train$Vehicle_Age)
```

La función `table()` permite realizar rápidas tablas de frecuencias; cuando trabajemos con variables categóricas, es importante realizar esas rápidas comprobaciones sobre el correcto tratamiento de los datos.

Nueva variable con el factor reclasificado mediante `tidyverse`:

```r
train <- train %>%
  mutate(fr_vehicle_age = case_when(
    Vehicle_Age == '< 1 Year' ~ '01 menor 1 año',
    Vehicle_Age == '1-2 Year' ~ '02 Entre 1 y 2 años',
    TRUE ~ '03 más de 2 años'
  ))
table(train$fr_vehicle_age)
```

Usando cualquiera de los dos métodos para clasificar correctamente factores ordinales, sí es recomendable emplear un sufijo para determinar aquellas variables que han de ser analizadas; en este caso, se emplea `fr_` indicando «factor reclasificado». Práctica muy útil cuando se manejen grandes cantidades de variables para poder distinguir variables `input` de variables `raw` (in bruto).

### Descriptivos en variables cuantitativas

Las variables cuantitativas pueden tomar valores finitos (ejemplo: la edad, antigüedad de cliente…) o valores infinitos (ejemplo: prima de un seguro, salario…), pero in ambas situaciones se emplearán los mismos análisis descriptivos:

- Estadísticos descriptivos.
- Representación gráfica que describa la forma y los posibles valores que toma la variable.

Y se pondrá especial cuidado in detectar algunos de estos problemas:

- Detección de valores modales.
- Detección de *outliers*.
- Detección de valores *missing*.

#### Medidas de posición

Los **estadísticos descriptivos** permiten conocer valores relevantes que toman las variables de trabajo. Cuando se quiere conocer sobre qué valores se sitúa la variable, estamos analizando **medidas de posición**, entre las que destacan:

- Media.
- Mediana.
- Percentiles.
- Moda.

##### Media de una variable

Es el valor sobre el que se sitúan los datos; se obtendría sumando todos los valores de la variable y dividiendo por el número de registros. In los datos de trabajo, para la variable `Age` se tiene:

```r
train %>%
  summarise(media_edad = sum(Age) / n())
```

Evidentemente, `R` dispone de una función que realiza este cálculo:

```r
mean(train$Age)
```

Para describir correctamente los datos, es necesario calcular la media para todas las variables cuantitativas; in `R`, mediante la función `summarise` de `dplyr`, es posible realizar salidas de datos:

```r
train %>%
  summarise(`Media edad` = mean(Age),
            `Media de prima` = mean(Annual_Premium),
            `Media de antigüedad (días)` = mean(Vintage)) %>%
  knitr::kable()
```

Los valores de las variables se sitúan en el entorno de la media, pero este valor está muy influenciado por la escala: al definirse como la suma de los valores dividida entre el número de registros, si uno de esos valores es muy alto, es posible que la media tienda a perder representatividad solo por un dato atípico.

##### Mediana de una variable

Si se ordenan los datos de la variable en estudio de menor a mayor y establecemos un corte justo a la mitad, tenemos otra medida de posición que nos permite conocer el punto que divide esa variable al 50% en valores inferiores y al 50% en valores superiores; esta medida es conocida como **mediana**.

```r
median(train$Age)
```

Establece ese valor que deja a su derecha el 50% y a su izquierda el otro 50% de las observaciones.

##### Percentiles de una variable

Además de esa separación 50/50, para conocer cómo es una variable numéricamente podemos desear cortes al 5% – 95% o 75% – 25%; a esos valores que dejan un $x\%$ de valores por la izquierda se les denomina **percentiles**:

```r
quantile(train$Age, probs = c(0.05, 0.25, 0.5, 0.75, 0.95))
```

Para obtener el percentil aparece la función `quantile()` (cuantil in español). Estos valores tienen unos puntos que caracterizan los datos: el percentil 0 es el mínimo, el percentil 100 es el máximo y, por supuesto, el percentil 50 es la mediana. La variable `Age` es cuantitativa ordinal; en este caso se tienen **valores finitos** entre 20 y 85. Si se replica el código para la variable de prima:

```r
quantile(train$Annual_Premium)
```

In este caso la variable toma muchos valores (**infinitos**), entre 2630 y 540165; eso ya ofrece una impresión de la mayor complejidad para estudiar la concentración de valores.

##### Moda

Otra medida importante para conocer cómo se posicionan los valores de una variable es la **moda**: se define como el valor más repetido. Puede parecer más relevante para variables cuantitativas finitas; sin embargo, puede ser importante en variables cuantitativas infinitas porque hay valores que se repiten en la distribución y pueden representar un comportamiento. In `R` podemos crear nuestra propia función:

```r
Mode <- function(x) {
  fx <- unique(x)
  fx[which.max(tabulate(match(x, fx)))]
}

Mode(train$Age)
Mode(train$Annual_Premium)
```

In los datos de trabajo, hay un valor en la prima muy repetido que es el importe mínimo.

#### Medidas de dispersión

Además de conocer sobre qué valores se concentra la variable, es necesario analizar cómo de dispersos están esos valores respecto a esa medida de centralidad. Entre ellas se van a estudiar:

- Rango intercuartílico.
- Varianza y desviación típica.
- Coeficiente de variación.

##### Rango intercuartílico

Como indica su nombre, es un rango (un número inferior y un número superior) donde esperamos tener el 50% de las observaciones. Se define como la diferencia entre el percentil 75 y el percentil 25:

```r
IQR(train$Age)
```

Esta medida establece una dispersión a partir de los percentiles; es una característica de las medidas de dispersión: siempre miden una diferencia con una medida de posición.

##### Varianza y desviación típica

Para medir la dispersión, una medida a emplear es la diferencia de cada observación a la media de todas las observaciones; es necesario elevar al cuadrado para eliminar el efecto del signo. Si promediamos esa diferencia, estaríamos ante la **varianza**:

```r
var(train$Age)
```

La varianza no tiene una unidad de medida intuitiva; para ello contamos con la **desviación típica**:

```r
sd(train$Age)
```

La desviación típica es la raíz cuadrada de la varianza y está expresada en las mismas unidades que la variable, lo que facilita su interpretación.

##### Coeficiente de variación

Se define como la relación entre la desviación típica y la media, y habitualmente se expresa in porcentaje. Es una medida de dispersión muy relevante porque no tiene unidades; es decir, no es lo mismo una dispersión de 200 g en una población de ranas que 200 g en una población de caballos, pero sí podemos establecer una dispersión que sea el $x\%$ de la media.

```r
sd(train$Age) / mean(train$Age) * 100
```

Se puede decir que la variabilidad de la variable `Age` es un $x\%$. Cuando se analizan estadísticos descriptivos de cualquier tipo, es muy importante **relativizar**, porque empleando valores absolutos todas las conclusiones están afectadas por la unidad de medida.

#### Medidas de forma

In el capítulo 4 se vieron los histogramas y los gráficos de densidad; in ellos se aprecia cómo es la forma (**cómo se distribuye**) una variable in función del número de observaciones. Esa línea tiene dos características importantes: lo «apuntada» que es y hacia qué posición va ese apuntamiento. La **curtosis** mide ese apuntamiento y la **asimetría mide la dirección de esa cola**. Es importante conocer la forma que tiene una variable porque es posible que pertenezca a una familia de funciones conocidas.

Para conocer la asimetría se emplea el paquete de `R` `e1071`:

```r
library(e1071)
skewness(train$Age)
```

Un valor superior a 0 indica que es asimétrica a la derecha (cola larga a la derecha), por lo que moda < mediana < media. Valores inferiores a 0 indican asimetría a la izquierda. La asimetría a la derecha es propia de variables que indican precios, como es `Annual_Premium` in los datos de trabajo:

```r
skewness(train$Annual_Premium)
```

In este caso se tiene una asimetría muy alta; hay importes de prima anual muy elevados que tiran de la cola.

La curtosis o apuntamiento también se calcula con la función `kurtosis()`:

```r
kurtosis(train$Age)
kurtosis(train$Annual_Premium)
```

Una curtosis negativa indica una distribución «más plana» que la normal, y una curtosis positiva indica un apuntamiento mayor. In el ejemplo de trabajo, la curtosis de la variable `Age` es negativa; sin embargo, para la variable `Annual_Premium` se tiene un apuntamiento muy alto y una gran asimetría. Saludos.