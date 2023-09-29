/* Re-create contingency table */
data symptomx;
	input symptomX gender$ count;
datalines;
1 Male 9
0 Male 39
1 Female 36
0 Female 63
;
run;

proc freq data = symptomx;
	tables symptomX*gender / chisq expected nocol norow nopercent;
	weight count;
run;

libname ADS534 '/home/u63483466/ADS534/Data';
	data work.lowbwt;
	set ADS534.lowbwt;
run;

/* Fit the logistic regression model */
proc logistic data = work.lowbwt;
	model grmhem = apgar5; 
run;

/* Predict the probability for Apgar score of 3 */
/* Calculate predicted probabilities */
proc logistic data = work.lowbwt;
   model grmhem = apgar5 / LINK = LOGIT;
   output out = PredictedProb1 predicted = p_GrmHem;
run;

/* Calculate predicted probability for apgar5 = 3 */
data PredictedProb1;
   set PredictedProb1;
   if apgar5 = 3;
run;

/* Display predicted probability */
proc print data = PredictedProb1 noobs;
   var apgar5 p_GrmHem;
run;

/* Determine the OR of germ with 1-unit increase */
/* Calculate predicted probabilities */
proc logistic data = work.lowbwt;
   model grmhem = apgar5 / LINK = LOGIT;
   output out = PredictedProb2 predicted = p_GrmHem;
run;

/* Calculate predicted probability for apgar5 = 1 */
data PredictedProb2;
   set PredictedProb2;
   if apgar5 = 1;
run;

/* Display predicted probability */
proc print data = PredictedProb2 noobs;
   var apgar5 p_GrmHem;
run;

/* Determine the OR of germ with 3-unit increase */
/* Fit the logistic regression model */
proc logistic data = work.lowbwt;
	model grmhem = tox / LINK = LOGIT;
run;

/* Calculate predicted probabilities */
proc logistic data = work.lowbwt;
   model grmhem = tox / LINK = LOGIT;
   output out = PredictedProb predicted = p_GrmHem;
run;

/* Calculate predicted probability for toxemia status = 1 */
data PredictedProb;
   set PredictedProb;
   if tox = 1;
run;

/* Display predicted probability */
proc print data = PredictedProb noobs;
   var tox p_GrmHem;
run;