---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-04-08'
lastmod: '2025-07-13'
related:
  - truco-sas-leer-datos-de-excel-con-sas-con-dde.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - trucos-excel-modificar-la-configuracion-regional-con-visual-basic.md
  - trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
  - importar-a-sas-desde-otras-aplicaciones.md
tags:
  - sas
  - trucos
title: Truco SAS. SAS y DDE, otra forma de exportar a Excel
url: /blog/truco-sas-sas-y-dde-aliados-de-excel/
---

Otro elemento con el que contamos para crear archivos Excel desde SAS es el [DDE](http://es.wikipedia.org/wiki/DDE), una tecnología que nos permite comunicar Windows con SAS. Mediante esta comunicación podemos leer un fichero SAS y escribir en una tabla de Excel. Con el siguiente artículo os voy a introducir a otra metodología que no sólo sirve para crear ficheros Excel desde SAS si no que además nos permitirá ejecutar macros, crear gráficos,…

Estudiemos el ejemplo más sencillo que **parte siempre de un fichero Excel existente** :

```r
options noxwait noxsync;x '"C:\temp\ej_dde.xls"';
/*ESPERAMOS PARA QUE NO HAYA UN CONFLICTO*/
data _null_;   x=sleep(2);
run;

/*ASIGNAMOS UN FILENAME AL RANGO AL QUE VAMOS ESCRIBIR

  ESTE FILENAME SERA DINAMICO */

filename ejemplo dde 'excel|Hoja2!f1c1:f20c3';

/*MEDIANTE UN PASO DATA PONEMOS EN EL LUGAR DEL FILENAME

  LOS DATOS*/

data _null_;
   file ejemplo;
   do i=1 to 20;
      x=ranuni(i);
      y=x+10;
      z=x/2;
      put x y z;
   end;
run;
```

Este ejemplo genera un dataset temporal de 20 observaciones y 3 variables que escribimos en un archivo excel C:\\temp\\ej_dde.xls que existe. La secuencia para su creación es: abrimos, esperamos unos segundos, asignamos una referencia y escribimos. Hemos creado:

![DDE SAS paso 1](/images/2008/04/tabla1.JPG)

Es evidente que los datos no han quedado muy bien debido a la notación americana así pues deberíamos jugar con los formatos de las variables o bien con la configuración regional de Excel. En este caso vamos a trabajar con macros de Excel que modifiquen las configuraciones regionales en el momento de escribir los datos desde SAS. Además estas macros van a ser llamadas por nuestro programa SAS ya que el DDE nos permite ejecutar macros de Excel. En Visual Basic si deseamos modificar la configuración regional haremos lo siguiente:

``` Sub formato_americano()``'``' formato_americano Macro ```

```r
'

With Application

.DecimalSeparator = "."

.ThousandsSeparator = ","

.UseSystemSeparators = False

End With

End Sub
```

Del mismo modo para el formato europeo creamos otra macro:

```r
Sub formato_europeo()

' formato_americano Macro

'

  With Application

  .UseSystemSeparators = True

  End With

End Sub
```

Estas macros estarán guardadas en el archivo Excel con el que trabajemos y serán llamadas desde SAS y pegaremos nuestros datos con formato europeo sin necesitad de trabajar el fichero SAS:

```r
/*ASIGNAMOS UN FILENAME AL RANGO AL QUE VAMOS ESCRIBIR
  ESTE FILENAME SERA DINAMICO */
filename ejemplo
   dde 'excel|Hoja2!f1c1:f20c3';

/*FILEMANE PARA REFERENCIAR AL SISTEMA Y EMPLEAR CODIGO DDE*/
filename sis dde 'EXCEL|SYSTEM';

/*ABRIMOS EL FICHERO EXCEL*/
data _null_;
file sis;
put "[open(""C:\temp\ej_dde.xls"")]";
run;
/*EJECUTAMOS LA MACRO QUE PONE FORMATO AMERICANO*/
data _null_;
file sis;
put '[RUN("formato_americano")]';
run;
/*ESCRIBIMOS EL FICHERO EXCEL*/
data _null_;
   file ejemplo;
   do i=1 to 20;
      x=ranuni(i);
      y=x+10;
      z=x/2;
      put x y z;
   end;
run;
/*VOLVEMOS AL FORMATO EUROPEO*/
data _null_;
file sis;
put '[RUN("formato_europeo")]';
run;
/*CERRAMOS Y GUARDAMOS EL FICHERO EXCEL*/
data _null_;
file sis;
put "[save()]";
put "[File.Close()]";
run;
```

Nuestra tabla Excel ha mejorado mucho su aspecto. Un buen programa para comenzar a usar DDE con SAS. Podemos sofisticarlo todo lo que queramos y crear informes directamente con SAS.

Saludos.
