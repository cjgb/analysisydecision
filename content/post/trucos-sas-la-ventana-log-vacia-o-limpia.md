---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2011-06-28'
lastmod: '2025-07-13'
related:
  - trucos-sas-borrando-blancos-innecesarios-con-compbl.md
  - trucos-sas-eliminacion-de-espacios-en-blanco.md
  - curso-de-lenguaje-sas-con-wps-ejecuciones.md
  - truco-sas-elminar-retornos-de-carro-o-saltos-de-linea-engorrosos.md
  - truco-sas-duplicar-registros-si-cumplen-una-condicion.md
tags:
  - log
  - proc printto
title: Trucos SAS. La ventana LOG vacía o limpia
url: /blog/trucos-sas-la-ventana-log-vacia-o-limpia/
---

Duda que me trasmitieron hace tiempo. Necesito que no se genere salida en el _log_ porque se llena y mi proceso da problemas. Con el **PROC PRINTTO** podemos hacer que nuestros procesos no generen salida en la ventana _log_. Para ello sólo tenemos que utilizar el siguiente código:

`proc printto log='null'; quit;`

Si deseamos volver a tener resultados en la ventana _log_ sólo tenemos que hacer:

`proc printto log=log; quit;`

Con el PROC PRINTTO no sólo podemos dirigir el _log_ a un fichero, también podemos dirigir el OUTPUT con la opción PRINT. Tenéis muchos ejemplos en la red acerca de este tema. Para limpiar el _log_ también podemos emplear la instrucción DM:

`dm log 'clear';`

Esta instrucción no la empleo habitualmente. Un truco SAS muy sencillo y que puede seros de utilidad. Saludos.
