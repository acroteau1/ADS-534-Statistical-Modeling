#install and import necessary libraries
#install.packages("readr")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("stats")
library(readr) #For reading CSV files
library(dplyr)   #For data manipulation
library(stats)    # For overall test, t-test

#Import data
pollution <- read.csv("C:\\Users\\acrot\\Downloads\\pollution.csv")
patsat <- read.csv("C:\\Users\\acrot\\Downloads\\patsat.csv")

#View structure of the data
str(pollution)
head(pollution)

#Create the Main Effect model
model_main <- lm(nn ~ caps + so2, data = pollution)
summary(model_main)

#Create the Interaction model
model_interaction <- lm(nn ~ caps + so2 + (caps*so2), data = pollution)
summary(model_interaction)

#Create the CAPs-only model
model_caps <- lm(nn ~ caps, data = pollution)
summary(model_caps)

#Test the correlation between Nn and CAPs
cor_nncaps <- cor.test(pollution$nn, pollution$caps)

#Test the correlation between Nn and SO2
cor_nnso2 <- cor.test(pollution$nn, pollution$so2)

#Test the correlation between CAPs and SO2
cor_capsso2 <- cor.test(pollution$caps, pollution$so2)

#Print the correlation test results
print(cor_nncaps)
print(cor_nnso2)
print(cor_capsso2)

#Fit the regression model
model_patsat <- lm(Y ~ X1 + X2 + X3, data = patsat)
summary(model_patsat)

#Get 95% CI estimates for each parameter
confint(model_patsat, level = 0.95)

#Get 95% CI estimates for specific paramaters
predict(model_patsat,data.frame(X1 = 35, X2 = 45, X3 = 2.2), interval = "confidence")

