---
author: rvaquerizo
categories:
  - business intelligence
  - consultoría
  - formación
  - monogrficos
  - r
date: '2011-11-28'
lastmod: '2025-07-13'
related:
  - graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
tags:
  - ddply
  - ggplot2
  - informes
  - memisc
  - plyr
  - r2html
  - recode
title: Informes con R en HTML. Comienzo con R2HTML (I)
url: /blog/informes-con-r-en-html-comienzo-con-r2html-i/
---

En las III jornadas de R tuve el placer de asistir al[ taller de Gregorio Serrano sobre informes con R](http://demo.usar.org.es/Taller+4). Me abri2 los ojos. Siempre he pensado que R no es una herramienta que sirva para hacer informes _[modo consultor = ON]_ R no serv2a para realizar reporting _[modo consultor = OFF]_. Pero R tiene un poderoso motor grfico y dispone del paquete **R2HTML** para poder realizar tablas en HTML y si trabajamos con libros CSS de estilos podemos obtener resultados muy atractivos. As2 que la otra tarde me puse manos a la obra y creo que puede salir una trilog2a interesante. Bueno, depende del inters que despierte esta entrada del blog har2 m2s entregas, pero de momento tengo en mente llegar a 3.

Seguimos con el sistema habitual. Simulo unos datos de ejemplo que pod2is copiar y pegar en vuestra consola de R:

```r
clientes=20000

saldo_vista=abs(rnorm(clientes,0,1)*10000+5000)

saldo_ppi=(runif(clientes,0.1,0.6)*rpois(clientes,2))*60000

saldo_fondos=abs(rnorm(clientes,0,1)*100000+3000)*(runif(clientes)>=0.6)

edad=rpois(clientes,60)

datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))

datos_inisaldo_ppi=(edad<65)*datos_inisaldo_ppi

#Creamos la variable objetivo a partir de un potencial

datos_inipotencial= runif(clientes,0,1)

datos_inipotencial= datos_inipotencial +

log(edad)/2 +

runif(1,0,0.03)*(saldo_vista>20000)+

runif(1,0,0.09)*(saldo_fondos>30000)+

runif(1,0,0.07)*(saldo_ppi>10000)

datos_inipvi=(datos_inipotencial>=quantile(datos_inipotencial, 0.85))*1

#Eliminamos la columna que genera nuestra variable dependiente

datos_ini = subset(datos_ini, select = -c(potencial))
```

Datos simulados de una entidad bancaria donde tenemos `edad`, `saldos` en distintos productos de pasivo e identificamos a aquellos `clientes` que tienen contratada una pensión vitalicia. Nos solicitan realizar un informe con los datos de contratación por edad y por pasivo. Cuando realizamos informes es muy habitual tramificar variables continuas. Para crear los tramos de `edad` y de pasivo vamos a emplear la funci2n `recode` de la librer2a `memisc`:

```r
#Con memisc recodifico los factores

library(memisc)

datos_inirango_edad <- recode(datos_iniedad,

"1 Menos de 45 aos" <- range(min,45),

"2 Entre 46 y 55 aos" <- 46:55,

"3 Entre 56 y 65 aos" <- 56:65,

"4 Ms de 65 aos" <- range(66,max))
```

```r
datos_inirango_vista <- recode(datos_inisaldo_vista,

"1 Menos de 5.000 €" <- range(min,5000),

"2 Entre 5.000 y 15.000 €" <- range(5000,15000),

"3 Entre 15.000 y 25.000 €" <- range(15000,25000),

"4 Ms de 25.000 €" <- range(25000,max))
```

Los intervalos creados son cerrados por la derecha. En el blog se ha tratado en [otra ocasi2n la recodificaci2n de los factores](https://analisisydecision.es/recodificar-el-valor-de-un-factor-en-r/) y no se trabaj2 con `memisc`. Bajo mi punto de vista `recode`+`memisc` es la mejor opci2n. Ya tenemos nuestras variables recodificadas y ahora tenemos que sumarizar y graficar el n2mero de clientes frente a las tasas de contrataci2n. A la hora de realizar informes los formatos son muy importantes. Por defecto en `R` estamos acostumbrados a trabajar con formatos americanos, comas para separar decimales y puntos para separar miles. Esto a mi no me gusta, prefiero el formato americano. Por ello lo primero que hacemos es crearnos unas funciones que nos den formatos europeos y formatos en porcentaje:

```r
#Funci2n para dar formatos a los datos

#Separador de miles europeo

sep.miles <- function(x){

format(x,big.mark=".")}

#Creaci2n de formatos de decimales

fmt.porcen <- function(x){

paste(format(round(x,2),decimal.mark = ","),'%')}
```

Estas funciones nos servirn para dar formatos a los n2meros de nuestras tablas. ?Como vamos a hacer las tablas? Con `ddply` por supuesto. Ahora las librer2as `plyr` y `ggplot2` son las que nos ayudarn a crear el informe:

```r
library(plyr)

library(ggplot2)
```

```r
#Realizamos la tabla de sumarizaci2n

resum1 <- ddply(datos_ini,"rango_edad",summarise,

clientes=length(rango_edad),

contrata=sum(pvi))

resum1tasa=fmt.porcen(resum1contrata*100/resum1clientes)

resum1clientes=sep.miles(resum1clientes)

resum1contrata=sep.miles(resum1$contrata)
```

```r
#Pintamos un diagrama de barras

png(file="C:\\temp\\informes\\resum1.png",width=600, height=450)

a <- ggplot(datos_ini, aes(rango_edad,fill=factor(pvi)))

a + geom_bar()

dev.off()
```

```r
resum2 <- ddply(datos_ini,"rango_vista",summarise,

clientes=length(rango_edad),

contrata=sum(pvi))

resum2tasa=fmt.porcen(resum2contrata*100/resum2clientes)

resum2clientes=sep.miles(resum2clientes)

resum2contrata=sep.miles(resum2$contrata)
```

```r
png(file="C:\\temp\\informes\\resum2.png",width=600, height=450)

a <- ggplot(datos_ini, aes(rango_vista,fill=factor(pvi)))

a + geom_bar()

dev.off()
```

Mucho c2digo. Los objetos `resumx` son las tablas que hemos de representar, son sumarizaciones del total de clientes y de los clientes que contratan el producto. Calculamos una `tasa` y aplicamos los correspondientes formatos. Al formatear los datos los n2meros pasan a ser texto, en ese sentido `R` no es como otras herramientas, no provoca muchos problemas. El 3ltimo paso es realizar el informe. Todo quedar almacenado en nuestro disco, en este caso trabajamos con `Windows` y guardamos el informe en `C:\Temp\informes`:

```r
library(R2HTML)

salida  = HTMLInitFile( "C:\\temp\\informes",filename="salida",

CSSFile="C:\\TEMP\\informes\\table_design.css")

HTML("<div align=center>")

HTML("<p align=center>Estudio por edad</p>" ,file=salida)

HTML(resum1, file=salida)

HTML("<p align=center>Clientes por rango de edad</p>")

HTML("<img src='c:\\temp\\informes\\resum1.png'></img>")

HTML("<p align=center>Estudio por saldo a la vista</p>" ,file=salida)

HTML(resum2, file=salida)

HTML("<p align=center>Clientes por saldo a la vista</p>")

HTML("<img src='c:\\temp\\informes\\resum2.png'></img>")

HTML("</div>")

HTMLEndFile()
```

El objeto `salida` es una p2gina esttica `HTML` que llama a una hoja de estilos, con esto podemos realizar tablas m2s bonitas y espectaculares. Esta p2gina se crea con la funci2n `HTMLInitFile`, con la funci2n `HTML` ya introducimos c2digo `HTML` a `salida` hasta que encontramos `HTMLEndFile`. Yo no soy ning2n experto en `HTML`, creo que ser2a mejor decir que no tengo ni idea pero con `Google` y `R2HTML` vamos a crear informes [tan bonitos como este](/images/2011/11/informes/salida.html).
