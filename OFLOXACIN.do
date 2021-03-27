use 02OFLOXACIN, clear

// Plot including all data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ///
	title(Ofloxacin) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(57, lc(black) lp(dash))
	
** unreliable data
drop if _n >= 145

// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ////
	ytitle(Ofloxacin prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(57, lc(black) lp(dash))
	
/// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot , yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Ofloxacin", color(black))  

// creating a seasonal varaible
egen Season = seq(), f(1) t(12) // season varaible

regress OutcomeAdjusted Time i.Season if Level == 0
rvfplot, yline(0) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white))
	
generate Time2 = Time*Time
regress OutcomeAdjusted Time Time2 i.Season if Level == 0
rvfplot, yline(0) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white))
	
// logging data, better fit
generate OutcomeAdjusted_Log = log(OutcomeAdjusted)	
regress OutcomeAdjusted_Log Time   if Level == 0

rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	title(Ofloxacin, color(black)) ///
	ylabel(, angle(horizontal) nogrid) 

// getting the predicted values
predict yhat 

scatter OutcomeAdjusted_Log Time, connect(1) msize(tiny) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel(, angle(horizontal) nogrid) ///
	title("", color(black)) ///
	graphregion(color(white)) xline(57) ///
	|| line yhat Time
	
drop Season

// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
*********************** 
//checking autocorrelation and seasonality
corrgram OutcomeAdjusted_Log, lag(101)  
regress OutcomeAdjusted_Log Time Level Trend  
estat ic // obtaining the AIC and BIC
estat dwatson

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Ofloxacin, color(black)) ///
	graphregion(color(white)) xline(84) ///
	|| line yhat2 Time if Level == 1  ///
	|| line yhat Time
	
prais OutcomeAdjusted_Log Time Level Trend   
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)150, valuelabel angle(vertical)) ///
	ylabel(0(1)6 , angle(horizontal) nogrid) ///
	title(Ofloxacin, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(57) ///
	|| line yhat3 Time ///
	|| line yhat2 Time
	
// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Ofloxacin, color(black)) ///
	graphregion(color(white)) xline(57) ///
	|| line yhat3 Time ///
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

** 12 months after
gen pre12 = [_n]
replace pre12 = pre12 - Trend + 12 if Level == 1 
gen post12 = 0
replace post12 = Time - pre12 if Level == 1

** 18 months after
gen pre18 = [_n]
replace pre18 = pre18 - Trend + 18 if Level == 1 
gen post18 = 0
replace post18 = Time - pre18 if Level == 1

** 24 months after
gen pre24 = [_n]
replace pre24 = pre24 - Trend + 24 if Level == 1 
gen post24 = 0
replace post24 = Time - pre24 if Level == 1

***
prais OutcomeAdjusted_Log Time Level Trend  
// post-trend
lincomest Time + Trend 

** getting the change in levels
prais OutcomeAdjusted_Log Level  pre0 post0 
prais OutcomeAdjusted_Log Level  pre6 post6
prais OutcomeAdjusted_Log Level  pre12 post12
prais OutcomeAdjusted_Log Level  pre18 post18
prais OutcomeAdjusted_Log Level  pre24 post24

************************************************************************
//Calculating relative change
************************************************************************
keep OutcomeAdjusted OutcomeAdjusted_Log Outcome Time Level Trend pre0 - post24

** model
prais OutcomeAdjusted_Log Time Level Trend  
predict yhat2 // to get the predicted values

//Predict relative change at 6 months
prais OutcomeAdjusted_Log Level pre6 post6
display 100*((0.1698352)/(4.026991 - (0.1698352))) 

//Predict relative change at 12 months
prais OutcomeAdjusted_Log Level  pre12 post12
display 100*((0.2409564)/(3.888709 - (0.2409564)))

//Predict relative change at 18 months
prais OutcomeAdjusted_Log Level  pre18 post18 
display 100*((0.3120776)/(3.750427 - (0.3120776)))

//Predict relative change at 24 months
prais OutcomeAdjusted_Log Level  pre24 post24
display 100*((0.3831988)/(3.612145 - (0.3831988)))
