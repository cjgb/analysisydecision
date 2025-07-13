******************************************************
PRUEBAS CON LOS EXPONENTES DE LOS OBJETOS HASH
PROGRAMA REALIZADO POR RAUL VAQUERIZO
******************************************************;


%macro ejecucion(exponente);
*INCREMENTAMOS EL NUMERO DE OBSERVACIONES;
%do i=500000 %to 5000000 %by 500000;
%let tamanio=&i.;

*DS CON DATOS ALEATORIOS PARA LA REALIZACION DE LA PRUEBA;
data uno;
array v(5);
do i=1 to &tamanio.;
importe=ranuni(mod(time(),1)*1000)*10000;
do j=1 to 5;
v(j)=ranuni(34)*100;
end;output;end;
run;

*HACEMOS 2 EJECUCIONES, DEBEMOS HACER MAS PERO RALENTIZA EL 
 EXPERIMENTO;
%do h= 1 %to 2;
%let inicio=%sysfunc(time());
data _null_;
   if 0 then set uno;
   declare hash obj (dataset:'uno',hashexp:&exponente., ordered:'a') ;
   obj.definekey ('importe');
   obj.definedata(all:'YES');
   obj.definedone () ;
   obj.output(dataset:'dos');
   stop;
run;
%let tiempo=%sysfunc(time())-&inicio.;
%if &i.=1 and &h.=1 %then %do;
data borra;
tamanio=&tamanio.;
t=&tiempo.;
run;
%end; %else %do;
data borra2;
tamanio=&tamanio.;
t=&tiempo.;
data borra;
set borra borra2;
run;
%end;
%end;
%end;
proc delete data=borra2; run;
%mend;
*NO ME HE COMPLICADO MUCHO LA EXISTENCIA, EL EXPONENTE ES UN 
 PARAMETRO MÁS DE LA EJECUCION;
%ejecucion(2);
data t2;
set borra;
exponente=2;
run;
%ejecucion(5);
data t5;
set borra;
exponente=5;
run;
%ejecucion(10);
data t10;
set borra;
exponente=10;
run;
%ejecucion(20);
data t20;
set borra;
exponente=20;
run;

*UNIMOS TODAS LAS EJECUCIONES;
data total;
set t2 t5 t10 t20;
run;

*NOS QUEDAMOS CON LA MEJOR DE ELLAS;
proc sql;
	create table total as select
	tamanio /1000 as tamanio,
	exponente,
	min(t) as t
	from total 
	group by 1,2;
quit;

*TRASPONEMOS PARA FACILITAR EL GRAFICO;
proc transpose data=total prefix=exp_ 
out=total (drop=_name_);
by tamanio;
id exponente;
var t;
run;

*MODIFICO EL ESTILO HTML;
ods html;
ods html style=styles.Statistical ;

*GRAFICAMOS EL TIEMPO QUE HA LLEVADO LA EJECUCION;
proc sgplot data=total;
xaxis type=discrete label="Tamaño DS '000";
yaxis label="Tiempos de ejecución en s.";
series x=tamanio y=exp_2/markers;
series x=tamanio y=exp_5/markers;
series x=tamanio y=exp_10/markers;
series x=tamanio y=exp_20/markers;
quit;



