---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-11-06T11:41:05-05:00'
slug: trucos-sas-autonumerico-con-proc-sql
tags: []
title: Trucos sas. Autonumérico con PROC SQL
url: /trucos-sas-autonumerico-con-proc-sql/
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