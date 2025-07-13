---
author: danifernandez
categories:
- Formación
date: '2010-06-16T15:58:42-05:00'
slug: x-command-ms-dos-prompt-desde-sas
tags: []
title: X command (MS-DOS prompt) desde SAS.
url: /x-command-ms-dos-prompt-desde-sas/
---

Como veo que a Raul le faltan algunas visitas para llegar a las 5000 (mensuales?), y dado que se curra esta web para dar a conocer multiples trucos en R, SAS, WPS, et…, he decidido crear esta sencilla macro (si queremos que el X command se ejecute repetitivamente dentro de un bucle, solo puede hacerse dentro de una macro pues si la ejecutamos dentro de un paso data SOLO lo ejecuta 1 vez por más que escribamos ‘do i=1 to 100;’ ). El comando X lo que hace es traspasar la sentencia SAS a ‘cmd’ o ‘command’ del MS-DOS. Aqui solo lo limito hasta 5 en modo de ejemplo:

options noxwait noxsync;

%macro visitar_analisisydecision;  
%do z=1 %to 5;  
x ‘start https://analisisydecision.es/’;  
%end;  
%mend;  
%visitar_analisisydecision

Raul, ya tienes 5 visitas más…. ¿el contador de visitas lo percibe o no? (Sorry por mi ignorancia respecto a los web analytics).

un saludo!