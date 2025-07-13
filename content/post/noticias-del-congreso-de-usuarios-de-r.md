---
author: cgbellosta
categories:
- Formación
- R
date: '2009-11-29T12:58:34-05:00'
slug: noticias-del-congreso-de-usuarios-de-r
tags:
- jornadas de usuarios de R
- R
title: Noticias del congreso de usuarios de R
url: /noticias-del-congreso-de-usuarios-de-r/
---

Hoy he regresado de las primeras jornadas de usuarios de R. Han sido dos días largos y densos, pero también productivos. Tenemos que estar muy agradecidos a [José Antonio Palazón](http://fobos.bio.um.es/palazon/index/ "J.A. Palazón"), de la Universidad de Murcia y coordinador del comité organizador, y a Manuel Muñoz Márquez, coordinador del comité científico y responsable del proyecto [R UCA](http://knuth.uca.es/R/doku.php "R UCA"), por su extraordinario trabajo.

Creo que para muchos de los participantes, uno de los principales beneficios que extrajimos de las jornadas fue el de poder establecer contacto real, físico, con gente y grupos a los que ya conocíamos directa o indirectamente. Allá me encontré con compañeros con los que había mantenido largos intercambios de correo y chat sobre los temas más diversos; algunos que me agradecieron alguna respuesta que les di años ha en la lista de correo de R-help (antes de que existiese R-help-es, incluso) e, incluso, fieles seguidores de este blog (del que sólo supieron contarme maravillas antes, incluso, de revelarles mi participación en él y que la cordialidad los cuasiobligase a ello). Incluso surgieron muchas vías de colaboración entre proyectos que habían surgido de manera espontánea e independiente y que, de repente, se vio que se enriquecían mutuamente.

La mayoría de los participantes procedía de ámbitos universitarios y había tanto estadísticos puros como ingenieros de distintas ramas (predominando la informática), ecólogos, biólogos, sociólogos, economistas e, incluso, un representante de las ciencias del deporte. De todos los portátiles que vi encendidos, todos menos dos (un Windows Vista y un XP) corrían diversas distribuciones de Linux, predominando Ubuntu, aunque también vi dos Xubuntus (uno, el mío) y un Fedora. Todas las presentaciones, menos una, se hicieron usando [Beamer](http://es.wikipedia.org/wiki/Beamer "Beamer") y sólo una con OpenOffice.

La primera ponencia, de Manuel Muñoz Márquez, trató acerca de la implantación de R y su tendencia en la universidad. Los datos procedían de una encuesta realizada en departamentos (o áreas departamentales) universitarios de estadística y cubría aspectos sobre el grado de uso de R en investigación, docencia, etc. y sobre la existencia de planes de migración más o menos oficiales. Habría sido interesante el haberla podido contrastar con datos de tan sólo 3 o 4 años de antigüedad para tener una visión más clara de la tendencia.

Pero emergió un claro patrón de avance: a pesar de ciertas reticencias de uso en docencia (habría que reelaborar cursos y prácticas, claro) y la falta de planes coordinados y _oficiales_ de migración, el uso de R progresa muy claramente en investigación y atrae especialmente al personal más joven. R penetra en la pirámide jerárquica de la universidad por su base y la tendencia, por tanto, es de extensión en su uso. Aunque no cabe tanto una revolución sino una evolución en su grado de penetración. Esta tendencia puede verse acelerada por la nueva política de licencias (y su precio) de SPSS, el viejo monopolizador del negocio del _software_ estadístico en la universidad.

Existen iniciativas, emergió en la ronda de preguntas, para que, igual que los ingenieros saben (realmente) y se los _obliga_ a saber usar Matlab, a los estadísticos se los _obligue_ también a saber realmente R al término de sus estudios.

De la segunda de las ponencias sólo puedo hablar maravillas, dado que fue la mía. Trató, bajo una perspectiva enteramente personal (y, por ende, algo caótica, deslavazada y _quevediana_), de qué cabida tiene R en la empresa y de qué otras herramientas puede servirse para hacerse un hueco en un ecosistema dominado por viejos depredadores. En particular, y dada la naturaleza de los entornos corporativos, quiso proponer una serie de herramientas orientada a resolver dos problemas fundamentales:

  * El de las restricciones de memoria de R cuando se trata de manejar grandes volúmenes de datos.
  * El de cómo encapsular la complejidad de R para que pueda ser implícitamente utilizado por empleados que ni saben ni tienen por qué saber R (o, más generalmente, programar).

Así, hablé de [KNIME](http://www.knime.org "KNIME"), [Kettle](http://kettle.pentaho.org/ "Kettle"), [Postgres](http://www.postgresql.org/ "Postgres"), [Rapache](http://biostat.mc.vanderbilt.edu/rapache/ "Rapache"). Y di ejemplos de uso y de posibles vías de extensión. Pero creo que el éxito, si alguno, de la conferencia fue el de los ejemplos reales de aplicaciones de la estadística en contextos reales, esos de los que nunca te habla nadie mientras eres estudiante.

Y eso que los jocundos los dejé para la hora del café. Hora en la que me semi-comprometí a aumentarla y enriquecerla con vista a hacer de ellos el asunto de mi charla en las II Jornadas bajo condición de que no se me grabase en vídeo y que lo que yo dijese no saliese de la sala. Por si acaso se pica alguien de los que come ajos a manojos.

En el primero de los talleres de la tarde del jueves, Antonio Maurandi López nos dio un paseo por [Rcommander](http://socserv.mcmaster.ca/jfox/Misc/Rcmdr/ "Rcommander"), una interfaz para R desarrollada por [John Fox](http://socserv.mcmaster.ca/jfox/ "John Fox") (y en la que también han colaborado los integrantes del proyecto R UCA en aspectos tales como el de su traducción, [el desarrollo de materiales (incluyendo un libro)](http://knuth.uca.es/moodle/course/view.php?id=37 "Libro de Rcommander"), etc.). El objeto fundamental de dicha interfaz es el de hacer más llevaderos los primeros pasos en R para los novatos y servir también de ayuda a quienes migren de otras plataformas como SPSS. Cabe esperar que Rcommander sea, cada vez más, el primer contacto con R para los futuros estudiantes de estadística y disciplinas afines.

El segundo de los talleres, de Fernando Cánovas García, fue un repaso de ideas y trucos para afrontar divesos problemas genéricos con R. Tal vez, algunos de nosotros echamos de menos algún taller paralelo en el que se tratasen temas más profundos (clases S4, cómo utilizar algún paquete avanzado, etc.).

El viernes 27 (a una hora que se nos antojó excesivamente temprana para quienes habíamos abusado de la magnífica hospitalidad de los organizadores, materializada en una estupenda cena copiosa en manjares y vinos de la región y amenizada con las más herméticas de las conversaciones para los no iniciados en Linux y estadística) nos enfrentamos a una batería de comunicaciones breves.

Dos de ellas corrieron a cargo de [José Miguel Contreras García](http://www.ugr.es/~estadis/1/ContrerasJM.html "JM Contreras"), de la Universidad de Granada, en la que nos habló de temas relacionados con la ponderación y calibración de muestras para la extrapolación de datos procedentes de encuestas (muestras finitas de una población) a dicha población entera. Se contrastaron paquetes existentes en el mercado y que utilizan diversos institutos estadísticos por todo el mundo, con librerías de R como [survey](http://cran.r-project.org/web/packages/survey/index.html "Paquete survey") y otras.

Mi compañero de [alma mater](http://www.unizar.es/ "Universidad de Zaragoza"), Roldán Galán, nos describió un sistema que había desarrollado para distribuir tareas (en su caso particular, entrenamiento de redes neuronales distintas sobre los mismos datos) dentro de una red local de ordenadores. Usando Java para establecer y gestionar las conexiones, un ordenador central es capaz de distribuir tareas entre los nodos para que éstos realicen sus cálculos y devuelvan los datos, que son posteriormente contrastados.

Luis Mariano Esteban, también de la Universidad de Zaragoza, compartió con nosotros experiencias en el desarrollo de modelos con R aplicados a diagnósticos médicos encuadrados en la colaboración de su grupo de investigación con el [Hospital Miguel Servet](http://www.hmservet.es/ "Hospital Miguel Servet") (ahí nací yo) de Zaragoza.

Miguel Ángel Rodríguez Muinosa nos puso al tanto del desarrollo de [Epilinux](http://www.sergas.es/mostrarcontidos_n3_t01.aspx?idpaxina=50178 "Epilinux"), una distribución de Linux derivada de Ubuntu que incluye gran cantidad de aplicaciones para el análisis de datos, desde R hasta [PSPP](http://www.gnu.org/software/pspp/ "PSPP"), [GRASS](http://grass.itc.it/statsgrass/index.php "GRASS") y otras. Puede arrancar desde lápices de memoria y CDs, por lo que es ideal para la organización de seminarios y jornadas prácticas: hace que todo el software necesario para desarrollarlos pueda ser instalado en el portátil de los asistentes sin necesidad de alterar para nada los contenidos del disco duro de ninguno de ellos. Y, por supuesto, sin ningún tipo de restricciones por uso de licencias de _software_ propietario.

Jorge Luis Ojeda Cabrera, de la Universidad de Zaragoza también, nos hizo una demostración de uso de su paquete [miniGUI](http://cran.r-project.org/web/packages/miniGUI/index.html "miniGUI"), disponible en CRAN. Este paquete permite construir de manera simple y automatizada un GUI de entrada de datos (usando [Tcl/Tk](http://es.wikipedia.org/wiki/Tcl "Tcl/Tk")) para una función dada.

Finalmente, Xavi de Blas, en una charla muy amena (en la que, de todos modos, echamos de menos sus consuetudinarios juegos malabares con las que ameniza sus conferencias) nos explicó cómo en el mundo del deporte, tan abundante en números, cifras, medidas y estadísticas, existen grandes posibilidades para el desarrollo de aplicaciones basadas en R. Y como ejemplo, nos ofreció una demostración de una herramienta, [Chronojump](http://chronojump.org/documents_es.html "Chronojump"), que ha desarrollado como plataforma de ayuda para el entrenamiento deportivo y que incluye tanto _[hardware](http://chronojump.org/documents_es.html "Chronojump")_ para medir tiempos de vuelo en saltos y otros datos, como _software_ para almacenar y procesar ese tipo de información, siendo R la plataforma que da soporte estadístico a la solución.

A estas charlas siguió una mesa redonda para recoger ideas de cara a la creación de una organización, plataforma o similar que integre a los usuarios de R (con ámbitos geográficos e idiomáticos a definir) y que sirva de punto de referencia a las iniciativas que se tomen, como, por ejemplo,

  * la organización de las II (y subsecuentes) Jornadas,
  * el desarrollo y mantenimiento de un portal que concentre y administre recursos relacionados con R que aporte la comunidad,
  * y la función de portavocía de la comunidad de usuarios frente a medios de comunicación o administraciones públicas.

Se quedó en que en las semanas venideras y a través de la [lista de correo R-help-es](https://stat.ethz.ch/mailman/listinfo/r-help-es "r-help-es"), van a proponerse y discutirse los temas relacionados con la organización de dicha superestructura, desde la elección de su nombre hasta su gestión.

Juan José Vidal, en una intervención sorpresa, nos mostró su propuesta para una renovación de la página de R que puede verse en [su repositorio](http://github.com/juanjo/rproject "Propuesta de la página de r-project"). La actual, aparte de no estar desarrollada con [html válido](http://validator.w3.org/ "Validador de html") y utilizar arcaicos _frames_ , manifiestamente, no está a la altura de los tiempos en lo que a diseño se refiere. Un proyecto de la madurez y envergadura de R merece una página más atractiva. Propuse que se trasladase la discusión y conveniencia de su actualizacion a la lista gobal de [R-help](https://stat.ethz.ch/mailman/listinfo/r-help "R-help") y espero una avalancha de votos positivos para contrarrestar los de los partidarios de tecnologías obsolescentes. Estemos preparados para votar sí nada más se haga pública la discusión.

La tarde del viernes se completó con dos talleres adicionales. En el primero de ellos, Manuel Muñoz Márquez nos guió a través del proceso de creación de extensiones y menús adicionales para Rcommander. Fue todo un descubrimiento (y muy feliz) constatar que el paquete miniGUI del que habíamos visto una presentación por la mañana, permitía acelerar y facilitar el desarrollo de algunos de ellos. Espero que exista un beneficioso fenómeno de polinización cruzada entre ambas iniciativas.

Finalmente, José Antonio Palazón nos ilustró acerca de cómo integrar R con OpenOffice y Latex mediante [Sweave](http://www.stat.uni-muenchen.de/~leisch/Sweave/ "Sweave") y [Odfweave](http://cran.r-project.org/web/packages/odfWeave/index.html "Odfweave"). Ambos paquetes permiten encapsular código de R en documentos escritos con R u OpenOffice de manera que, de cambiar los datos, basta _compilarlos_ para que, de manera automática, cambien gráficos, tablas y resultados. Sería muy útil para la elaboración automática de informes periódicos.

En resumen, el ambiente de las jornadas no pudo ser más positivo y es de esperar que tengan la continuidad que merecen tanto en el desarrollo de las segundas (y subsiguientes) como en la formalización de una comunidad de usuarios de R.