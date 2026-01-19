---
author: danifernandez
categories:
- formación
date: '2010-06-16'
lastmod: '2025-07-13'
related:
- truco-excel-y-sas-ejecutar-sas-desde-macro-en-excel.md
- comunicar-sas-con-r-creando-ejecutables-windows.md
- 1500-visitas-mensuales.md
- macros-sas-dataset-a-data-frame-r.md
- macros-faciles-de-sas-normaliza-un-texto-rapido.md
tags:
- sin etiqueta
title: X command (MS-DOS prompt) desde SAS.
url: /blog/x-command-ms-dos-prompt-desde-sas/
---
Como veo que a Raul le faltan algunas visitas para llegar a las 5000 (mensuales?), y dado que se curra esta web para dar a conocer multiples trucos en R, SAS, WPS, et…, he decidido crear esta sencilla macro (si queremos que el X command se ejecute repetitivamente dentro de un bucle, solo puede hacerse dentro de una macro pues si la ejecutamos dentro de un paso data SOLO lo ejecuta 1 vez por más que escribamos ‘do i=1 to 100;’ ). El comando X lo que hace es traspasar la sentencia SAS a ‘cmd’ o ‘command’ del MS-DOS. Aqui solo lo limito hasta 5 en modo de ejemplo:

```sas
options noxwait noxsync;

%macro visitar_analisisydecision;
%do z=1 %to 5;
x ‘start https://analisisydecision.es/’;
%end;
%mend;
%visitar_analisisydecision
```

Raul, ya tienes 5 visitas más…. ¿el contador de visitas lo percibe o no? (Sorry por mi ignorancia respecto a los web analytics).

un saludo!
