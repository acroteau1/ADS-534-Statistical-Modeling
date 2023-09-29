libname ADS534 '/home/u63483466/ADS534/Data';
	data work.satisfaction;
	set ADS534.satisfaction;
run;

/* Fit the linear regression model */
proc reg data = work.satisfaction;
   model Y = X1 X2 X3;
/* Calculate studentized residuals and output them */
	output out = studresid
      rstudent = stud_resid;  
run;

/* Draw a scatter plot of fitted values (x) vs studentized residuals (y) */
proc sgplot data = studresid;
	scatter x = Y y = stud_resid;
run;

/* Draw a normal Q-Q plot using studentized residuals */
proc univariate data = studresid noprint;
   qqplot stud_resid;
run;

/* Obtain the leverage values of each of the patients */
proc reg data = studresid;
	model Y = X1 X2 X3;
	plot H.*obs.;
	title "leverage points";
run;

/* Obtain Cook's Distance values */
proc reg data = studresid;
	model Y = X1 X2 X3;
	plot COOKD.*obs.;
	title "Cook's Distance";
	output out = lres 
	cookd = cookdistance 
	dffits = dffitsest 
	predicted = ypred 
	student = stut 
	residual = r 
	h = leverage 
	rstudent=sr;
run;

/* Filter the cases with the three largest absolute studentized residuals */
proc sort data = lres out = top3_resid;
   by descending stud_resid;
run;

data top3_influence;
   set top3_resid;
   if _N_ <=3;
run;

proc print data = top3_influence;
	var Y X1 X2 X3 stud_resid cookdistance dffitsest;
run;

libname ADS534 '/home/u63483466/ADS534/Data';
	data work.cigarette;
	set ADS534.cigarette;
run;

/* Model selection with adjusted R^2 */
proc reg data = cigarette;
	model sales = age hs income black female price / aic bic;
run;

/* Perform a stepwise regression */
proc reg data = cigarette;
	model sales = age hs income black female price / 
	selection = adjrsq 
	slentry = 0.05 
	slstay = 0.05;
run;

/* Model selection using AIC */
proc reg data = cigarette outest = var_select_aic;
	model sales = age hs income black female price / selection = adjrsq aic;
run;

/* Check the variable selection results to find the variable name for AIC */
proc contents data = var_select_aic;
run;

/* Sort the variable selection results by AIC (lowest to highest) */ 
proc sort data = var_select_aic;
	by _AIC_;
run;

/* print the results -- the first row is the model with lowest AIC */
proc print data = var_select_aic;
run;

/* Perform a backward selection using variables specified from model selection */
proc reg data = cigarette;
	model sales = age income price / 
	selection = backward;
run;

/* Use studentized residual plot to check outliers in Sales */
proc reg data = cigarette;
	model sales = age hs income black female price;
	plot rstudent.*predicted.;
	title "scatter plot of studentized residuals versus fitted values";
run;

/* Create boxplot to visualize distribution of points */
ods output sgplot = boxplot_data;
proc sgplot data = cigarette;
    vbox sales;
run;

/* View summary of boxplot descriptive statistics */
proc print data = boxplot_data;