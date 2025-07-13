---
author: rvaquerizo
categories:
- Modelos
- SAS
date: '2012-11-15T08:55:47-05:00'
slug: parametro-asociado-a-una-poisson-con-sas
tags: []
title: Parámetro asociado a una Poisson con SAS
url: /parametro-asociado-a-una-poisson-con-sas/
---

Mirad que he visto datos en mi vida. Y esos datos siguen muchas distribuciones. Y una de las distribuciones más habituales con las que me he encontrado es la **distribución de poisson**. Esta distribución tiene una característica muy interesante: la varianza es igual que la media. Y si **la varianza no es igual a la media** tenemos distribuciones de poisson sobredispersa o poisson infradispersa con propiedades muy interesantes y que se emplea mucho en el ámbito actuarial, aunque tendremos eventos con una distribución de poisson cuando estamos hablando de eventos independientes en intervalos de tiempo. No soy yo el más adecuado para escribir sobre el modelo matemático que tienen detrás estas distribuciones, pero si me gustaría mostraros como hacer mediante SAS con el PROC GENMOD algo tan básico como obtener el parámetro asociado a mi distribución de poisson y el intervalo de confianza al 95% para este parámetro. Vale que el parámetro es la media pero tengo que escribiros un código SAS importante ¿Y cómo lo calculamos?

```r
*SIMULAMOS EL NÚMERO DE VISISTAS A UNA WEB
 EN HORARIO DE OFICINA;
data poisson;
do hora=8 to 17 by 0.5;
visitas = ranpoi(2,15);
output;
end;
run;
*GRAFICAMOS LA DISTRIBUCIÓN;
proc gchart data=poisson;
vbar hora /freq=visitas discrete;
run;quit;
*EMPLEAMOS EL PROC GENMOD PARA LA OBTENCIÓN
 DEL PARÁMETRO Y EL INTERVALO;
proc genmod data=poisson;
   model visitas = / dist=poisson;
   ods output parameterestimates=param;
run;
*ESTÁ EN ESCALA LOGARÍTMICA;
data param;
set param;
if _n_=1;
lamda = exp(estimate);
sup=exp(uppercl);
min=exp(lowercl);
call symput ('lamda',lamda);
run;
*CON PROC MEANS;
proc means data=poisson mean clm ;
var visitas;
quit;
```
 

Una entrada que puede parecer una tontería, pero que es necesaria para desordenar mi conciencia. Espero que os sea de utilidad, un saludo.