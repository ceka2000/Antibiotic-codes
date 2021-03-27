use 02AZTREONAM, clear
	
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ////
	ytitle(Aztreonam prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(139, lc(black) lp(dash)) 

************************
**Sensitivity analysis**
************************
// shortage of aztreonam between June 2009 and June 2010 	
// replace OutcomeAdjusted=. if _n>125 & _n<139

regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	title(Aztreonam, color(black)) ///
	ylabel(, angle(horizontal) nogrid) 

// checking linearity
generate Time2 = Time*Time
regress OutcomeAdjusted Time Time2 if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Aztreonam", color(black)) 

generate Time3 = Time*Time*Time
regress OutcomeAdjusted Time Time2 Time3 if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Aztreonam", color(black)) 

generate OutcomeAdjustedLog = log(OutcomeAdjusted)
regress OutcomeAdjustedLog Time if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Aztreonam", color(black)) 
** all are the same - using linear

// getting the predicted values
regress OutcomeAdjusted Time if Level == 0
predict yhat  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Aztreonam, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(139) ///
	|| line yhat Time	

drop Time2 Time3 OutcomeAdjustedLog

// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
*********************** 
//checking autocorrelation and seasonality
corrgram OutcomeAdjusted, lag(138)
regress OutcomeAdjusted Time Level Trend 
estat ic // obtaining the AIC and BIC
estat dwatson

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Aztreonam, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(139) ///
	|| line yhat2 Time if Level == 1  ///
	|| line yhat Time
	
prais OutcomeAdjusted Time Level Trend  
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Aztreonam, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(139) ///
	|| line yhat3 Time ///
	|| line yhat2 Time
	
** fitted values for when intervention didn't happen and did
scatter OutcomeAdjusted Time, connect(1) msize (small) lc(black) mc(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical)) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Aztreonam, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(139) ///
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
prais OutcomeAdjusted Time Level Trend  
// post-trend
lincomest Time + Trend 

** getting the change in levels
prais OutcomeAdjusted Level  pre0 post0 
prais OutcomeAdjusted Level  pre6 post6
prais OutcomeAdjusted Level  pre12 post12
prais OutcomeAdjusted Level  pre18 post18 
prais OutcomeAdjusted Level  pre24 post24
lincomest Level - .00541312  // adjusting because the predicted fitted value was going below zero which can not happen
	
************************************************************************
//Calculating relative change
************************************************************************
keep OutcomeAdjusted Outcome Time Level Trend pre0 - post24

** model
prais OutcomeAdjusted Time Level Trend  
predict yhat2

** relative effect for the immediate change
prais OutcomeAdjusted Level  pre0 post0 
display 100*((0.0272936)/(0.05302775 - (0.0272936)))

//Predict relative change at 6 months
prais OutcomeAdjusted Level pre6 post6
display 100*((0.0337708)/(0.0524622 - (0.0337708))) 

//Predict relative change at 12 months
prais OutcomeAdjusted Level  pre12 post12
display 100*((0.0415435)/(0.0517835 - (0.0415435)))

//Predict relative change at 18 months
prais OutcomeAdjusted Level  pre18 post18 
display 100*((0.0493161)/(0.0511049 - (0.0493161)))

//Predict relative change at 24 months
prais OutcomeAdjusted Level  pre24 post24
display 100*((0.0570887)/(0.0504262 - (0.0570887)))
