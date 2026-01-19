---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2010-06-11'
lastmod: '2025-07-13'
related:
- trucos-sas-identificar-registros-duplicados.md
- truco-sas-proc-contents.md
- macros-faciles-de-sas-busca-duplicados.md
- macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
- trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
tags:
- output
title: Truco SAS. Duplicar registros si cumplen una condición
url: /blog/truco-sas-duplicar-registros-si-cumplen-una-condicion/
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