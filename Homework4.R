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
patsat <- read.csv("C:\\Users\\acrot\\Downloads\\patsat.csv")

#View structure of the data
str(patsat)
head(patsat)

#Fit the regression model
model_patsat <- lm(Y ~ X1 + X2 + X3, data = patsat)
summary(model_patsat)

#Create the full model
model_full <- lm(Y ~ X1 + X2 + X3, data = patsat)
summary(model_full)

#Create the reduced model
model_reduced <- lm(Y ~ X1 + X2, data = patsat)
summary(model_reduced)

#Perform an ANOVA to compared full model and reduced model
anova_x3 <- anova(model_full, model_reduced)
print(anova_x3)

#Create further reduced model
model_onlyx1 <- lm(Y ~ X1, data = patsat)
summary(model_onlyx1)

#Perform an ANOVA to compared full model and further reduced model
anova_further <- anova(model_full, model_onlyx1)
print(anova_further)

