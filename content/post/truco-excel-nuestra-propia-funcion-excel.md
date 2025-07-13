---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2008-11-21T08:53:14-05:00'
slug: truco-excel-nuestra-propia-funcion-excel
tags: []
title: Truco Excel. Nuestra propia función redondear en Excel
url: /truco-excel-nuestra-propia-funcion-excel/
---

Hay operaciones que pueden ser muy habituales de hacer con Excel y necesitaríamos una función propia que la realizara. A continuación vamos a plantear una situación en la que es especialmente útil crear una función específica y guardarla en el libro de macros personal para utilizarla en nuestras sesiones SAS. En este caso concreto vamos a crear una función que nos redondeé un número a 0 o 0.5, es decir, 6,3 valdría 6 y 6,7 valdría 6,5. Para realizarlo sin una función específica emplaríamos múltiples funciones de Excel, por ejemplo:

`=ENTERO(6,3)+(SI(RESIDUO(6,3;1)>=0,5;0,5;0))`

Cada celda habría de tener esta fórmula para realizar el redondeo. Pero podemos crear nuestra propia función en el libro de macros personal. Para ello hacemos ALT + F11 y nos vamos al módulo de macros personal si existe y si no debemos crearlo. Allí será donde creemos nuestra función. Esta función recibe un número con decimales y devuelve el número redondeado, también con decimales. La sintaxis sería:

```r
Function redondea05(numero As Double) As Double
```

```r
Dim entero As Long

  Dim decima As Double
```

```r
'Obtenemos el entero

  entero = Int(numero)
```

```r
'Obtenemos la parte decimal

  decima = numero - entero
```

'Hacemos un condicional  
If decima < 0.5 Then  
redondea05 = entero  
Else  
redondea05 = entero + 0.5  
End If

End Function

Un código sencillo que hace prácticamente lo mismo que las funciones de Excel. Ahora sólo debemos poner en una casilla de nuestra tabla:

`=redondea05(6,5)`

Ya tenemos nuestra función disponible para cualquier sesión de Excel. Truco sencillo y al que seguro buscáis utilidad.

Como siempre, si alguien tiene dudas, sugerencias o un trabajo bien retribuido… rvaquerizo@analisisydecision.es