---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2010-06-11T06:14:22-05:00'
slug: truco-sas-duplicar-registros-si-cumplen-una-condicion
tags:
- output
title: Truco SAS. Duplicar registros si cumplen una condición
url: /truco-sas-duplicar-registros-si-cumplen-una-condicion/
---

Mejor que truco, tontería SAS pero sirve para entender mejor el paso DATA. Se trata de duplicar registros si cumplen una condición. Es decir, añadimos una fila en SAS si se cumple la condición:

```r
data uno;

do id_cliente=1 to 10000;

output;

end;

run;

data uno;

set uno;

output;

if mod(id_cliente,2)=0 then output;

run;
```

No puede ser más sencillo pero me llegó esta duda y me parece un buen ejemplo de uso de OUTPUT.