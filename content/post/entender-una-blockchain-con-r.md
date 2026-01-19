---
author: rvaquerizo
categories:
- big data
- consultoría
- r
date: '2020-04-09'
lastmod: '2025-07-13'
related:
- objetos-hash-para-ordenar-tablas-sas.md
- laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- analisis-de-textos-con-r.md
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
tags:
- digest
title: Entender una blockchain con R
url: /blog/entender-una-blockchain-con-r/
---
Una introducción de bajo nivel (sin entrar mucho en tecnología) a los blockchain con #rtats. Es una entrada destinada a comprender que es un blockchain desde otro punto de vista, no sólo criptografía o criptomoneda, podemos poner información que sólo conoce el origen. ¿Os imagináis si pusieran a disposición de los científicos de datos información sobre todos los españoles identificados por NIF y si tiene o no coronavirus? Los científicos de datos podrían trabajar de forma anónima con esos datos y ayudar a establecer las zonas libres de covid-19, persona a persona de forma perfectamente anónima. Aunque no se descarta que algún cabestro se dedicara a desencriptar…

Al lío, de forma sencilla vamos a construir nuestra cadena de bloques aunque particularmente me gusta mucho el término contabilidad distribuida. Por ese motivo vamos a crear un apunte contable y distribuirlo dentro de una blockchain. No soy un experto en contabilidad pero se me ocurre crear un apunte contable del siguiente modo:

```r
#Definimos un bloque como una transacción
bloque <- list(index = 1,
               fecha = "2020-04-09:12:00:00",
               descripcion = "Bloque 0",
               referencia = "1.1.1",
               debe = "3000",
               haber = "0",
               hash_previos = 0,
               profundidad = 9,
               hash = NULL)
```


En R el bloque es una lista con determinados elementos, siendo un apunte contable ponemos una fecha, una descripción, una referencia y un debe/haber; los elementos que necesitamos para crear los eslabones de la cadena serán la profundidad de la cadena y los hash, tanto previo como el de nuestro bloque. ¿Qué es un hash? Es un procedimiento criptográfico que transforma una información en una cadena de caracteres. Ojo con los hash porque una vez creados no se pueden descifrar, es decir, una vez creado el bloque este queda guardado a fuego. Esto en contabilidad es un problema porque no se puede deshacer, no nos podemos equivocar. Sin embargo, desde el punto de vista del auditor de una cuenta puede ser interesante. En R esa cadena de caracteres la vamos a crear a partir de la librería digest:

```r
#Esta librería de R crea hash de objetos de R
library("digest")

#¿Cómo se ve el término analisisydecision encriptado?
digest("analisisydecision" ,"sha256")
```


`[1] "bec1a55f485045e8a1f5f774fe2a66f09cc93e046eb9fa978c97a7c061009d9c"`

La función digest transforma un elemento de R en una cadena de caracteres

, si queréis entender mejor el concepto en [este enlace está perfectamente explicado](https://academy.bit2me.com/como-funciona-el-hash-en-bitcoin/). Viendo la estructura del bloque que deseamos enlazar vamos a crear una función que genere esa lista:

```r
#Realizamos una función de R que genere objetos encriptados con la estructura del bloque deseada
crea_hash <- function(block){
  block$hash <- digest(c(block$index,
                         block$fecha,
                         block$descripcion,
                         block$referencia,
                         block$debe,
                         block$haber,
                         block$hash_previos), "sha256")
  return(block)
}

#Vemos su funcionamiento
crea_hash(bloque)
```


```r
index

[1] 1fecha

[1] "2020-01-05:00:00:00"
```

descripcion
[1] "Bloque 0"referencia
[1] "1.1.1"

debe
[1] "3000"haber
[1] "0"

hash_previos
[1] 0profundidad
[1] 9

$hash
[1] "849f2807b1cc111b11608820fdcf76164996d201b8470c1599718432bb5de140"

El elemento fundamental de la cadena serán los eslabones, en este punto sería muy importante dificultar el movimiento entre los eslabones de forma que sólo el creador del bloque fuera capaz de moverse entre ellos. En nuestro caso planteamos un algoritmo ridículo, más tarde veremos el motivo:

```r
#Algoritmo de control de eslabones
une_eslabones <- function(ultima_profundidad){
  profundidad <- ultima_profundidad + 1

  # Se incrementa la profundidad del bloque hasta cierta condicion
  while (!(profundidad - ultima_profundidad) %% 11 == 0 ){
    profundidad <- profundidad + 113
  }

  return(profundidad)}

une_eslabones(1)
une_eslabones(1695)

Para unir eslabones planteo un orden, una profundidad de la cadena pero en vez de colocar los eslabones de forma consecutiva damos algo de dificultad para ir incrementando el orden, la resta del orden anterior menos el actual orden ha de ser múltiplo de 11 y se va incrementando de 113 en 113 hasta que se cumpla la condición.

Ya tenemos una función en R que nos genera el bloque y otra que nos genera el eslabón, ahora preparamos la función que une el bloques a la cadena a partir del eslabón:

#Generamos bloques de forma iterativa
genera_nuevo_bloque <- function(bloque_previo){

  #Profundidad actual
  nueva_profundidad <- une_eslabones(bloque_previo$profundidad)

  #Generación del nuevo bloque
  nuevo_bloque <- list(index = bloque_previo$index + 1,
                       fecha = Sys.time(),
                       descripcion = paste0("Este bloque es posterior a ", bloque_previo$index),
                       referencia = "1.1.1",
                       debe = bloque_previo$debe,
                       haber = bloque_previo$haber,
                       hash_previos = bloque_previo$hash,
                       profundidad = nueva_profundidad)

  #Hash de conexión de bloques
  nuevo_bloque_hashed <- crea_hash(nuevo_bloque)

  return(nuevo_bloque_hashed)
}

Toda blockchain necesita un origen un bloque génesis y a partir de él empezamos creando el eslabón de unión y el bloque siguiente, que se identificará por el hash del bloque inicial y la profundidad dentro de la cadena, esos son los elementos que garantizan que ese bloque pertenece a esa cadena.

#Este es el bloque de partida, la primera entrada de mi libro de contabilidad
bloque_inicial <- list(index = 1,
                       fecha = "2020-04-09:13:00:00",
                       descripcion = "Inicio del libro",
                       referencia = "",
                       debe = "3000",
                       haber = "0",
                       hash_previos = "0",
                       profundidad = 1,
                       hash = digest("analisisydecision" ,"sha256"))

blockchain <- list(bloque_inicial)

bloque_previo <- blockchain[[1]]
genera_nuevo_bloque(bloque_previo)

index

[1] 2fecha

[1] "2020-04-09 18:38:10 CEST"
descripcion

[1] "Este bloque es posterior a 1"referencia

[1] "1.1.1"
debe

[1] "3000"haber

[1] "0"
hash_previos

[1] "bec1a55f485045e8a1f5f774fe2a66f09cc93e046eb9fa978c97a7c061009d9c"profundidad

[1] 793
$hash

[1] "f8900d65008f2611e60e0eafa39c6fbaf4ce2477dc5032c44e668bb11df039f5"

El nuevo bloque sería el posterior al génesis, mantiene la información, y sabemos que es el siguiente al génesis porque el primer número que cumple la condición de unión de eslabones es el 793 y coincide el hash previo con el hash del génesis. Si este proceso lo metemos en un bucle:
# Incrementando el número de bloques añadimos complejidad a la cadena
bloques_incluir <- 10

# Bucle para añadir bloques a la cadena
for (i in 1: bloques_incluir){
  nuevo_bloque <- genera_nuevo_bloque(bloque_previo)
  blockchain[i+1] <- list(nuevo_bloque)
  bloque_previo <- nuevo_bloque
}
Ya tenemos nuestra primera cadena de bloques generada con 11 bloques. Cuanta mayor profundidad tuviera tendría mayor complejidad, pero en realidad la complejidad habría que tenerla en la creación de los eslabones, pero a medida que introducimos complejidad y profundidad ¿qué sucede? que necesitamos una mayor cantidad de recursos. Este ejemplo está planteado para ejecutarse de forma rápida, en el momento que aparezca una función seno, coseno o exponencial el proceso se alarga y nos encontramos con el principal problema que tiene un blockchain seguridad=consumo de recursos.
```