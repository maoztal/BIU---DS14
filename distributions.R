# Binomial distribution
x <- seq(0,100)
y <- dbinom(x,size = 100,prob = 0.2)
plot(x,y)

table(rbinom(1000,size=1,prob=0.3))
mean(rbinom(1000,size=1,prob=0.65))


# Poisson distribution
x <- seq(1:20)
y <- dpois(x, lambda = 10)
plot(x,y)

barplot(table(rpois(1000,2)))


# Normal distribution
x <- rnorm(10000, mean=5, sd=1.5)
hist(x,breaks = 30)

# t distribution
x <- rt(100000, df=10e10)
hist(x)

# Chi-square distribution
x <- seq(0,20,by=0.5)
y <- dchisq(x,df=4)
plot(x,y,type="l")

hist(rchisq(1000,df=10))

# Exponential distribution
x <- seq(0,20,by=0.1)
y <- dexp(x,rate=0.2)
plot(x,y,type="l")

hist(rexp(1000,rate=0.5),type="l")

hist(runif(1000,min = 0, max=0.16))
