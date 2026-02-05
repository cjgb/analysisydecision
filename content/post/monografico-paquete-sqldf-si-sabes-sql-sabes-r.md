---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2010-01-12'
lastmod: '2025-07-13'
related:
  - trucos-r-funcion-ddply-del-paquete-plyr.md
  - proc-sql-merge-set.md
  - capitulo-4-uniones-de-tablas-con-r.md
  - tres-fracasos-y-medio-con-r.md
  - data-management-con-dplyr.md
tags:
  - merge
  - r
  - sql
  - sqldf
title: Monográfico. Paquete sqldf, si sabes SQL, sabes R
url: /blog/monografico-paquete-sqldf-si-sabes-sql-sabes-r/
---

El paquete `sqldf` de R nos permite ejecutar sentencias de `SQL`. Las cláusulas, las expresiones, los predicados… son la salvación para muchos tipos mediocres como el ahora escribiente. `sqldf` es un módulo imprescindible: casi cualquier persona con conocimientos básicos de bases de datos es capaz de programar en `SQL`. 

Evidentemente no voy a enseñaros a hacer *queries*, pero sí quiero mostraros algunas de las posibilidades que nos ofrece este paquete de R. Como siempre, trabajaremos con ejemplos. El primer paso es crear un `data.frame`:

```r
# Generamos datos aleatorios
saldo1 <- runif(100, 0, 1) * 1000
saldo2 <- runif(100, 0, 0.5) * 10000
saldos <- data.frame(saldo1, saldo2)

saldos$id_cliente <- 1:100
saldos$alto <- as.factor(ifelse(saldos$saldo1 + saldos$saldo2 >= 4000, 1, 2))

summary(saldos)
```

Creamos una estructura con dos variables numéricas `saldo1` y `saldo2`, una variable `id_cliente` (autonumérica) y un factor que indica si los saldos son altos (1) o bajos (2). El primer paso es resumir los saldos por el factor `alto`. 

Programando en R, un tipo mediocre como yo emplearía la función `aggregate()`:

```r
# Usando aggregate de R base
d1 <- aggregate(saldos$saldo1, list(alto = saldos$alto), FUN = max)
names(d1)[2] <- "max_saldo1"

d2 <- aggregate(saldos$saldo1, list(alto = saldos$alto), FUN = min)
names(d2)[2] <- "min_saldo1"

# ... y así sucesivamente para saldo2 ...
agr <- merge(d1, d2, by = "alto")
```

No queda exactamente como debiera, pero es un código rápido y sencillo. Sin embargo, muchos preferimos emplear `SQL` para agregar datos:

```r
library(sqldf)

agr2 <- sqldf('
  SELECT alto,
         MAX(saldo1) AS max_saldo1,
         MIN(saldo1) AS min_saldo1,
         MAX(saldo2) AS max_saldo2,
         MIN(saldo2) AS min_saldo2
  FROM saldos
  GROUP BY alto
')
```

Sencillo código, perfectamente entendible. Migrar de otra aplicación a R puede ser menos complicado de lo que nos creemos. Evidentemente también podemos realizar uniones (*joins*) entre tablas. Comparamos el código en R base con el código análogo en `sqldf` y así aprendemos a usar la función `merge()`:

```r
# Creamos una muestra aleatoria de 50 registros
muestra <- data.frame(muestra = sample(1:100, 50))

# En esta unión nos quedamos con las observaciones de muestra (Left Join)
saldos.muestra <- merge(saldos, muestra, by.x = "id_cliente", by.y = "muestra", all.y = TRUE)
```

Si esta unión la intenta alguien con mentalidad `SQL`, lo primero que hace es una mítica `LEFT JOIN`:

```r
saldos.muestra2 <- sqldf('
  SELECT b.*
  FROM muestra a 
  LEFT JOIN saldos b ON a.muestra = b.id_cliente
')
```

La `INNER JOIN`, imprescindible en este monográfico:

```r
# Empleando merge:
muestra2 <- data.frame(muestra = sample(1:1000, 100))

saldos.muestra.21 <- merge(saldos, muestra2, by.x = "id_cliente", by.y = "muestra")

# Empleando sqldf:
saldos.muestra.22 <- sqldf('
  SELECT a.*
  FROM saldos a 
  INNER JOIN muestra2 b ON a.id_cliente = b.muestra
')
```

Y por último la `FULL JOIN`:

```r
saldos.muestra.31 <- merge(saldos, muestra2, by.x = "id_cliente", 
                           by.y = "muestra", all = TRUE)
```

No he puesto el código análogo para `sqldf` porque, dependiendo del motor que use por debajo (habitualmente `SQLite`), puede que no soporte `FULL JOIN` o `RIGHT JOIN`. Pero no me negaréis que el código en R base es muy sencillo también.

¿A qué estás esperando para usar R en la gestión de datos? Saludos.