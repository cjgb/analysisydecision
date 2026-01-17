---
author: cgbellosta
categories:
- Formación
date: '2009-12-08T19:44:27-05:00'
lastmod: '2025-07-13T16:04:39.362808'
related:
- arboles-de-decision-con-sas-base-con-r-por-supuesto.md
- aprende-pyspark-sin-complicaciones.md
- cloud-words-con-r-trabajar-con-la-api-del-europe-pmc-con-r.md
- porque-me-gusta-r.md
- manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i.md
slug: probando-r-sobre-el-ec2-de-amazon
tags:
- Amazon
- EC2
- R
title: Probando R sobre el EC2 de Amazon
url: /blog/probando-r-sobre-el-ec2-de-amazon/
---

Hacía tiempo que quería probarlo. Menos en las grutas pobladas de seres del siglo anterior, todo el mundo habla del [EC2](http://aws.amazon.com/ec2/ "EC2 de Amazon").

Entre otras muchas cosas que iré explorando más adelante, el EC2 de Amazon te alquila un servidor por horas. También te ofrece [espacio de disco](http://aws.amazon.com/s3/ "Amazon S3") a unos [precios de risa](http://aws.amazon.com/s3/#pricing "Precios Amazon S3") y otras cosas más que bien podrían mandar al paro a departamentos enteros de IT. Pero hoy, de momento, sólo me interesaba el servidor, alquilar un servidor por un rato.

Tengo un pequeño programa en R que resuelve un complicado problema de combinatoria, una especie de sudoku en el que hay que sentar a gente en sillas de acuerdo con una serie de normas. No lee datos de ningún sitio y la salida es un fichero pequeño. Pero podría freír la CPU de mi portátil si lo ejecutase en local.

Repasaré y dejaré, pues, constancia de lo hecho y conseguido:

Primero me he dado de alta en el servicio a través de [http://aws.amazon.com](http://aws.amazon.com/ "Amazon EC2"). He dado mis datos, mi tarjeta de crédito, etc. y me han llamado al teléfono que les he dado: la voz de una señorita grabada en [casete](http://es.wikipedia.org/wiki/Casete "Casete") me ha pedido un código que me habían pasado previamente. Se lo he dado y me ha llegado un mensaje de confirmación.

En mi primer paseo por EC2 me he apoyado en dos páginas, una de [Ubuntu](https://help.ubuntu.com/community/EC2StartersGuide "EC2 Guide for Ubuntu") y [otra más genérica](http://linuxsysadminblog.com/2009/06/howto-get-started-with-amazon-ec2-api-tools/ "EC2 for Linux"). Para interactuar con los servidores de Amazon hacen falta unos certificados de seguridad con claves privada y pública, etc. que esos tutoriales explican cómo gestionar mejor de lo que podría hacer yo. Pero en esencia, lo que hay que hacer es lo siguiente:

1) Descargarse los ficheros de los certificados (el certificado y la clave) de la sección _«Security Credentials»_ de la página de Amazon.

2) Guardarlos en el lugar adecuado y crear una llave privada usando el comando `ec2-add-keypair`. Yo la he llamado `ec2-keypair` (lo hago constar para que queden claros comandos posteriores).

En Amazon EC2 hay muchos tipos distintos de servidores dependiendo del _hardware_ , del _software_ y de la ubicación. Ubicaciones hay tres: dos en EE.UU. y otra en Irlanda. Plataformas de _hardware_ , también, otras tres: buena (1 núcleo de 32 bits, 1,7GB de RAM y 160GB de disco por 10 céntimos de dólar la hora), mejor y requetemejor (8 CPUs de 64 bits, 15GB de RAM y 1.690GB de disco por 0.76 céntimos de dólar por hora).

Dependiendo del _software_ , hay la tira. Hay Ubutus, Fedoras, Suses, Debians, OpenSolaris de varias versiones. Hay algunas que vienen ya con ciertos componentes de _sofware_ montados: Drupal, Apache, R, WordPress, Postgres, LAMP, RoR, SugarCRM, etc. En total, he contado 4101 de ellas. Por no faltar, no faltan, para las abuelillas, máquinas con Windows (pero son más caros).

El comando

`carlos@kropotkin:~$ ec2-describe-images -a`

te permite ver todas. De hecho, para elegir una, he lanzado

`carlos@kropotkin:~$ec2-describe-images -a | egrep i386 | egrep ubuntu | egrep karmic`

para seleccionar una máquina, la ami-19a34270, de 32 bits con Ubuntu Karmic Koala, el mismo sistema operativo que tengo en local. Luego, con el comando

`carlos@kropotkin:~$ ec2-run-instances ami-19a34270 -k ec2-keypair`

he levantado mi instancia (y he puesto el taxímetro a correr). Y con

`carlos@kropotkin:~$ ec2-authorize default -p 22`

he abierto el puerto 22 (el de ssh) para poder acceder remotamente a la máquina. El comando

`carlos@kropotkin:~$ ec2-describe-instances`

me ha permitido conocer la URL de mi servidor, `ec2-274-192-183-237.compute-1.amazonaws.com`, al que he accedido como root mediante

`carlos@kropotkin:~$ ssh -i /home/carlos/.ssh/ec2-keypair.pem root@ec2-274-192-183-237.compute-1.amazonaws.com`

Usando sftp de la forma

`carlos@kropotkin:~$ sftp -oIdentityFile=/home/carlos/.ssh/ec2-keypair.pem root@ec2-274-192-183-237.compute-1.amazonaws.com:/root`

he subido mi programa de R al servidor y una vez en él, después de curiosear por directorios y ficheros para ver si lo que tenía entre manos era, realmente, una cuenta root de una máquina más que decente, lo de siempre:

```r
root@ec2:~# apt-get install r-base

root@ec2:~# R CMD BATCH src.R

root@ec2:~# tail -f src.Rout
```

Es decir, instalar R y correr mi pequeño programa, src.R, en remoto.

Al cabo de 807 segundos (y 10 céntimos de dólar) ya tenía mis resultados. Así que he cerrado mi sesión y he parado el taxímetro mediante

`carlos@kropotkin:~$ec2-terminate-instances i-b7c282df`

Simpático, ¿verdad?

Otro día tengo que probar el almacenamiento, [hadoop](hadoop.apache.org "Hadoop"), los _web services_ y alguna cosa más de esas por las que en España no voy a facturar jamás un euro.