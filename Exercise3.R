library(dplyr)

#1
help(mtcars)
View(mtcars)

#2
mtcars1 <- mtcars
mtcars1$cyl <- factor(mtcars1$cyl, levels = c(4,6,8), labels = c("medium","high","extreme"))
mtcars1$vs <- factor(mtcars1$vs, levels = c(0,1), labels = c("V-shaped","straight"))
mtcars1$am <- factor(mtcars1$am, levels = c(0,1), labels = c("automatic","manual"))

#3
mtcars2 <- mtcars1 %>%
  group_by(am) %>%
  summarise(
    mpg_mean=mean(mpg, na.rm=T),
    mpg_min=min(mpg, na.rm=T),
    mpg_max=max(mpg, na.rm=T),
    mpg_median=median(mpg, na.rm=T)
    )

boxplot(mtcars1$mpg ~ mtcars1$am, ylab = "mpg", xlab = "am" ,main="Gas consumption vs Transmission type")

#4
boxplot(mtcars$mpg ~ mtcars$cyl, ylab = "mpg", xlab = "#cyl" ,main="Gas consumption vs Cylinders#")

#5
scatter.smooth(mtcars$mpg ~ mtcars$wt)

#6
boxplot(mtcars$mpg ~ mtcars$cyl*mtcars1$am, col=c("red", "green", "blue"))

