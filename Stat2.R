install.packages("e1071")
library(e1071)

mtcars <- data.frame(mtcars)
nbmod <- naiveBayes(am ~ cyl + hp + wt, data = mtcars)
pred <- predict(nbmod, mtcars)
pred

library(ggplot2)
hist(am ~ pred)

# Binomial distribution 
x <- seq(0:50)
y <- dbinom(x,size = 50, prob = 0.5)
plot(x, y)

# Poisson distribution 
x <- seq(1:50)
y <- dpois(x, lambda = 10)
plot(x, y)

# Normal distribution 
x <- rnorm(n = 10000, mean = 20, sd = 3)
hist(x, breaks = 30)

# t distribution 
x <- rt(n = 200, df = 199)
hist(x)

# Gamma distributions:
  # Chi-Square (power 2 of normal distribution )
x <- seq(0, 100, by=0.5)
y <- dchisq(x, df = 10)
plot(x, y, type = "l", col="red")

# Exponential (as poisson but events between times)
x <- seq(0, 1, 0.01)
y <- dexp(x, rate = 10)
plot(x, y, type = "l", col="red")

# in order to project dice of 6 probabilities distribution
hist(runif(n = 1000, min = 0, max = 1))






