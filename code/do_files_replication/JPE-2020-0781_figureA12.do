***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A12
***Other Heterogeneous Effects

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full

***Panel A: Sectors
*Yearly effects
foreach dep_var of var ln_tfpr  {

forvalues i=1/4 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & sector==`i', absorb(time) cluster(cluster) `version'
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
label define alt_treat 1 "Agriculture" 2 "Manufacturing" 3 "Transportation" 4 "Services"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--...")) ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--...")) ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(O) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--...")) ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92") mlwidth(thin) msymbol(Oh) msize(large) lwidth(vthin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "Agriculture") label(4 "Manufacturing") label(6 "Transportation") label(8 "Services")) graphregion(color(white))
graph export "${directory_results}/figureA12_`dep_var'_sector`1'.pdf", replace

restore

}


***Panel B: Regions
*Yearly effects
foreach dep_var of var ln_tfpr {

forvalues i=1/4 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & geo==`i', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
label define alt_treat 1 "North East" 2 "Midwest" 3 "South" 4 "West"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(O) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92") mlwidth(thin)  msymbol(Oh) msize(large) lwidth(vthin) lpatter("--..."))  ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "J-I, North East") label(4 "J-I, Midwest") label(6 "J-I, South") label(8 "J-I, West")) graphregion(color(white))
graph export "${directory_results}/figure_A12_`dep_var'_geo`1'.pdf", replace

restore

}


*Panel C: Treatment years
*Yearly effects
foreach dep_var of var ln_tfpr {

forvalues i=1/4 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & alternative_treatment_year==`i', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
label define alt_treat 1 "1940-1942" 2 "1943" 3 "1944" 4 "1945"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(O) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92") mlwidth(thin) msymbol(Oh) msize(large) lwidth(vthin) lpatter("--...")) /// 
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "1940-1942") label(4 "1943") label(6 "1944") label(8 "1945")) graphregion(color(white))
graph export  "${directory_results}/figureA12_`dep_var'_byyear`1'.pdf", replace

restore

}


*Panel D: Firm size
*Yearly effects
foreach dep_var of var ln_tfpr {

forvalues i=1/4 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & quart_size==`i', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
label define alt_treat 1 "Quartile 1" 2 "Quartile 2" 3 "Quartile 3" 4 "Quartile 4"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(O) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92") mlwidth(thin) msymbol(Oh) msize(large) lwidth(vthin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "Quartile 1") label(4 "Quartile 2") label(6 "Quartile 3") label(8 "Quartile 4")) graphregion(color(white))
graph export "${directory_results}/figureA12_`dep_var'_size`1'.pdf", replace

restore

}


*Panel E: Initial TFP level
*Yearly effects
foreach dep_var of var ln_tfpr {

forvalues i=1/4 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & quart_`dep_var'==`i', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
label define alt_treat 1 "Quartile 1" 2 "Quartile 2" 3 "Quartile 3" 4 "Quartile 4"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(O) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92") mlwidth(thin)  msymbol(Oh) msize(large) lwidth(vthin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "Quartile 1") label(4 "Quartile 2") label(6 "Quartile 3") label(8 "Quartile 4")) graphregion(color(white))
graph export "${directory_results}/figureA12_`dep_var'_perf`1'.pdf", replace

restore

}


*Panel F: Instructors from private sector
*Yearly effects
foreach dep_var of var ln_tfpr  {

forvalues i=1/3 {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & median_priv==`i', absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
label define alt_treat 1 "Tertile 1" 2 "Tertile 2" 3 "Tertile 3"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(Oh) mlwidth(thin) msize(large) lwidth(vthin) lpatter("--..."))  ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6) label(2 "Tertile 1") label(4 "Tertile 2") label(6 "Tertile 3")) graphregion(color(white))
graph export "${directory_results}/figureA12_`dep_var'_govt`1'.pdf", replace

restore

}

