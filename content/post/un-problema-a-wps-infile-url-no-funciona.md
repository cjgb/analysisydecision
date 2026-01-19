---
author: rvaquerizo
categories:
  - consultoría
  - sas
date: '2010-02-07'
lastmod: '2025-07-13'
related:
  - curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
  - acercamiento-a-wps-migrando-desde-sas.md
  - ayudadme-importar-a-sas-texto-con-comillas.md
  - como-abrir-proyectos-de-enterprise-guide-corruptos-o-de-una-version-anterior.md
  - truco-leer-sas7bdat-sin-sas.md
tags:
  - sin etiqueta
title: Un problema a WPS. Infile url no funciona
url: /blog/un-problema-a-wps-infile-url-no-funciona/
---

ERROR: url is not a valid access method. The access method names are : DDE, EMAIL

He encontrado una pega que no me gusta al WPS:

filename pepin url «http://news.google.es/news?q=banco santander&oe=utf-8&rls=org.mozilla:es-ES:official&client=firefox-a&um=1&ie=UTF-8&sa=N&hl=es&tab=wn»;

data uno;
infile pepin;
run;

No se puede hacer en WPS. Desconozco si es necesario otro modulo, pero es un problema. Aun asi me sigue gustando mucho.
