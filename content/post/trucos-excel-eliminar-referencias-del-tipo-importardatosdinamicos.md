---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2009-05-21'
lastmod: '2025-07-13'
related:
  - truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic.md
  - truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro.md
  - trucos-excel-transponer-con-la-funcion-desref.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - trucos-excel-trasponer-con-la-funcion-indirecto.md
tags:
  - excel
  - formación
  - trucos
title: Trucos Excel. Eliminar referencias del tipo IMPORTARDATOSDINAMICOS
url: /blog/trucos-excel-eliminar-referencias-del-tipo-importardatosdinamicos/
---

A la hora de referenciar en Excel celdas de tablas dinámicas es muy molesto encontrarnos con referencias del tipo «`+IMPORTARDATOSDINAMICOS("CLIENTES"; F3;"POTENCIAL";2)`» El `IMPORTARDATOSDINAMICOS` puede resultarnos muy molesto para trabajar con fórmulas que normalmente arrastramos. Para evitar este problema hemos de colocar en la barra de herramientas el botón «`Generar GetPivotData`». Esto lo hacemos ubicándonos en una barra de herramientas y con el botón derecho nos vamos a Personalizar y entre los botones de datos tenemos el `Generar GetPivotData`, como vemos en la figura adjunta. Lo seleccionamos y lo pulsamos cuando deseemos no tener la dichosa fórmula del `IMPORTARDATOSDINAMICOS` y podemos hacer fórmulas más habituales.

![Generar GetPivotData button in Excel](/images/2009/04/quitar-importardatosdinamicos.thumbnail.JPG "quitar-importardatosdinamicos.JPG")

Un truco sencillo pero que me he dado cuenta que trae a más de un «experto en Excel» de cabeza. Espero que os sea de utilidad. En mi entorno le ha hecho feliz a más de uno.
