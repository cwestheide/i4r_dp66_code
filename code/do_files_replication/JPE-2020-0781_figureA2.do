***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021


if inlist(`1', 3, 5) {
	local version "version(`1')"
}

***Description: Replication of Figure A2
***Pre-TWI Trends

use "${directory_data}/pre_trends.dta", clear


global nonlinear_trends treat_period_1 treat_period_2 treat_period_3 treat_period_4 period1 period2 period3 period4 treatment


*Nonlinear trends
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${nonlinear_trends} if balanced==1, absorb(app_window app_day county_sector) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_period_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_period")
label define treat 1 "Treat"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="-1" if regexm(var,"_5$")
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
forvalues i=1/1 {
local nn=_N+1
set obs `nn'
replace treatment=`i' if var==.
replace var=-1 if var==.
sort treatment var 
}


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*10
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


*All
graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")), yline(0, lcolor(black)) xlabel(-5(1)-1) ylabel(-0.1(0.025)0.1, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) graphregion(color(white))
graph export "${directory_results}/figureA2_`dep_var'_onetreat`1'.pdf", replace

restore
}


global nonlinear_trends hr_period_1 hr_period_2 hr_period_3 hr_period_4 op_period_1 op_period_2 op_period_3 op_period_4 io_period_1 io_period_2 io_period_3 io_period_4  hr_op_period_1 hr_op_period_2 hr_op_period_3 hr_op_period_4 hr_io_period_1 hr_io_period_2 hr_io_period_3 hr_io_period_4 op_io_period_1 op_io_period_2 op_io_period_3 op_io_period_4  hr_io_op_period_1 hr_io_op_period_2 hr_io_op_period_3 hr_io_op_period_4 period1 period2 period3 period4 hr op io hr_op hr_io op_io hr_io_op


*Nonlinear trends
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${nonlinear_trends} if balanced==1, absorb(app_window app_day county_sector) cluster(cluster) `version'
preserve
regsave, ci

keep if regexm(var, "_period_")

*Define treatment
gen treatment=1 if regexm(var, "^op_period")
replace treatment=2 if regexm(var, "^hr_period")
replace treatment=3 if regexm(var, "^io_period")
replace treatment=4 if regexm(var, "^hr_op_period")
replace treatment=5 if regexm(var, "^hr_io_period")
replace treatment=6 if regexm(var, "^op_io_period")
replace treatment=7 if regexm(var, "^hr_io_op_period")
label define treat 1 "J-I" 2 "J-R" 3 "J-M" 4 "J-I and J-R" 5 "J-R and J-M" 6 "J-I and J-M" 7 "All"
label values treatment treat

*Define periods
replace var="-5" if regexm(var,"_1$")
replace var="-4" if regexm(var,"_2$")
replace var="-3" if regexm(var,"_3$")
replace var="-2" if regexm(var,"_4$")
replace var="-1" if regexm(var,"_5$")
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
forvalues i=1/7 {
local nn=_N+1
set obs `nn'
replace treatment=`i' if var==.
replace var=-1 if var==.
sort treatment var 
}


*Missing values are zeros
foreach var of varlist coef stderr ci_lower ci_upper {
replace `var'=0 if `var'==.
}


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*15
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


*All
graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==2, color("188 80 144")) (connected coef var if treatment==2, color("188 80 144") msymbol(t) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==3, color("255 166 0")) (connected coef var if treatment==3, color("255 166 0") msymbol(d) msize(small) lpatter(shortdash)) (rcap ci_upper ci_lower var if treatment==4, color("203 24 29")) (connected coef var if treatment==4, color("203 24 29") msymbol(s) msize(small) lpatter("_###")) (rcap ci_upper ci_lower var if treatment==5, color("65 171 93")) (connected coef var if treatment==5, color("65 171 93") msymbol(v) msize(small) lpatter(longdash)) (rcap ci_upper ci_lower var if treatment==6, color("227 26 28")) (connected coef var if treatment==6, color("227 26 28") msymbol(+) msize(small) lpatter(dot))  (rcap ci_upper ci_lower var if treatment==7, color("106 81 163")) (connected coef var if treatment==7, color("106 81 163") msymbol(Oh) msize(small) lpatter("_...###-...")), yline(0, lcolor(black)) xlabel(-5(1)-1) ylabel(-0.10(0.025)0.10, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(3) order(2 4 6 8 10 12 14) label(2 "J-I") label(4 "J-R") label(6 "J-M") label(8 "J-I and J-R") label(10 "J-R and J-M") label(12 "J-I and J-M") label(14 "All")) graphregion(color(white))
graph export "${directory_results}/figureA2_`dep_var'_no_order`1'.pdf", replace

restore
}


