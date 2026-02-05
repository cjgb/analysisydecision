---
author: rvaquerizo
categories:
  - formation
  - r
  - tricks
date: '2019-02-11'
lastmod: '2025-07-13'
related:
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - analisis-de-textos-con-r.md
  - los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
  - tablas-elegantes-en-rstats-y-formattable.md
tags:
  - formation
  - r
  - tricks
title: Simple tricks for `rstats`
url: /blog/trucos-simples-para-rstats/
---

In [my Twitter account](https://twitter.com/r_vaquerizo), I usually post some simple R tricks, things that come up when I'm working and don't cost much to share in 2 minutes, in case I can help someone. I just realized that they are really useful and that having them scattered on Twitter is a problem, so I thought I'd collect them in a blog post to make them easier to find (even for me). Here are some of those tricks:

Pass data from a `data.frame` to the clipboard, useful when you want to move data from R to Excel without complications:

```r
write.table(borra, "clipboard", sep = "\t", dec = ",", row.names = F)
```

Pass the field names of a `data.frame` to the clipboard (connects with the previous one), useful when you work with a text editor or a spreadsheet to automate code:

```r
write.table(colnames(DF), "clipboard", sep = "\t", dec = ",", row.names = F)
```

Set format `00000` for postal codes:

```r
cp <- c(8080, 29001)
cp <- sprintf("%05d", cp)
```

The best `subset` for H2O:

```r
df.hex[df.hex$campo > 0, ]
```

Text to date in R:

```r
dffecha = as.Date(dffecha, "%d/%m/%Y")
```

Identify repeated records in a `data.frame`; creates a `data.frame` with duplicate records in one line of `dplyr` code:

```r
repetidos <- df %>%
  group_by(campo_ID) %>%
  summarise(repetido = n()) %>%
  filter(repetido > 1)
```

My favorite and the reason for the post, binning a quantitative variable into $n$ groups:

```r
grupos = 10
df <- df %>%
  arrange(campo) %>%
  mutate(campo_tramos = as.factor(ceiling((row_number() / n()) * grupos)))
```

Transform nulls to `0` in 20 characters:

```r
df[is.na(df$V1)] <- 0
```

Transform numbers separated by a comma in text format to numeric format:

```r
dfnumero <- as.numeric(sub(",", ".", dftexto))
```

All factors of my R `data.frame` to character to avoid some trouble, using `lapply`:

```r
df <- data.frame(lapply(df, as.character), stringsAsFactors = FALSE)
```

Create a sequence of dates in R and format the sequence of dates in R:

```r
secuencia <- seq(as.Date("2016/1/1"), by = "month", length.out = 12)
format(secuencia, "%Y%m")
```

Function to get only the numbers that start a text string in R:

```r
library(readr)
parse_number("1234abcd")
```

Using `tidyr` to extract only numbers from a string. Note that sometimes you need talent to do this task:

```r
library(tidyr)
extract_numeric("abcd1234efgh")
```

Function to export larger `dataframes` to the clipboard, ideal for moving `dataframes` to Excel, converting from American to European format:

```r
write_excel <- function(x, row.names = FALSE, col.names = TRUE, ...) {
  write.table(x, "clipboard-16384", sep = "\t", dec = ",", row.names = row.names, col.names = col.names, ...)
}
```

Sequence of dates with R:

```r
seq(as.Date("2018-01-01"), as.Date("2018-12-31"), by = "days")
```

Function to get only numbers within a text string in R; there are many, I use this one:

```r
gsub("[^0-9]", "", "abc123def")
```

The `not in` in R:

```r
`%nin%` <- Negate(`%in%`)
```

Allow RStudio to display all columns of the `data.frame`:

```r
options(max.print = 10000)
```

Replace a variable with a null value to `0` using `ifelse`:

```r
df$var <- ifelse(is.na(df$var), 0, df$var)
```

Operate with months in `YYYYMM` format, the typical ones for partitions, a trick that probably already exists:

```r
mes <- 201812
mes_sig <- as.numeric(format(as.Date(paste0(mes, "01"), "%Y%m%d") + 31, "%Y%m"))
```

I hope this post can continue to grow, they are trifles (my trifles) and I have them centralized in a single post.