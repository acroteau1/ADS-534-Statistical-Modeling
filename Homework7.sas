libname ADS534 '/home/u63483466/ADS534/Data';
	data work.lowbwt;
	set ADS534.lowbwt;
run;

/* Fit the logistic regression model */
proc logistic data = work.lowbwt;
   model grmhem(event = '1') = apgar5 / clparm=wald;
run;

/* CI based on Wald test */
proc logistic data = work.lowbwt;
   model grmhem(event = '1') = apgar5 / clparm=wald clodds = wald;
run;

/* Fit the logistic regression model with multiple predictors */
proc logistic data = work.lowbwt;
   model grmhem(event = '1') = apgar5 tox / clparm=wald clodds = wald;
run;

/*Likelihood ratio test */
proc genmod data = work.lowbwt descending;
	model grmhem = apgar5 tox / error = bin link = logit type3;
run;

/* CI based on profile likelihood */
proc logistic data = work.lowbwt;
   model grmhem(event = '1') = apgar5 tox / clparm=pl clodds = pl;
run;

/* Import ICU data set and create variables for race specifications */
libname ADS534 '/home/u63483466/ADS534/Data';
	data work.icu;
	set ADS534.icu;
	if race = 1
		then race1 = 1;
		else race1 = 0;
	if race = 2
		then race2 = 1;
		else race2 = 0;
	if race = 3
		then race3 = 1;
		else race3 = 0;
run;

/* Fit a logistic model of sta on crn and race using dummy variables */
proc logistic data = work.icu;
	model sta(event = '1') = crn race2 race3;
run;

/* Likelihood ratio test based on model */
proc genmod data = work.icu descending;
	model sta = crn race2 race3 / error = bin link = logit type3;
run;

/* Fit a logistic regression model of sta on age, sex, crn and race */
proc logistic data = work.icu;
	model sta(event = '1') = age sex crn race2 race3;
run;

/* Estimated OR death with crn, age = 30, sex = female, and race = black */
/* Estimated OR death with crn, age = 50, sex = male, and race = white */
proc logistic data = work.icu;
	model sta(event = '1') = age sex crn race2 race3;
	oddsratio "OR1" crn / at(age = 30 sex = 1 race2 = 1);
	oddsratio "OR2" crn / at(age = 50 sex = 0 race2 = 0 race3 = 0);
run;

/* Fit a logistic regression model of sta on age, sex, crn, race, and crn*race */
proc logistic data = work.icu;
	model sta(event = '1') = age sex crn race2 race3 crn*sex;
run;

/* Estimated OR death with crn, age = 30, sex = female, and race = black */
/* Estimated OR death with crn, age = 50, sex = male, and race = white */
proc logistic data = work.icu;
	model sta(event = '1') = age sex crn race2 race3 crn*sex;
	oddsratio "OR1" crn / at(age = 30 sex = 1 race2 = 1);
	oddsratio "OR2" crn / at(age = 50 sex = 0 race2 = 0 race3 = 0);
run;

/* Construct Wald test based CIs for the two ORs */
proc logistic data = work.icu;
	model sta(event = '1') = age sex crn race2 race3 crn*sex;
	oddsratio "OR1" crn / at(sex = 1);
	oddsratio "OR2" crn / at(sex = 0);
run;

/* LRT testing age on sta given crn = 1 */
proc genmod data = work.icu descending;
	model sta = age sex crn race2 race3 crn*sex / error = bin link = logit type3;
	contrast "crn = 1" sex 1 crn*sex 1;
run;