libname ADS534 '/home/u63483466/ADS534/Data';
	data work.hersdata;
	set ADS534.hersdata;
run;

/* Fit the linear regression model */
PROC REG DATA=work.hersdata;
   MODEL LDL = BMI Age; 
   TEST BMI;
RUN;

/* Create interaction terms */
data hersdata_2;
	set ADS534.hersdata;
	BMI_STATINS = BMI * STATINS;
run;

/* Fit the reduced model */
/* Save the residuals in a dataset using output */
PROC REG DATA = hersdata_2;
   MODEL LDL = STATINS AGE SMOKING DRINKANY NONWHITE;
   OUTPUT OUT = ReducedModelResiduals R=residual;
   test BMI BMI_STATINS;
RUN;

/* Fit the full model*/
/* Save the residuals in a dataset using output */
PROC REG DATA = hersdata_2;
   MODEL LDL = STATINS BMI BMI_STATINS AGE SMOKING DRINKANY NONWHITE;
   OUTPUT OUT=FullModelResiduals R=residual;
   test BMI BMI_STATINS;
RUN;

/* ANOVA */
PROC ANOVA DATA = ReducedModelResiduals;
	class BMI;
	model LDL = BMI_STATINS;
RUN;

PROC ANOVA DATA = FullModelResiduals;
	class BMI;
	model LDL = BMI BMI_STATINS;
RUN;