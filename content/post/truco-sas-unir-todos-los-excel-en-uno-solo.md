---
author: svalle
categories:
  - sas
  - trucos
date: '2008-04-23'
lastmod: '2025-07-13'
related:
  - trucos-excel-unir-varios-excel-en-uno.md
  - truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada.md
tags:
  - sas
  - trucos
title: Truco SAS. Unir todos los Excel en uno sólo
url: /blog/truco-sas-unir-todos-los-excel-en-uno-solo/
---

Este programa SAS une todos los excel que queramos en un único libro.
Cuando estamos haciendo análisis de variables y exportamos los resultados
con ods o con otro método a excel, resulta un poco pesado ir abriendo
cada libro para ver los resultados, a mi me resulta más facil unirmelas todas y tener toda la información contenida en un único Excel.

Espero que os resulte útil!

```r
ods noresults;

ods listing close;

ods html body="c:\temp\retail.xls";

proc print data=sashelp.retail;

run;

ods html close;
```

```r
ods html body="c:\temp\shoes.xls";

proc print data=sashelp.shoes ;

run;

ods html close;
```

```r
%macro UNE_EXCEL(in=,out=);

options noxwait;

x erase "&&out";

options xwait;

data _null_;

file "c:\temp\class.vbs";

put 'Set XL = CreateObject("Excel.Application")' /

'XL.Visible=True';

%let n=1;

%let from=%scan(&&in,&&n," ");

%do %while("&&from" ne "");

%let fromwb=%scan(&&from,1,"!");

%let fromws=%scan(&&from,2,"!");

put "XL.Workbooks.Open ""&&fromwb""";

%if &&n=1 %then

put "XL.ActiveWorkbook.SaveAs ""&&out"", -4143"%str(;);

%else %do;

put "XL.Workbooks(""%scan(&&fromwb,-1,'\')"").Sheets(""&&fromws"").Copy ,XL.Workbooks(""%scan(&&out,-1,'\')"").Sheets(%eval(&&n-1))";

put "XL.Workbooks(""%scan(&&fromwb,-1,'\')"").Close";

%end;

%let n=%eval(&&n+1);

%let from=%scan(&&in,&&n, " ");

%end;

put "XL.Workbooks(""%scan(&&out,-1,'\')"").sheets(1).activate";

put "XL.Workbooks(""%scan(&out,-1,'\')"").Save";

put "XL.Quit";

run;
```

x 'c:\\temp\\class.vbs';
%mend;
%UNE_EXCEL(in= c:\\temp\\shoes.xls!shoes c:\\temp\\retail.xls!retail,
out=c:\\temp\\TodasJuntas.xls);
