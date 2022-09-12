a <- 10
class(a)
data.class(a)
b <- as.character(a)
b

c <- as.numeric(b)
c

d <- '2022-08-17'
e <- as.Date(d)
e
class(e)
f <- c('2015-04-22',"2017/03/06","16/03/2011", "16-03-2022", "03-16-2022")
f
g <- as.Date(f)
g

### NULL deletes a column in a data frame 
df <- mtcars
df
df$mpg <- NULL

#Adding a columns to a data frame by 2 ways:
#--1.concatenation - cbind(df, ColumnName=c(value1, value2,....))
#--2. Slicing - df$ColumnName <- c(value1, value2,....)

#function paste() - concatenates vector of single strings

##################################
#Data Frames
##################################
#package dplyr (similar ti pandas)
  #install.packages("dplyr") to install or
  #library(dplyr) to use
#package tidyverse

#the sign %>% is for sequencing of arguments

#new variables in data frames using "mutate" function (similar to "case, when" in SQL)

library(dplyr)





