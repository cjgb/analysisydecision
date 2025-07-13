---
author: rvaquerizo
categories:
- Excel
- Trucos
date: '2010-02-21T09:59:46-05:00'
lastmod: '2025-07-13T16:09:10.702197'
related:
- truco-sas-sas-y-dde-aliados-de-excel.md
- trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- trucos-excel-pasar-de-caracter-a-numerico-con-formulas.md
- macros-sas-pasar-de-texto-a-numerico.md
slug: trucos-excel-modificar-la-configuracion-regional-con-visual-basic
tags:
- Application
- configuracion regional
- DecimalSeparator
- pegar R
- pegar SAS
- ThousandsSeparator
title: Trucos Excel. Modificar la configuración regional con Visual Basic
url: /trucos-excel-modificar-la-configuracion-regional-con-visual-basic/
---

Con Visual Basic podemos modificar la configuración regional. Podemos crear macros en Excel que nos realicen esta tarea. De este modo si trabajamos con aplicaciones que tienen configuración americana podemos cambiar con una macro, pegar los valores y volver a cambiar la configuración. Para poner separador decimal «.» y separador de miles «,» tendremos que emplear el siguiente código:  

```r
Sub formato_americano()'' formato_americano Macro'

With Application

.DecimalSeparator = "."

.ThousandsSeparator = ","

.UseSystemSeparators = False

End With

End Sub
```
  
Es un excelente ejemplo de uso de _Application._ De forma análoga si deseamos volver a la configuración europea solo debemos emplear los separadores del sistema:  

```r
Sub formato_europeo() ' formato_americano Macro

With Application.UseSystemSeparators = True

End With

End Sub
```
  
Todo esto también lo podemos hacer desde el menú herramientas->opciones->internacional. Pero si creamos dos macros en nuestro libro personal y personalizando los menús asignamos dos botones a estas macros podemos copiar y pegar datos desde SAS a Excel (por ejemplo) sin tener que jugar con los formatos de SAS, podemos tener perfectamente tuneado nuestro Excel.

Está feo que lo diga yo, pero este truco Excel es impresionante y para todos aquellos que trabajamos con SAS o Res de gran utilidad. Si tenéis dudas o un trabajo a media jornada: rvaquerizo@analisisydecision.es

Saludos.