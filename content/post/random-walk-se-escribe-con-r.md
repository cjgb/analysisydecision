---
author: danifernandez
categories:
  - formación
date: '2010-05-20'
lastmod: '2025-07-13'
related:
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - series-temporales-animadas-con-r-y-gganimate-comparando-cotizaciones.md
  - leer-y-representar-datos-de-google-trends-con-r.md
  - graficos-de-calendarios-con-series-temporales.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
tags:
  - bolsa
  - charts gratis
  - getquote
  - getsymbols
  - mercados financieros
  - quantmod
  - r
title: «Random walk» se escribe con R
url: /blog/random-walk-se-escribe-con-r/
---

*Random walk* hace referencia a la teoría financiera de que los mercados financieros siguen un camino aleatorio. Pero NO vamos a discutir si se da o NO tal hipótesis; lo que SÍ vamos a hacer es utilizar R para seguir las acciones, fondos de inversión, o sencillamente para ver nuestro decepcionante euro respecto a otras divisas (por si algún día los *españolitos* debiéramos empezar a emigrar de nuevo… ¡tal como está el patio!).

Vamos a necesitar varios paquetes; si no me olvido de ninguno, básicamente son estos dos:

- `quantmod`
- `tawny`

La manera de funcionar es que conectan a la fuente de datos de los portales de `Yahoo` y `Google`, y extraen los datos que le pidamos con unos 15-30 minutos de retraso respecto al tiempo real de mercado (creo que conecta con `Yahoo` por defecto). Sea como sea, nos indica también la fecha y hora de la cotización más reciente.

Es tan sencillo como hacer:

```r
library(quantmod)
getQuote("AAPL")
```

…y nos informa de la última cotización de las acciones de `APPLE`.

El ligero inconveniente es que siempre vamos a depender de la conectividad a `Yahoo` o `Google`: si ellos dejan de recibir datos, nosotros también. Un apunte importante: para las acciones americanas solo basta escribir su `ticker` (código de 3 o 4 letras que identifica a las acciones de una compañía) tal cual, pero para el resto de países es otra historia: hemos de añadir su "destino". Aquí os facilito una breve guía:

- `.MC` para el Mercado Continuo español.
- `.PA` si cotiza en París.
- `.DE` si cotiza en Alemania (*Deutschland*).
- `.MI` si cotiza en Milán.
- `.LS` si cotiza en Lisboa.

Así tenemos, por ejemplo (CITIGROUP, BANCO SANTANDER, BNP PARIBAS, DEUTSCHE BANK, BANCO ESPIRITU SANTO):

```r
getQuote("C;SAN.MC;BNP.PA;DBK.DE;BES.LS")
```

La lista de valores la podemos separar por `";"` o `"+"`.

Veamos un listado de índices europeos (4), americanos (3), Japón, Brasil y algunos pares de divisas:

```r
getQuote("^IBEX;^GDAXI;^FCHI;^STOXX50E;^DJI;^IXIC;^GSPC;^N225;^BVSP;EURUSD=X;GBPEUR=X;USDJPY=X")
```

La función `getQuote` solo nos informa de la cotización más reciente. Para extraer un histórico lo mejor es `getSymbols`, especificando el inicio y final de fechas; si NO indicamos final, extrae hasta el último cierre de día (este histórico NO incluye la cotización del día presente en curso), y si NO especificamos el inicio de la serie histórica, nos dará por defecto el primer día de enero de 2007. Para estar seguros siempre podemos acudir a la función `head()` y ver unas líneas del inicio de la serie o bien `tail()` para ver los días más recientes. Ejemplo con las "Starbucks":

```r
getSymbols("SBUX")
head(SBUX)
tail(SBUX)
```

Si queremos extraer un detalle de los últimos meses (formato de fechas `yyyy-mm-dd`):

```r
getSymbols("SBUX", from = "2010-01-01")
```

Y ahora llega lo mejor: vamos a confeccionar su gráfico con `chartSeries(SBUX)` y, sin cerrar la ventana de salida, creamos algunos de sus indicadores (`RSI`, `Bollinger Bands` y `ADX`):

```r
chartSeries(SBUX)
addRSI()
addBBands()
addADX()
```

![sbux2.jpeg](/images/2010/05/sbux2.jpeg "sbux2.jpeg")

…y guardamos el gráfico en `.PDF`:

```r
saveChart(.type = "pdf", dev = dev.cur())
# chart saved to SBUX.pdf
```

Si quisiéramos concretar el rango temporal, basta con definirlo (ejemplo sólo año 2009):

```r
getSymbols("SBUX", from = "2009-01-01", to = "2009-12-31")
```

Para filtrar la información (columnas) a extraer podemos usar la función `yahooQF()`:

```r
getQuote("TEF.MC", what = yahooQF())
```

Podemos también conocer el histórico de dividendos que una compañía ha repartido a sus accionistas:

```r
getDividends("SBUX")
```

O bien conocer los rendimientos diarios de los últimos 30 días o desde una fecha anterior hasta la fecha reciente:

```r
getPortfolioReturns("SBUX", obs = 30) # Suponiendo que la función esté disponible en tawny
getPortfolioReturns("SBUX", start = "2010-03-01", end = Sys.Date())
```

Lo que tenemos que TENER MUY CLARO es que cada vez que usemos el `ticker` para cualquier función de gráfico a extraer, éste hace referencia al objeto memorizado de la última vez que lo definimos como símbolo con `getSymbols`. Si cambiamos el rango temporal a uno muy corto, solo "graficaremos" un *chart* sobre ese corto espacio temporal, su respectivo histórico de dividendos también estará sujeto a dicho espacio, etc.

Para extraer un listado completo de compañías, por ahora que yo sepa solo existe esta posibilidad para los índices DOW JONES y SP500:

```r
# Nota: Estas funciones pueden variar según la versión del paquete
# getIndexComposition("^DJI")
# getIndexComposition("^GSPC")
```

En caso de ignorar algún `ticker` o el código de algún índice o cualquier producto financiero, lo mejor es remitirse a `Yahoo` y/o `Google`. Como hemos visto, lo que aquí R nos puede ofrecer es la facilidad de seguir un listado de *stocks* e índices de diferentes países, divisas, conocer su histórico y, sobre todo, graficar *charts* con sus indicadores técnicos sin coste alguno.

Saludos. Y ya saben: «Random» también se escribe con R.