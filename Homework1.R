#install and import libraries
#install.packages("psych")
#install.packages("ISwR")
library(psych)
library(ISwR)

#import data
data1 <- read.csv('C:\\Users\\acrot\\Downloads\\hospital.csv')

#view structure of data
str(data1)
head(data1)

#Create summary statistic table for expadm and los variables
describe(data1[ , c('EXPADM', 'LOS')])

#Create a scatter plot for expadm and los variables
plot(x = data1$LOS, y = data1$EXPADM)
#Add line of best fit to scatter plot
abline(lm(data1$EXPADM ~ data1$LOS))

#use method of least squares to fit regression line
model <- lm(data1$EXPADM ~ data1$LOS)

#view regression model summary
summary(model)

#Find 95% confidence interval for the slope
confint(model,level=0.95)

#import data
data2 <- read.csv('C:\\Users\\acrot\\Downloads\\lowbwt.csv')

#view structure of data
str(data2)
head(data2)

#Create a scatter plot for gestage and sbp variables
plot(x = data2$gestage, y = data2$sbp)
#Add line of best fit to scatter plot
abline(lm(data2$sbp ~ data2$gestage))

#use method of least squares to fit regression line
model2 <- lm(data2$sbp ~ data2$gestage)

#view regression model summary
summary(model2)

#Create a data subset where gestational age is 31 weeks
subset_data <- subset(data2, data2$gestage == 31)

#Calculate the mean systolic blood pressure for the subset of data
mean_systolic_bp <- mean(subset_data$sbp)

#Construct the 95% confidence interval
confidence_interval <- t.test(subset_data$sbp, conf.level = 0.95)$conf.int

#Print the estimated mean systolic blood pressure and the confidence interval
print(mean_systolic_bp)
print(confidence_interval)

# Create new data frame with the desired gestational age value
newdatabp2 <- data.frame(gestage = 31)

# Generate predictions and prediction interval
prediction <- predict(model2, newdata = newdatabp2)

#Construct the 95% prediction interval
prediction_interval <- predict(model2, newdata = newdatabp2, interval = "prediction")

#Print the values
print(prediction)
print(prediction_interval)