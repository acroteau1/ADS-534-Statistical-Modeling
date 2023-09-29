libname ADS534 '/home/u63483466/ADS534/Data';
	data work.hersdata;
	set ADS534.hersdata;
run;

/* Take a look at the variables and number of observations in the data set */
/* 2763 observations of 36 variables */
proc contents data = ADS534.hersdata;
run;

/* Create the variable for the interaction between BMI and statins */
data hersdata_2;
	set ADS534.hersdata;
	bmi_statins = bmi * statins;
run;

/* Model selection using adjusted R2 */
proc reg data = hersdata_2;
	model ldl = bmi age statins smoking drinkany nonwhite diabetes physact bmi_statins / selection = adjrsq; 
run;

/* Model selection using AIC */
proc reg data = hersdata_2 outest = var_select_aic;
	model ldl = bmi age statins smoking drinkany nonwhite diabetes physact bmi_statins / selection = adjrsq aic;
run;

/* Check the variable selection results to find the variable name for AIC */
proc contents data = var_select_aic;
run;

/* Sort the variable selection results by AIC (lowest to highest) */
proc sort data = var_select_aic;
	by _AIC_;
run;

/* Print the results -- the first row is the model with lowest AIC */
proc print data = var_select_aic;
run;

/* Perform forward selection using p < 0.05 as the entry criterion */
proc reg data = hersdata_2;
	model ldl = bmi age statins smoking drinkany nonwhite diabetes physact 
	bmi_statins / selection = forward slentry = 0.05;
run;

/* Perform backward selection using p < 0.05 as the staying criterion */
proc reg data = hersdata_2;
	model ldl = bmi age statins smoking drinkany nonwhite diabetes physact 
	bmi_statins / selection = backward slstay = 0.05;
run;

/* Perform stepwise selection using p-value < 0.05 as the entry criterion 
and p-value < 0.05 as the staying criterion */
proc reg data = hersdata_2;
	model ldl = bmi age statins smoking drinkany nonwhite diabetes physact 
	bmi_statins / selection = stepwise 
	slentry = 0.05 slstay = 0.05;
run;