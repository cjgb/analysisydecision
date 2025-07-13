*200000 DATOS ALEATORIOS;
data datos;
do id_cliente=1 to 200000;
edad=min(65,ranpoi(4,45));
pasivo=ranuni(4)*10000+ranuni(12)*(10000*(edad-5));
compras=round(pasivo/(ranexp(423)*1000));
vinculacion=max(1,ranpoi(2,round(pasivo/300000)+1));
recibos=ranpoi(1,2);
provincia=min(52,ranpoi(123,28));
output;
end;
run;
*VAMOS A ASIGNAR UN POTENCIAL DE COMPRA FICTICIO;
data sasuser.datos;
set datos;
potencial=0.3;
*MODIFICAMOS LIGERAMENTE EL POTENCIAL;
*EDAD;
if edad<30 then potencial=potencial+0.05*ranuni(13);
else if edad<40 then potencial=potencial+0.03*ranuni(13);
else if edad<45 then potencial=potencial+0.04*ranuni(13);
else if edad<55 then potencial=potencial+0.05*ranuni(13);
else potencial=potencial+0.02*ranuni(13);
*RECIBOS;
if recibos<=2 then potencial=potencial+0.01*ranuni(13);
else if recibos<=4 then potencial=potencial+0.03*ranuni(13);
else potencial=potencial+0.05*ranuni(13);
*VINCULACION;
if vinculacion<=5 then potencial=potencial-0.01*ranuni(13);
else if vinculacion<=8 then potencial=potencial+0.05*ranuni(13);
else if vinculacion<=12 then potencial=potencial+0.2*ranuni(13);
else potencial=potencial+0.4*ranuni(13);
*COMPRAS;
if compras<100 then potencial=potencial-0.01*ranuni(13);
else if compras<250 then potencial=potencial+0.03*ranuni(13);
else if compras<700 then potencial=potencial+0.05*ranuni(13);
else if compras<2000 then potencial=potencial+0.06*ranuni(13);
else potencial=potencial+0.07*ranuni(13);
*PASIVO;
if pasivo<50000 then potencial=potencial-0.02*ranuni(13);
else if pasivo<100000 then potencial=potencial-0.01*ranuni(13);
else if pasivo<200000 then potencial=potencial+0.05*ranuni(13);
else if pasivo<300000 then potencial=potencial+0.2*ranuni(13);
else if pasivo<500000 then potencial=potencial+0.1*ranuni(13);
else potencial=potencial+.1;
*PROVINCIA;
if mod(provincia,5)=0 then potencial=potencial-0.02*ranuni(13);
if potencial>0.4 then contrata=1;
else contrata=0; 
run;
*CREAMOS ENTRENAMIENTO Y VALIDACION;
data entreno validacion;
set sasuser.datos (drop=potencial);
if ranuni(46)>=0.6 then output validacion;
else output entreno;
run;
*EXPORTACION A CSV DEL DS;
PROC EXPORT DATA= entreno
OUTFILE= "c:\temp\elimina.csv"
DBMS=CSV REPLACE;
RUN;


data ejecucion_R;
infile datalines dlm='@';
input lineas: $200.;
lineas = tranwrd(lineas,'names[i],"\n"','names[i],";\n"');
datalines4;
setwd('c:/temp')									@
dfsas <- read.csv('elimina.csv')					@
library(rpart)										@
arbol=rpart(as.factor(contrata)~ pasivo + edad +	@
recibos + vinculacion + compras 		,			@
data=dfsas,method="anova",							@
control=rpart.control(minsplit=30, cp=0.0008) )		@
arbol$frame											@
####################################################@
#Ubicación de salida del modelo						@
fsalida = "C:\\temp\\reglas_arbol.txt"				@
#Función que identifica las reglas					@
reglas.rpart <- function(model)						@
{frm <- model$frame									@
names <- row.names(frm)								@
cat("\n",file=fsalida)								@
for (i in 1:nrow(frm))								@
{if (frm[i,1] == "<leaf>")							@
{cat("\n",file=fsalida,append=T)					@
cat(sprintf("IF ", names[i]),file=fsalida, 			@
append=T)											@
pth <- path.rpart(model, nodes=as.numeric(names[i]),@
print.it=FALSE)										@
cat(sprintf(" %s\n", unlist(pth)[-1]), sep=" AND ", @
file=fsalida, append=T)								@
cat(sprintf("THEN NODO= "),names[i],";\n",			@
file=fsalida,append=T)}}}							@
####################################################@
reglas.rpart(arbol)									@
;;;;
run;

*ESTABLECEMOS EL DIRECTORIO, LEEMOS Y GUARDAMOS;
data _null_;
set ejecucion_R;
file "c:\temp\pgm.R";
put lineas;
run;
*******************************************************;
data _null_;
file "c:\temp\ejecucion.bat";
*TENEMOS QUE TENER EN CUENTA DONDE ESTA R Y QUE VERSION 
 TENEMOS;
put '"C:\Archivos de programa\R\R-2.12.0\bin\R.exe"'@@;
put ' CMD BATCH --no-save "'@@;
put "c:\temp\pgm.R"@@;
put '"';
call sleep (150);
run;
*EJECUTAMOS EL PROCESO;
options noxwait;
x "C:\temp\ejecucion.bat";

*EJECUTAMOS EL CODIGO GENERADO;
data validacion;
set validacion;
%include "C:\temp\reglas_arbol.txt";
run;
*PODEMOS ANALIZAR SU RESULTADO;
proc sql;
select nodo,
count(*) as cli,
sum(contrata)/count(*) as tasa
from validacion
group by 1;
quit;
