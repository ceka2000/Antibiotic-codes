// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ////
	ytitle(Cefprozil prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(84, lc(black) lp(dash))
	
/// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0) graphregion(color(white)) ///
	ylabel(, angle(horizontal) nogrid) title("Cefprozil", color(black)) 

// creating a seasonal varaible 
egen Season = seq(), f(1) t(12)

regress OutcomeAdjusted Time i.Season if Level == 0
rvfplot, yline(0) ylabel(, angle(horizontal) nogrid) graphregion(color(white))
	
generate Time2 = Time*Time	
regress OutcomeAdjusted Time Time2 i.Season if Level == 0
rvfplot, yline(0) ylabel(, angle(horizontal) nogrid) graphregion(color(white))	
	
generate Time3 = Time*Time*Time	
regress OutcomeAdjusted Time Time2 Time3 i.Season if Level == 0
rvfplot, yline(0) ylabel(, angle(horizontal) nogrid) graphregion(color(white))
	
// logging data
generate OutcomeAdjusted_Log = log(OutcomeAdjusted)
	
regress  OutcomeAdjusted_Log Time i.Season if Level == 0
rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	title(Cefprozil, color(black)) ///
	ylabel(, angle(horizontal) nogrid)

// getting the predicted values
regress  OutcomeAdjusted_Log Time i.Season if Level == 0
predict yhat  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefprozil, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month)  ///
	graphregion(color(white)) xline(84) ///
	|| line yhat Time

// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
*********************** 
//checking autocorrelation and seasonality
corrgram OutcomeAdjusted_Log, lag(101)  
regress OutcomeAdjusted_Log Time Level Trend i.Season
estat ic // obtaining the AIC and BIC
estat dwatson

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefprozil, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(84) ///
	|| line yhat2 Time if Level == 1  ///
	|| line yhat Time
	
prais OutcomeAdjusted_Log Time Level Trend  i.Season
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) )  ///
	ylabel(, angle(horizontal) nogrid) ///
	title(Cefprozil, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(84)  ///
	|| line yhat3 Time ///
	|| line yhat2 Time 
	
** fitted values for when intervention didn't happen and did
scatter OutcomeAdjusted_Log Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) )  ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Cefprozil, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(84) ///
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
