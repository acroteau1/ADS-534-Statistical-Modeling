#Install and import necessary libraries
#install.packages("readr")
#install.packages("dplyr")
#install.packages("stats")
library(readr)   # For reading CSV file
library(dplyr)   # For data manipulation
library(stats)   # For linear regression

#Import data
cf2 <- read.csv("C:\\Users\\acrot\\Downloads\\cf2.csv")

#View structure of the data
str(cf2)
head(cf2)

#Convert FEV2 to a factor variable
cf2$FEV2 <- factor(cf2$FEV2)

#Create binary indicator variables
predictors <- model.matrix(~ FEV2, data = cf2)

#Convert predictors matrix to data frame
predictors <- as.data.frame(predictors)

#Prepare the response variable
response <- cf2$PEmax

#Fit the multiple linear regression model
model <- lm(response ~ ., data = predictors)

#View the summary of the regression model
summary(model)

#Calculate Pearson correlation coefficient
correlation <- cor(cf2$Age, cf2$PEmax)

#Print the Pearson correlation coefficient
print(correlation)

#Perform a hypothesis test
cor_test <- cor.test(cf2$Age, cf2$PEmax)

#Print the hypothesis test results
print(cor_test)

#Fit the linear regression model
model2 <- lm(PEmax ~ FEV2, data = cf2)

#Perform ANOVA
anova_result <- anova(model2)

#Print the ANOVA table
print(anova_result)

#Perform one-way ANOVA
anova_1 <- aov(Age ~ FEV2, data = cf2)

#Print the ANOVA table
summary(anova_1)

#Fit the simple linear regression model for Age alone
model2 <- lm(PEmax ~ Age, data = cf2)

#Print the summary of the regression model
summary(model2)

#Fit the multiple linear regression model for Age and FEV2
model3 <- lm(PEmax ~ Age + FEV2, data = cf2)

#Print the summary of the regression model
summary(model3)

#Convert 'FEV2' to a factor variable
cf2$FEV2 <- as.factor(cf2$FEV2)

#Fit the multiple linear regression model for Age and FEV2
model4 <- lm(PEmax ~ Age + FEV2, data = cf2)

#Create a new data frame with Age 16 and FEV2 levels
new_df <- data.frame(Age = rep(16, 3), FEV2 = factor(c(1, 2, 3), levels = levels(cf2$FEV2)))

#Predict the PEmax scores using the model
predictions <- predict(model4, newdata = new_df)

#Print the predictions
print(predictions)

#Fit the model with PEmax, Age, FEV2, and Age and FEV2 interactions
model5 <- lm(PEmax ~ Age + FEV2 + Age:FEV2, data = cf2)

#Print the summary of the model
summary(model5)

#Predict the PEmax scores using the model
predictions2 <- predict(model5, newdata = new_df)

#Print the predictions
print(predictions2)

