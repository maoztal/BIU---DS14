library(dplyr)
library(ggplot2)
library(car)
library(psych)
library(Hmisc)
library(rcompanion)
library(corrplot)
library(survival)
library(ggfortify)

###########################################
### Home Exercise - Models
###########################################

# import csv dataset

library(readr)

heart_failure <-
  read_csv("heart_failure_clinical_records_dataset.csv",
    col_types = cols(
      anaemia = col_factor(levels = c("0","1")),
      diabetes = col_factor(levels = c("0","1")),
      high_blood_pressure = col_factor(levels = c("0","1")),
      sex = col_factor(levels = c("0","1")),
      smoking = col_factor(levels = c("0","1")),
      DEATH_EVENT = col_factor(levels = c("0","1"))
    )
  )


###########################
# 1. Create a linear regression for the “time” variable. Exclude the variable “DEATH_EVENT” from the analysis
###########################

time_mod <- lm(time ~ . -DEATH_EVENT, data = heart_failure)
summary(time_mod)

# Extra: prediction model for time variable
# -------------------------------------------------
# time_pred <- predict(time_mod, type = "response")
# time_plot <- plot(heart_failure$time ~ time_pred)
# 
# Try to present the different regression lines
# -------------------------------------------------
# for (i in names(heart_failure)) {
#     for (n in names(time_mod$coefficients[2:length(time_mod$coefficients)])) {
#         if (i != "time" & i != "DEATH_EVENT") {
#           abline(coef = c(time_mod$coefficients[[1]], time_mod$coefficients[[n]]), 
#                  col=abs(time_mod$coefficients[[n]]))
#           
#         }
#     }
# }

#####
# a.	Check if there is any correlation between the independent variables (X)
#####

# General observation on the data
summary(heart_failure)
pairs.panels(heart_failure)

# Numeric vs. numeric variable correlations - Spearman
cor_mod_num <- NULL

for (i in names(heart_failure)) {
  if (is.numeric(heart_failure[[i]])) {
    for (n in names(heart_failure)) {
      if (is.numeric(heart_failure[[n]])) {
        if (n != i) {
          cor1 = cor.test(heart_failure[[n]], heart_failure[[i]], method="spearman")
          cor_mod_num = rbind(cor_mod_num, data.frame(var1=i, var2=n, cor=round(as.numeric(cor1$estimate), 2), 
                                                      p_val=round(as.numeric(cor1$p.val), 2)))
        }
      }
    }
  }   
}

# Numeric vs. binary variable correlations - Logistic model
cor_mod_numbin <- NULL

for (i in names(heart_failure)) {
  if (is.numeric(heart_failure[[i]])) {
    for (n in names(heart_failure)) {
      if (is.factor(heart_failure[[n]])) {
        if (n != i) {
          cor2 = glm(heart_failure[[n]] ~ heart_failure[[i]], family = "binomial")
          cor_mod_numbin = rbind(cor_mod_numbin, 
                                 data.frame(var1=i, var2=n, cor=round(as.numeric(cor2$coefficients[[2]]), 2),
                                            OR=exp(round(as.numeric(cor2$coefficients[[2]]), 2))))
        }
      }
    }
  }   
}

# Binary vs. binary variable correlations - Cramer's V + Chi-Square
cor_mod_binbin <- NULL

for (i in names(heart_failure)) {
  if (is.factor(heart_failure[[i]])) {
    for (n in names(heart_failure)) {
      if (is.factor(heart_failure[[n]])) {
        if (n != i) {
          cor3 = cramerV(as.vector(heart_failure[[i]]), as.vector(heart_failure[[n]]))
          cor4 = chisq.test(as.vector(heart_failure[[i]]), as.vector(heart_failure[[n]]))
          cor_mod_binbin = rbind(cor_mod_binbin, 
                                 data.frame(var1=i, var2=n, cor=round(as.numeric(cor3), 2),
                                            p_val=round(as.numeric(cor4$p.value), 2)))
        }
      }
    }
  }   
}


# heart_failure2 <- read_csv("heart_failure_clinical_records_dataset.csv")
# cor_table <- rcorr(as.matrix(heart_failure2))
# cor_table_f <- cor_table %>%
#   filter_all(any_vars((. >= 0.3 & . < 1) | (. <= -0.3 & . > -1)))
# 
# flattenCorrMatrix <- function(cormat, pmat) {
#   ut <- upper.tri(cormat)
#   data.frame(
#     row = rownames(cormat)[row(cormat)[ut]],
#     column = rownames(cormat)[col(cormat)[ut]],
#     cor  =(cormat)[ut],
#     p = pmat[ut]
#   )
# }
# 
# cor_table <- flattenCorrMatrix(round(cor_table$r, 2), round(cor_table$P, 2))
# cor_table_t_f <- filter(cor_table_t, abs(cor_table_t$cor) >= 0.3 | cor_table_t$p <= 0.05)

#####
# b.	Check if the betas for the model are inflated (use the vif function)
#####

vif(time_mod)
step(time_mod)



#####
# c.	Recreate the linear regression excluding problematic variables if they exist
#####
time_mod2 <- lm(time ~ age + anaemia  + high_blood_pressure + serum_creatinine, data = heart_failure)
summary(time_mod2)

# Extra: prediction model for time variable
# -------------------------------------------------
# time_pred2 <- predict(time_mod2, type = "response")
# time_plot2 <- plot(heart_failure$time ~ time_pred2)
# 
# Try to present the different regression lines
# -------------------------------------------------
# for (i in names(heart_failure)) {
#     for (n in names(time_mod2$coefficients[2:length(time_mod2$coefficients)])) {
#         if (i != "time" & i != "DEATH_EVENT") {
#           abline(coef = c(time_mod2$coefficients[[1]], time_mod2$coefficients[[n]]),
#                  col=abs(time_mod2$coefficients[[n]]))
# 
#         }
#     }
# }

#####
# d.	Calculate the exp of the estimates and based on the p-value determine which values increase the risk 
#     (relative risk).
#####

rr_tbl <- data.frame(RR= round(exp(time_mod$coefficients[2:length(time_mod$coefficients)]),3))

###########################
### 2. Create a logistic regression model for the “DEATH_EVENT” variable. 
###    Exclude the “time” variable from the analysis
###########################

death_mod <- glm(DEATH_EVENT ~ . -time, data = heart_failure, family = "binomial")
summary(death_mod)

###
# a.	Check if the betas for the model are inflated (use the vif function)
###

vif(death_mod)
step(death_mod)

###
#b.	Recreate the linear regression excluding problematic variables if they exist.
###

death_mod2 <- glm(DEATH_EVENT ~ age + anaemia + creatinine_phosphokinase + ejection_fraction + high_blood_pressure + 
              serum_creatinine + serum_sodium, data = heart_failure, family = "binomial")
summary(death_mod2)

###
#c.	Calculate the exp of the estimates and based on the p-value determine which values 
#   increase the probability of death(Odds ratios).
###

exp_tbl2 <- data.frame(Exp= round(exp(mod2$coefficients[2:length(lm1$coefficients)]),3))

#######################
###3.    Calculate the Kaplan-Meyer curve for the survival time, using the “time” and “DEATH_EVENT” variables.
#######################

#import csv dataset w/o factorizing the variables 

heart_failure2 <- read_csv("heart_failure_clinical_records_dataset.csv")

surv1 <- survfit(Surv(time, DEATH_EVENT) ~ 1, data = heart_failure2)
summary(surv1)
plot(surv1)

###
# a.	Check if there is any difference between males and females
###
surv2_sex <- survdiff(Surv(time, DEATH_EVENT) ~ factor(sex) , data = heart_failure2)
surv2_sex2 <- survfit(Surv(time, DEATH_EVENT) ~ sex, data = heart_failure2)
summary(surv2_sex2)
autoplot(surv2_sex2)

###
# b.	Check if there is any difference between smokers and non-smokers
###
surv_smoke <- survfit(Surv(time, DEATH_EVENT) ~ smoking, data = heart_failure2)
autoplot(surv_smoke)
surv_smoke2 <- survdiff(Surv(time, DEATH_EVENT) ~ smoking, data = heart_failure2)

###
# c.	Check if there is any difference between diabetics and non-diabetics
###
surv_diab <- survfit(Surv(time, DEATH_EVENT) ~ diabetes, data = heart_failure2)
autoplot(surv_diab)
surv_diab2 <- survdiff(Surv(time, DEATH_EVENT) ~ diabetes, data = heart_failure2)

#############################
### 4.   Create a Cox regression using the “time” and “DEATH_EVENT” as the outcome and the other variables as the 
###      independent predictors (X).
#############################

cor_mod_cox <- NULL

for (i in names(heart_failure2)) {
        if (i != "time" & i != "DEATH_EVENT") {
          cor5 = coxph(Surv(time, DEATH_EVENT) ~ heart_failure2[[i]], data = heart_failure2)
          cor_mod_cox = rbind(cor_mod_cox, 
                              data.frame(DeathEvent_vs_Time=i, 
                                         exp_coef=round(exp(as.numeric(cor5$coefficients)), 3)))
  }
}

###
# a.	Check if the betas for the model are inflated (use the vif function)
###
# in order to evaluate inflation, a comparison between Uni-variable (the above loop) 
# and Multi-variable analysis was done to detect no significant inflation.

surv_cox <- coxph(Surv(time, DEATH_EVENT) ~ ., data = heart_failure2)
summary(surv_cox)
vif_cox <- vif(surv_cox)

###
# b.	Recreate the linear regression excluding problematic variables if they exist.
###

sm <- summary(surv_cox)
p_values <- summary(surv_cox)$coefficients[,5]
sm <- data.frame(sm$conf.int)
sm$exp..coef. <- NULL
sm$pvalue <- round(p_values, 3) 

###
# c.	Calculate the exp of the estimates and based on the p-value determine which values 
#     increase the hazard of death(Hazard ratios).
###

library(forestplot)

forestplot(row.names(sm),
           sm$`exp.coef.`,
           sm$`lower..95`,
           sm$`upper..95`,
           zero = 1,
           cex = 2,
           #lineheight = "auto",
           xlab = "Hazard ratios"
)






