//Note: Generating individual data sets for each molecule

**************************************
//AZITHROMYCIN
**************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "AZITHROMYCIN"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

//Generating Time, Level, Trend
gen time = _n
gen level = 0 in 1/82
replace level = 1 in 83/168
gen trend = 0 in 1/82
replace trend = _n - 82 in 83/168

//Creating a variable adjusted for population
generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

//Label Time variable with Date variable
generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)

save 02AZITHROMYCIN, replace
clear

***************************************
//AZTREONAM
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "AZTREONAM"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)
 
//Add missing values
tsset Date
tsfill
//Missing values 2009m8 (128) and 2010m1 (133)
replace MainMolecule = MainMolecule[_n-1] if MainMolecule == ""

gen time = _n
gen level = 0 in 1/138
replace level = 1 in 139/168
gen trend = 0 in 1/138
replace trend = _n - 138 in 139/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000
rename (time level trend projectedTrx) (Time Level Trend Outcome)

// replacing empty dates - due to missing data
replace Year = 2009 if _n == 128
replace Month_String = "Aug" if _n == 128
replace Year = 2010 if _n == 133
replace Month_String = "Jan" if _n == 133

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)

save 02AZTREONAM, replace
clear

**************************************
//CEFDINIR
**************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CEFDINIR"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/100
replace level = 1 in 101/168
gen trend = 0 in 1/100
replace trend = _n - 100 in 101/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CEFDINIR, replace
clear

**************************************
//CEFPODOXIME PROXETIL
**************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CEFPODOXIME PROXETIL"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/65
replace level = 1 in 66/168
gen trend = 0 in 1/65
replace trend = _n - 65 in 66/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CEFPODOXIMEPROXETIL, replace
clear

***************************************
//CEFPROZIL
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CEFPROZIL"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/83
replace level = 1 in 84/168
gen trend = 0 in 1/83
replace trend = _n - 83 in 84/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CEFPROZIL, replace
clear

***************************************
//CEFUROXIME AXETIL
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CEFUROXIME AXETIL"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/38
replace level = 1 in 39/168
gen trend = 0 in 1/38
replace trend = _n - 38 in 39/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CEFUROXIMEAXETIL, replace
clear

***************************************
//CIPROFLOXACIN
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CIPROFLOXACIN"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/52
replace level = 1 in 53/168
gen trend = 0 in 1/52
replace trend = _n - 52 in 53/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CIPROFLOXACIN, replace
clear

***************************************
//CLARITHROMYCIN
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "CLARITHROMYCIN"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/76
replace level = 1 in 77/168
gen trend = 0 in 1/76
replace trend = _n - 76 in 77/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02CLARITHROMYCIN, replace
clear

***************************************
//DEMECLOCYCLINE
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "DEMECLOCYCLINE"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/62
replace level = 1 in 63/168
gen trend = 0 in 1/62
replace trend = _n - 62 in 63/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02DEMECLOCYCLINE, replace
clear

***************************************
//LEVOFLOXACIN
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "LEVOFLOXACIN"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/144
replace level = 1 in 145/168
gen trend = 0 in 1/144
replace trend = _n - 144 in 145/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02LEVOFLOXACIN, replace
clear

***************************************
//MEROPENEM
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "MEROPENEM"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/138
replace level = 1 in 139/168
gen trend = 0 in 1/138
replace trend = _n - 138 in 139/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02MEROPENEM, replace
clear

***************************************
//OFLOXACIN
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "OFLOXACIN"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/56
replace level = 1 in 57/168
gen trend = 0 in 1/56
replace trend = _n - 56 in 57/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02OFLOXACIN, replace
clear

***************************************
//PIPERACILLIN/TAZOBACTAM
***************************************
use 01USAbxPatentDrugs, clear
keep if MainMolecule == "PIPERACILLIN/TAZOBACTAM"
collapse (sum) projectedTrx, by( MainMolecule Date Month_String Year USAPopulation)

gen time = _n
gen level = 0 in 1/129
replace level = 1 in 130/168
gen trend = 0 in 1/129
replace trend = _n - 129 in 130/168

generate OutcomeAdjusted = (projectedTrx/USAPopulation)*1000000

rename (time level trend projectedTrx) (Time Level Trend Outcome)

generate sDate = string(Date,"%tm")
tostring Year, force replace
generate Date_Graph = Month_String + " " + Year
labmask Time, value (Date_Graph)
save 02PIPERACILLINTAZOBACTAM, replace
