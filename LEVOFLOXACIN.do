use 02LEVOFLOXACIN, clear

// Plot data
scatter OutcomeAdjusted Time, connect(1) msize(vsmall) lcolor(black) mcolor(black) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ////
	ytitle(Levofloxacin prescriptions (per 1000 000 population)) xtitle(Month) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white)) ///
	xline(145, lc(black) lp(dash))
	
/// checking linearity
regress OutcomeAdjusted Time if Level == 0
rvfplot, yline(0) ///
	ylabel(, angle(horizontal) nogrid) graphregion(color(white))
	
** there is a seasonal pattern and a parabolic shape curve	
generate Time2 = Time*Time 
egen Season = seq(), f(1) t(12) // season varaible

regress OutcomeAdjusted Time Time2 i.Season if Level == 0
rvfplot, yline(0,lc(black)) color(black) graphregion(color(white)) ///
	title(Levofloxacin, color(black)) ///
	ylabel(, angle(horizontal) nogrid) 

// getting the predicted values
regress OutcomeAdjusted Time Time2 i.Season if Level == 0
predict yhat  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel(, angle(horizontal) nogrid) ///
	title(Levofloxacin, color(black)) ytitle(Prescriptions (per 1000 000 population)) ///
	graphregion(color(white)) xline(145) ///
	|| line yhat Time

// Set time variable
tsset Time

*********************** 
** Diagnostics stage **
***********************
corrgram OutcomeAdjusted, lag(82)  

generate Trend2 = Trend*Trend 

regress OutcomeAdjusted Time Time2 Level Trend Trend2 i.Season
estat ic // obtaining the AIC and BIC
estat dwatson 

predict yhat2  

// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title(Levofloxacin, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(148) ///
	|| line yhat2 Time ///
	|| line yhat Time
	
prais OutcomeAdjusted Time Time2 Level Trend Trend2 i.Season 
estat ic
predict yhat3  

// comparing regression OLS and regression P-W
scatter OutcomeAdjusted  Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical)) ///
	ylabel(0(1000)5000, angle(horizontal) nogrid) ///
	title(Levofloxacin, color(black)) ytitle(Prescriptions (per 1000 000 population)) xtitle(Month) ///
	graphregion(color(white)) xline(148) ///
	|| line yhat3 Time ///
	|| line yhat2 Time
	
// fitting the outcome and predicted values by time
scatter OutcomeAdjusted Time, connect(1) msize (small) ///
	xlabel(1(12)160 168, valuelabel angle(vertical) ) ytitle(Prescription) ///
	ylabel( , angle(horizontal) nogrid) ///
	title("", color(black)) ///
	graphregion(color(white)) xline(145) ///
	|| line yhat2 Time ///
	|| line yhat Time
	
*********************** 
** Analysis          **
*********************** 
** immediate change in level
gen pre0 = [_n]
replace pre0 = pre0 - Trend + 1 if Level == 1 
gen post0 = 0
replace post0 = Time - pre0 if Level == 1

** 6 months
gen pre6 = [_n]
replace pre6 = pre6 - Trend + 6 if Level == 1 
gen post6 = 0
replace post6 = Time - pre6 if Level == 1

** 12 months after
gen pre12 = [_n]
replace pre12 = pre12 - Trend + 12 if Level == 1 
gen post12 = 0
replace post12 = Time - pre12 if Level == 1

** 18 months
gen pre18 = [_n]
replace pre18 = pre18 - Trend + 1 if Level == 1 
gen post18 = 0
replace post18 = Time - pre18 if Level == 1

** 24 months after
gen pre24 = [_n]
replace pre24 = pre24 - Trend + 24 if Level == 1 
gen post24 = 0
replace post24 = Time - pre24 if Level == 1

generate pre0_2 = pre0*pre0
generate post0_2 = post0*post0

generate pre6_2 = pre6*pre6
generate post6_2 = post6*post6

generate pre12_2 = pre12*pre12
generate post12_2 = post12*post12

generate pre18_2 = pre18*pre18
generate post18_2 = post18*post18

generate pre24_2 = pre24*pre24
generate post24_2 = post24*post24

replace post12_2 = -post12_2 if post12 < 0
replace post24_2 = -post24_2 if post24 < 0

***
regress OutcomeAdjusted Time Time2 Level Trend Trend2 i.Season

** getting the change in levels
regress OutcomeAdjusted Level i.Season pre0 post0 pre0_2 post0_2
regress OutcomeAdjusted Level i.Season pre6 post6 pre6_2 post6_2
regress OutcomeAdjusted Level i.Season pre12 post12 pre12_2 post12_2
regress OutcomeAdjusted Level i.Season pre18 post18 pre18_2 post18_2
regress OutcomeAdjusted Level i.Season pre24 post24 pre24_2 post24_2

************************************************************************
//Calculating relative change
************************************************************************
keep OutcomeAdjusted Outcome Time Time2 Level Trend Trend2 Season pre0 - post24_2

** model
regress OutcomeAdjusted Time Time2 Level Trend Trend2 i.Season  
predict yhat2

regress OutcomeAdjusted Level i.Season pre0 post0 pre0_2 post0_2

//Predict relative change at 6 months
regress OutcomeAdjusted Level i.Season pre6 post6 pre6_2 post6_2
display 100*((103.3434)/(1711.63 - (103.3434)))

//Predict relative change at 12 months
regress OutcomeAdjusted Level i.Season pre12 post12 pre12_2 post12_2
display 100*((672.4085)/(2965.651 - (672.4085)))

//Predict relative change at 18 months
regress OutcomeAdjusted Level i.Season pre18 post18 pre18_2 post18_2
display 100*((-237.6299)/(2151.899 - (-237.6299)))

//Predict relative change at 24 months
regress OutcomeAdjusted Level i.Season pre24 post24 pre24_2 post24_2
display 100*((1989.136)/(3579.969 - (1989.136)))
