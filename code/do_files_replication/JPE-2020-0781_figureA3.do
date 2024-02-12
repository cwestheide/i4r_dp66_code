***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A3
***Influence of Higher Attrition Among Nontrained Applicants

if inlist(`1', 3, 5) {
	local version "version(`1')"
}


***Panel A: Kaplan-Meier Survival Curve

use "${directory_data}/exit.dta", clear

stset periods_alive, failure(exit)


gen treat1=0 if type_treatment=="NA"
replace treat1=1 if type_treatment=="OP" | type_treatment=="HR"| type_treatment=="IO"
label define treat1 0 "No Training" 1 "TWI Training"

sts graph if second_treatment=="", by(treat1) ci ci1opts(fintensity(inten30) fcolor(ltblue) lwidth(none)) ci2opts(fintensity(inten30) fcolor(maroon) lwidth(none)) ///
ylabel(0.6(0.1)1) legend(ring(0) pos(7) col(1) row(2) order(6 5) label(5 "No training") label(6 "TWI Training")) ///
xtitle("Years since TWI Training") ytitle("Estimated Survival Probability") title("") graphregion(color(white))

graph export "${directory_results}/figureA3_panelA`1'.pdf", replace


***Panels B and C: Sales and TFP, Unbalanced sample
use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full

global keep_year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16


foreach dep_var of var ln_tfpr ln_annual_sales {

forvalues i=1/2 {

if `i'==1 local conditions "if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time)"
if `i'==2 local conditions "if second_treatment=="", absorb(app_window app_day county_sector_time)"

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
label define alt_treat 1 "Balanced" 2 "Unbalanced"
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


graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Oh) mlwidth(thin) msize(medlarge) lwidth(vthin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(`pos') col(1) size(small) order(2 4) label(2 "Balanced") label(4 "Unbalanced")) graphregion(color(white))
graph export "${directory_results}/figureA3_`dep_var'_unbalanced`1'.pdf", replace

restore

}

****Panels D and E: Sales and TFP, treatment-bound effects
use "${directory_data}/app_main_outcomes_yearly.dta", clear

drop quart_ln_tfpr

foreach dep_var of var ln_tfpr ln_annual_sales {
xtile quart_`dep_var'=`dep_var' if time==-1 & balanced==1 & treatment_full==1, nq(4)
by id, s: egen max=max(quart_`dep_var')
drop quart_`dep_var'
rename max quart_`dep_var'
replace quart_`dep_var'=2 if treatment_full==0
}


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


global keep_year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16


*Yearly effects
foreach dep_var of var ln_tfpr ln_annual_sales {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & quart_`dep_var'<4, absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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



*Yearly effects
foreach dep_var of var ln_tfpr ln_annual_sales {

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & quart_`dep_var'>1 & quart_`dep_var'!=., absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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
gen alternative_time=2

tempfile `dep_var'_alt_time_1
save ``dep_var'_alt_time_1'
restore

}



*Graph them with the baseline
***Load dataset
use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full

global keep_year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16


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
append using ``dep_var'_alt_time_1'
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alternative_time==1, color("0 63 92")) (connected coef var if treatment==1 & alternative_time==1, color("0 63 92") msymbol(o) mlwidth(thin) lwidth(thin) msize(small) lpatter("solid")) ///
(rcap ci_upper ci_lower var if treatment==1 & alternative_time==0, color("0 63 92")) (connected coef var if treatment==1 & alternative_time==0, color("0 63 92") msymbol(Oh) mlwidth(thin) lwidth(thin) lpatter("dash")) ///
(rcap ci_upper ci_lower var if treatment==1 & alternative_time==2, color("0 63 92")) (connected coef var if treatment==1 & alternative_time==2, color("0 63 92") msymbol(Dh) mlwidth(thin) lwidth(thin) lpatter("--...")) ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(`down'(`steps')`up', format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) order(2 4 6) label(2 "Baseline") label(4 "No top performers") label(6 "No bottom performers")) graphregion(color(white))

graph export "${directory_results}/figureA3_`dep_var'_te_bounds`1'.pdf", replace

restore

}

***Panel F: Lee Bounds
//cap log close
//cap log using "${directory_results}/figureA3_ln_tfpr_lee", replace
foreach var of varlist ln_tfpr {

forvalues i=1/10 {

leebounds `var' treatment_full  if time==`i'  & second_treatment=="", tight(sector)
}

}
//cap log close

use "${directory_data}/lee_bounds.dta", clear

graph twoway ///
(rcap ci_upper_lower ci_lower_lower period if tight=="YES" & variables=="ln_tfpr", color("0 63 92") lwidth(vthin)) ///
(connected upper period if tight=="YES" & variables=="ln_tfpr", color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--...")) ///
(rcap ci_upper_upper ci_lower_upper period if tight=="YES" & variables=="ln_tfpr", color("0 63 92") lwidth(vthin)) ///
(connected lower period if tight=="YES" & variables=="ln_tfpr", color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
, yline(0, lcolor(black)) xlabel(0(1)10) ylabel(-0.1(0.1)0.5, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4) label(2 "Upper Lee bound") label(4 "Lower Lee bound")) graphregion(color(white))
graph export "${directory_results}/figureA3_lee_bounds`1'.pdf", replace


***Panels G and H: imputing TFP
use "${directory_data}/app_main_outcomes_yearly.dta", clear

*Generate hypothetical tfpr
gen ln_tfpr_hypo_99=ln_tfpr
gen ln_tfpr_hypo_95=ln_tfpr
gen ln_tfpr_hypo_90=ln_tfpr
gen ln_tfpr_hypo_75=ln_tfpr
gen ln_tfpr_hypo_50=ln_tfpr

forvalues i=1/10 {

sum ln_tfpr if balanced==1 & time==`i' & second_treatment=="", d
local p_99_`i'=r(p99)
local p_95_`i'=r(p95)
local p_90_`i'=r(p90)
local p_75_`i'=r(p75)
local p_50_`i'=r(p50)

replace ln_tfpr_hypo_99=`p_99_`i'' if ln_tfpr_hypo_99==. & balanced==0 & time==`i'
replace ln_tfpr_hypo_95=`p_95_`i'' if ln_tfpr_hypo_95==. & balanced==0 & time==`i'
replace ln_tfpr_hypo_90=`p_90_`i'' if ln_tfpr_hypo_90==. & balanced==0 & time==`i'
replace ln_tfpr_hypo_75=`p_75_`i'' if ln_tfpr_hypo_75==. & balanced==0 & time==`i'
replace ln_tfpr_hypo_50=`p_50_`i'' if ln_tfpr_hypo_50==. & balanced==0 & time==`i'

}


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


local counter=0

foreach dep_var of var ln_tfpr ln_tfpr_hypo_99 ln_tfpr_hypo_95 ln_tfpr_hypo_90 ln_tfpr_hypo_75 ln_tfpr_hypo_50 {

if "`dep_var'"=="ln_tfpr" local command replace
if "`dep_var'"!="ln_tfpr" local command append

local counter=`counter'+1

reghdfe `dep_var' ${year_effects} if  second_treatment=="", absorb(app_window app_day county_sector_time) cluster(subdistrict) `version'

*Put in a graph
preserve
regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")


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
gen alt_treat=`counter'

tempfile alt_treat_`counter'
save `alt_treat_`counter''
restore

}
 


preserve
use `alt_treat_1', clear
append using `alt_treat_2'
append using `alt_treat_3'
append using `alt_treat_4'
append using `alt_treat_5'
append using `alt_treat_6'

*Label of alt_treat
label define alt_treat 1 "Baseline" 2 "99 perc" 3 "95 perc" 4 "90 perc" 5 "75 perc" 6 "Median"
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

graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))   ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==3, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==4, color("0 63 92%30") msymbol(Oh) mlwidth(thin) msize(large) lwidth(vthin) lpatter("--..."))  ///
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4 6 8) label(2 "99th perc.") label(4 "95th perc.") label(6 "90th perc.")) graphregion(color(white))
graph export "${directory_results}/figureA3_ln_tfpr_hypo_2`1'.pdf", replace


graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==5, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==5, color("0 63 92") msymbol(o) mlwidth(thin) msize(small) lwidth(vthin) lpatter("--..."))   ///
(rcap ci_upper ci_lower var if treatment==1 & alt_treat==6, color("0 63 92") lwidth(vthin)) (connected coef var if treatment==1 & alt_treat==6, color("0 63 92") msymbol(Oh) mlwidth(thin)  msize(small) lwidth(vthin) lpatter("--..."))  ///  
, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(ring(0) pos(11) col(1) size(vsmall) order(2 4) label(2 "75th perc,") label(4 "Median")) graphregion(color(white))
graph export "${directory_results}/figureA3_ln_tfpr_hypo_1`1'.pdf", replace

restore



