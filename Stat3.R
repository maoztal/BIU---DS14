library(dplyr)
library(mechkar)
library(car)

############################################
### Linear Regression
############################################

#########################
# Uni-variate Analysis
#########################

data("cars")

hist(cars$speed)
hist(cars$dist)

#Model1
mod1 <- lm(cars$dist ~ cars$speed)
summary(mod1)
mod1$fitted.values
mod1$model

pred1 <- predict(object = mod1)
plot(pred1, type = "l")

  #Plot the model
plot(cars$dist ~ cars$speed)
abline(reg = mod1, col="red")

plot(pred1 ~ cars$dist)

############################
### Multivariate Analysis 
############################
data("mtcars")

# One variable
mod2 <- lm(mpg ~ wt, data = mtcars)
summary(mod2)
pred2 <- predict(mod2)

plot(mpg ~ wt, data = mtcars)
abline(reg = mod2, col="red")

# Two and more variables 
mod3 <- lm(mpg ~ wt + cyl, data = mtcars)
summary(mod3)

mod4 <- lm(mpg ~ wt + cyl + hp, data = mtcars)
summary(mod4)

mod5 <- lm(mpg ~ wt + ., data = mtcars) # "." = all variables
summary(mod5)

############################################
### Logistic Regression
############################################
# "Y" is categorical variable 

data("TitanicSurvival")

titanic <- TitanicSurvival
summary(titanic)
titanic <- titanic %>% filter(is.na(age) == FALSE)

mod6 <- glm(survived ~ age, data = titanic, family = "binomial")
summary(mod6)
pred6 <- predict(object = mod6, type = "response")
hist(pred6)
summary(pred6)

table(sur=titanic$survived, pred=ifelse(pred6 >= 0.5,1,0))

#####
mod7 <- glm(survived ~ age + sex, data = titanic, family = "binomial")
summary(mod7)

pred7 <- predict(mod7, type = "response")
hist(pred7)
summary(pred7)
table(surv=titanic$survived, pred=ifelse(pred7 >=0.5,1,0))

