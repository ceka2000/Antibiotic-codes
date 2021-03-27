use 02CEFDINIR, clear

// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ////
	ytitle(Cefdinir prescriptions (per 1000 000)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(101, lc(black) lp(dash)) 

// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Cefdinir sales", color(black)) 

// creating a seasonal varaible	
egen Season = seq(), f(1) t(12) 

regress OutcomeAdjusted Time i.Season if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Cefdinir sales", color(black)) 
	
// creating a time squared (fitting a curve) and adding 
// it to the regression (seasonal variable already created)	
generate Time2 = Time*Time
regress OutcomeAdjusted Time Time2 i.Season if Level == 0	
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Cefdinir sales", color(black))
	
generate Time3 = Time*Time*Time
regress OutcomeAdjusted Time Time2 Time3 i.Season if Level == 0	
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Cefdinir sales", color(black))
	
// logging data
generate OutcomeAdjusted_Log = log(OutcomeAdjusted)

regress OutcomeAdjusted_Log i.Season Time2 Time3 if Level == 0
rvfplot, yline(0) ylabel(, angle(horizontal) nogrid) graphregion(color(white))

regress OutcomeAdjusted_Log i.Season  if Level == 0
rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid)

** just logged best fit

regress OutcomeAdjusted_Log Time i.Season if Level == 0	
predict yhat 

drop Time2 Time3

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel(, angle(horizontal) nogrid) ///
	title(Cefdinir, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(101) ///
	|| line yhat Time
	
// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
***********************
//checking autocorrelation and seasonality
corrgram OutcomeAdjusted_Log, lag(101) 
regress OutcomeAdjusted_Log Time i.Season Level Trend
estat ic // obtaining the AIC and BIC
estat dwatson 

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefdinir, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(101) ///
	|| line yhat2 Time if Level == 1  ///
	|| line yhat Time
	
prais OutcomeAdjusted_Log Time  Level Trend  i.Season
estat ic
predict yhat3 

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefdinir, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(101) ///
	|| line yhat3 Time ///
	|| line yhat2 Time 
	
** fitted values for when intervention didn't happen and did
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefdinir, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month)  ///
	graphregion(color(white)) xline(101) ///
	|| line yhat3 Time if Level == 1  ///
	|| line yhat Time
	
*********************** 
** Analysis          **
*********************** 

** immediate change in level
gen pre0 = [_n]
replace pre0 = pre0 - Trend + 1 if Level == 1 
gen post0 = 0
replace post0 = Time - pre0 if Level == 1

** 6 months after
gen pre6 = [_n]
replace pre6 = pre6 - Trend + 6 if Level == 1 
gen post6 = 0
replace post6 = Time - pre6 if Level == 1

** 12 months after (1 year)
gen pre12 = [_n]
replace pre12 = pre12 - Trend + 12 if Level == 1 
gen post12 = 0
replace post12 = Time - pre12 if Level == 1

** 18 months after
gen pre18 = [_n]
replace pre18 = pre18 - Trend + 18 if Level == 1 
gen post18 = 0
replace post18 = Time - pre18 if Level == 1

** 24 months after (2 years)
gen pre24 = [_n]
replace pre24 = pre24 - Trend + 24 if Level == 1 
gen post24 = 0
replace post24 = Time - pre24 if Level == 1

***
prais OutcomeAdjusted_Log Time Level Trend i.Season
// post-trend
lincomest Time + Trend 

** getting the change in levels
prais OutcomeAdjusted_Log Level i.Season pre0 post0 
prais OutcomeAdjusted_Log Level i.Season pre6 post6
prais OutcomeAdjusted_Log Level i.Season pre12 post12
prais OutcomeAdjusted_Log Level i.Season pre18 post18
prais OutcomeAdjusted_Log Level i.Season pre24 post24

************************************************************************
//Calculating relative change
************************************************************************
keep OutcomeAdjusted OutcomeAdjusted_Log Outcome Time Level Trend Season pre0 - post24

** model
prais OutcomeAdjusted_Log Time Level Trend i.Season
predict yhat2

//Predict relative change at 6 months
prais OutcomeAdjusted_Log Level i.Season pre6 post6
display 100*((-0.2707858)/(7.968064 - (-0.2707858))) 

//Predict relative change at 12 months
prais OutcomeAdjusted_Log Level i.Season pre12 post12
display 100*((-0.4643227)/(8.037777 - (-0.4643227)))

//Predict relative change at 18 months
prais OutcomeAdjusted_Log Level i.Season pre18 post18 
display 100*((-0.6578595)/(7.911022 - (-0.6578595)))

//Predict relative change at 24 months
prais OutcomeAdjusted_Log Level i.Season pre24 post24
display 100*((-0.8513964)/(7.980733 - (-0.8513964)))
