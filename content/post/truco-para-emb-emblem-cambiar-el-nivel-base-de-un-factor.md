---
author: rvaquerizo
categories:
- Formación
- Modelos
- Trucos
date: '2015-10-22T03:28:09-05:00'
slug: truco-para-emb-emblem-cambiar-el-nivel-base-de-un-factor
tags:
- emblem
title: Truco para EMB Emblem. Cambiar el nivel base de un factor
url: /truco-para-emb-emblem-cambiar-el-nivel-base-de-un-factor/
---

Un buen truco que me han descubierto hoy para los usuarios de EMB Emblem, como cambiar el nivel base de un factor de datos sin necesidad de pasar por los datos (habitualmente SAS) o sin hacerlo a posteriori (habitualmente Excel y lo que hacía el ahora escribiente). Cuando se generan los datos se genera el fichero binario *.BID y el fichero que se emplea para leer ese fichero *.FAC; para alterar el nivel base debemos abrir este archivo *.FAC con un block de notas o cualquier editor de texto plano. Al abrirlo tendremos lo siguiente:

XXXXXXXXXX –> ES EL NOMBRE DEL ARCHIVO  
99 –>ES EL NÚMERO DE FACTORES  
XXXXXXXXXX.Bid –> ES EL NOMBRE DEL ARCHIVO BINARIO CON LOS DATOS  
0  
99999999 –> ES EL NÚMERO DE REGISTROS  
No. Levels Base –> ES LA DESCRIPCION DE LO QUE VIENE A CONTINUACIÓN  
XXXXXXXXXXXX –> NOMBRE DE UN FACTOR  
999 **99** –> EL PRIMERO ES EL NÚMERO DE NIVELES Y **EL SEGUNDO ES EL NIVEL BASE**

ASÍ PARA TODOS LOS FACTORES. Si deseamos cambiar el nivel base de un factor sólo tenemos que cambiar ese segundo número que hay tras cada definición de los factores. Un truco muy sencillo y que será de utilidad para aquellos que usáis EMB Emblem. Saludos.