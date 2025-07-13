#Instala los paquetes necesarios si no están
list.of.packages <- c("tidyverse", "tabulizer","svDialogs")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#Llama a los archivos necesarios
library(tidyverse)
library(tabulizer)
library(svDialogs)


#Nos permite seleccionar el archivo PDF
archivo_pdf = choose.files(default = "*.pdf", caption = "Seleccionar archivo PDF",
             multi = FALSE, filters = Filters,
             index = nrow(Filters))

#Ventana para poner la página donde está la tabla a leer
pagina = dlgInput("Selecciona la página del PDF", "1")$res

#Extraer a mano alzada
#Nos permite extraer de la página especificada a mano alzada
write.table(extract_areas(archivo_pdf, widget='native', pages = pagina, encoding='UTF-8', resolution=30L),
            file="clipboard-16384",sep="\t", row.names = F, col.names = F, dec=",")


############################################################################################################


