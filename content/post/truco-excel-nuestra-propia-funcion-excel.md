---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2008-11-21'
lastmod: '2025-07-13'
related:
  - medias-ponderadas-en-excel-crear-tu-propia-funcion.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
  - trucos-excel-convertir-texto-en-un-resultado-o-formula.md
  - trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Nuestra propia función redondear en Excel
url: /blog/truco-excel-nuestra-propia-funcion-excel/
---

Hay operaciones que pueden ser muy habituales de hacer con `Excel` y para las que necesitaríamos una función propia que las realizara. A continuación, vamos a plantear una situación en la que es especialmente útil crear una función específica y guardarla en el libro de macros personal para utilizarla en nuestras sesiones. 

En este caso concreto, vamos a crear una función que nos redondee un número a 0 o 0,5; es decir, 6,3 valdría 6 y 6,7 valdría 6,5. Para realizarlo sin una función específica emplearíamos múltiples funciones de `Excel`, por ejemplo:

```text
=ENTERO(6,3) + (SI(RESIDUO(6,3; 1) >= 0,5; 0,5; 0))
```

Cada celda habría de tener esta fórmula para realizar el redondeo. Pero podemos crear nuestra propia función en el libro de macros personal. Para ello hacemos `ALT + F11` y nos vamos al módulo de macros personal (si no existe, debemos crearlo). Allí será donde definamos nuestra función. Esta función recibe un número con decimales y devuelve el número redondeado. La sintaxis sería:

```vba
Function redondea05(numero As Double) As Double
    Dim entero As Long
    Dim decima As Double

    ' Obtenemos la parte entera
    entero = Int(numero)
    
    ' Obtenemos la parte decimal
    decima = numero - entero
    
    ' Hacemos un condicional para redondear
    If decima < 0.5 Then
        redondea05 = entero
    Else
        redondea05 = entero + 0.5
    End If
End Function
```

Un código sencillo que hace prácticamente lo mismo que la combinación de funciones de `Excel`. Ahora sólo debemos poner en una celda de nuestra tabla:

```text
=redondea05(6,7)
```

Ya tenemos nuestra función disponible para cualquier sesión de `Excel`. Truco sencillo y al que seguro buscáis utilidad.

Como siempre, si alguien tiene dudas, sugerencias o un trabajo bien retribuido… `rvaquerizo@analisisydecision.es`. Saludos.