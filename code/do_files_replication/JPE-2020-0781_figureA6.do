***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A6
***Effects of Different J-Modules on Firm Performance

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects op_post_1 op_post_2 op_post_3 op_post_4 op_post_6 op_post_7 op_post_8 op_post_9 op_post_10 op_post_11 op_post_12 op_post_13 op_post_14 op_post_15 op_post_16 hr_post_1 hr_post_2 hr_post_3 hr_post_4 hr_post_6 hr_post_7 hr_post_8 hr_post_9 hr_post_10 hr_post_11 hr_post_12 hr_post_13 hr_post_14 hr_post_15 hr_post_16 io_post_1 io_post_2 io_post_3 io_post_4 io_post_6 io_post_7 io_post_8 io_post_9 io_post_10 io_post_11 io_post_12 io_post_13 io_post_14 io_post_15 io_post_16 post_2-post_16 first_hr first_op first_io


*Yearly effects
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^op_")
replace treatment=2 if regexm(var, "^hr_")
replace treatment=3 if regexm(var, "^io_")
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

local nn=_N+1
set obs `nn'
replace treatment=2 if var==.
replace var=-1 if var==.
sort treatment var 

local nn=_N+1
set obs `nn'
replace treatment=3 if var==.
replace var=-1 if var==.
sort treatment var 


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


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

graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==2, color("188 80 144")) (connected coef var if treatment==2, color("188 80 144") msymbol(t) msize(small) lpatter(shortdash)) (rcap ci_upper ci_lower var if treatment==3, color("255 166 0")) (connected coef var if treatment==3, color("255 166 0") msymbol(d) msize(small) lpatter("_###")), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.10(0.05)0.45, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) order(2 4 6) label(2 "J-I") label(4 "J-R") label(6 "J-M")) graphregion(color(white))
graph export "${directory_results}/figureA6_`dep_var'_dd`1'.pdf", replace

restore

}



global single_diff post_1-post_4 post_6-post_16 


foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${single_diff} if balanced==1 & first_na==1 & second_treatment=="", absorb(id) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=4

tempfile part_1
save `part_1'
restore

reghdfe `dep_var' ${single_diff} if balanced==1 & first_op==1 & second_treatment=="", absorb(id) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=1

tempfile part_2
save `part_2'
restore

reghdfe `dep_var' ${single_diff} if balanced==1 & first_hr==1 & second_treatment=="", absorb(id) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=2

tempfile part_3
save `part_3'
restore

reghdfe `dep_var' ${single_diff} if balanced==1 & first_io==1 & second_treatment=="", absorb(id) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=3

*Append others
append using `part_1'
append using `part_2'
append using `part_3'

*Label on treatment
label define treat 1 "J-I" 2 "J-R" 3 "J-M" 4 "No training"
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

local nn=_N+1
set obs `nn'
replace treatment=2 if var==.
replace var=-1 if var==.
sort treatment var 

local nn=_N+1
set obs `nn'
replace treatment=3 if var==.
replace var=-1 if var==.
sort treatment var 

local nn=_N+1
set obs `nn'
replace treatment=4 if var==.
replace var=-1 if var==.
sort treatment var 


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


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

graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==2, color("188 80 144")) (connected coef var if treatment==2, color("188 80 144") msymbol(t) msize(small) lpatter(shortdash)) (rcap ci_upper ci_lower var if treatment==3, color("255 166 0")) (connected coef var if treatment==3, color("255 166 0") msymbol(d) msize(small) lpatter("_###")) (rcap ci_upper ci_lower var if treatment==4, color("51 160 44")) (connected coef var if treatment==4, color("51 160 44") msymbol(+) msize(small) lpatter("dot")), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.3(.1).8, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) order(2 4 6 8) label(2 "J-I") label(4 "J-R") label(6 "J-M") label(8 "No TWI")) graphregion(color(white))
graph export "${directory_results}/figureA6_`dep_var'_d`1'.pdf", replace

restore

}


