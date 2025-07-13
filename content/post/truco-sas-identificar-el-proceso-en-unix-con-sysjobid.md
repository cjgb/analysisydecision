---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2009-08-26T08:55:03-05:00'
slug: truco-sas-identificar-el-proceso-en-unix-con-sysjobid
tags:
- ''
- macro
- SAS
title: Truco SAS. Identificar el proceso en Unix con SYSJOBID
url: /truco-sas-identificar-el-proceso-en-unix-con-sysjobid/
---

Un truco SAS muy rápido y que a algún compañero le ha venido muy bien y por eso lo pongo. La macro variable _& sysjobid_ nos idenfica el job de Unix que está corriendo en ese momento. Es una macro del sistema y se haya en el diccionario de macros de SAS. Tenemos una vista en SASHELP VMACRO de cuales son estas macros AUTOMATIC. Curiosead SASHELP, tiene algunas vistas muy interesantes, creo que ya he comentado algo sonbre ellas.

Vuelvo con _& sysjobid._ sólo con poner PUT &SYSJODID. podremos ver en el log el ID del proceso Unix que se está ejecutando. De este modo podremos identificarlo para hacerle un kill -9 en la máquina Unix para parar un proceso colgado. También nos permite identificar que proceso no vamos a matar. Este truco que parece una tontería nos ha librado a muchos de muchos disgustos.