---
author: rvaquerizo
categories:
  - formación
  - r
  - trucos
date: '2011-01-07'
lastmod: '2025-07-13'
related:
  - recodificar-el-valor-de-un-factor-en-r.md
  - trucos-simples-para-rstats.md
  - trabajando-con-factores-en-r-attach-frente-a-within.md
  - truco-malo-de-r-leer-datos-desde-excel.md
  - analisis-de-textos-con-r.md
tags:
  - automatizar código
  - eval
  - parse
  - paste
  - r
  - replicate
title: Truco R. Eval, parse y paste para automatizar código
url: /blog/truco-r-eval-parse-y-paste-para-automatizar-codigo/
---

La función `paste` nos permite concatenar cadenas de texto con R:

```r
paste("Dato", 1:10, sep = "")
```

`parse` recoge una expresión pero no la evalúa:

```r
parse(text = "sqrt(121)")
```

Y, por último, `eval` evalúa una expresión:

```r
eval(parse(text = "sqrt(121)"))
```

Interesantes funciones que nos pueden permitir automatizar códigos recursivos o códigos guardados como objetos en R. Imaginemos el siguiente ejemplo:

```r
# Creamos un data frame con 20 variables aleatorias Poisson
ejemplo1 <- data.frame(replicate(20, rpois(20, 10)))

# Automatizamos los nombres de las columnas
nom <- paste("dato", 1:20, sep = "")
names(ejemplo1) <- nom

summary(ejemplo1)
```

Hemos automatizado los 20 nombres de un *data frame* con datos aleatorios con una distribución de Poisson de media 10 creado con la función `replicate`. Ahora imaginemos que deseamos transformar en factor sólo aquellos elementos del *data frame* con un sufijo par (`dato2`, `dato4`…). Podemos crear una función o podemos generar las ejecuciones de código R del siguiente modo:

```r
ejecucion <- paste("ejemplo1$dato", seq(2, 20, by = 2), 
                   " <- as.factor(ejemplo1$dato", seq(2, 20, by = 2), ")", sep = "")

ejecucion
```

El resultado es un vector de cadenas de texto con las instrucciones:

```text
[1] "ejemplo1$dato2 <- as.factor(ejemplo1$dato2)"
[2] "ejemplo1$dato4 <- as.factor(ejemplo1$dato4)"
...
[10] "ejemplo1$dato20 <- as.factor(ejemplo1$dato20)"
```

Ahora tenemos que hacer que este objeto con instrucciones se ejecute con `parse` y `eval`:

```r
eval(parse(text = ejecucion))

# Comprobamos los cambios
summary(ejemplo1)
```

Hemos transformado en factores los elementos con sufijo par. Esto también puede realizarse con `sapply` o `lapply`, pero merece la pena que le echéis un vistazo a este proceso, lo ejecutéis y aprendáis una forma de automatizar código mediante la evaluación de cadenas de texto. Saludos.