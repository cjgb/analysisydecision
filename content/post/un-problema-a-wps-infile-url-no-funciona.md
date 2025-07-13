---
author: rvaquerizo
categories:
- Consultoría
- SAS
date: '2010-02-07T13:24:59-05:00'
slug: un-problema-a-wps-infile-url-no-funciona
tags: []
title: Un problema a WPS. Infile url no funciona
url: /un-problema-a-wps-infile-url-no-funciona/
---

ERROR: url is not a valid access method. The access method names are : DDE, EMAIL

He encontrado una pega que no me gusta al WPS:

filename pepin url «http://news.google.es/news?q=banco santander&oe=utf-8&rls=org.mozilla:es-ES:official&client=firefox-a&um=1&ie=UTF-8&sa=N&hl=es&tab=wn»;

data uno;  
infile pepin;  
run;

No se puede hacer en WPS. Desconozco si es necesario otro modulo, pero es un problema. Aun asi me sigue gustando mucho.