---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2010-06-07T09:26:50-05:00'
slug: un-acercamiento-a-graph-annotate-macros
tags:
- ANNOMAC
- ANNOTATE
- GRAPH
- PROC GANNO
title: Un acercamiento a GRAPH. ANNOTATE macros
url: /un-acercamiento-a-graph-annotate-macros/
---

No quiero entrar en muchos detalles sobre el uso de %_**ANNOMAC**_. Esta macro nos permite usar las macros de _**ANNOTATE**_. Estas macros sirven para trabajar con el PROC GANNO del que ya hicimos una [pequeña revisión](https://analisisydecision.es/un-acercamiento-a-graph-proc-ganno/). Ahora me gustaría presentaros un ejemplo de uso de estas macros y sobre todo me gustaría que analizáseis el conjunto de datos SAS generado. Pongo directamente todo el código necesario:

```r
*OPCIONES NECESARIAS;

goptions reset=global

         cback='white'

         colors=(blcack)

		xpixels=1000 ypixels=1000;;
```

%LET pos_inicial_x=50;  
%let pos_inicial_y=99;

Iniciamos con opciones globales y creamos unas posiciones iniciales. Estudiemos como trabaja annomac:

```r
%annomac;

data dibujo (where=( x>0 and x<100 and y>0 and y<100));
	length function style color $ 8 text $ 25;
	retain hsys xsys ysys '3';
	pos_x=&pos_inicial_x.;
	pos_y=&pos_inicial_y.;

	pos_x=&pos_inicial_x.;
	pos_y=&pos_inicial_y.;
	%rect(pos_x+2.5,pos_y,pos_x-2.5,pos_y-4, red,1,1);

	%LINE(50,95,50,93, red,1, 0.1);
	%LINE(25,93,75,93, red,1, 0.1);
	%LINE(25,93,25,91, red,1, 0.1);
	%LINE(75,93,75,91, red,1, 0.1);

	para=0;
	i=1;
	do while (para=0);
	i=i*2;
	pos_y=pos_y-8;
	do j=1 to 35 by 2;
	paso=(j/i);
	pos_x=&pos_inicial_x.*paso;
	%rect(pos_x+2,pos_y,pos_x-2,pos_y-4, red,1,1);

	if i>=10 then para=1;

	end;end;
```

%LINE(12.5,85,37.5,85, red,1, 0.1);  
%LINE(25,87,25,85, red,1, 0.1);  
%LINE(12.5,85,12.5,83, red,1, 0.1);  
%LINE(37.5,85,37.5,83, red,1, 0.1);

%LINE(62.5,85,87.5,85, red,1, 0.1);  
%LINE(75,87,75,85, red,1, 0.1);  
%LINE(62.5,85,62.5,83, red,1, 0.1);  
%LINE(87.5,85,87.5,83, red,1, 0.1);

do i=0 to 4;  
%LINE((12.5/2)+(25*i),77,(37.5/2)+(25*i),77, red,1, 0.1);  
%LINE(12.5+(25*i),79,12.5+(25*i),77, red,1, 0.1);  
%LINE((12.5/2)+(25*i),77,(12.5/2)+(25*i),75, red,1, 0.1);  
%LINE((37.5/2)+(25*i),77,(37.5/2)+(25*i),75, red,1, 0.1);  
end;

do i=0 to 8;  
%LINE((12.5/4)+(12.5*i),69,(37.5/4)+(12.5*i),69, red,1, 0.1);  
%LINE((12.5/2)+(12.5*i),71,(12.5/2)+(12.5*i),69, red,1, 0.1);  
%LINE((12.5/4)+(12.5*i),69,(12.5/4)+(12.5*i),67, red,1, 0.1);  
%LINE((37.5/4)+(12.5*i),69,(37.5/4)+(12.5*i),67, red,1, 0.1);  
end;

run;

proc ganno anno=dibujo;  
run;quit;

El proceso realiza rectángulos con las macros annotate y lo que hacemos es movernos por el dibujo empleando coordenadas. Ejecutad el código y sobre todo abrid el dataset dibujo para analizar que es lo que necesita el PROC GANNO. También me gustaría dejaros el [siguiente link ](http://support.sas.com/documentation/cdl/en/graphref/63022/HTML/default/viewer.htm#/documentation/cdl/en/graphref/63022/HTML/default/annotate_annomac.htm)por si estáis interesados en trabajar con este procedimiento. No será el único ejemplo que pondré al respecto. No irán muy comentados pero puede ser de utilidad para vuestro trabajo.

Saludos.