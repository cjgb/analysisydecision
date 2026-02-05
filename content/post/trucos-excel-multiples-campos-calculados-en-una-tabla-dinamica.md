---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2011-05-12'
lastmod: '2025-07-13'
related:
  - truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro.md
  - truco-excel-producto-cartesiano-de-dos-campos.md
  - truco-excel-agrupar-valores-en-un-campo-de-una-tabla-dinamica.md
  - truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic.md
  - truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
tags:
  - macro excel
  - tabla dinamica
title: Trucos Excel. Múltiples campos calculados en una tabla dinámica
url: /blog/trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica/
---

Truco de `Excel` muy rápido que os permite crear múltiples campos calculados en una tabla dinámica. Imaginemos que tenemos una tabla dinámica con un campo que es la suma de la exposición al riesgo y, por otro lado, tenemos el número de siniestros. Estos dos campos los tenemos para 30 coberturas. Si queremos crear un campo calculado que sea la frecuencia siniestral (número de siniestros / exposición) para esos 30 campos, tenemos que irnos a herramientas de tabla dinámica, fórmulas, definir el nuevo campo… O bien podemos emplear la siguiente macro:

```vba
Sub CreaCamposCalculados()
    Dim pt As PivotTable
    Dim i As Integer
    Dim nombreCampo As String
    Dim formulaCampo As String

    ' Referencia a la primera tabla dinámica de la hoja activa
    Set pt = ActiveSheet.PivotTables(1)

    ' Bucle para crear múltiples campos calculados (ejemplo para 3 coberturas)
    For i = 1 To 3
        nombreCampo = "Frecuencia_Cobertura_" & i
        ' La fórmula usa los nombres de los campos existentes
        formulaCampo = "='Siniestros_" & i & "' / 'Exposicion_" & i & "'"
        
        pt.CalculatedFields.Add nombreCampo, formulaCampo
        pt.PivotFields(nombreCampo).Orientation = xlDataField
    Next i
End Sub
```

Macro sencilla que puede ahorraros muchos pasos con las fórmulas de las tablas dinámicas. Espero que sea de utilidad. Saludos.