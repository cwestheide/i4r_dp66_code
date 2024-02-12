***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A11
***Effects of TWI Training on War Contracts

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/war_variables.dta", clear

global year_effects_1 treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


global year_effects_2  treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 post_2-post_16 treatment_full



*Yearly effects
foreach dep_var of var having_contract ln_value_contracts ln_number_contracts  {

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local upper 2
if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local lower -5
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local upper 8
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local lower 1

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local missing_year -1
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local missing_year 1

if  "`dep_var'"=="gr_number_contracts" local pos 7
if "`dep_var'"=="gr_gov_tfpr" local pos 12
if "`dep_var'"=="gr_value_contracts"  local pos 5
if  "`dep_var'"=="ln_gov_sales" | "`dep_var'"=="ln_value_contracts" local pos 6
if "`dep_var'"!="gr_gov_tfpr"  & "`dep_var'"!="gr_value_contracts" & "`dep_var'"!="ln_gov_sales" & "`dep_var'"!="ln_value_contracts" & "`dep_var'"!="gr_number_contracts" local pos 11

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local glob 1
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local glob 2


reghdfe `dep_var' ${year_effects_`glob'} if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
replace var=`missing_year' if var==.
sort treatment var 

*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.8
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

graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")), yline(0, lcolor(black)) xlabel(`lower'(1)`upper') xline(-0.8, lcolor(maroon*0.3)) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) graphregion(color(white))
graph export "${directory_results}/figureA11_`dep_var'`1'.pdf", replace

restore

}

