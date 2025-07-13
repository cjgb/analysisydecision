clientes=20000
saldo_vista=runif(clientes,0,1)*10000
saldo_ppi=(runif(clientes,0.1,0.6)*rpois(clientes,2))*60000
saldo_fondos=(runif(clientes,0.1,0.9)*(rpois(clientes,1)-0.5>0))*30000
edad=rpois(clientes,60)
datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))
datos_ini$saldo_ppi=(edad<65)*datos_ini$saldo_ppi
#Creamos la variable objetivo a partir de un potencial
datos_ini$potencial= runif(clientes,0,1)
datos_ini$potencial= datos_ini$potencial +
log(edad)/2 +
runif(1,0,0.03)*(saldo_vista>5000)+
runif(1,0,0.09)*(saldo_fondos>5000)+
runif(1,0,0.07)*(saldo_ppi>10000)
summary(datos_ini)
datos_ini$pvi=as.factor((datos_ini$potencial>=quantile(datos_ini$potencial,
0.98))*1)
#Eliminamos la columna que genera nuestra variable dependiente
datos_ini = subset(datos_ini, select = -c(potencial))
#Realizamos una tabla de frecuencias
table(datos_ini$edad,datos_ini$pvi)

library(sqldf)
sqldf('select edad,sum(pvi)*100/count(*) as freq
from datos_ini
group by edad;')



#Subconjunto de validacion
validacion <- sample(1:clientes,5000)

#install.packages("sampling")
library( sampling )

selec1 <- strata( datos_ini[-validacion,], stratanames = c("pvi"),
size = c(5000,5000), method = "srswr" )

#Modelo sin sobremuestreo
modelo.1 = glm(pvi~.,data=datos_ini[-validacion,],family=binomial)
summary(modelo.1)

#Modelo con sobremuestreo
#Nos quedamos con el elemento ID_unit
selec1 <- selec1$ID_unit
modelo.2 = glm(pvi~.,data=datos_ini[selec1,],family=binomial)
summary(modelo.2)

#Realizamos la curva ROC para ambos modelos y comparamos
#install.packages("ROCR")
library(ROCR)

#Objeto que contiene la validación del modelo sin sobremuestreo
valida.1 <- datos_ini[validacion,]
valida.1$pred <- predict(modelo.1,newdata=valida.1,type="response")

pred.1 <- prediction(valida.1$pred,valida.1$pvi)
perf.1 <- performance(pred.1,"tpr", "fpr")

#Validación con sobremuestreo
valida.2 <- datos_ini[validacion,]
valida.2$pred <- predict(modelo.2,newdata=valida.2,type="response")

pred.2 <- prediction(valida.2$pred,valida.2$pvi)
perf.2 <- performance(pred.2,"tpr", "fpr")

#Pintamos ambas curvas ROC 
plot(perf.2,colorize = FALSE)
par(new=TRUE)
plot(c(0,1),c(0,1),type='l',col = "red", 
lwd=2, ann=FALSE)
par(new=TRUE)
plot(perf.1,colorize = TRUE)

library(rpart)
#Modelo sin sobremuestreo
arbol.1=rpart(as.factor(pvi)~edad+saldo_ppi+saldo_fondos,
data=datos_ini[-validacion,],method="anova",
control=rpart.control(minsplit=20, cp=0.001) ) 

#Modelo con sobremuestreo
arbol.2=rpart(as.factor(pvi)~edad+saldo_ppi+saldo_fondos,
data=datos_ini[selec1,],method="anova",
control=rpart.control(minsplit=20, cp=0.001) )

#Validacion  sin sobremuestreo
valida.arbol.1 <- datos_ini[validacion,]
valida.arbol.1$pred <- predict(arbol.1,newdata=valida.arbol.1)

pred.1 <- prediction(valida.arbol.1$pred,valida.arbol.1$pvi)
perf.1 <- performance(pred.1,"tpr", "fpr")

#Validacion con sobremuestreo
valida.arbol.2 <- datos_ini[validacion,]
valida.arbol.2$pred <- predict(arbol.2,newdata=valida.arbol.2)

pred.2 <- prediction(valida.arbol.2$pred,valida.arbol.2$pvi)
perf.2 <- performance(pred.2,"tpr", "fpr")

#Pintamos ambas curvas ROC 
plot(perf.2,colorize = FALSE)
par(new=TRUE)
plot(c(0,1),c(0,1),type='l',col = "red",
 lwd=2,ann=FALSE)
par(new=TRUE)
plot(perf.1,colorize = TRUE)
