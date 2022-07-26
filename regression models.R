library(dplyr)
library(mechkar)
library(car)

############################################
##  Linear Regression
############################################

############################
### Univariate Analysis 
############################

### cars

data(cars)

hist(cars$speed)
hist(cars$dist)

###### Model
mod1 <- lm(cars$dist ~ cars$speed)
summary(mod1)

pred1 <- predict(mod1)

##### plot the model
plot(cars$dist ~ cars$speed)
abline(reg=mod1, col="red")

lines(pred1 ~ cars$speed)

plot(pred1 ~ cars$dist)

plot(cars$dist ~ pred1)

##### summary
summary(mod1)


############################
### Multivariate Analysis 
############################

data(mtcars)

### model
mod2 <- lm(mpg ~ wt,data=mtcars)
summary(mod2)
pred2 <- predict(mod2)

plot(mtcars$mpg ~ mtcars$wt)
abline(reg=mod2, col="red")

plot(pred2 ~ mtcars$mpg)

summary(mod2)

######

### model with two variables
mod3 <- lm(mpg ~ wt + cyl,data=mtcars)
summary(mod3)
  
Table2(mod3)

### model with three variables
mod4 <- lm(mpg ~ wt + cyl + hp,data=mtcars)
summary(mod4)

Table2(mod4)

### multivariable model
mod5 <- lm(mpg ~ . ,data=mtcars)
summary(mod5)

Table2(mod5)


### Colinearity test
library(car)
vif(mod5)

### Plot all vs all
pairs(mtcars)

mod5 <- lm(mpg ~ drat +  vs + 
             am  + carb ,data=mtcars)
summary(mod5)
vif(mod5)

step(mod5)

mod5 <- lm(formula = mpg ~ wt + qsec + factor(am), data = mtcars)
summary(mod5)
vif(mod5)

mechkar::Table2(mod5)
mechkar::Table2.forestplot(mod5)

######################


############################################
##   Logistic Regression
############################################

titanic <- TitanicSurvival
summary(titanic)

titanic <- titanic %>% filter(is.na(age)==FALSE)

#titanic$age <- ifelse(is.na(titanic$age)==TRUE,30,titanic$age)

### logistic regression model

mod6 <- glm(survived ~ age, data=titanic, family = "binomial")
summary(mod6)

pred6 <- predict(mod6,type="response")

hist(pred6)

summary(pred6)

table(surv=titanic$survived, pred=ifelse(pred6 >= 0.5,1,0))
table(surv=titanic$survived, pred=ifelse(pred6 >= 0.4,1,0))



########

mod7 <- glm(survived ~ age + sex, data=titanic, family = "binomial")
summary(mod7)

pred7 <- predict(mod7,type="response")

hist(pred7)

summary(pred7)

table(surv=titanic$survived, pred=ifelse(pred7 >= 0.5,1,0))

########

mod8 <- glm(survived ~ age + sex + passengerClass, data=titanic, family = "binomial")
summary(mod8)

pred8 <- predict(mod8,type="response")
#pred8 <- predict(mod8)


hist(pred8)

summary(pred8)

table(surv=titanic$survived, pred=ifelse(pred8 >= 0.5,1,0))

Table2(mod8)

Table2.forestplot(mod8)


############################################
## Poisson Regression
############################################

df <- warpbreaks

head(df)

summary(df)
table(df$breaks)
boxplot(df$breaks)
hist(df$breaks)

mean(df$breaks)
var(df$breaks)

mod9 <- glm(breaks ~ ., data=df, family = "poisson")
summary(mod9)

pred9 <- predict(mod9,type="response")
hist(pred9)

plot(df$breaks ~ pred9)

Table2(mod9)

## NB model
mod9a <- MASS::glm.nb(breaks ~ ., data=df)
pred9a <- predict(mod9a,type="response")
hist(pred9a)



set.seed(10)
runif(10,0,100)

set.seed(5)
runif(10,0,100)


library(pROC)

mod1 <- glm(death ~., data=df)

pred1 <- predict(mod1, newdata=df, type="response")

auc(df$death,pred1)


