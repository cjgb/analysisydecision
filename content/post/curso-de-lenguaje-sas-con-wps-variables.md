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

El elemento fundamental de los conjuntos de datos `SAS` son las variables. Ya las hemos referenciado en capítulos anteriores. Éstas pueden ser numéricas o alfanuméricas. Las variables se pueden crear, eliminar o se pueden recodificar. Todo esto siempre lo haremos mediante pasos `DATA`. Disponemos de un amplio número de funciones para que todas las variables se ajusten a nuestras necesidades.
Las variables tienen los siguientes **atributos**:

- Nombre: no pueden exceder de 32 caracteres o empezar por un número ni tener espacios en blanco
- Tipo: Numérica o alfanumérica (`$`)
- Longitud: máximo 8 bytes para numérica y 1 – 32,000 para alfanumérica
- Formato salida de la variable: Por defecto para num `BEST12.` para numéricas y `$w.` para alfanumérica
- Formato de entrada: similar al formato de salida
- Etiqueta

Un tipo muy especial de variable es el valor perdido o missing. Por defecto la representación del missing para una variable numérica es `.` y `' '` para una variable alfanumérica. Para todas las variables podemos emplear operadores de comparación (por ejemplo en sentencias `IF`) y/o operadores lógicos. Los operadores de comparación son:

- `= EQ`
- `^= NE`
- `¬= NE`
- `~= NE`
- `> GT`
- `< LT`
- `>= GE`
- `<= LE`
- `IN`

Los operadores lógicos son:

- `& AND`
- `| OR`
- `! OR`
- `¦ OR`
- `¬ NOT`
- `ˆ NOT`
- `~ NOT`

**Variables numéricas:**

Son las variables que representan números, son medidas de cada observación de nuestro `dataset`. Dentro de las numéricas se incluyen las variables de fecha y hora (un tipo muy especial). Su longitud va desde los 2 a los 8 bytes. El formato que tienen por defecto es `BEST12.` que es el formato de 12 bytes que `SAS` considera más adecuado para una variable numérica. La forma más común de representar las variables numéricas es `w.[d]` donde `w` representa la longitud de la parte entera y `d` la longitud de la parte decimal.

Los missing numéricos tienen un comportamiento especial y debemos tener especial cuidado al trabajar con variables numéricas que puedan contener valores perdidos. Analicemos algunos ejemplos:

```sas
data _null_;

y=3;

x=.;

z=x+y;

l=x*y;

m=min(x,y);

n=sum(x,y);

put z= l= m= n=;

run;
```

La sentencia `DATA _NULL_` no genera conjunto de datos `SAS`, `_NULL_` es un tipo especial de `dataset` que no genera un fichero físico; con la instrucción `PUT=` nuestro paso `data` escribirá en la ventana log el valor de las variables que deseamos ver. Si analizamos el resultado en la ventana log tendremos:

```sas
22 data _null_;

23 y=3;

24 x=.;

25 z=x+y;

26 l=x*y;

27 m=min(x,y);

28 n=sum(x,y);

29 put z= l= m= n=;

30 run;

z=. l=. m=3 n=3

NOTE: The data step took :

real time : 00:00:00.280

cpu time : 00:00:00.000
```

Una variable missing que opera con un número da como resultado una variable missing, sin embargo si empleamos una función de `SAS` como es `min()` para determinar el mínimo entre dos valores o `sum()` para determinar la suma el valor missing no es tenido en cuenta.

**Variables fecha:**

Un tipo muy importante de variable numérica es la variable que representa una fecha u hora en `SAS`. La variable fecha se codifica internamente como la diferencia en días entre la fecha en cuestión y el **1 de enero de 1960** de modo que las fechas posteriores serán un número positivo y las anteriores a 1960 serán un número negativo. Igualmente las variables hora serán la diferencia en horas con el 1 de enero de 1960 a las 00:00. Analicemos con algunos ejemplos como codifica `SAS` las variables fecha:

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

Este programa crea desde el editor un conjunto de datos `SAS` con una variable carácter y otra numérica a la que a través de `: ddmmyy10.` le asignamos un formato de lectura a `SAS`. Si hacemos una vista del conjunto de datos veremos que tenemos números que se codifican como la diferencia en días respecto el 01/01/1960. Si deseamos ver el valor fecha que toma esta variable deberemos asignarle un formato de salida. Esto lo podemos hacer desde el mismo paso `data`:

```sas
data fechas;

input id $5. fecha : ddmmyy10.;

format fecha ddmmyy10.;

cards;

AAAAA 01/01/1960

ABAAC 01/01/1961

ACBAC 01/01/1970

ACABA 01/01/1962

AAAAC 01/01/1980
```

El formato es uno de los atributos más importantes de las variables y en función de él podremos ver correctamente los resultados. Los formatos fecha/hora más empleados son:

- `DATE`
- `DATETIME`
- `DDMMYY`

Para trabajar con constantes tenemos que introducir el valor numérico o escribir “DIA(MES EN INGLES)AÑO”d, por ejemplo:

```sas
data fechas;

set fechas;

anyos_entre_dos_fechas= ("01NOV80"d - fecha)/365.25;

run;
```

En el siguiente capítulo analizaremos mejor este tipo de variables ya que requiere especial cuidado trabajar con ellas en `WPS`.

**Variables alfanuméricas**:

Las variables alfanuméricas son aquellas que almacenan caracteres. Su longitud puede ir de 1 a 32.000 bytes. En anteriores ejemplos ya hemos visto la forma de introducir manualmente variables carácter a través de `INPUT`, sin embargo si queremos realizar
modificaciones sobre ellas, crear nuevas variables o trabajar con constantes tendremos que emplear las comillas (simples `'` o dobles `"`). Por ejemplo, retomando la tabla fechas creada anteriormente tenemos:

```sas
data fechas;

input id $5. fecha : ddmmyy10.;

format fecha ddmmyy10.;

cards;

AAAAA 01/01/1960

ABAAC 01/01/1961

ACBAC 01/01/1970

ACABA 01/01/1962

AAAAC 01/01/1980

;
```

Sobre esta tabla se nos solicita añadir al campo `id` el prefijo `ID-`. El programa `SAS` que se emplea para modificar este campo sería:

```sas
data fechas;

set fechas;

id="ID-"||id;

run;
```

El operador fundamental para las variables alfanuméricas es la concatenación, para ello `SAS` emplea `||`. Para trabajar con constantes de caracteres es necesario el uso de comillas. De este modo modificamos nuestro campo `id` añadiéndole un prefijo. Nuestro `dataset` ejemplo se compone de 2 variables, una de texto de longitud 5 y otra numérica de longitud 8 con formato de salida `DDMMYY10.`.

Para modificar los atributos de nuestro `dataset` y que nuestra variable tenga la forma que deseamos hemos de emplear la instrucción `ATTRIB` pero con una peculiaridad, lo vemos en el ejemplo:

```sas
data fechas;

attrib id length=$10;

set fechas;

id="ID-"||id;

run;
```

La instrucción `ATTRIB` modifica los atributos de nuestras variables, los posibles atributos a modificar son: `LENGTH`, `LABEL`, `FORMAT` e `INFORMAT`. Siempre ha de ir antes de poner `SET` para poder asignar unos atributos iniciales. Posteriormente presentaremos las funciones de texto más empleadas en `WPS`.
