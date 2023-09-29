#install and import libraries
library(sas7bdat)
library(psych)

#Set working directory
setwd("C:\\Users\\acrot\\Downloads")

#Import data
lbw<- read.csv("lbw-1.csv")
write.table(lbw, file = "lbw.csv", sep = ",", qmethod = "double")

#View structure of data
str(lbw)
head(lbw)

#Create Summary Statistic Table
describe(lbw)

#Create a scatter plot of gestage versus headcirc
plot(x = lbw$gestage, y = lbw$headcirc)
#Add line of best fit to scatter plot
abline(lm(lbw$headcirc ~ lbw$gestage))

#Use method of least squares to fit regression line
model <- lm(lbw$headcirc ~ lbw$gestage)

#View regression model summary
summary(model)

#Compute the 95% confidence interval for the coefficient of gestational age
confidence_interval <- confint(model)["lbw$gestage", 1, 1]

# Print the confidence interval
print(paste("95% Confidence Interval:", confidence_interval))

#Create a data subset where gestational age is 33 weeks
subset_data <- subset(lbw, lbw$gestage == 33)

#Calculate the mean head circumference for the subset of data
mean_headcirc <- mean(subset_data$headcirc)

#Construct the 95% confidence interval
confidence_interval <- t.test(subset_data$headcirc, conf.level = 0.95)$conf.int

#Print the estimated mean head circumference and the confidence interval
print(mean_headcirc)
print(confidence_interval)

# Create new data frame with the desired gestational age value
newdatahc <- data.frame(gestage = 33)

# Generate predictions and prediction interval
prediction <- predict(model, newdata = newdatahc)

#Construct the 95% prediction interval
prediction_interval <- predict(model, newdata = newdatahc, interval = "prediction")

#Print the values
print(prediction)
print(prediction_interval)

#Perform a t-test
t.test(lbw$headcirc, lbw$gestage)