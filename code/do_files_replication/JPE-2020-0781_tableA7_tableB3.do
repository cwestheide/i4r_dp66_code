***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A7
***Matching Trained and Nontrained firms

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

****************************************************************
*PROPENSITY SCORE MATCHING BETWEEN TREATED AND CONTROL, Table B3
****************************************************************
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched

*Keep years before 1940
keep if time==-1

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3`1'.xls", dec(4) replace

keep if _weight!=.
keep if time==-1
gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1


global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post


*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) `command'

}
***************************************************************************


***************************************************************************
*SAME PROCESS USED FOR APPLICANTS AND NON-APPLICANTS
*BUT USE ALL PRE-WAR OBSERVATIONS
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched


*Keep years before 1940
keep if time<=-1 & time>=-5

tab year, gen(yfe)

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services yfe*, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3.xls", dec(4) append


keep if _weight!=.
keep if time==-1

gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1

global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post


*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) append

}
***************************************************************************


***************************************************************************
*MORE VARIABLES
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched


*Keep years before 1940
keep if time==-1

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services foundation_year inventory capital current_assets investment strikes injuries bonus acquisition, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3`1'.xls", dec(4) append


keep if _weight!=.
keep if time==-1

gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1

global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post



*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) append

}
***************************************************************************



***************************************************************************
*MORE VARIABLES AND DISTRICT FIXED EFFECTS
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched

*Keep years before 1940
keep if time==-1

tab twi_district, gen(disfe)

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services foundation_year inventory capital current_assets investment strikes injuries bonus acquisition disfe*, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3`1'.xls", dec(4) append


keep if _weight!=.
keep if time==-1
gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1

global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post


*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) append

}
***************************************************************************



***************************************************************************
*MORE VARIABLES AND SUBDISTRICT FIXED EFFECTS
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched


*Keep years before 1940
keep if time==-1


tab subdistrict, gen(subfe)

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services foundation_year inventory capital current_assets investment strikes injuries bonus acquisition subfe*, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3`1'.xls", dec(4) append


keep if _weight!=.
keep if time==-1
gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1

global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post

*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) append

}
***************************************************************************




***************************************************************************
*MORE VARIABLES AND SUBDISTRICT FIXED EFFECTS AND APP WINDOW FIXED EFFECTS
use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched

*Keep years before 1940
keep if time==-1

tab subdistrict, gen(subfe)
tab app_window, gen(appfe)

psmatch2 treatment plants employees ln_tfpr distance_port distance_railroad annual_sales manufacturing transportation services foundation_year inventory capital current_assets investment strikes injuries bonus acquisition subfe* appfe*, common ties noreplacement descending
outreg2 using "${directory_results}/table_b3`1'.xls", dec(4) append

keep if _weight!=.
keep if time==-1
gen matched=1
keep id matched
tempfile weight
save `weight', replace


use "${directory_data}/app_main_outcomes_yearly.dta", clear
cap drop weight_nonapp
cap drop matched
merge m:1 id using `weight', keep(1 3)
drop _merge
replace matched=0 if matched==.


*Keep period in which we observe everybody
keep if time>=-5 & time<=10 & applied==1

global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post


*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition ln_investment {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a7`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) append

}
***************************************************************************
