---
author: rvaquerizo
categories:
  - excel
  - trucos
date: '2008-07-07'
lastmod: '2025-07-13'
related:
  - trucos-sas-envio-de-email-con-data.md
  - enviar-correos-electronicos-con-rstats-libreria-emayili.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - trucos-excel-archivos-de-un-directorio-con-una-macro.md
  - truco-excel-insertar-imagenes-con-visual-basic.md
tags:
  - sin etiqueta
title: Trucos Excel. Crear un borrador de correo con Excel
url: /blog/trucos-excel-crear-un-borrador-de-correo-con-excel/
---

Inicio una serie de mensajes con trucos de Excel que considero pueden ser de utilidad para realizar tareas habituales en nuestro trabajo diario. Este primer truco Excel consiste en una macro que nos permite crear en borradores correos electrónicos. También nos permitiría enviarlos directamente, pero en ese caso habríamos de tener permisos para que otras aplicaciones accedieran a Outlook. Veamos el código que emplea:

```r
Sub Correo()
```

```r
Dim ol As Object, myItem As Object

Dim adjunto As String
```

```r
Set ol = CreateObject("outlook.application")

Set myItem = ol.CreateItem(olMailItem)
```

adjunto = "C:\\temp\\fichero.xls"

With myItem
.Subject = "Titulo del correo"
.Body = "Cuerpo del mensaje"
.To = "rvaquerizo@analisisydecision.es"
.Attachments.Add adjunto, 1, 500
.Close (olSave)
'.send (ol) 'Si tenemos permisos para enviar correos
End With

Set ol = Nothing

End Sub

Creamos un objeto Outlook y a ese objeto le añadimos título, cuerpo, destinatario, un archivo adjunto de C:/temp y lo guardamos como borrador, si tenemos los suficientes permisos podremos enviarlos con .Send Como os podéis imaginar esta es la versión menos sofisticada de la macro y a ella podemos añadir bucles, busquedas,... Espero que pueda seros de utilidad. Por supuesto si no funciona o tenéis dudas rvaquerizo@analisisydecision.es
