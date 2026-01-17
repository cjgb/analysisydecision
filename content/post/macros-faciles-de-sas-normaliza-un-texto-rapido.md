---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-11-08T10:49:24-05:00'
lastmod: '2025-07-13T16:00:51.333199'
related:
- macros-sas-limpiar-una-cadena-de-caracteres.md
- macros-sas-pasar-de-texto-a-numerico.md
- truco-sas-limpieza-de-tabuladores-con-expresiones-regulares.md
- trucos-sas-eliminacion-de-espacios-en-blanco.md
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
slug: macros-faciles-de-sas-normaliza-un-texto-rapido
tags:
- CALL PRXCHANGE
- TRANSLATE
- tranwrd
title: Macros (fáciles) de SAS. Normaliza un texto rápido
url: /blog/macros-faciles-de-sas-normaliza-un-texto-rapido/
---

¿Tienes que normalizar un texto con SAS? Llevas 2 horas buscando funciones de texto con la ayuda y te has crispado. En una macro y de forma muy rápida os planteo un muestrario de funciones con las que podéis normalizar (**un poco**) un texto. Esto es algo que tuve que hacer la otra mañana no es muy sofisticado pero que puede seros de utilidad:

```r
%macro prepara(varib);

&varib.=translate(&varib.,"AEIOU","ÁÉÍÓÚ");

&varib.=tranwrd(&varib.,"NUM","NUMERO");

&varib.=tranwrd(&varib.,"CONT","CONTABLE");

&varib.=tranwrd(&varib.,"IMP ","IMPORTE ");

&varib.=tranwrd(&varib.," POR "," ");

&varib.=tranwrd(&varib.," DE "," ");

&varib.=tranwrd(&varib.," EN "," ");

&varib.=tranwrd(&varib.," LOS "," ");

&varib.=tranwrd(&varib.," AL "," ");

&varib.=tranwrd(&varib.," EL "," ");

&varib.=tranwrd(&varib.," ULTIMOS 12 "," 12 ");

&varib.=tranwrd(&varib.," ULTIMOS 3 "," 3 ");

&varib.=tranwrd(&varib.," ULTIMO MES "," MES ");

&varib.=tranwrd(&varib.," TRANSACCIOENES "," TRANSACCIONES ");

call prxchange(prxparse('s/([A-ZÑa-zñ 0-9]*)([^A-Za-zÑñ 0-9]*)/$1/'),-1,&varib.);

%mend;
```

En realidad es una sucesión de TRANWRD pero destacaría el uso de la función TRANSLATE para eliminar tildes en nuestras vocales y el uso de CALL PRXCHANGE del que [ya tuvimos un aperitivo hace tiempo](https://analisisydecision.es/macros-sas-limpiar-una-cadena-de-caracteres/). Sólo tenéis que copiar y pegar y si tenéis dudas mejor seguid el hilo porque últimamente me están llegando demasiadas por correo y no dispongo de tiempo, algo que ya habréis detectado muchos de los seguidores del blog. De todos modos tengo trucos de estos para seguir dotando de contenido al blog en los próximos meses. Por cierto, si alguien lo mejora que siga el hilo…