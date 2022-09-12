#########
# Part A
#########

a <- 10:20
# b <- seq("d", "m") --doesn't work
# b <- "d":"m" --doesn't work
b <- letters[4:13]
f <- c(0, 1, 0)
f2 <- append(f, c(1, 1, 1, 0, 0, 0, 0, 0))
f2f <- factor(f2, levels = c(0, 1), labels = c("YES", "NO"))
f2f
objects(pattern = "NO")

########
#Part B
########

m1 <- matrix(c(seq(1:24)), nrow = 3, ncol = 8, byrow = TRUE)
m2 <- matrix(c(seq(1:10)), nrow = 2, ncol = 5, byrow = FALSE)
m2
sum(m1)
colSums(m1)
mean(m1)
rowMeans(m1)
m1
t(m1)
m1 %*% t(m1)
m1

a1 <- array(1:768, c(16, 16, 3))
a1

########
#Part C
########

ml1 <- list
  (
    a=list(Rank=1, Peak=1, Title="Avatar", Worldwide_gross=2787965087, Year=2009),
    b=list(Rank=2, Peak=1, Title="Titanic", Worldwide_gross=2187463944, Year=1997),
    c=list(Rank=3, Peak=3, Title="Star Wars: The Force Awakens", Worldwide_gross=2068223624, Year=2015),
    d=list(Rank=4, Peak=4, Title="Avengers: Infinity War", Worldwide_gross=1844894638, Year=2018),
    e=list(Rank=5, Peak=3, Title="Jurassic World", Worldwide_gross=1671713208, Year=2015)
  )

ml1
names(ml1)
colnames(ml1)
row.names(ml1)
str(ml1)
summary(ml1)

ml1$b$Title

ml1[[2]][[3]]

########
#Part D
########

Name=c("Avi", "Ben", "Gad", "Dan", "Harel", "Vered", "Zelig")
age=c(31, 25, 28, 28, 33, 27, 32)
is.married=c(FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE)
city=c("Jerusalem", "Jerusalem", "Haifa", "Jerusalem", "Haifa", "Tel Aviv", "Tel Aviv")
has.pet=c(TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE)

mdf1 <- data.frame(Name, age, is.married, city, has.pet, stringsAsFactors = T)

mdf1$age[[3]]

sum(mdf1$is.married)

mean(mdf1$age)

sum(mdf1$has.pet[mdf1$city!="Jerusalem"])
sum(mdf1$has.pet[mdf1$city=="Jerusalem"])

mdf1 <- subset(mdf1, age<30)
mdf1 <- mdf1[-c(1, 2, 3),]


