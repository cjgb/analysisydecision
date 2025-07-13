---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2011-02-01T14:59:42-05:00'
slug: trucos-sas-borrando-blancos-innecesarios-con-compbl
tags:
- COMPBL
- funciones SAS caracter
title: Trucos SAS. Borrando blancos innecesarios con COMPBL
url: /trucos-sas-borrando-blancos-innecesarios-con-compbl/
---

Me ha llegado hoy una duda interesante. El problema era eliminar espacios en blanco innecesarios mediante alguna función de SAS. Más concretamente teníamos algo parecido a:

```r
data prueba;

nombre="DE PEDRO                     MARTINEZ                ESTEBAN JOSE";

/*QUEREMOS LLEGAR A: DE PEDRO MARTINEZ ESTEBAN JOSE*/

run;
```

Pues bien, esto se puede hacer con la función **COMPBL** que “ _remove blank spaces with SAS_ ”:

```r
data prueba;

nombre="DE PEDRO                 MARTINEZ             ESTEBAN JOSE";

nombre2=compbl(nombre);

put nombre2;

run;
```

Una función fácil y práctica que seguro conocéis pero que no está mal recordar. Saludos.