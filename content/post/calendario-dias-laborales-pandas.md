---
author: Paco Gárate
categories:
  - banca
  - machine learning
  - python
  - seguros
date: '2019-07-01'
lastmod: '2025-07-13'
related:
  - graficos-de-calendarios-con-series-temporales.md
  - trabajo-con-fechas-sas-funciones-fecha.md
  - curso-de-lenguaje-sas-con-wps-funciones-fecha.md
  - trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
  - bucle-de-fechas-con-sas-para-tablas-particionadas.md
tags:
  - banca
  - machine learning
  - python
  - seguros
title: Calendario de días laborales con Pandas
url: /blog/calendario-dias-laborales-pandas/
---

Es habitual escuchar que un científico de datos es un estadístico que trabaja con Python. En parte, tiene razón. Sin embargo, quien ha trabajado dentro del mundo académico sabe que para un estadístico las [vacas son esféricas](https://es.wikipedia.org/wiki/Vaca_esf%C3%A9rica) y los meses tienen 365,25/12 días. En cambio, en el mundo real, ni hay dos vacas iguales ni un mes igual a otro.
Sirva esta entrada para poner en valor todo aquel trabajo adicional y tiempo dedicado por aquellos que trabajan con datos y huyen de simplificaciones estadísticas, ya se denominen científicos de datos o cómo quieran llamarse.

## Series temporales con Pandas

Pandas, como se ha visto aquí, es la librería por excelencia para el [manejo de datos](https://analisisydecision.es/data-management-basico-con-pandas/) ya que permite trabajar fácilmente con tablas numéricas y series temporales.
Una utilidad disponible en Pandas en relación a las series temporales es crear directamente rangos de fechas con la función `pd.date_range()`, la cual utiliza los siguientes parámetros (no todos obligatorios):

- **start** : Inicio del rango. Límite izquierdo para generar fechas.
- **end** : Fin del rango. Límite derecho para generar fechas.
- **period** : Número de periodos a generar
- **freq** : Frecuencia de las proyecciones. Entre otros:
  - D: Diaria (por defecto)
  - Y: Anual
  - M: Mensual
- **closed** : Si queremos excluir el inicio (closed=’right’) o el final (closed=’left’)
- **name** : Nombre del DatetimeIndex resultante (por defecto ninguno)

## Ejemplo básico de una serie temporal

```r
import pandas as pd
s = pd.date_range(start='2019-01-01', periods=12, freq='M')
df = pd.DataFrame(s, columns=['Fecha'])
print(df)
```

```r
Fecha
0  2019-01-31
1  2019-02-28
2  2019-03-31
3  2019-04-30
4  2019-05-31
5  2019-06-30
6  2019-07-31
7  2019-08-31
8  2019-09-30
9  2019-10-31
10 2019-11-30
11 2019-12-31
```

## Crear una serie temporal con los últimos días laborales de cada mes

En determinados ámbitos, principalmente financiero y actuarial, resulta especialmente útil manejar rangos de fechas en donde los días de la serie correspondan al primer o último día laboral del mes (por ejemplo, cuando proyectamos pagos de cupones o rentas).
Para ello, la función `pd.date_range()` dispone de diferentes valores para el parámetro frecuencia. En el siguiente ejemplo, ‘BM’ corresponde con BusinessMonthEnd (último día laboral del mes):

```r
import pandas as pd
s = pd.date_range('2019-01-01', periods=12, freq='BM')
df = pd.DataFrame(s, columns=['Fecha'])
print(df)
```

```r
Fecha
0  2019-01-31
1  2019-02-28
2  2019-03-29
3  2019-04-30
4  2019-05-31
5  2019-06-28
6  2019-07-31
7  2019-08-30
8  2019-09-30
9  2019-10-31
10 2019-11-29
11 2019-12-31
```

Aunque si queremos mayor exactitud, debemos tener en cuenta los días festivos (por ejemplo, si calculamos costes que dependan de los días exactamente transcurridos entre cupón y cupón, un 1 día entre 20 representa un 5% de error). Conocer los días festivos dentro de un periodo de tiempo es especialmente útil cuando estimamos usos y comportamientos humanos (transporte público, asistencias médicas, cargas en servidores informáticos…). En el sector asegurador, dichos patrones pueden afectar directamente en las reservas contables, por ejemplo, a la hora de calcular los costes incurridos pero no declarados (IBNR). De hecho, en algunas compañías aseguradoras es habitual que se incrementen ligeramente los ratios de siniestralidad los años bisiestos simplemente por disponer de un día natural más que el resto.

En el siguiente ejemplo introducimos una lista con un par de días festivos simplemente para ver el funcionamiento: el 31 de mayo (Día de Castilla-La Mancha) y 28 de febrero (Día de Andalucía). Posteriormente calculamos los días transcurridos entre pagos si estos se produjeran el último día de mes:

```r
import pandas as pd
fiestas = ['2019-02-28','2019-05-31']
es_holidays = pd.tseries.offsets.CustomBusinessMonthEnd(holidays=fiestas)
s = pd.date_range('2019-01-01', periods=12, freq=es_holidays)
df = pd.DataFrame(s, columns=['Fecha'])
df['n_dias'] = df['Fecha'].diff().dt.days.fillna(0)
print(df)
```

```r
Fecha  n_dias
0  2019-01-31     0.0
1  2019-02-27    27.0
2  2019-03-29    30.0
3  2019-04-30    32.0
4  2019-05-30    30.0
5  2019-06-28    29.0
6  2019-07-31    33.0
7  2019-08-30    30.0
8  2019-09-30    31.0
9  2019-10-31    31.0
10 2019-11-29    29.0
11 2019-12-31    32.0
```

_(Como puede observarse, el 28-2 y 31-5 no aparecen en el calendario de pagos)_

## Reglas de cálculo para los días festivos

Por último, existe la opción de escribir reglas para calcular los días festivos (ya que normalmente estos son trasladados al siguiente día laboral). En ciertos países, como Estados Unidos, existen leyes al respecto (como la Uniform Monday Holiday Act of 1968), cuyas reglas están incluidas en Pandas y pueden consultarse haciendo un `print(USFederalHolidayCalendar.rules)`.

Sin embargo, en muchos otros países no existen reglas para determinar los festivos del año (como ocurre en España), sino que cada año las fiestas laborales son fijadas por normativa. No obstante, vamos a aventurarnos a crear las reglas del calendario laboral español con la premisa de que los festivos que caigan en domingo se pasan al lunes siguiente (instrucción `observance=sunday_to_monday`). Posteriormente, mostramos los días laborales de diciembre para comprobar su funcionamiento.

```r
from pandas.tseries.holiday import *
from pandas.tseries.offsets import CustomBusinessDay

class EsBusinessCalendar(AbstractHolidayCalendar):
   rules = [
     Holiday('Año Nuevo', month=1, day=1, observance=sunday_to_monday),
     Holiday('Epifanía del Señor', month=1, day=6, observance=sunday_to_monday),
     Holiday('Viernes Santo', month=1, day=1, offset=[Easter(), Day(-2)]),
     Holiday('Día del Trabajador', month=5, day=1, observance=sunday_to_monday),
     Holiday('Asunción de la Virgen', month=8, day=15, observance=sunday_to_monday),
     Holiday('Día de la Hispanidad', month=10, day=12, observance=sunday_to_monday),
     Holiday('Todos los Santos', month=11, day=1, observance=sunday_to_monday),
     Holiday('Día Constitución', month=12, day=6, observance=sunday_to_monday),
     Holiday('Inmaculada Concepción', month=12, day=8, observance=sunday_to_monday),
     Holiday('Navidad', month=12, day=25, observance=sunday_to_monday)
   ]

es_BD = CustomBusinessDay(calendar=EsBusinessCalendar())
s = pd.date_range('2019-12-01', end='2019-12-31', freq=es_BD)
df = pd.DataFrame(s, columns=['Fecha'])
print(df)
```

```r
Fecha
0  2019-12-02
1  2019-12-03
2  2019-12-04
3  2019-12-05
4  2019-12-10
5  2019-12-11
6  2019-12-12
7  2019-12-13
8  2019-12-16
9  2019-12-17
10 2019-12-18
11 2019-12-19
12 2019-12-20
13 2019-12-23
14 2019-12-24
15 2019-12-26
16 2019-12-27
17 2019-12-30
18 2019-12-31
```

_(Se aprecia como el domingo 8 de diciembre es reemplazado por el lunes 9)_

Así, una vez creado nuestro calendario de fiestas nacionales, podemos utilizarlo para conocer las fiestas de próximos años, por ejemplo para el año 2020:

```r
calendar = EsBusinessCalendar()
print(calendar.holidays(start='2020-01-01', end='2020-12-31'))
```

```r
DatetimeIndex(['2020-01-01', '2020-01-06', '2020-04-10', '2020-05-01',
               '2020-08-15', '2020-10-12', '2020-11-02', '2020-12-07',
               '2020-12-08', '2020-12-25'],
              dtype='datetime64[ns]', freq=None)
```

Las fiestas regionales o locales pueden ser incluidas de la misma manera, aunque hay que tener en cuenta que en ciertas comunidades es costumbre trasladar ciertas fiestas al 19 de marzo o el jueves del Corpus en vez de al siguiente lunes (en ese caso habría que crear una nueva función basada en la función de Pandas `sunday_to_monday`).

Nuestro calendario puede ser utilizado también en otras librerías como Prophet. [Prophet](https://facebook.github.io/prophet/docs/quick_start.html) es una librería avanzada de _[machine learning](https://analisisydecision.es/machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion/)_ creada por Facebook, enfocada a modelos de regresión no lineales de datos a lo largo del tiempo, la cual requiere un listado de días festivos que debe ser proporcionado por el usuario.
