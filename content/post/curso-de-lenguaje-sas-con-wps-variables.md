---
author: rvaquerizo
categories:
  - consultoría
  - formación
date: '2010-06-14'
lastmod: '2025-07-13'
related:
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - curso-de-lenguaje-sas-con-wps-introduccion-a-los-formatos-de-variables.md
  - trabajo-con-fechas-sas-introduccion.md
  - curso-de-lenguaje-sas-con-wps-funciones-fecha.md
  - trabajo-con-fechas-sas-funciones-fecha.md
tags:
  - variables
title: Curso de lenguaje SAS con WPS. Variables
url: /blog/curso-de-lenguaje-sas-con-wps-variables/
---

El elemento fundamental de los conjuntos de datos SAS son las variables. Ya las hemos referenciado en capítulos anteriores. Éstas pueden ser numéricas o alfanuméricas. Las variables se pueden crear, eliminar o se pueden recodificar. Todo esto siempre lo haremos mediante pasos `DATA`. Disponemos de un amplio número de funciones para que todas las variables se ajusten a nuestras necesidades.

Las variables tienen los siguientes **atributos**:

- **Nombre**: no pueden exceder de 32 caracteres, empezar por un número ni tener espacios en blanco.
- **Tipo**: numérica o alfanumérica (carácter, precedida por `$`).
- **Longitud**: máximo 8 *bytes* para numérica y 1 a 32.000 para alfanumérica.
- **Formato de salida**: por defecto `BEST12.` para numéricas y `$w.` para alfanuméricas.
- **Formato de entrada**: similar al formato de salida.
- **Etiqueta**.

Un tipo muy especial de variable es el valor perdido o *missing*. Por defecto, la representación del *missing* para una variable numérica es `.` y `' '` para una variable alfanumérica. Para todas las variables podemos emplear operadores de comparación (por ejemplo, en sentencias `IF`) y operadores lógicos.

**Operadores de comparación:**
- `= EQ`
- `^= NE` (también `¬=` o `~=`)
- `> GT`
- `< LT`
- `>= GE`
- `<= LE`
- `IN`

**Operadores lógicos:**
- `& AND`
- `| OR` (también `!` o `¦`)
- `¬ NOT` (también `ˆ` o `~`)

### Variables numéricas

Son las variables que representan números; son medidas de cada observación de nuestro *dataset*. Dentro de las numéricas se incluyen las variables de fecha y hora (un tipo muy especial). Su longitud va desde los 2 a los 8 *bytes*. El formato que tienen por defecto es `BEST12.`, que es el formato de 12 *bytes* que SAS considera más adecuado para una variable numérica. La forma más común de representar las variables numéricas es `w.d`, donde `w` representa la longitud total y `d` la longitud de la parte decimal.

Los *missing* numéricos tienen un comportamiento especial y debemos tener cuidado al trabajar con ellos. Analicemos algunos ejemplos:

```sas
data _null_;
    y = 3;
    x = .;
    
    z = x + y;
    l = x * y;
    m = min(x, y);
    n = sum(x, y);
    
    put z= l= m= n=;
run;
```

La sentencia `DATA _NULL_` no genera un conjunto de datos SAS físico; `_NULL_` es un tipo especial de *dataset* que no genera un fichero. Con la instrucción `PUT` nuestro paso `DATA` escribirá en la ventana *log* el valor de las variables. Si analizamos el resultado en el *log*, tendremos:

```text
z=. l=. m=3 n=3
```

Una variable *missing* que opera aritméticamente con un número da como resultado una variable *missing*; sin embargo, si empleamos una función de SAS como `MIN()` o `SUM()`, el valor *missing* no es tenido en cuenta.

### Variables fecha

Un tipo muy importante de variable numérica es la que representa una fecha u hora en SAS. La variable fecha se codifica internamente como la diferencia en días entre la fecha en cuestión y el **1 de enero de 1960**, de modo que las fechas posteriores serán un número positivo y las anteriores serán un número negativo. Igualmente, las variables hora serán la diferencia en segundos con el 1 de enero de 1960 a las 00:00. Analicemos cómo codifica SAS las variables fecha:

```sas
data fechas;
    input id $5. fecha : ddmmyy10.;
    cards;
AAAAA 01/01/1960
ABAAC 01/01/1961
ACBAC 01/01/1970
ACABA 01/01/1962
AAAAC 01/01/1980
;
run;
```

Este programa crea un conjunto de datos SAS con una variable carácter y otra numérica a la que, a través de `: ddmmyy10.`, le asignamos un formato de lectura (informat). Si hacemos una vista del conjunto de datos, veremos números. Para ver el valor fecha legible, debemos asignarle un formato de salida:

```sas
data fechas_formateadas;
    set fechas;
    format fecha ddmmyy10.;
run;
```

Para trabajar con constantes de fecha tenemos que escribir `"DDMMMYYYY"d`, por ejemplo:

```sas
data calculo_fechas;
    set fechas;
    anyos_entre_dos_fechas = ("01NOV1980"d - fecha) / 365.25;
run;
```

### Variables alfanuméricas (carácter)

Almacenan caracteres. Su longitud puede ir de 1 a 32.000 *bytes*. Para realizar modificaciones sobre ellas o trabajar con constantes, tendremos que emplear comillas (simples `'` o dobles `"`). Por ejemplo, para añadir al campo `id` el prefijo `ID-`:

```sas
data fechas_prefijo;
    set fechas;
    id = "ID-" || id;
run;
```

El operador fundamental para las variables alfanuméricas es la concatenación: `||`. Para modificar los atributos de nuestro *dataset* y que nuestra variable tenga la longitud deseada, hemos de emplear la instrucción `ATTRIB`:

```sas
data fechas_attrib;
    attrib id length=$10 label="Identificador Modificado";
    set fechas;
    id = "ID-" || id;
run;
```

La instrucción `ATTRIB` modifica atributos como `LENGTH`, `LABEL`, `FORMAT` e `INFORMAT`. Siempre ha de ir antes de la sentencia `SET` para definir los atributos de las nuevas variables antes de que se lean los datos. Posteriormente presentaremos las funciones de texto más empleadas en `WPS`. Saludos.