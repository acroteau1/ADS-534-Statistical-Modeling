libname ADS534 '/home/u63483466/ADS534/Data';
	data work.bladder;
	set ADS534.bladder;
run;

/* Estimate the survival function in each treatment group using the Kaplan-Meier estimator */
proc lifetest data = work.bladder plot = s;
	time time*censor(0);
run;

/* Test the null hypothesis with a log-rank test */
proc lifetest data = work.bladder plot = s;
	time time*censor(0);
	strata group;
run;

/* Fit the Cox proportional hazards model */
proc phreg data = work.bladder;
	class number (ref="1");
	model time*censor(0) = group number;
	hazardratio "Hazard Ratio of Group Type" group / units = 1;
run;