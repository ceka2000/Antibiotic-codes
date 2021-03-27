use 02CIPROFLOXACIN, clear

// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)130, valuelabel angle(vertical) ) ///
	title(Ciprofloxacin prescriptions) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel( , angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(63, lc(black) lp(dash))

** removing data points post oct 2009 due to a shortage in the drug and we can 
drop if _n > 130

//Sensitivity analysis
//drop if _n < 34

//Change level and trend according to new generic entry date
//2004m3

drop Time Level Trend
gen Time=_n
gen Level=0
replace Level=1 if Time>28
gen Trend=0
replace Trend=_n-27 if Time>28
labmask Time, value (Date_Graph)

// Plot including line for intervention
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)96, valuelabel angle(vertical) ) ////
	ytitle(Ciprofloxacin prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel( , angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(29, lc(black) lp(dash))
		
/// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Ciprofloxacin", color(black)) 

regress OutcomeAdjusted Time if Level == 0
predict yhat 

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)96, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title("", color(black)) ///
	graphregion(color(white)) xline(29) ///
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
	xlabel(1(12)96, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title("", color(black)) ///
	graphregion(color(white)) xline(29) ///
	|| line yhat2 Time
	
prais OutcomeAdjusted Time Level Trend  
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)96, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Ciprofloxacin, color(black)) ytitle(Prescription (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(29) ///
	|| line yhat2 Time ///
	|| line yhat3 Time
	
// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)96, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Ciprofloxacin, color(black)) ///
	graphregion(color(white)) xline(29) ///
	|| line yhat3 Time ///
	|| line yhat Time
	
********************* 
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
prais OutcomeAdjusted Level pre6 post6
prais OutcomeAdjusted Level  pre12 post12
prais OutcomeAdjusted Level  pre18 post18 
prais OutcomeAdjusted Level  pre24 post24

************************************************************************
//Calculating relative change
************************************************************************
keep OutcomeAdjusted Outcome Time Level Trend pre0 - post24

** model
prais OutcomeAdjusted Time Level Trend  
predict yhat2

//Predict relative change at 6 months
prais OutcomeAdjusted Level pre6 post6
display 100*((211.0212)/(3833.236 - (211.0212))) 

//Predict relative change at 12 months
prais OutcomeAdjusted Level  pre12 post12
display 100*((408.5995)/(4014.349 - (408.5995)))

//Predict relative change at 18 months
prais OutcomeAdjusted Level  pre18 post18 
display 100*((606.1777)/(4225.648 - (606.1777)))

//Predict relative change at 24 months
prais OutcomeAdjusted Level  pre24 post24
display 100*((803.756)/(4376.576 - (803.756)))
