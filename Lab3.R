#install and import necessary libraries
#install.packages("readr")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("stats")
library(readr) #For reading CSV files
library(dplyr)   #For data manipulation
library(tidyr)  #For removal of missing data
library(stats)    # For overall test, t-test

#Import data
hersdata <- read.csv("C:\\Users\\acrot\\Downloads\\hersdata-1.csv")

#Remove rows with missing data
hersdata <- hersdata %>% drop_na(LDL, BMI, AGE)

#View structure of the data
str(hersdata)
head(hersdata)

#Fit the multiple linear regression model
model <- lm(LDL ~ BMI + AGE, data = hersdata)

#Perform an overall test using ANOVA
overall_test <- anova(model)

#Display the results
print(overall_test)

#Perform the t-test
t_test <- t.test(hersdata$BMI, hersdata$LDL, alternative = "two.sided", paired = FALSE)

#Print the result
print(t_test)

#Create a reduced model
reduced <- lm(LDL ~ AGE, data = hersdata)

#Create a full model
full <- lm(LDL ~ BMI + AGE, data = hersdata)

#Perform a partial F-test using ANOVA
partial_F <- anova(reduced,full)

#Print the result
print(partial_F)

#Create a reduced model for groups of predictors
reduced_groups <- lm(LDL ~ STATINS + AGE + SMOKING + DRINKANY + NONWHITE, data = hersdata)

#Create a full model for groups of predictors
full_groups <- lm(LDL ~ STATINS + BMI + STATINS:BMI + AGE + SMOKING + DRINKANY + NONWHITE, data = hersdata)

#Perform a partial F-test using ANOVA
partial_F_groups <- anova(reduced_groups,full_groups)

#Print the result
print(partial_F_groups)