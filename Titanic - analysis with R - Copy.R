############################################################################
###### Titanic - Analyzing the titanic data
############################################################################
library(dplyr)
library(ggplot2)

### Import the titanic dataset
path <-  [[[[ put here the path were your file is stored ]]]]

titanic <- read.csv(paste0(path,"/titanic.csv"))
head(titanic)

View(Titanic)

##################################################
### Number of pasangers and how many survived (n, %)
##################################################


###################################################
#### Missing values
## How many missing values are in the dataset?
## We can use summary to see the ammount of NA's on each variable
###################################################

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



## Age distribution and survival
## Plot the Age frequencies of the passangers. (use an histogram)




############################################
### Create a new variable that will divide the passangers in four age categories:
# Babies: 0-5
# Children: 6-12 years old
# Young: 13-17 years old
# Adult: 18-59 years old
# Older: 60+ years old
### How many (number and percent) survived on each age group?
############################################




# Age-Gender Survival
# Where there differences on survival by age group and gender?




#####################################
## Passenger Class and Survival
## Was there any difference in the survival among passangers by their ticket class (Pclass) ?
#####################################





######################################
## Traveling alone vs with family
## Who survived more, individuals that traveled alone or those who traveled with their families?
######################################


#######################################
## Embarking port and survival
## Was there any difference in survival related to the embarking port?
#######################################




#######################################
## Paid fair and survival
## What was the fare range paid by the passangers?
#######################################





#######################################
## How many individuals didn't paid for their ticket?
#######################################




########################################
## Does this affected their survival?
########################################




#########################################
## Where there differences in fare rates among the same ticket classes?
## If the answer was yes, does those differences affected the survival of individuals?
#########################################





###########################################
## The title passanger had and survival
## Which were the five most common titles passanger had? (Sir, Mr, Mrs, etc)?
## For this part we will take the 'Name' column and will split all the words in the name 
##   by the white space.Then we will join all the words and calculate the frequency of 
##  appearance of each world in descending order. We will take the five most common words 
##  (must be titles), and with them we will create a new column. Then we will procede as 
##  we did in the other analyses.
############################################

words = 

## we can use the :punct: opperand from the re (regular expression) package:

words = gsub('[[:punct:] ]+',' ',words)
print(words)

## or we can use the function removePunctuation from the tm package 
# install.packages("tm")
library(tm)
words<-removePunctuation(words)
print(words)

## now we split the words into a vector.
## strsplit generates a list with one element that is a vector of strings
## we are only interested on the vector, so we get it adding the [[1]]

wordlist = strsplit(words," ")[[1]]
class(wordlist)
length(wordlist)
wordlist
wordcnt <- data.frame(table(wordlist))

wordcnt %>% arrange(desc(Freq)) %>% top_n(15)

## We have shown here that the most common titles were Mr (521), Miss (182), Mrs (129) 
## and Master (40). This totals 872 out of 891 passengers (97.9%).
## Now we will create a new variable with those titles and check for differences on 
## survival among them.




