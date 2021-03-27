use 02MEROPENEM, clear
** due to drug shortage data pre may 2000 is removed
//drop if _n < 17

//Sensitivity analysis
//replace OutcomeAdjusted=. if _n < 73

drop Time

generate Time = _n
labmask Time, value (Date_Graph)

// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160, valuelabel angle(vertical) ) ////
	ytitle(Meropenem prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(123, lc(black) lp(dash))

/// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	title(Meropenem, color(black)) ///
	ylabel(, angle(horizontal) nogrid)
// linear

// getting the predicted values
predict yhat  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel(, angle(horizontal) nogrid) ///
	title(Meropenem, color(black)) ytitle(Prescriptions (per 1000 000 population)) ///
	graphregion(color(white)) xline(123) ///
	|| line yhat Time
	
// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
*********************** 
//checking autocorrelation and seasonality
corrgram OutcomeAdjusted, lag(82)  
regress OutcomeAdjusted Time Level Trend  
estat ic // obtaining the AIC and BIC
estat dwatson 

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Meropenem, color(black)) ytitle(Prescriptions (per 1000 000)) xtitle(Month)  ///
	graphregion(color(white)) xline(123) ///
	|| line yhat2 Time if Level == 1  ///
	|| line yhat Time
	
prais OutcomeAdjusted Time Level Trend 
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) )  ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Meropenem, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(123)  ///
	|| line yhat3 Time ///
	|| line yhat2 Time 

** fitted values for when intervention didn't happen and did
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) )  ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Meropenem, color(black)) ytitle(prescriptions (per 1000 000)) xtitle(Month) ///
	graphregion(color(white)) xline(123) ///
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
prais OutcomeAdjusted Time Level Trend  
// post-trend
lincomest Time + Trend 

** getting the change in levels
prais OutcomeAdjusted Level  pre0 post0 
prais OutcomeAdjusted Level  pre6 post6
prais OutcomeAdjusted Level  pre12 post12
prais OutcomeAdjusted Level  pre18 post18 
prais OutcomeAdjusted Level  pre24 post24
