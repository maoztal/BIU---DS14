############################################################################
###### Titanic - Analyzing the titanic data
############################################################################
library(dplyr)
library(ggplot2)

### Import the titanic dataset
path <- ("~/BIU_DS14/Jupyter")

titanic <- read.csv(paste0(path,"/titanic.csv"))
titanic <- as_tibble(titanic)
head(titanic)

View(Titanic)

##################################################
### Number of passengers and how many survived (n, %)
##################################################
titanic %>% nrow() #Number of passengers
#nrow(titanic) #2nd option

sum(titanic$Survived)/nrow(titanic)*100 #Survivors %
#titanic %>%
#  summarize("%Survivors" = sum(Survived)/n()*100) #2nd option

###################################################
#### Missing values
## How many missing values are in the dataset?
## We can use summary to see the amount of NA's on each variable
###################################################

colSums(is.na(titanic))
#titanic %>% summarise_all(~ sum(is.na(.))) #2nd option
#summary(titanic) #3rd option

titanic$Cabin <- factor(ifelse(titanic$Cabin == "", NA, titanic$Cabin))

res <- NULL
for (i in names(titanic)) {
  res <- rbind(res, cbind(i, sum(is.na(titanic[[i]]))))
}
res

res <- NULL
for (i in names(titanic)) {
  res <- rbind(res, cbind(i, length(unique(titanic[[i]]))))
}
res

summary(titanic)
table(titanic$Sex)

##############################################
## Gender distribution and survival
## How distribute the survivors by gender?
##############################################

titanic %>%
  filter(!is.na(Survived)) %>%
  group_by(Sex) %>%
  summarize(
            Sex_count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            Sur_mean = mean(Survived, na.rm=T)
            )


## Age distribution and survival
## Plot the Age frequencies of the passangers. (use an histogram)

hist(titanic$Age, main = "Titanic Age Distribution", xlab = "Ages", ylab = "Frequencies")

#ggplot(titanic, aes(Age)) + 
#  geom_histogram(aes(alpha=0.1), bins = 8, na.rm = T) #2nd option


############################################
### Create a new variable that will divide the passangers in four age categories:
# Babies: 0-5
# Children: 6-12 years old
# Young: 13-17 years old
# Adult: 18-59 years old
# Older: 60+ years old
### How many (number and percent) survived on each age group?
############################################

titanic %>% 
  mutate(Age_group = ifelse(Age <= 5, "Babies", 
                     ifelse(Age > 5 & Age <= 12, "Children",
                     ifelse(Age > 12 & Age <= 17, "Young",
                     ifelse(Age > 17 & Age <= 59, "Adult",
                     ifelse(Age > 59, "older", "NA")))))) %>%
  group_by(Age_group) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))

# Age-Gender Survival
# Where there differences on survival by age group and gender?

titanic %>% 
  mutate(Age_group = ifelse(Age <= 5, "Babies", 
                            ifelse(Age > 5 & Age <= 12, "Children",
                                   ifelse(Age > 12 & Age <= 17, "Young",
                                          ifelse(Age > 17 & Age <= 59, "Adult",
                                                 ifelse(Age > 59, "older", "NA")))))) %>%
  group_by(Age_group, Sex) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            Sur_mean = mean(Survived, na.rm=T))


#####################################
## Passenger Class and Survival
## Was there any difference in the survival among passangers by their ticket class (Pclass) ?
#####################################

titanic %>% 
  group_by(Pclass) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))

######################################
## Traveling alone vs with family
## Who survived more, individuals that traveled alone or those who traveled with their families?
######################################

titanic %>% 
  mutate(Travel_group = ifelse(SibSp == 0 & Parch == 0, "Alone", "Group")) %>%
  group_by(Travel_group) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))

#######################################
## Embarking port and survival
## Was there any difference in survival related to the embarking port?
#######################################

titanic$Embarked <- factor(ifelse(titanic$Embarked == '', NA, titanic$Embarked))

titanic %>% 
  group_by(Embarked) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))



#######################################
## Paid fair and survival
## What was the fare range paid by the passangers?
#######################################

summary(titanic$Fare)


#######################################
## How many individuals didn't paid for their ticket?
#######################################

table(titanic$Fare)[["0"]]


########################################
## Does this affected their survival?
########################################

titanic %>%
  mutate(Payed = ifelse(Fare == 0, "no", "yes")) %>%
  group_by(Payed) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))


#########################################
## Where there differences in fare rates among the same ticket classes?
## If the answer was yes, does those differences affected the survival of individuals?
#########################################

titanic %>%
  group_by(Pclass) %>%
  summarize(Fare_IQR25 = quantile(Fare, probs=0.25),
            Fare_IQR75 = quantile(Fare, probs=0.75))

titanic %>%
  mutate(Fare_group = ifelse(Pclass==1 & Fare < 30.9, "1_Low",
                      ifelse(Pclass==1 & Fare > 93.5, "3_High",
                      ifelse(Pclass==2 & Fare < 13, "1_Low",
                      ifelse(Pclass==2 & Fare > 26, "3_High",
                      ifelse(Pclass==3 & Fare < 7.75, "1_Low",
                      ifelse(Pclass==3 & Fare > 15.5, "3_High", "2_Avg"))))))) %>%
  group_by(Pclass,Fare_group) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))



###########################################
## The title passenger had and survival
## Which were the five most common titles passenger had? (Sir, Mr, Mrs, etc)?
## For this part we will take the 'Name' column and will split all the words in the name 
##   by the white space.Then we will join all the words and calculate the frequency of 
##  appearance of each world in descending order. We will take the five most common words 
##  (must be titles), and with them we will create a new column. Then we will proceed as 
##  we did in the other analyses.
############################################

words = titanic$Name
words[head(10)]

## we can use the :punct: opperand from the re (regular expression) package:

words = gsub('[[:punct:] ]+',' ',words)
print(words)

## or we can use the function removePunctuation from the tm package 
install.packages("tm")
library(tm)
words<-removePunctuation(words)
print(words)

## now we split the words into a vector.
## strsplit generates a list with one element that is a vector of strings
## we are only interested on the vector, so we get it adding the [[1]]

wordlist = strsplit(words," ")
class(wordlist)
length(wordlist)
str(wordlist)
wordlist

unwordlist <- unlist(wordlist)

wordcnt <- data.frame(table(unwordlist))

wordcnt %>% arrange(desc(Freq)) %>% top_n(15)

## We have shown here that the most common titles were Mr (521), Miss (182), Mrs (129) 
## and Master (40). This totals 872 out of 891 passengers (97.9%).
## Now we will create a new variable with those titles and check for differences on 
## survival among them.

titanic %>% 
  mutate(Name_titel = ifelse(grepl('Mrs', Name), "Mrs", 
                      ifelse(grepl('Mr', Name), "Mr",
                      ifelse(grepl('Miss', Name), "Miss",
                      ifelse(grepl('Master', Name), "Master", "Other"))))) %>%
  group_by(Name_titel) %>%
  summarize(count = n(),
            Sur_sum = sum(Survived, na.rm=T),
            "%Sur" = mean(Survived, na.rm=T))
