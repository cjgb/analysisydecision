---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2011-02-01T14:59:42-05:00'
lastmod: '2025-07-13T16:09:46.235196'
related:
- trucos-sas-eliminacion-de-espacios-en-blanco.md
- espacios-en-sas.md
- truco-sas-limpieza-de-tabuladores-con-expresiones-regulares.md
- macros-sas-limpiar-una-cadena-de-caracteres.md
- trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
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