---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2011-05-12T14:43:57-05:00'
slug: trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica
tags:
- macro excel
- tabla dinamica
title: Trucos Excel. Múltiples campos calculados en una tabla dinámica
url: /trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica/
---

Truco Excel muy rápido y que os permite crear múltiples campos calculados en una tabla dinámica de Excel. Imaginemos que tenemos una tabla dinámica con un campo que es la suma de la exposición al riesgo y por otro lado tenemos el número de siniestros. Estos dos campos los tenemos para 30 coberturas. Si queremos crear un campo calculado que sea la frecuencia siniestral (número de siniestros/exposición) para esos 30 campos tenemos que irnos a herramientas de tabla dinámica, fórmulas, definir el nuevo campo,… O bien podemos hacer emplear la siguiente macro:

```r
Sub calculados()

'Tendríamos que modificar el nombre de la tabla dinámica
```

'

ActiveSheet.PivotTables("Tabla dinámica4").CalculatedFields.Add "FREQ1", _

"=N_SINIESTROS_1 /EXPOSICION_1", True

ActiveSheet.PivotTables("Tabla dinámica4").CalculatedFields.Add "FREQ2", _

"=N_SINIESTROS_2 /EXPOSICION_2", True

'

'

'

ActiveSheet.PivotTables("Tabla dinámica4").CalculatedFields.Add "FREQ30", _

"=N_SINIESTROS_30 /EXPOSICION_30", True

End Sub

Macro sencilla y que puede ahorraros muchos pasos con las fórmulas de las tablas dinámicas. Espero que sea de utilidad. Saludos.