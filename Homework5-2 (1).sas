libname ADS534 '/home/u63483466/ADS534/Data';
	data work.cigarette;
	set ADS534.cigarette;
run;

/* Create boxplot to visualize distribution of points */
ods output sgplot = boxplot_data;
proc sgplot data = cigarette;
    vbox sales;
run;

/* View summary of boxplot descriptive statistics */
proc print data = boxplot_data;

/* Create new dataset with outliers removed */
data cigarette_no_out;
    set cigarette;
    if sales >= 155.55 then delete;
    if sales <= 73.55 then delete;
run;

/* Model selection with adjusted R^2 */
proc reg data = cigarette_no_out;
	model sales = age hs income black female price / aic bic;
run;

/* Perform a stepwise regression */
proc reg data = cigarette_no_out;
	model sales = age hs income black female price / 
	selection = adjrsq 
	slentry = 0.05 
	slstay = 0.05;
run;

/* Model selection using AIC */
proc reg data = cigarette_no_out outest = var_select_aic;
	model sales = age hs income black female price / selection = adjrsq aic;
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

/* Perform a backward selection using variables specified from model selection */
proc reg data = cigarette_no_out;
	model sales = income female price / 
	selection = backward;
run;

/* Perform a forward selection */
proc reg data = cigarette_no_out;
	model sales = age hs income black female price
	/ selection = forward 
	slentry=0.10;
run;

/* Perform a backward selection */
proc reg data = cigarette_no_out;
	model sales = age hs income black female price
	/ selection = backward 
	slstay = 0.10;
run;

/* Perform a stepwise selection */
proc reg data = cigarette_no_out;
	model sales = age hs income black female price
	/ selection = stepwise
	slentry = 0.10
	slstay = 0.10;
run;