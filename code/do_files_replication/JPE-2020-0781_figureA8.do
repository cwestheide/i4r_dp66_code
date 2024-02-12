***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A8
***Effects of TWI Training on Matched Sample

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_main_outcomes_yearly.dta", clear

global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full

*Only balanced and reweighted
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

forvalues i=1/2 {

if `i'==1 local conditions "if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time)"
if `i'==2 local conditions "if balanced==1 & second_treatment=="" & matched==1, absorb(app_window app_day id)"

reghdfe `dep_var' ${year_effects} `conditions' cluster(cluster) `version'
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

*Label of alt_treat
label define alt_treat 1 "Baseline" 2 "Reweighted"
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

if "`dep_var'"=="ln_tfpr" | "`dep_var'"=="ln_annual_sales" | "`dep_var'"=="ln_roa" local pos 11


graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--...")) ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin) msize(medlarge) lwidth(vthin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.1(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(`pos') col(1) size(small) order(2 4) label(2 "Baseline")label(4 "Matched")) graphregion(color(white))
graph export "${directory_results}/figureA8_`dep_var'_matched`1'.pdf", replace

restore

}
