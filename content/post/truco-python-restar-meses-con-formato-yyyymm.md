---
author: rvaquerizo
categories:
- Formación
- Python
- Trucos
date: '2018-04-10T11:27:19-05:00'
lastmod: '2025-07-13T16:07:50.300363'
related:
- trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
- macros-sas-transformar-un-numerico-a-fecha.md
- bucle-de-fechas-con-sas-para-tablas-particionadas.md
- truco-excel-pasar-de-numero-con-formato-aaaammdd-a-fecha-con-formulas.md
- macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
slug: truco-python-restar-meses-con-formato-yyyymm
tags: []
title: Truco Python. Restar meses con formato YYYYMM
url: /truco-python-restar-meses-con-formato-yyyymm/
---

La operación con fechas en meses con el formato YYYYMM es tarea habitual cuando trabajamos con tablas particionadas. De hecho [hay una entrada en el blog sobre esto muy popular](https://analisisydecision.es/trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle/). Me ha surgido este tema con Python y os pongo la función que he creado:

```r
def dif_mes(d1, d2):
    return (d1//100 - d2//100) * 12 + d1%100 - d2%100

dif_mes (201812,201709)
```
 

Muy sencilla, por si os surge la necesidad.