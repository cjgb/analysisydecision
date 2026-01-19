---
author: rvaquerizo
categories:
  - banca
  - formación
  - monográficos
date: '2011-08-07'
lastmod: '2025-07-13'
related:
  - lecciones-de-economia-de-un-ignorante-espana-esta-salvando-a-alemania-pero-alemania-no-esta-salvando-europa.md
  - lecciones-de-economia-de-un-ignorante-caen-los-beneficios-y-nos-dejan-colocar-preferentes.md
  - lecciones-de-economia-de-un-ignorante-poniendo-fecha-a-la-intervencion-de-espana.md
  - lecciones-de-economia-de-un-ignorante-llegamos-a-solvencia-ii.md
  - lecciones-de-economia-de-un-ignorante-la-caixa-a-colocar-preferentes.md
tags:
  - banca
  - formación
  - monográficos
title: Lecciones de economía de un ignorante. La prima de riesgo (y la madre que la parió)
url: /blog/lecciones-de-economia-de-un-ignorante-la-prima-de-riesgo-y-la-madre-que-la-pario/
---

![](https://lavengro.typepad.com/.a/6a00d8341ccd5b53ef0147e3777daf970b-pi)

El término **prima de riesgo** está todo el día y a todas horas en los informativos españoles. La bolsa baja porque la prima de riesgo sube, ahora baja, ahora estamos por encima de Italia, luego por debajo, los franceses asustados,… En fin «los mercados» nos tienen asustados porque están locos, algunos llaman a esto volatilidad que suena más técnico. Y los menos puestos os preguntaréis **¿que es la prima de riesgo?** Pues aquí estoy yo para transmitir mi ignorancia. Me centro en la zona Euro.

Resulta que, los países necesitan emitir deuda para financiarse ¿el motivo? No os lo cuento porque me meto en un jardín muy peligroso sino que le pregunten a Obana. En fin, que necesitan emitir deuda soberana. Antes del Euro (el verdadero problema) los tipos que compraban esa deuda soberana estaban más preocupados en una depreciación de la moneda que en el riesgo de impago. Pero luego vino la unión monetaria en Europa y entonces pasó lo que está pasando ahora. Había que medir el riesgo de invertir en deuda de un país ya que la depreciación de la moneda no era el mayor problema, ahora _los mercados_ tenían que calcular la probabilidad de no recuperar su inversión.

Como en todos los negocios, cuando no sabemos que hacer, hacemos un ranking. Y como país con menor probabilidad de impago aparecía Alemania. Por otro lado, la falta de talento les llevó a pensar en el _gap_(Valle-Inclán diría diferencia) entre la deuda alemana y la deuda de otro país. Pero existen muchos tipos de emisiones de deuda sobre todo en función del plazo, desde meses a 30 años. Pero se emplean los bonos del estado a 10 años.

Con todo esto la prima de riesgo es la **diferencia del bono a 10 años de un país con el bono aleman**. Si Alemania paga un 2% por sus bonos a 10 años y España paga un 6% la diferencia es de un 4% pero se mide en valor absoluto por 100 luego la diferencia es de 400 puntos básicos. Y esto es lo que nos tiene asustados.

**¿Cómo podemos seguir una serie histórica de la prima de riesgo?** Por ejemplo con [Bloomberg ](http://www.bloomberg.com/)o [Tradingeconomics](http://www.tradingeconomics.com/). Tenemos que buscar Spain Government Bond 10 Year Yield y en poco tiempo entenderemos mejor qué es la prima de riesgo. En Bloomberg tenemos el GSPG10YR:IND (de momento desconozco como descargar los datos con R) y tendremos:

![bono-espana-10-anos.png](/images/2011/08/bono-espana-10-anos.png)

Y arriba a la izquierda tenemos Add a comparison, allí ponemos GDBR10:IND trigger del bono aleman y…

![prima-de-riesgo-espana-alemania.png](/images/2011/08/prima-de-riesgo-espana-alemania.png)

Eso que se ve a la derecha del gráfico con forma de embudo es lo que está llenando Telediarios y lo que está haciendo temblar a _los mercados_. Es la diferencia que se paga por el bono aleman (en verde) con el bono español (en naranja). En fin, creo que se explica de forma sencilla y que tenéis mecanismos para realizar un seguimiento de esta información, por otro lado creo que no he sido duro con el sistema financiero actual que nunca se sabe quién puede leer estas líneas. Incluso me despido sin llamar cabestros a los dirigentes de los bancos centrales. Saludos.
