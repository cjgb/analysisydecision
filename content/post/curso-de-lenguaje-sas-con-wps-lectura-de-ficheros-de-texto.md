---
author: rvaquerizo
categories:
- Consultoría
- Formación
date: '2010-06-03T04:02:17-05:00'
lastmod: '2025-07-13T15:55:52.314863'
related:
- curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
- importar-a-sas-desde-otras-aplicaciones.md
- curso-de-lenguaje-sas-con-wps-el-paso-data.md
- ayudadme-importar-a-sas-texto-con-comillas.md
- curso-de-lenguaje-sas-con-wps-ejecuciones.md
slug: curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto
tags:
- DATA
- INFILE
- INPUT
title: Curso de lenguaje SAS con WPS. Lectura de ficheros de texto
url: /blog/curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto/
---

Leer ficheros de texto con lenguaje SAS no es sencillo debido a la escasa flexibilidad de SAS. La cosa se complica cuando leemos texto con WPS.[ Empleando el asistente de SAS y haciendo recall podemos leer ficheros con bastante comodidad](https://analisisydecision.es/importar-a-sas-desde-otras-aplicaciones/). **Eso no lo podemos hacer con WPS porque no dispone de asistente ni nada parecido al EFI de SAS**. Así que tenemos que tantear con INPUT hasta conseguir leer el fichero correctamente. Pero esta entrada nos permite conocer mejor como funciona el paso DATA. Más adelante veremos como hacerlo con el PROC IMPORT. El primer ejemplo importa un fichero de texto de este tipo:

```r
1 ,479.70055858 ,760.70972521 ,198.59444871 ,75.189163012 ,372.82062293 ,

2 ,754.21879802 ,343.8333852 ,253.53378256 ,398.35220966 ,532.53241281 ,

3 ,554.54856463 ,190.96417175 ,827.15448683 ,537.47661437 ,656.19086086 ,

4 ,377.5517132 ,180.89431253 ,519.43704743 ,814.11889932 ,812.06014837 ,
```

No tiene cabeceras está delimitado por comas, tiene 6 variables: id, importe1,.., importe5. Conocemos la estructura, el delimitador y las variables:

```r
data importes;

infile "D:\raul\wordpress\curso sas\muestra1.txt" dlm=',';

input id importe1 importe2 importe3 importe4 importe5;

run;
```

Si estuviera delimitado por tabuladores trabajamos con dlm:

```r
data importes;

infile "D:\raul\wordpress\curso sas\muestra2.txt" dlm='09'x;

input id importe1 importe2 importe3 importe4 importe5;

run;
```

Es el ejemplo más sencillo DATA genera un dataset que lee de un INFILE y con INPUT creamos un vector de variables que en la terminología de SAS se denomina PDV. Complicamos ligeramente la cosa. Tenemos cabeceras y WPS tiene que empezar a leer desde el segundo registro:

```r
data importes;

infile "D:\raul\wordpress\curso sas\muestra3.txt" dlm='09'x firstobs=2;

input id importe1 importe2 importe3 importe4 importe5;

run;
```

Recordamos, primero creamos una estructura y después hacemos una iteración que lee datos. Es importante señalar que **no sirven de nada las cabeceras** , la estructura la creamos nosotros con INPUT. Ahora podéis plantear la siguiente cuestion: ¿Si tiene muchas variables tenemos que escribirlas previamente a mano? La respuesta es si. Pero iremos aprendiendo trucos…

Si tenemos fechas del siguiente modo:

```r
id@fecha

1 @21/10/2004

2 @01/03/2006

3 @09/03/2006

4 @26/03/2006

5 @27/03/2005

...
```

Tendremos que tener especial cuidado con la sentencia INPUT que genera el vector de variables del dataset:

```r
data fechas2;

infile "D:\raul\wordpress\curso sas\muestra4.txt" dlm='@' firstobs=2;

input id fecha ddmmyy10.;

run;
```

Sabemos que el campo que leemos es una fecha del tipo DD/MM/YY de tamaño 10. En muchas ocasiones leemos ficheros de texto y no conocemos como son los campos que leemos. En este sentido WPS es más delicado que SAS. Lo más interesante es que esta problemática se la haremos llegar directamente a las personas que desarrollan WPS, **necesitamos un asistente a la importación de ficheros de texto.** Por otro lado es tan barato disponer del módulo de conexión a Microsoft ACCESS que puede ser perfectamente prescindible.

En próximas entregas analizaremos el procedimiento específico de WPS para la importación de ficheros. En ese punto determinaremos que es mejor utilizar, la creación del vector de entrada de forma manual (como os he mostrado en esta entrada) o el uso del PROC IMPORT peroes necesario que tengáis claro que un paso DATA es una estructura que se crea en una fase de compilación y después es una iteración hasta el final del fichero que vuelca los registros en RUN. Es la idea más simple pero que mejor se entiende.

Saludos.