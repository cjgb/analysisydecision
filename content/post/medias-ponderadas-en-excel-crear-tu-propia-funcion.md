---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2019-07-12T10:18:11-05:00'
lastmod: '2025-07-13T16:02:18.171630'
related:
- truco-excel-nuestra-propia-funcion-excel.md
- truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
- truco-excel-producto-cartesiano-de-dos-campos.md
- trucos-excel-convertir-texto-en-un-resultado-o-formula.md
- trucos-sas-calcular-percentiles-como-excel-o-r.md
slug: medias-ponderadas-en-excel-crear-tu-propia-funcion
tags: []
title: Medias ponderadas en Excel. Crear tu propia función
url: /blog/medias-ponderadas-en-excel-crear-tu-propia-funcion/
---

Hace años conocí a una persona que no sabía hacer medias ponderadas con Excel, hoy esa persona es una referencia dentro de este ecosistema de Inteligencia Artificial, Big Data, Machine Learning, Unsupervised Learning,… total, una referencia en la venta de humo porque me imagino que seguirá sin saber hacer una media ponderada en Excel con el SUMAPRODUCTO y por eso realizo esta entrada en homenaje a esas grandes locomotoras que echan humo y más humo pero que ahí siguen. Además también es útil para varias cosas más como:

  * Crear nuestra propia función en Excel
  * Emplear rangos en funciones de Excel
  * Crear sumas acumuladas con un bucle en nuestra función
  * Emplear funciones propias de Excel en nuestra función de visual basic

La función es sencilla y replica la forma habitual de hacer medias ponderadas en Excel con el SUMAPRODUCTO del dato del que deseamos calcular la media por el campo de ponderación dividido por la suma del campo de ponderación:

```r
Public Function MEDIAPONDERADA(Valor As Range, Ponderacion As Range)

 If Valor.Rows.Count <> Ponderacion.Rows.Count Then
 Sample = "Tamaños distintos de rango"
 Exit Function

 ElseIf Valor.Rows.Count = 1 Then
 Sample = "Solo un número no se puede"
 Exit Function
 End If

 acum = 0
 For i = 1 To Valor.Rows.Count
   dato = Valor(i) * Ponderacion(i)
   acum = acum + dato
 Next

 MEDIAPONDERADA = acum / Excel.WorksheetFunction.Sum(Ponderacion)

End Function
```


Esta función la ponéis en el libro de macros personal y cuando escribáis =MEDIAPONDERADA ya la tendréis a vuestra disposición en todas las sesiones de Excel. Saludos.