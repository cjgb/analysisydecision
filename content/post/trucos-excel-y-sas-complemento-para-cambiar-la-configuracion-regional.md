---
author: rvaquerizo
categories:
  - business intelligence
  - excel
  - sas
  - trucos
date: '2011-11-25'
lastmod: '2025-07-13'
related:
  - trucos-excel-modificar-la-configuracion-regional-con-visual-basic.md
  - truco-sas-sas-y-dde-aliados-de-excel.md
  - truco-sas-leer-datos-de-excel-con-sas-con-dde.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - importar-a-sas-desde-otras-aplicaciones.md
tags:
  - complementos de excel
  - configuracion regional
  - visual basic
title: Trucos Excel (y SAS). Complemento para cambiar la configuración regional
url: /blog/trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional/
---

**Pasar salidas de SAS a Excel** trae de cabeza a muchos usuarios de SAS. A este blog llegan un gran número de entradas desde Google con términos del tipo importar datos de sas a Excel, conectar SAS a excel, cambiar la configuración regional con macros,… Hoy quería ayudaros un poco con esta problemática. Bueno, en realidad os va a ayudar el compañero **Salva** que hace unos meses me pasó un complemento de Excel tremendamente útil para aquellos que movemos datos entre SAS y Excel. Para trabajar con este complemento sólo tenéis que [descargarlo en este enlace](/images/2011/11/configura-sas.xla "configura-sas.xla") y activar el complemento en _Opciones de Excel Administrar complementos_. Una vez hayamos hecho esto tendremos en nuestra pestaña complementos lo siguiente:

![configuracion-regional-excel.PNG](/images/2011/11/configuracion-regional-excel.PNG)

Muy sencillo, si elegimos Excel Americano habremos cambiado la configuración regional de Excel a . para separar decimales y , para separar miles. Si elegimos configuración Excel del sistema tendremos la configuración habitual europea. Si elegimos eliminar el Add-in… Ahora podéis copiar y pegar directamente salidas de Enterprise Guide o SAS en Excel. También os será mucho más sencillo exportar ficheros de Excel a SAS para aquellos que no tenéis los módulos necesarios ya que podéis guardar los archivos SAS como texto e importarlos desde SAS sin problemas. No me lo agradezcáis a mi, yo sólo escribo estas líneas, agradecédselo a Salva. Por cierto, el complemento está protegido con una contraseña que no diré sin su permiso.
