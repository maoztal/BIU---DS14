head(mtcars)

# correlation of two normally distributed variables 
cor.test(x = mtcars$mpg, y = mtcars$wt, method = "pearson")

# comparison of two normally distributed variables 
t.test(x = mtcars$mpg, y = mtcars$wt, alternative = "greater", paired = FALSE)
t.test(mtcars$mpg ~ factor(mtcars$am))

library(ggplot2)

ggplot(data = mtcars) + 
  geom_density(aes(x = mpg*1.5), alpha=0.3, colors="red") + 
  geom_density(aes(x = mpg), alpha=0.3)

library(dplyr)
mtcars <- as_tibble(mtcars)

across(.col(mtcars), shapiro.test(.col(mtcars)))
shapiro.test(x = mtcars$carb)

j <- list(NULL)
for (i in colnames(mtcars)){
  j <- shapiro.test(mtcars[[i]])
  j_n <- cbind(j)
}
j

# correlations
mod <- glm(mtcars$mpg ~ mtcars$am, family = "binomial")
summary(mod)
