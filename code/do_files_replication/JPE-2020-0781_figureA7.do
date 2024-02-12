***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A7
***Horizontal Spillovers

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/horizontal_main.dta", clear


*Globals for simple specifications with just treated (same vs. diff) and nontreated (same vs. diff)
global year_simple num_same_treat_post_1 num_same_treat_post_2 num_same_treat_post_3 num_same_treat_post_4 num_same_treat_post_6 num_same_treat_post_7 num_same_treat_post_8 num_same_treat_post_9 num_same_treat_post_10 num_same_treat_post_11 num_same_treat_post_12 num_same_treat_post_13 num_same_treat_post_14 num_same_treat_post_15 num_same_treat_post_16 num_diff_treat_post_1 num_diff_treat_post_2 num_diff_treat_post_3 num_diff_treat_post_4 num_diff_treat_post_6 num_diff_treat_post_7 num_diff_treat_post_8 num_diff_treat_post_9 num_diff_treat_post_10 num_diff_treat_post_11 num_diff_treat_post_12 num_diff_treat_post_13 num_diff_treat_post_14 num_diff_treat_post_15 num_diff_treat_post_16 num_same_na_post_1 num_same_na_post_2 num_same_na_post_3 num_same_na_post_4 num_same_na_post_6 num_same_na_post_7 num_same_na_post_8 num_same_na_post_9 num_same_na_post_10 num_same_na_post_11 num_same_na_post_12 num_same_na_post_13 num_same_na_post_14 num_same_na_post_15 num_same_na_post_16 num_diff_na_post_1 num_diff_na_post_2 num_diff_na_post_3 num_diff_na_post_4 num_diff_na_post_6 num_diff_na_post_7 num_diff_na_post_8 num_diff_na_post_9 num_diff_na_post_10 num_diff_na_post_11 num_diff_na_post_12 num_diff_na_post_13 num_diff_na_post_14 num_diff_na_post_15 num_diff_na_post_16 post_2-post_16 num_same_treat num_diff_treat num_same_na num_diff_na


*Globals for simple specifications with just treated (same vs. diff) and nontreated (same vs. diff) using mean distance, not number of firms
global dist_year_simple dist_same_treat_post_1 dist_same_treat_post_2 dist_same_treat_post_3 dist_same_treat_post_4 dist_same_treat_post_6 dist_same_treat_post_7 dist_same_treat_post_8 dist_same_treat_post_9 dist_same_treat_post_10 dist_same_treat_post_11 dist_same_treat_post_12 dist_same_treat_post_13 dist_same_treat_post_14 dist_same_treat_post_15 dist_same_treat_post_16 dist_diff_treat_post_1 dist_diff_treat_post_2 dist_diff_treat_post_3 dist_diff_treat_post_4 dist_diff_treat_post_6 dist_diff_treat_post_7 dist_diff_treat_post_8 dist_diff_treat_post_9 dist_diff_treat_post_10 dist_diff_treat_post_11 dist_diff_treat_post_12 dist_diff_treat_post_13 dist_diff_treat_post_14 dist_diff_treat_post_15 dist_diff_treat_post_16 dist_same_na_post_1 dist_same_na_post_2 dist_same_na_post_3 dist_same_na_post_4 dist_same_na_post_6 dist_same_na_post_7 dist_same_na_post_8 dist_same_na_post_9 dist_same_na_post_10 dist_same_na_post_11 dist_same_na_post_12 dist_same_na_post_13 dist_same_na_post_14 dist_same_na_post_15 dist_same_na_post_16 dist_diff_na_post_1 dist_diff_na_post_2 dist_diff_na_post_3 dist_diff_na_post_4 dist_diff_na_post_6 dist_diff_na_post_7 dist_diff_na_post_8 dist_diff_na_post_9 dist_diff_na_post_10 dist_diff_na_post_11 dist_diff_na_post_12 dist_diff_na_post_13 dist_diff_na_post_14 dist_diff_na_post_15 dist_diff_na_post_16 post_2-post_16 dist_same_treat dist_diff_treat dist_same_na dist_diff_na



*Yearly effects -simple specifications
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${year_simple}, absorb(id) cluster(subdistrict) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "same_treat")
replace treatment=2 if regexm(var, "diff_treat")
replace treatment=3 if regexm(var, "same_na")
replace treatment=4 if regexm(var, "diff_na")
label define treat 1 "Same treated" 2 "Different treated" 3 "Same not treated" 4 "Different not treated"
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
gen add=max_upper*5
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

graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==2, color("188 80 144")) (connected coef var if treatment==2, color("188 80 144") msymbol(t) msize(small) lpatter(shortdash)) (rcap ci_upper ci_lower var if treatment==3, color("255 166 0")) (connected coef var if treatment==3, color("255 166 0") msymbol(d) msize(small) lpatter("_###")) (rcap ci_upper ci_lower var if treatment==4, color("51 160 44")) (connected coef var if treatment==4, color("51 160 44") msymbol(+) msize(small) lpatter("dot")), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.4f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(small) order(2 4 6 8) label(2 "Treated, same sector") label(4 "Treated, diff. sector") label(6 "Not treated, same sector") label(8 "Not treated, diff. sector")) graphregion(color(white))
graph export "${directory_results}/figureA7_`dep_var'_simple_year`1'.pdf", replace

restore

}


*Yearly effects -simple and distance specifications
foreach dep_var of var ln_tfpr ln_annual_sales ln_roa {

reghdfe `dep_var' ${dist_year_simple}, absorb(id) cluster(subdistrict) `version'
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "same_treat")
replace treatment=2 if regexm(var, "diff_treat")
replace treatment=3 if regexm(var, "same_na")
replace treatment=4 if regexm(var, "diff_na")
label define treat 1 "Same treated" 2 "Different treated" 3 "Same not treated" 4 "Different not treated"
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
gen add=max_upper*5
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

graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (rcap ci_upper ci_lower var if treatment==2, color("188 80 144")) (connected coef var if treatment==2, color("188 80 144") msymbol(t) msize(small) lpatter(shortdash)) (rcap ci_upper ci_lower var if treatment==3, color("255 166 0")) (connected coef var if treatment==3, color("255 166 0") msymbol(d) msize(small) lpatter("_###")) (rcap ci_upper ci_lower var if treatment==4, color("51 160 44")) (connected coef var if treatment==4, color("51 160 44") msymbol(+) msize(small) lpatter("dot")), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3) ) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.4f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(small) order(2 4 6 8) label(2 "Treated, same sector") label(4 "Treated, diff. sector") label(6 "Not treated, same sector") label(8 "Not treated, diff. sector")) graphregion(color(white))
graph export "${directory_results}/figureA7_`dep_var'_simple_dist_year`1'.pdf", replace

restore

}

