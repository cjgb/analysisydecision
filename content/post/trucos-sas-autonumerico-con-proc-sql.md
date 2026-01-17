---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-11-06T11:41:05-05:00'
lastmod: '2025-07-13T16:09:44.792836'
related:
- truco-sas-duplicar-registros-si-cumplen-una-condicion.md
- trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento.md
- trucos-sas-identificar-registros-duplicados.md
- truco-sas-observaciones-de-un-dataset-en-una-macro-variable.md
- macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
slug: trucos-sas-autonumerico-con-proc-sql
tags: []
title: Trucos sas. Autonumérico con PROC SQL
url: /blog/trucos-sas-autonumerico-con-proc-sql/
---

Rápido. Me ha llegado una consulta que me preguntaba como crear un campo autonumérico con PROC SQL. Tenemos que emplear la funciòn _monotonic():_

```r
data uno;

do i=1 to 100;

output; end;

run;

proc sql;

create table uno as select

monotonic() as obs,

a.*

from uno a

where mod(i,2)=0;

quit;
```

Equivale al __n__ de un paso data. Es una tontería pero a un lector del blog le ha venido bien. Saludos.