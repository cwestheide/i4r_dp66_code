***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A5
***Robustness Checks of Main Results on Sales and TFP


if inlist(`1', 3, 5) {
	local version "version(`1')"
}

***Panels A and D: Sales and TFP, alternative fixed effects

use "${directory_data}/app_main_outcomes_yearly.dta", clear

global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full



*Yearly effects
reghdfe ln_tfpr ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
gen keep_obs=(e(sample))


foreach dep_var of var ln_tfpr ln_annual_sales {

forvalues i=1/3 {

if `i'==1 local conditions "absorb(id)"
if `i'==2 local conditions "absorb(app_window app_day county_sector_time)"
if `i'==3 local conditions "absorb(app_window app_day district_sector_time)"

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, `conditions' cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")
label define treat 1 "Treated"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="0" if regexm(var,"_6$")
replace var="1" if regexm(var,"_7$")
replace var="2" if regexm(var,"_8$")
replace var="3" if regexm(var,"_9$")
replace var="4" if regexm(var,"_10$")
replace var="5" if regexm(var,"_11$")
replace var="6" if regexm(var,"_12$")
replace var="7" if regexm(var,"_13$")
replace var="8" if regexm(var,"_14$")
replace var="9" if regexm(var,"_15$")
replace var="10" if regexm(var,"_16$")
destring var, replace force
drop if var==.

*Add -1
local nn=_N+1
set obs `nn'
replace treatment=1 if var==.
replace var=-1 if var==.
sort treatment var 

*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}

*Alternative treatment
gen alt_treat=`i'

tempfile alt_treat_`i'
save `alt_treat_`i''
restore

}

preserve
use `alt_treat_1', clear
append using `alt_treat_2'
append using `alt_treat_3'

*Label of alt_treat
label define alt_treat 1 "Firm FE" 2 "County-Sector FE + App Window FE" 3 "District-Sector FE + App Window FE"
label values alt_treat alt_treat


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.3
replace max_upper=max_upper+add if add>0
replace max_upper=max_upper-add if add<0
replace min_lower=min_lower-add if add>0
replace min_lower=min_lower+add if add<0
gen steps=(max_upper-min_lower)/8

sum max_upper
local up=r(mean)
sum min_lower
local down=r(mean)
sum steps
local steps=r(mean)

if "`dep_var'"=="ln_tfpr" | "`dep_var'"=="ln_annual_sales" local pos 11


graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) msize(small) mlwidth(vthin) lpatter("--..."))  ///
 (rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Th) msize(medlarge) mlwidth(vthin) lpatter("--..."))  ///
 (rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") mfcolor(%30) msize(large) msymbol(Dh) mlwidth(vthin) lpatter("--...")) ///
 , yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(`pos') col(1) size(small) order(2 4 6) label(2 "Firm FE") label(4 "County-Sector FE") label(6 "District-Sector FE")) graphregion(color(white))
graph export "${directory_results}/figureA5_`dep_var'_main_specs`1'.pdf", replace

restore

}



****Panels B and E: Sales and TFP, alternative clustering
use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


*Yearly effects
reghdfe ln_tfpr ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
gen keep_obs=(e(sample))


foreach dep_var of var ln_tfpr ln_annual_sales {

forvalues i=1/4 {

if `i'==1 local conditions "cluster"
if `i'==2 local conditions "subdistrict"
if `i'==3 local conditions "county_fips"
if `i'==4 local conditions "id"

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, absorb(app_window app_day county_sector_time) cluster(`conditions') `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")
label define treat 1 "Treated"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="0" if regexm(var,"_6$")
replace var="1" if regexm(var,"_7$")
replace var="2" if regexm(var,"_8$")
replace var="3" if regexm(var,"_9$")
replace var="4" if regexm(var,"_10$")
replace var="5" if regexm(var,"_11$")
replace var="6" if regexm(var,"_12$")
replace var="7" if regexm(var,"_13$")
replace var="8" if regexm(var,"_14$")
replace var="9" if regexm(var,"_15$")
replace var="10" if regexm(var,"_16$")
destring var, replace force
drop if var==.

*Add -1
local nn=_N+1
set obs `nn'
replace treatment=1 if var==.
replace var=-1 if var==.
sort treatment var 

*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}

*Alternative treatment
gen alt_treat=`i'

tempfile alt_treat_`i'
save `alt_treat_`i''
restore

}

preserve
use `alt_treat_1', clear
append using `alt_treat_2'
append using `alt_treat_3'
append using `alt_treat_4'

*Label of alt_treat
label define alt_treat 1 "Sub-App" 2 "Subdistrict" 3 "County" 4 "Firm"
label values alt_treat alt_treat


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.05
replace max_upper=max_upper+add if add>0
replace max_upper=max_upper-add if add<0
replace min_lower=min_lower-add if add>0
replace min_lower=min_lower+add if add<0
gen steps=(max_upper-min_lower)/8

sum max_upper
local up=r(mean)
sum min_lower
local down=r(mean)
sum steps
local steps=r(mean)

if "`dep_var'"=="ln_tfpr" | "`dep_var'"=="ln_annual_sales" local pos 11


graph twoway (rarea ci_upper ci_lower var if treatment==1 & alt_treat==1, fcolor("0 63 92") lwidth(medtick) lcolor("0 63 92") lpattern(longdash)) (scatter coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(none)) ///
(rarea ci_upper ci_lower var if treatment==1 & alt_treat==2, lcolor("188 80 144") fcolor("188 80 144") lwidth(medtick) lpattern("-###")) (scatter coef var if treatment==1 & alt_treat==2, color("188 80 144") msymbol(none) ) ///
(rarea ci_upper ci_lower var if treatment==1 & alt_treat==3, fcolor("255 166 0") lcolor("255 166 0") lwidth(medtick) lpatter("_-###")) (scatter coef var if treatment==1 & alt_treat==3, color("255 166 0") msymbol(none)) ///
(rarea ci_upper ci_lower var if treatment==1 & alt_treat==4, fcolor("51 160 44") lcolor("51 160 44") lwidth(medtick) lpatter(shortdash)) (scatter coef var if treatment==1 & alt_treat==4, color("51 160 44") msymbol(none)) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(`pos') col(1) size(small) order(1 3 5 7) label(1 "Sub-App") label(3 "Sub") label(5 "County") label(7 "Firm")) graphregion(color(white))
graph export "${directory_results}/figureA5_`dep_var'_clustering`1'.eps", replace

restore

}



***Panels C and F: Sales and TFP, alternative timing

use "${directory_data}/app_main_outcomes_yearly_alttime.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


*Yearly effects
foreach dep_var of var ln_tfpr ln_annual_sales {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")
label define treat 1 "J-I" 2 "J-R" 3 "J-M"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="0" if regexm(var,"_6$")
replace var="1" if regexm(var,"_7$")
replace var="2" if regexm(var,"_8$")
replace var="3" if regexm(var,"_9$")
replace var="4" if regexm(var,"_10$")
replace var="5" if regexm(var,"_11$")
replace var="6" if regexm(var,"_12$")
replace var="7" if regexm(var,"_13$")
replace var="8" if regexm(var,"_14$")
replace var="9" if regexm(var,"_15$")
replace var="10" if regexm(var,"_16$")
destring var, replace force
drop if var==.

*Add -1
local nn=_N+1
set obs `nn'
replace treatment=1 if var==.
replace var=-1 if var==.
sort treatment var 


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.05
replace max_upper=max_upper+add if add>0
replace max_upper=max_upper-add if add<0
replace min_lower=min_lower-add if add>0
replace min_lower=min_lower+add if add<0
gen steps=(max_upper-min_lower)/8

sum max_upper
local up=r(mean)
sum min_lower
local down=r(mean)
sum steps
local steps=r(mean)


*Keep the files for later
drop max_upper min_lower add steps
keep var coef ci_lower ci_upper treatment
gen alternative_time=0

tempfile `dep_var'_alt_time_0
save ``dep_var'_alt_time_0'
restore

}


*Graph them with the baseline
***Load dataset
use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


*Yearly effects
foreach dep_var of var ln_tfpr ln_annual_sales {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")
label define treat 1 "J-I" 2 "J-R" 3 "J-M"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="0" if regexm(var,"_6$")
replace var="1" if regexm(var,"_7$")
replace var="2" if regexm(var,"_8$")
replace var="3" if regexm(var,"_9$")
replace var="4" if regexm(var,"_10$")
replace var="5" if regexm(var,"_11$")
replace var="6" if regexm(var,"_12$")
replace var="7" if regexm(var,"_13$")
replace var="8" if regexm(var,"_14$")
replace var="9" if regexm(var,"_15$")
replace var="10" if regexm(var,"_16$")
destring var, replace force
drop if var==.

*Add -1
local nn=_N+1
set obs `nn'
replace treatment=1 if var==.
replace var=-1 if var==.
sort treatment var 


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


*Add the relevant temp_file
append using ``dep_var'_alt_time_0'
replace alternative_time=1 if alternative_time==.


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.05
replace max_upper=max_upper+add if add>0
replace max_upper=max_upper-add if add<0
replace min_lower=min_lower-add if add>0
replace min_lower=min_lower+add if add<0
gen steps=(max_upper-min_lower)/8

sum max_upper
local up=r(mean)
sum min_lower
local down=r(mean)
sum steps
local steps=r(mean)

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alternative_time==1, color("0 63 92")) (connected coef var if treatment==1 & alternative_time==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lpatter("--...")) ///
(rcap ci_upper ci_lower var if treatment==1 & alternative_time==0, color("0 63 92")) (connected coef var if treatment==1 & alternative_time==0, color("0 63 92") msymbol(Oh) mlwidth(thin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*30)) xline(3.2, lcolor(maroon*30)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) order(2 4) label(2 "Baseline") label(4 "Alt. timing")) graphregion(color(white))
graph export "${directory_results}/figureA5_`dep_var'_base_v_alt.pdf", replace

restore

}

