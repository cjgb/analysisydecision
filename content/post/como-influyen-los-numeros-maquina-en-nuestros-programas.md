---
author: rvaquerizo
categories:
- Formación
- R
date: '2008-10-01T05:45:35-05:00'
lastmod: '2025-07-13T15:55:00.632770'
related:
- truco-excel-nuestra-propia-funcion-excel.md
- ajuste-de-splines-con-r.md
- determinar-el-mimino-tamano-muestral-para-detectar-un-cambio-en-la-fraccion-no-conforme.md
- trucos-r-la-funcion-mod-para-r.md
- truco-sas-proc-format-vs-formato-percent.md
slug: como-influyen-los-numeros-maquina-en-nuestros-programas
tags:
- números maquina
- programación
title: Como influyen los números máquina en nuestros programas
url: /como-influyen-los-numeros-maquina-en-nuestros-programas/
---

Es imposible no cometer un error a la hora de ajustar un número de máquina ya que todos los números tienen un espacio asignado y números con infinitos decimales no se pueden almacenar en memoria correctamente. Este «pequeño» error puede influir en nuestra programación. Vamos a crear una función en R que nos permita ejemplificar como pueden influir los errores de aproximación de los números de máquina en la programación. La siguiente función realiza la operación aritmética 1.1/11, 3.3/33,… y, mediante la función IFELSE creamos una condición:

```r
> valores_maquina <- function (num) {

+ operacion<-((num*11)/10)/(num*11)

+ print(operacion)

+ ifelse(operacion<0.1,"OK","MAL")

+ }
```

La función valores_maquina tiene un sólo parámetro y realiza una operación que genera el valor 0.1, con IFELSE si ese valor generado es mayor que 0.1 nos pondrá OK, si no es mayor nos pondrá MAL. En principio siempre debería poner el valor MAL ya que 0.1 < 0.1 es falso. Entonces:

```r
> valores_maquina(1)

[1] 0.1

[1] "MAL"

> valores_maquina(2)

[1] 0.1

[1] "MAL"

> valores_maquina(3)

[1] 0.1

[1] "OK"

> valores_maquina(4)

[1] 0.1

[1] "MAL"

> valores_maquina(5)

[1] 0.1

[1] "MAL"

> valores_maquina(6)

[1] 0.1

[1] "OK"

> valores_maquina(7)

[1] 0.1

[1] "MAL"
```

¡Aquí pasa algo! Los ceros y unos es lo que tienen… Esto es debido a los números de máquina, en la red encontraréis mucha documentación al respecto sobre este tema. Pero desde aquí recomendaros que uséis la función ROUND:

```r
> valores_maquina <- function (num) {

+ operacion<-((num*11)/10)/(num*11)

+ operacion<-round(operacion,digits=5)

+ print(operacion)

+ ifelse(operacion<0.1,"OK","MAL")

+ }

> valores_maquina(3)

[1] 0.1

[1] "MAL"
```