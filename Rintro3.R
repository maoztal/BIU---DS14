##############################################################
##############  R intro part 3          ######################
##############################################################

#install.packages("tidyverse")
library(tidyverse)

##############################
##########  dplyr
##############################

library(dplyr)

#### transform a data.frame into a dplyr compatible data table
class(iris)

#as.data.frame()

#iris2 <- as_data_frame(iris)   ## function imported to dplyr from the 'tibble' package
iris2 <- as_tibble(iris)   ## function imported to dplyr from the 'tibble' package

class(iris2)

iris
iris2

str(iris2)

#### selection of columns
iris2 %>% select(Sepal.Length, Sepal.Width)

### selection of rows using a condition
iris2 %>% filter(Species=="virginica")

### add new columns
iris2 %>% mutate(Sepal.ratio = Sepal.Length/Sepal.Width, 
                 Petal.ratio = Petal.Length/Petal.Width)


### summarise (summarize)
iris2 %>% summarise(Sepal_len_mean=mean(Sepal.Length,na.rm=TRUE), 
                    Petal_len_mean=mean(Petal.Length,na.rm=TRUE))

### summarise by groupping
iris2 %>% 
  group_by(Species) %>%
  summarise(Sepal_len_mean=mean(Sepal.Length,na.rm=T), 
                    Petal_len_mean=mean(Petal.Length,na.rm=T))

######

iris3 <- iris2 %>% 
  select(Sepal.Length, Sepal.Width, Species) %>%
  filter(Species!="virginica") %>%
  mutate(Sepal.ratio = Sepal.Length/Sepal.Width) %>%
  group_by(Species) %>%
  summarise(Sepal_len_mean=mean(Sepal.Length,na.rm=T),
            Sepal_ratio_mean=mean(Sepal.ratio,na.rm=T)) %>%
  arrange(desc(Species))

######

### joining two datasets
df1 <- iris2 %>% 
  mutate(Sepal.ratio = Sepal.Length/Sepal.Width,
         Petal.ratio = Petal.Length/Petal.Width,
         id = 1:nrow(iris2)) %>%
  select(id, Sepal.ratio, Petal.ratio)

iris2_id <- iris2 %>%
  mutate(id = 1:nrow(iris2))

iris3 <- inner_join(iris2_id, df1, by="id")

iris3

#### order the data by a column
iris3 %>%
  arrange(Sepal.Length,Sepal.Width)

iris3 %>%
  arrange(desc(Petal.Width))

#### counting
iris2 %>% tally()


iris2 %>% group_by(Species) %>% tally()

iris2 %>% group_by(Species) %>% summarise(m1=mean(Sepal.Length), cnt = n())

setosa <- iris2 %>% filter(Species=="setosa")
virginica <- iris2 %>% filter(Species=="virginica")
versicolor <- iris2 %>% filter(Species=="versicolor")

iris4 <- rbind(setosa, virginica)
iris4 <- rbind(iris4, versicolor)

######## complex transformation
### Get the minimum, maximum and average of the height and mass, the count and the 
### number of males, females and those without a defined gender, of the characters of 
### the movie 'starwars' that appeared in the film "Attack of the Clones" 
### and by their homeworld procedence

head(starwars)

View(starwars)

starwars$films


mysw <- starwars %>%
  group_by(homeworld) %>% 
  mutate(male = ifelse(gender == "masculine",1,0),
         female = ifelse(gender == "feminine", 1,0),
         nogender = ifelse(is.na(gender)==TRUE,1,0),
         attack_of_clones = ifelse("Attack of the Clones" %in% films,1,0)) %>%
  filter(attack_of_clones == 1) %>%
  summarise(height_min=min(height,na.rm=TRUE),
            height_mean=mean(height,na.rm=TRUE),
            height_max=max(height,na.rm=TRUE),
            mass_min=min(mass,na.rm=TRUE),
            mass_mean=mean(mass,na.rm=TRUE),
            mass_max=max(mass,na.rm=TRUE),
            males = sum(male, na.rm=TRUE),
            females = sum(female, na.rm=TRUE),
            nogender = sum(nogender, na.rm=TRUE),
            num_individuals=n()) %>%
  arrange(desc(num_individuals))



###########################################
###  Graphs in R
###########################################

x <- c(1,2,3,4,5,6,7,8)
y <- x + 15
#z <- (x + y/2)

plot(x, y) 

plot(x ~ y)  ## what happen with the axes?
x1 = x+10
y1 = y -3
lines(x1 ~ y1)

plot(x, y, type='o') ## points and lines
plot(x, y, type='p') ## points
plot(x, y, type='l') ## lines
plot(x, y, type='b') ## both points and dotted lines
plot(x, y, type='c') ## dotted lines
plot(x, y, type='s') ## steped lines
plot(x, y, type='n') ## no dots or lines

###### adding horizontal and verical lines to a graph
plot(iris$Sepal.Length ~ iris$Sepal.Width)
## lets add to the graph a vertical line at the mean septal lenght
abline(h=mean(iris$Sepal.Length), col="red")
## and an horizontal line at the mean septal with
abline(v=mean(iris$Sepal.Width), col="green")

plot(iris$Sepal.Length ~ iris$Sepal.Width, col=iris$Species)


##############################
###### plot parameters
##############################

### defining the x and y limits
plot(x=NULL, xlim=c(1,10), ylim=c(1,11))

### line width
y <- 1 
for(n in seq(0.5,5,0.5)) {
  abline(h=y, lwd=n)
  y <- y + 1
}
### write the values of the line width 0.2 points over the line
text(x=rep(8,10),y = seq(1.4,10.4,1),labels = paste("lwd=",seq(0.5,5,0.5)),cex=0.7)


### line type (6 types)
plot(x=NULL, xlim=c(1,7), ylim=c(1,7), xlab="X", ylab="Y")
y <- 1 
for(n in 1:6) {
  abline(h=y, lty=n, lwd=4)
  y <- y + 1
}
### write the values of the line width 0.2 points over the line
text(x=rep(3,6),y = seq(1.4,6.4,1),labels = paste("lty=",1:6))

### point symbols: there are 35, 25 accessible by numbers (1-25) and 10 accessible by 
### symbols ('*','+','-','.','|','%','#','o','O','0')

plot(x=NULL, xlim=c(-1,7), ylim=c(0,6), xlab="X", ylab="Y")
for(x in 1:5) {
  for(y in 1:5) {
    p <- y+(5*(x-1))
    points(x,y,pch=p,cex=1.5)
    text(x,y+0.3,labels=paste("pch=",p),cex=1.1)
  }
}


q <- c('*','+','-','.','|','%','#','o','O','0')
plot(x=NULL, xlim=c(0,3), ylim=c(0,6), xlab="X", ylab="Y")
for(x in 1:2) {
  for(y in 1:5) {
    p <- y+(2*(x-1))
    points(x,y,pch=q[p],cex=1.5)
    text(x,y+0.2,labels=paste("pch=",q[p]),cex=1.2)
  }
}

#### symbols from 21 to 25 may be drawn in different colors:

cl <- 2:5
gr <- 21:25
plot(x=NULL, xlim=c(1,4), ylim=c(0,5), xlab="X", ylab="Y")
for(x in 1:4) {
  for(y in 1:4) {
    p <- y+(2*(x-1))
    points(x,y,pch=gr[x],bg=cl[y],cex=2)
    text(x,y+0.2,labels=paste("pch=",q[p]),cex=1.3)
  }
}


x <- c(1,2,3,4,5,6,7,8)
y <- x + 15

plot(x ~ y)  ## what happen with the axes?
lines(x ~ y, lty=2 )
lines(x+3 ~ y, lty=3)
points(x ~ y, pch=24, bg=4)
points(x+3 ~ y, pch=22, bg=2)

plot(iris$Sepal.Length ~ iris$Species)
plot(iris$Species)
plot(iris$Species ~ iris$Sepal.Length)

### barplot
barplot(mtcars$mpg)
barplot(table(mtcars$cyl))
barplot(mtcars$cyl)

### histograms and boxplots
x <- rnorm(400, mean=40, sd=15)
hist(x)
hist(x, breaks = 20)

y <- factor(rbinom(400, 2, 0.3))
summary(y)
table(y)
boxplot(x ~ y)

t1 <- table(iris$Species)
t1
pie(t1)

scatter.smooth(x)

### adding color to a plot
mycol <- ifelse(x >44,"red","blue")
scatter.smooth(x, col=mycol)

### adding a title and axis labels
scatter.smooth(x, 
               col=mycol, 
               main="Scatter plot", 
               xlab="Individuals", 
               ylab="Frequency", 
               ylim=c(-50,100))

legend(x="bottomright",
       fill=c("red","blue"), 
       col=c("red","blue") ,
       legend=c(">44","<=44"),
       cex=0.8,
       horiz = F)

### ploting many graphics at once
par(mfrow=c(2,2))
cl <- as.numeric(iris$Species)
plot(iris$Sepal.Length, main="Septal Lenght",col=cl)
hist(iris$Sepal.Width, main="Septal Width",col=cl)
scatter.smooth(iris$Petal.Length, main="Petal Lenght",col=cl)
boxplot(iris$Petal.Width ~ iris$Species, main="Petal Width")
plot(iris$Sepal.Length, main="Septal Lenght",col=cl)
par(mfrow=c(1,1))

plot(mtcars$disp)

### plotting time-series
j <- JohnsonJohnson
j
plot(j)

##############################
##########  ggplot2
##############################
library(dplyr)
library(ggplot2)

# ggplot(data = <DATA>) +
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

iris3 <- iris

iris3 <- iris3 %>% 
  mutate(Sepal.ratio = Sepal.Length/Sepal.Width,
         Petal.ratio = Petal.Length/Petal.Width)

### a simple graph
plot(iris3$Sepal.Length ~ iris3$Sepal.Width)

####################################
### a ggplot2 graph
####################################

### Main graph: ggplot(data = <mydata>, aes( x= <X_var>, y= <Y_var>) ) +
### geometry       geom_XXXXX()
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio))

### adding color by Species
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, color=Species))

### define the shape of the points by species
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, shape=Species, color=Species))

### define the transparency by species
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, alpha=Species, color=Species))


### define size by Species 
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, size=Species))

### define stroke by Petal.Width (doesn't work with factors)
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, stroke=Petal.Length, 
                           color=Species))

### combining many properties in one graph
ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, 
                           color=Species,shape=Species, 
                           alpha=Species, size=as.numeric(Species)))

########## Separate graphs for each class: Facets

ggplot(data=iris3) +
  geom_point(aes(x = Sepal.ratio, y = Petal.ratio, color=Species)) +
  facet_wrap(~ Species, nrow = 1) 

ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, col=Species)) +
  facet_grid(round(Sepal.Length,0) ~ round(Petal.Length,0))

########### Combining two geometric objects into one graph

ggplot(data=iris3) +
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio)) 

ggplot(data=iris3) +
  geom_smooth(mapping = aes(x = Sepal.ratio, y = Petal.ratio)) 

ggplot(data = iris3) + 
  geom_smooth(mapping = aes(Sepal.ratio, y = Petal.ratio, 
                            linetype = Species, color=Species))

ggplot(data = iris3) + 
  geom_smooth(mapping = aes(Sepal.ratio, y = Petal.ratio, 
                            group=Species, color=Species))

### add two different geometries into one graph
ggplot(data = iris3) + 
  geom_point(mapping = aes(x = Sepal.ratio, y = Petal.ratio, color=Species)) +
  geom_smooth(mapping = aes(x = Sepal.ratio, y = Petal.ratio, color=Species))

### Positioning the mapping in the initial graph definition
ggplot(data = iris3, mapping = aes(x = Sepal.ratio, y = Petal.ratio, color=Species)) + 
  geom_point() +
  geom_smooth()


### setting the color of the points by species
ggplot(data = iris3, mapping = aes(x = Sepal.ratio, y = Petal.ratio)) + 
  geom_point(mapping = aes(color = Species)) + 
  geom_smooth()

### filtering the second geometry data to show all out of setosa
ggplot(data = iris3, mapping = aes(x = Sepal.ratio, y = Petal.ratio)) + 
  geom_point(mapping = aes(color = Species)) + 
  geom_smooth(data = filter(iris3, Species != "setosa"))

######### Other Geometric objects 
ggplot(data = iris3) + 
  geom_histogram(mapping = aes(x=Sepal.Length))

hist(iris3$Sepal.Lengt)

ggplot(data = iris3,mapping = aes(x=Sepal.Length)) + 
  geom_histogram(bins = 10)

ggplot(data = iris3,mapping = aes(x=(iris3$Sepal.Lengt))) + 
  geom_histogram(bins = 10, aes(alpha=0.3))


### Bar graph
iris3 <- iris3 %>%
  mutate(Sepal.Length.cat=factor(round(Sepal.Length,0)),
         Petal.Length.cat=factor(round(Petal.Length,0)))

ggplot(data = iris3) + 
  geom_bar(mapping = aes(x=Sepal.Length.cat))

tab1 <- table(iris3$Sepal.Length.cat)

cl <- ifelse(iris3$Species=="Setosa","red",
             ifelse(iris3$Species=="Versicolor","blue","green"))

ggplot(data=iris3, aes(fill=cl, y=Sepal.Length.cat,x=Species)) + 
  geom_bar(position="fill", stat="identity")


#### Colored bars
ggplot(data = iris3) + 
  geom_bar(mapping = aes(x=Sepal.Length.cat, fill=Species))

#### stacked bars
ggplot(data = iris3) + 
  geom_bar(mapping = aes(x=Sepal.Length.cat, fill=Species, position = "fill"))

### Dodge
ggplot(data = iris3) + 
  geom_bar(mapping = aes(x=Sepal.Length.cat, fill=Species), position = "dodge" )

####### Boxplots
ggplot(data = iris3) + 
  geom_boxplot(mapping = aes(x=Species,y=Sepal.ratio))

ggplot(data = iris3) + 
  geom_boxplot(mapping = aes(x=Species,y=Sepal.ratio)) +
  coord_flip()

##################################
#####  Extended layered grammar
##################################
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#   mapping = aes(<MAPPINGS>),
#   stat = <STAT>, 
#   position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>
##################################

ggplot(data = iris3) + 
  geom_bar(mapping = aes(x = Sepal.Length.cat, fill=Species)) 

ggplot(data = iris3) + 
  geom_bar(mapping = aes(x = Sepal.Length.cat, fill=Species)) +
  coord_polar() 

####################
#summary(mysw)
#table(mtcars$cyl)
# mpg - wt - cyl

#ggplot(data = mtcars) +
#  geom_point(mapping=aes(x = mpg, y = wt, color=factor(cyl))) +
#  facet_grid(~cyl) +
#  coord_flip()



#########################################################
#####   Import / Export data
#########################################################

###### CSV (comma separated text)

write.csv(iris, file="iris.csv")
write.csv(iris, file="iris.csv",row.names = F)

mydata <- read.csv(file="iris.csv")
class(mydata)
str(mydata)

####### Excel
library(xlsx)
df1 <- read.xlsx("excel-example.xlsx",sheetIndex = 1)
df2 <- read.xlsx("excel-example.xlsx",sheetIndex = 2)

### Write a data.frame to an excel file
write.xlsx(df1, "one-sheet-example.xlsx", sheetName="Data Frame")


### generate some worksheets and add them to a workbook, then save it into an excel file
library(dplyr)

countries <- df1 %>% 
  group_by(Country) %>% 
  summarise(age_mean=mean(Age,na.rm=T),
            income_mean=mean(Income, na.rm=T),
            income_min=min(Income, na.rm=T),
            income_max=max(Income, na.rm=T),
            count=n())

calories <- df2 %>% 
  group_by(Diet) %>% 
  summarise(caliries_mean=mean(Calories_per_day,na.rm=T),
            caliries_min=min(Calories_per_day,na.rm=T),
            caliries_max=max(Calories_per_day,na.rm=T),
            count=n())

#### pass the tables to an excel file

file <- "excel-example2.xlsx"

wb <- createWorkbook()
sheet1 <- createSheet(wb, sheetName="Countries")
sheet2 <- createSheet(wb, sheetName="Calories")
sheet3 <- createSheet(wb, sheetName="Diet")
sheet4 <- createSheet(wb, sheetName="Income")

addDataFrame(countries,sheet1)
addDataFrame(calories,sheet2)
addDataFrame(df1,sheet3)
addDataFrame(df2,sheet4)

saveWorkbook(wb, file)


################################
##### SPSS / SAS / STATA
###############################

#### SPSS
library(foreign)
sav <- read.spss(file="c:/mydata.sav", to.data.frame=TRUE) 

#### SAS
library(Hmisc)
sap <- sasxport.get("c:/mydata.xpt")

#### STATA
library(foreign)
stata <- read.dta("c:/mydata.dta")

##########################
##### HTML / XML
##########################

###### HTML

library(XML)

url <- "http://www.google.com/search?q=introduction+to+r"
doc <- htmlParse(url)
links <- xpathSApply(doc, "//a/@href")
free(doc)


length(links)

links[[1]]
links[[20]]

###### XML

myxml <- "<foo>
  <bar>text <baz id = 'a' /></bar>
  <bar>2</bar>
  <baz id = 'b' />
</foo>"

xmldoc <- xmlParse(myxml)
rootNode <- xmlRoot(xmldoc)
rootNode[1]
rootNode[2]

########################
#### JSON files
########################
library(jsonlite)

json_file <- "http://api.worldbank.org/country?per_page=10&region=OED&lendingtype=LNX&format=json"
json_data <- fromJSON(json_file)

json_data[[1]]$per_page

json_df <- as.data.frame(json_data)


########################
#### DATABASE
########################

#### To be able to query the database we need to create a new ODBC DNS on the windows computer


library(DBI)
#con <- dbConnect(odbc::odbc(), "COLLEGE")

con <- dbConnect(odbc::odbc(), 
                 .connection_string = "driver={SQL Server Native Client 11.0};server=100.24.57.162;database=COLLEGE;uId=dsuser02;pwd=DSuser02!", 
                 timeout = 10)

#con <- dbConnect(odbc(),
#                 Driver = "SQL Server Native Client 11.0",
#                 Server = "localhost\SQLEXPRESS",
#                 Database = "mydbname",
#                 UID = "myuser",
#                 PWD = "MyPassword",
#                 Port = 1433)

con <- dbConnect(odbc::odbc(),
                 Driver = "SQL Server Native Client 11.0",
                 Server = "100.24.57.162",
                 Database = "COLLEGE",
                 UID = "dsuser10",
                 PWD = "DSuser10!",
                 Port = 1433)

# Using a DSN
con <- dbConnect(odbc::odbc(), "COLLEGE",)

# Retrieve data
sql <- "SELECT * FROM Students"
acs <- dbGetQuery(con, sql)
dbDisconnect(con)


# Using RODBC
library(RODBC)
dbconnection <- odbcDriverConnect("Driver=SQL Server Native Client 11.0;Server=localhost\\SQLEXPRESS; Database=COLLEGE;Uid=; Pwd=; trusted_connection=yes")
students <- sqlQuery(dbconnection,paste("select * from Students;"))
View(students)
odbcClose(dbconnection)



