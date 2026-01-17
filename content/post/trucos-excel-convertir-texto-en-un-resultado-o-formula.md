---
author: rvaquerizo
categories:
- Excel
- Trucos
date: '2020-09-10T01:53:18-05:00'
lastmod: '2025-07-13T16:08:54.213124'
related:
- trucos-excel-pasar-de-caracter-a-numerico-con-formulas.md
- trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada.md
- truco-excel-funcion-para-identificar-el-color-de-una-celda.md
- truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
- medias-ponderadas-en-excel-crear-tu-propia-funcion.md
slug: trucos-excel-convertir-texto-en-un-resultado-o-formula
tags: []
title: Trucos Excel. Convertir texto en un resultado o fórmula
url: /blog/trucos-excel-convertir-texto-en-un-resultado-o-formula/
---

[![](/images/2020/09/truco_excel_texto_a_formula.png)](/images/2020/09/truco_excel_texto_a_formula.png)

Es posible que en Excel tengamos fórmulas que provengan de la concatenación de algunas celdas y necesitemos ejecutar o crear una fórmula. En este caso he encontrado una función muy sencilla que podemos añadir a nuestro libro de macros personal o directamente a nuestro libro. La función es genial y sencilla y proviene de este foro:

<https://www.mrexcel.com/board/threads/eval-function-without-the-morefunc-add-in.62067/>

```r
Function Eval(Ref As String)
Application.Volatile
Eval = Evaluate(Ref)
End Function
```


Tiene muchos años pero podéis comprobar que funciona perfectamente. Esta solución me parece más elegante que otras, aunque es probable que MS haya optado por incluir una función que haga esta labor, lo desconozco. Saludos.