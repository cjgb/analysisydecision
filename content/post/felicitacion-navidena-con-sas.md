---
author: rvaquerizo
categories:
  - sas
date: '2009-12-30'
lastmod: '2025-07-13'
related:
  - sas-te-felicita-la-navidad.md
  - macros-faciles-de-sas-normaliza-un-texto-rapido.md
  - monograficos-call-symput-imprescindible.md
  - macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
  - analisisydecision-es-os-desea-felices-fiestas.md
tags:
  - sas
title: Felicitación navideña con SAS
url: /blog/felicitacion-navidena-con-sas/
---

Ejecutad el siguiente código en SAS local:

\`\`\`data _null_;\`

/\*
LA 440
SI 494
DO 523
RE 587
MI 659
FA 698
SOL 784
LA 880
\*/

call sound(659,100);
call sound(659,100);
call sound(659,200);
call sound(659,100);
call sound(659,100);
call sound(659,200);

call sound(659,100);
call sound(784,100);
call sound(523,100);
call sound(587,100);
call sound(659,400);

call sound(698,100);
call sound(698,100);
call sound(698,150);
call sound(698,50);

call sound(698,100);
call sound(698,100);
call sound(659,100);
call sound(659,50);
call sound(659,50);

call sound(659,100);
call sound(587,100);
call sound(587,100);
call sound(659,100);

call sound(587,200);
call sound(784,200);

run;

Buen ejemplo de la función CALL SOUND (frecuencia, duracion)
