---
author: rvaquerizo
categories:
- consultoría
- formación
- libro estadística
- machine learning
- r
date: '2023-05-16'
lastmod: '2025-07-13'
related:
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-6-descripcion-numerica-de-variables.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-8-problemas-con-los-datos.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-9-analisis-exploratorio-de-datos-eda.md
- entrenamiento-validacion-y-test.md
tags:
- sin etiqueta
title: Introducción a la Estadística para Científicos de Datos. Capítulo 16. Modelización
  estadística. Conociendo los datos
url: /blog/introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-16-modelizacion-estadistica-conociendo-los-datos/
---
## Establecer un método para la modelización estadística

En el capítulo 3 del ensayo se hacía mención al [universo tidyverse](https://www.tidyverse.org/) y las librerías de R que englobaba, además de esas librerías hay una publicación de Hadley Wickham y Garret Grolemund [R for data sience](https://r4ds.had.co.nz/) donde aparece la siguiente imagen:

![](https://d33wubrfki0l68.cloudfront.net/571b056757d68e6df81a3e3853f54d3c76ad6efc/32d37/diagrams/data-science.png)

Esa imagen describe un método para realizar _ciencia de datos_ con R. Como en la anterior figura, este capítulo se dedicará a describir e ilustrar un método de modelización que recoge todo lo trabajado con anterioridad en el ensayo, para ello se emplea el ejemplo que ha servido de hilo conductor en otros capítulos. El ya conocido **modelo de venta cruzada en el sector asegurador** :

> Las compañías de seguros que operan en múltiples ramos tienen en sus propios clientes potenciales a los que ofrecer seguros de otro ramo. Esta estrategia no es solo beneficiosa para ganar clientes, también es importante para fidelizar e incluso a la hora de seleccionar riesgos. Si un cliente tiene asegurados dos vehículos en la compañía es de suponer que sólo está conduciendo uno de ellos. Por estos motivos un cliente integral en una compañía de seguros aporta más valor.

A continuación se trabaja con un ejemplo de clientes de una compañía aseguradora que están en el ramo de Salud, la compañía pretende comercializar entre estos clientes su seguro de automóviles y para ello realizó una encuesta y etiquetó a aquellos clientes que estarían interesados en el seguro de automóviles. Los datos empleados para este trabajo se pueden obtener en [este link](https://www.kaggle.com/datasets/anmolkumar/health-insurance-cross-sell-prediction) ya que corresponden a una competición de kaggle. Como se indica en la propia competición:

> El cliente es una compañía de seguros que ofrece seguros médicos, ahora ellos realizan un test para construir un modelo que permita predecir si los asegurados (clientes) del año pasado también estarán interesados en el seguro para vehículos provisto por la compañía.

El científico de datos tiene que tener muy claro el objetivo de su trabajo de modelización. Con los datos que provienen de las encuestas es necesario realizar un modelo que permita seleccionar y caracterizar clientes para futuras campañas comerciales. Una vez se tiene claro el objetivo puede dar comienzo el trabajo de modelización.

## Un método de modelización estadística

Cada profesional ha de diseñar su propio método o seguir el que se utilice en el equipo con el que trabaje, en este ensayo se muestra un método probado en múltiples proyectos de ciencia de datos y que resume todo lo trabajado en capítulos anteriores:

[![](/images/2023/05/wp_editor_md_27b9a01430023cb93f618c4fef0f4448.jpg)](/images/2023/05/wp_editor_md_27b9a01430023cb93f618c4fef0f4448.jpg)

Selección de datos, aproximación a los datos y análisis gráficos descriptivos para comenzar a describir el problema. El estudio de las principales características de la variable dependiente, creación de los factores que han de describirla y finalmente la modelización estadística.

## Conocimiento de los datos

Antes de empezar es necesario disponer del data frame de trabajo. Proceso ya conocido.

```r
library(tidyverse)
library(DT)

train <- read.csv("./data/train.csv")
datatable(head(train,5))
```


Este paso es fundamental y puede ser uno de los más complicados, **disponer de los datos necesarios** , no es el objetivo de este trabajo pero es necesario asegurar con los equipos técnicos y con los ingenieros de datos que la base de partida tiene la estructura necesaria para la modelización. Aunque sea a alto nivel se puede intuir que el científico de datos tiene que tener buena comunicación tanto con los equipos de tecnología como con los equipos de negocio ya que unos son el origen y otros son los usuarios finales del conocimiento extraído a los datos. Una vez se disponga de la tabla inicial puede dar comienzo el trabajo de modelización.

### Muestreo. Datos de entrenamiento, datos de validación, datos de test y prueba ciega.

Para comprobar el correcto funcionamiento de los modelos es necesario separar los datos en distintos subconjuntos que permitan medir no sólo la capacidad predictiva del modelo, también velar que el modelo no se exceda en la complejidad de los parámetros y que éstos puedan servir sólo para el conjunto de datos de entrenamiento. En un proceso de modelización pueden participar los siguientes conjuntos de datos.

[![](/images/2023/05/wp_editor_md_be58409dcb89c12eb753af6252e49a32.jpg)](/images/2023/05/wp_editor_md_be58409dcb89c12eb753af6252e49a32.jpg)

  * Conjunto de datos de partida o universo. Es el conjunto inicial con datos no necesariamente depurados pero con la estructura e información necesaria para realizar un modelo, en el caso que ocupa se tratan de registros a nivel de cliente sobre los que se desea realizar una clasificación binomial que determine que clientes están interesados en el seguro de automóviles.
  * Conjunto de datos de entrenamiento. Son los datos que se van a emplear para modelizar, como aparece en la figura anterior en ocasiones se _balanceará_ la muestra para incrementar el número de 1’s en los datos de forma que el modelo sea capaz de encontrar segmentos e indicios que permitan separar el azar de lo estadísticamente explicable. No hay un porcentaje mínimo de 1’s que indiquen la necesidad de balancear la muestra pero porcentajes por debajo del 5% pueden suponer un problema para una regresión logística (por ejemplo).

> Si un conjunto de datos tiene un 3% de 1s, de casos positivos, el modelo puede tender a etiquetar todo 0s ya que acertará en un 97% de las ocasiones y no se consideraría un mal modelo aunque no sirva para nada.

  * Conjunto de datos de validación. Para evitar el _overfitting_ o la _sobreparametrización_ se separa un conjunto de datos con las mismas características que el conjunto de datos de entrenamiento y se comprueba si el modelo está aprendiendo sólo de los datos de entrenamiento. Hay técnicas estadísticas que no adolecen de esta problemática pero es buena práctica validar el modelo.
  * Conjunto de datos de test. Es un conjunto de datos que tiene exactamente las mismas características que el conjunto de datos de partida, se deshacen los posibles balanceos y tiene las mismas proporciones de 1’s que el universo. Sobre él se estudiará el comportamiento del modelo que finalmente seleccione el analista. En el caso de no realizar balanceo en la muestra se puede prescindir del conjunto de datos de validación y que los datos de test directamente hagan el rol de validación y test.

  * Prueba ciega. No aparece en la figura, no todos los científicos de datos emplean esta prueba. Se trata de un conjunto de datos que no ha participado en ninguna parte del proceso de modelización pero que supondrá la prueba final para el modelo. Es habitual cuando se trabaja con «cosechas» de datos, conjuntos de datos particionados por periodos temporales, habitualmente meses, donde el último mes disponible puede hacer este rol. De este modo se puede medir con los datos más recientes si el modelo cumple su cometido. Es un buen método para medir la capacidad predictiva del modelo en los equipos de negocio.

Las proporciones de observaciones para cada uno de los conjuntos de datos la marcará el propio científico de datos. En el ejemplo de trabajo no se dispone de prueba ciega aunque revisando la competición de Kaggle se puede identificar un conjunto de datos que realice ese rol. Se dispone del data frame de partida, _train_ , que se va a dividir en el conjunto de datos de entrenamiento y de test, se prescinde el uso de validación ya que no se realizará un balanceo de la muestra puesto que se tiene un % de unos por encima del 10%.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```


Se comienza inicialmente con el proceso de muestreo ya que es recomendable emplear menos observaciones en las fases descriptivas porque requieren un alto tiempo de computación y de interacción con los datos. En esta primera fase se divide _train_ al 50%.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```


Se ha dividido _train_ en _entrenamiento_ y _test_ al 50% y sobre _entrenamiento_ dan comienzo las primeras aproximaciones a los datos.

### Aproximación inicial a los datos

El primer paso es determinar el rol que juega cada variable dentro del conjunto de datos para definir los primeros análisis.

  * `Id` es el campo identificativo del cliente, no debe participar en el proceso de modelización
  * `Response` es la variable respuesta, será el target
  * Resto de variables. Variables input, variables de entrada que deben describir el comportamiento de `Response`

La proporción de `Response` en _entrenamiento_ es la siguiente:

```r
entrenamiento %>% group_by(Response) %>%
  summarise(pct_interesados = round(sum(Response)/nrow(entrenamiento),4))
```


A partir de este momento el trabajo del científico de datos será identificar características en las variables input que hagan variar en mayor medida ese `r round(sum(entrenamiento$Response)*100/nrow(entrenamiento),1)`% de clientes interesados y reunir todas esas características en una estructura algebraica que se denomina modelo.

Como se indicó en capítulos anteriores todo debe dar comienzo con el análisis EDA y por ello es necesario retomar el uso de de la librería `DataExplorer` y, sin lanzar el análisis EDA al completo, obtener una serie de gráficos ya conocidos.

```r
library(DataExplorer)
introduce(entrenamiento)
plot_missing(entrenamiento)
plot_histogram(entrenamiento, ncol = 3)
```


[![](/images/2023/05/wp_editor_md_541f26aa1b980c6531281a8a4f598962.jpg)](/images/2023/05/wp_editor_md_541f26aa1b980c6531281a8a4f598962.jpg)

[![](/images/2023/05/wp_editor_md_e15957f6cf76831c412e2feb1a302317.jpg)](/images/2023/05/wp_editor_md_e15957f6cf76831c412e2feb1a302317.jpg)

Comprobado que no hay valores perdidos se empieza graficando los histogramas de las variables cuantitativas presentes en los datos y aparecen problemas conocidos. Tanto el campo `Id` como `Vintage` parecen ser completamente aleatorios por la forma de su histograma, es normal con un campo identificativo pero es algo a tener en cuenta con la variable que define la antigüedad del cliente. Por otro lado, `Policy_Sales_Channel` y `Region_Code` son variables categóricas y aparecen como variables numéricas. Este tipo de situaciones sólo se identifican si se conocen los datos y de nuevo se reitera la necesidad de que el científico de datos se involucre tanto con el problema de negocio y como con los equipos técnicos encargados de elaborar los datos, no se pueden hacer medias de sexo ni contabilizar saldos en fondos de inversión, cada variable tiene su propio análisis como se ha reiterado a lo largo de todo el ensayo.

```r
entrenamiento <- entrenamiento %>% mutate(
  Policy_Sales_Channel = as.factor(Policy_Sales_Channel),
  Region_Code = as.factor(Region_Code))
```


Ahora se está en disposición de estudiar los factores disponibles en el conjunto de datos.

```r
plot_bar(entrenamiento, ncol=2)
```


[![](/images/2023/05/wp_editor_md_21f669d1849a856cd9065070cf5ea5e8.jpg)](/images/2023/05/wp_editor_md_21f669d1849a856cd9065070cf5ea5e8.jpg)

Directamente se obtiene un mensaje que identifica otro problema, precisamente las variables que se han transformado en factores tienen un gran número de niveles, será necesario realizar un trabajo de agrupación de niveles que se hará con posterioridad. Otro de los problemas que apareció en capítulos anteriores se encuentra en la variable `Driving License` que sólo toma el valor 1, este hecho tiene todo el sentido, ya que solo se debe ofrecer un seguro de automóviles a aquel cliente que dispone de licencia de conducción. Esta variable será eliminada del proceso porque tiene una justificación desde el punto de vista de negocio.

```r
entrenamiento <- entrenamiento %>% select(-Driving_License)
```


### Clasificación de factores

En las aproximaciones iniciales se han realizado las principales depuraciones de datos, pero no es un proceso acabado, las siguientes iteraciones en el proceso de modelización continuarán con esa labor de depuración. Sin embargo, a partir de ahora el científico de datos ya introduce «su problema» en los análisis. Cuando se tiene una variable target y una variable que ayude a describir ese target se está realizando análisis bivariable como se trabajó en el capítulo 11. En aquel momento se planteó un análisis descriptivo de esta forma:

```r
bivariable <- function(df, target, varib, ajuste=1){

target = as.symbol(target)
fr_analisis = as.symbol(varib)

g <- df %>%
   group_by(factor_analisis = as.factor(!!fr_analisis)) %>%
   summarise(pct_clientes = round(n()*100/nrow(df),1),
           pct_interesados = round(sum(!!target)*100/n(),1), .groups='drop') %>%
   ggplot(aes(x=factor_analisis)) +
   geom_line(aes(y=pct_interesados * ajuste), group=1, color="red") +
   geom_col(aes(y=pct_clientes),fill="yellow",alpha=0.5)  +
   geom_text(size=3, aes(y=pct_interesados * ajuste, label = paste(pct_interesados,' %')), color="red") +
   scale_y_continuous(sec.axis = sec_axis(~./ajuste, name="% interesados"), name='% clientes') +
   theme_light()

g + labs(title = paste0("Análisis de la variable ",varib))
}
```


Es necesario realizar este análisis para cada una de las variables cualitativas presentes en el proceso de modelización.

```r
library(gridExtra)

p1 <- bivariable(entrenamiento, 'Response', 'Gender', 0.5)
p2 <- bivariable(entrenamiento, 'Response', 'Age', 0.5)
p3 <- bivariable(entrenamiento, 'Response', 'Region_Code', 0.5)
p4 <- bivariable(entrenamiento, 'Response', 'Previously_Insured', 0.5)
p5 <- bivariable(entrenamiento, 'Response', 'Vehicle_Age', 0.5)
p6 <- bivariable(entrenamiento, 'Response', 'Vehicle_Damage', 0.5)
p7 <- bivariable(entrenamiento, 'Response', 'Policy_Sales_Channel', 0.5)

grid.arrange(p1,p2,p3,p4,p5,p6,p7, ncol=2)
```


[![](/images/2023/05/wp_editor_md_84b53b99e09ebd7ec4276f7086d94900.jpg)](/images/2023/05/wp_editor_md_84b53b99e09ebd7ec4276f7086d94900.jpg)

Situaciones ya conocidas. La variable `Age` parece discriminar bien pero es necesario trabajar sobre ella. La variable `Region_Code` es inmanejable al igual que `Policy_Sales_Channel` debido al alto número de factores. Además, tanto `Previosly_Insured` como `Vehicle_Damage` discriminan _demasiado bien_. La variable `Vehicle Age` es un factor con orden y en el gráfico éste no se está siguiendo. Por otro lado, quedan por analizar las variables cuantitativas. Es decir, el análisis bivariable está volviendo a la necesidad de depurar los datos.

El primer paso que ha de dar el científico de datos es el que requiera introducir o eliminar observaciones, es necesario determinar que se hace con las variables `Previosly_Insured` y `Vehicle_Damage`, ¿se eliminan esos clientes que no muestran ningún tipo de interés en el seguro de Automóviles? Es una decisión que hay que consensuar con los equipos de negocio y en realidad ya está arrojando información acerca del uso que se le puede dar a la encuesta planteada, ¿cómo es posible que no tengan interés un cliente que ya ha estado asegurado?

En este caso se opta por eliminar aquellos segmentos de clientes que no tienen interés en el producto de automóviles aunque se pierda capacidad a la hora de discriminar clientes. Directamente nunca debería realizarse un contacto comercial con aquellos clientes que ya han estado asegurados o que no tienen daños.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
0

Además, se modifica el orden de la variable `Vehicle_Age`.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
1

Se crea una nueva variable manteniendo la original. Como recomendación, en el momento de tener una variable trabajada es buena práctica añadir a ésta una denominación que permita identificarla, en este caso se añade el prefijo `fr_` de _factor reclasificado_. Esto significa que este factor ya está listo para formar parte del proceso de modelización.

Se repite el análisis bivariable con los factores seleccionados.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
2

[![](/images/2023/05/wp_editor_md_380e7a141d890ba42cab5e5abc0dbbd8.jpg)](/images/2023/05/wp_editor_md_380e7a141d890ba42cab5e5abc0dbbd8.jpg)
El siguiente paso será la **agrupación de niveles de factores** se comienza con la agrupación de los factores en estudio. Existen técnicas de agrupación de factores como el WOE (Weight Of Evidence) pero en este caso la agrupación se va a llevar a cabo en función del propio análisis bivariable dividiendo los factores en 3 niveles alto, medio y bajo interés.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
3

De nuevo se reitera la importancia de trabajar con equipos de negocio, es posible que se estén identificando comportamientos zonales interesantes. Para facilitar el trabajo se fijan los siguientes umbrales, alto interés >=20% interesados, medio interés 20-12% de interesados, bajo interés < 12% este establecimiento de umbrales se tiene que hacer mediante análisis y en consenso con los equipos usuarios de los modelos, si esta clasificación es correcta se puede emplear también para la variable `Policy_Sales_Channel`.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
4

Se crean dos conjuntos de datos con la agrupación del % de clientes interesados y se cruzan con el conjunto de datos de entrenamiento. Ahora se disponen de 2 factores reclasificados que deben estudiarse de forma bivariable.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
5

[![](/images/2023/05/wp_editor_md_0c379ca9364cd4e08bf9efa54fcb7375.jpg)](/images/2023/05/wp_editor_md_0c379ca9364cd4e08bf9efa54fcb7375.jpg)

Es necesario rehacer los factores creados, aparecen niveles con pocos clientes, están descompensados. Hay que iterar con la agrupación de esos factores. No hay una regla para decidir el % de observaciones o de exposición en un nivel, pero por debajo del 5% es necesario plantearse la agrupación de un nivel de un factor.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
6

[![](/images/2023/05/wp_editor_md_e74db98a864c3fbbf5d13a1c8abef2c1.jpg)](/images/2023/05/wp_editor_md_e74db98a864c3fbbf5d13a1c8abef2c1.jpg)

Este proceso se puede alargar pero tiene importancia debido a que genera factores y **conocimiento de negocio** sobre el problema para el analista. Por ejemplo, se aprecia que hay canales donde no se muestra ningún interés, la media de la proporción está por debajo del 9% y en intereses medios y altos apenas ofrece poder discriminatorio esta variable. Por el momento se mantienen estas agrupaciones.

Una de las variables que están ofreciendo una buena capacidad de discriminar el interés de los clientes por el producto de automóviles es `Age`, sin embargo, también interesa agruparla. En el capítulo dedicado al muestreo y la inferencia se vio este gráfico.

[![](/images/2023/05/wp_editor_md_e0bec0b004613ba8c3d0efa386923960.jpg)](/images/2023/05/wp_editor_md_e0bec0b004613ba8c3d0efa386923960.jpg)

Los intervalos de confianza son buenos aliados a la hora de agrupar factores porque están estableciendo un rango entre el que la media, la proporción, aparecerá un 95% de las veces. Se mejora la función bivariable con ese código.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
7

[![](/images/2023/05/wp_editor_md_876a2052825f5dd73ec608b1e553b3db.jpg)](/images/2023/05/wp_editor_md_876a2052825f5dd73ec608b1e553b3db.jpg)

> Los códigos de R se van sofisticando y no se estudia su estructura Todo ese código se ha visto con anterioridad. Se insiste en la importancia que tiene para el científico de datos construirse sus funciones y sus herramientas para los análisis exploratorios iniciales.

Se aprecia como la inferencia estadística hace más efectivo el trabajo del científico de datos. Se pueden crear agrupaciones en base a ese intervalo de confianza, en este caso y para simplificar, se opta por agrupar las edades superiores a 60 años.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
8

[![](/images/2023/05/wp_editor_md_61e9f86943f800514ecaeaea5646263f.jpg)](/images/2023/05/wp_editor_md_61e9f86943f800514ecaeaea5646263f.jpg)

Esta agrupación es insuficiente porque se incumple la proposición de disponer al menos del 5% de observaciones en muchos niveles del factor. Es necesario mejorar la reclasificación.

```r
sum(train$Response)/nrow(train)

## [1] 0.1225634
```
9

[![](/images/2023/05/wp_editor_md_9f74249a7103229048a312662bc9f7ea.jpg)](/images/2023/05/wp_editor_md_9f74249a7103229048a312662bc9f7ea.jpg)

Todos los factores están trabajados, pero es necesario **discretizar las variables cuantitativas** para que puedan formar parte del modelo. Al igual que sucede con los factores existen métodos automáticos como el WOE que permiten realizar esta agrupación, pero se pretende que el científico de datos emplee la estadística aprendida para mejorar sus análisis y el conocimiento de los datos. En el capítulo 11 dedicado al análisis bivariable se planteó un método para agrupar variables cuantitativas trabajando con 10 grupos con el mismo número de clientes. Recuperando ese código:

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
0

[![](/images/2023/05/wp_editor_md_7587341d9028dbc19656543484ae8c34.jpg)](/images/2023/05/wp_editor_md_7587341d9028dbc19656543484ae8c34.jpg)

Una simple agrupación de una variable cuantitativa está describiendo la situación, primas bajas muestran menos interés que las primas altas. Además estos niveles son susceptibles de ser agrupados.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
1

Aparece un valor modal en la prima en 2630 €, sería necesario comunicar de nuevo con los equipos de negocio para que nos comentaran que está sucediendo con ese rango de prima. Con el gráfico anterior y esta tabla se puede plantear una agrupación de este modo:

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
2

[![](/images/2023/05/wp_editor_md_bf179c286330d77a84f1009a1986c662.jpg)](/images/2023/05/wp_editor_md_bf179c286330d77a84f1009a1986c662.jpg)

Tampoco se aprecia un poder muy discriminatorio para primas superiores a 3000 €. Se repite el proceso con la variable `Vintage`.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
3

[![](/images/2023/05/wp_editor_md_83ef95656532e2be099c714702b03fc2.jpg)](/images/2023/05/wp_editor_md_83ef95656532e2be099c714702b03fc2.jpg)

Con esta variable el target apenas tiene variación, permanece plano en toda la agrupación de deciles. Algo que se podía intuir con los histogramas previos de la variable ya que la distribución era cuadrada, forma típica de variables aleatorias. Debido a su (aparente) escasa capacidad predictiva no se trabaja más con ella pero participará en el proceso de modelización de modo que sea el modelo el encargado de aceptar o rechazar algunos de los niveles del factor.

## El código de reclasificación de factores

Antes de continuar y analizar las interacciones es necesario recopilar y ordenar todo el código R necesario para preparar los datos de cara a la modelización. Este código de reclasificación de factores debe ser parte del modelo y de la **documentación que acompaña al modelo** al igual que los gráficos descriptivos y bivariables. Este paso simplemente recopila los análisis previos y las clasificaciones finales elegidas para cada factor. Además ese código se empleará en los datos de origen ya que es posible replicar el proceso de muestreo.

El primer paso consiste en filtrar por aquellas variables que no aportan al modelo o cuya aportación pueden empeorar el objetivo del proceso de modelización.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
4

No se sobrescribe el conjunto de datos de partida, se crea una réplica por si fuera necesario iterar de nuevo con los datos. Una vez filtrados los datos se seleccionan los códigos empleados para la reclasificación.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
5

Se mantienen todas las variables en bruto, las iniciales, por si fuera necesario volver atrás y realizar una nueva agrupación o reclasificación. Siempre es necesario ejecutar el análisis bivariable para que forme parte de la documentación de todo el proceso.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
6

Otro de los motivos por los que es interesante identificar de algún modo los factores reclasificados que formarán parte del modelo es la posibilidad de automatizar código como ilustra el ejemplo anterior ya que no ha sido necesario escribir el nombre de la variable, además será un código que el científico de datos podrá reutilizar.

Se ha creado una lista con los gráficos que podrán ser obtenidos mediante `grid.arrange` del siguiente modo.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
7

[![](/images/2023/05/wp_editor_md_48b14b33405ed7e907629a00f9f725c0.jpg)](/images/2023/05/wp_editor_md_48b14b33405ed7e907629a00f9f725c0.jpg)

Insistiendo, todos estos resultados deben acompañar a la documentación que el científico de datos genere cuando realice el modelo. Cuanto más automatizado esté el proceso de generación de análisis previos, gráficos y documentación menos tiempo se dedicará a esta relevante tarea, cuanto más documentado esté el proceso más sencillo será de replicar.

## Análisis de interacciones

El último paso de la fase previa sobre el conocimiento de los datos será el análisis de interacciones. Definidos los factores que van a formar parte del modelo es posible trabajar sobre ellos para encontrar posibles interacciones entre ellos. Las interacciones serán más fáciles de analizar si los factores presentes tienen un número bajo de niveles, de nuevo se recomienda que el científico de datos disponga de herramientas y análisis gráficos para estudiar esta situación. Un posible análisis gráfico puede ser.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
8

[![](/images/2023/05/wp_editor_md_b966070dbdd6c833cd8166af3a29e70b.jpg)](/images/2023/05/wp_editor_md_b966070dbdd6c833cd8166af3a29e70b.jpg)

Sobre esta propuesta se crea una función.

```r
set.seed(45)
indices <- sample(seq(1:nrow(train)) , round(nrow(train) * 0.50))

entrenamiento <- train[indices,]; nrow(entrenamiento)/nrow(train)
test <- train[-indices,]; nrow(test)/nrow(train)
```
9

[![](/images/2023/05/wp_editor_md_0a8de07979c202461481dd5c7888b509.jpg)](/images/2023/05/wp_editor_md_0a8de07979c202461481dd5c7888b509.jpg)

[![](/images/2023/05/wp_editor_md_bc7dcfffe11ac98272cdc3a0a455279d.jpg)](/images/2023/05/wp_editor_md_bc7dcfffe11ac98272cdc3a0a455279d.jpg)

Se obtienen 2 ejemplos, el cruce entre antigüedad del vehículo y sexo y el cruce entre canal y zona. En el primero parece existir cierta interacción entre los factores y en el segundo las tres líneas son «paralelas». Este proceso es arduo y requiere reprocesar los factores continuamente, pero proporcionará al científico de datos variables y conocimiento del problema a analizar. En este caso no se profundiza en ello para no alargar demasiado el capítulo.