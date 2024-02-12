***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure A4
***Comparison with Effect Sizes in the Literature

if inlist(`1', 3, 5) {
	local version "version(`1')"
}


use "${directory_data}/app_main_outcomes_yearly.dta", clear



global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full

global keep_year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16

*Panel A: Output
reghdfe ln_annual_sales ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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

*Add bloom
gen bloom=0.09 if var==1
gen higuchi=0.31 if var==3
gen giorcelli=0.125 if var==5
gen giorcelli_2=0.208 if var==10


*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.25
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


graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (scatter bloom var if var==1 & treatment==1, color(red) msymbol(O)) (scatter higuchi var if var==3 & treatment==1, color(red) msymbol(O)) (scatter giorcelli var if var==5 & treatment==1, color(red) msymbol(O)) (scatter giorcelli_2 var if var==10 & treatment==1, color(red) msymbol(O)), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30)) xline(3.2, lcolor(maroon*.30)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) text(0.107 -1.5 "Bloom et al. (2013)", size(small) place(e)) text(0.32 3 "Higuchi et al. (2016)", size(small) place(nw)) text(0.10 5 "Giorcelli (2019)", size(small) place(n)) text(0.23 10.7 "Giorcelli (2019)", size(small) place(sw)) graphregion(color(white))
graph export "${directory_results}/figureA4_ln_annual_sales`1'.pdf", replace

restore

*Panel B: TFPR
reghdfe ln_tfpr ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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

*Add bloom
gen bloom=0.154 if var==1
gen giorcelli=0.221 if var==5
gen giorcelli_2=0.312 if var==10

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


graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (scatter bloom var if var==1 & treatment==1, color(red) msymbol(O)) (scatter giorcelli var if var==5 & treatment==1, color(red) msymbol(O)) (scatter giorcelli_2 var if var==10 & treatment==1, color(red) msymbol(O)), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30)) xline(3.2, lcolor(maroon*.30)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.35, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) text(0.16 1 "Bloom et al. (2013)", size(small) place(w)) text(0.23 5 "Giorcelli (2019)", size(small) place(n)) text(0.315 9.9 "Giorcelli (2019)", size(small) place(w)) graphregion(color(white))
graph export "${directory_results}/figureA4_ln_tfpr`1'.pdf", replace

restore


*Panel C: Employees
reghdfe ln_employees ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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

*Add bloom
gen bruhn=0.45 if var==5
gen giorcelli=0.069 if var==5
gen giorcelli_2=0.219 if var==10

*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.7
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


graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (scatter bruhn var if var==5 & treatment==1, color(red) msymbol(O)) (scatter giorcelli var if var==5 & treatment==1, color(red) msymbol(O)) (scatter giorcelli_2 var if var==10 & treatment==1, color(red) msymbol(O)), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30*30)) xline(3.2, lcolor(maroon*.30*30)) xlabel(-5(1)10) ylabel(-0.05(0.05)0.45, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) text(0.44 5 "Bruhn et al. (2018)", size(small) place(s)) text(0.063 5.1 "Giorcelli (2019)", size(small) place(se)) text(0.219 9.9 "Giorcelli (2019)", size(small) place(w)) graphregion(color(white))
graph export "${directory_results}/figureA4_ln_employees`1'.pdf", replace

restore


*Panel D: Inventory
reghdfe ln_inventory ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'
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

*Add bloom
gen bloom=-0.245 if var==1

*Labels of the y variables
egen max_upper=max(ci_upper)
egen min_lower=min(ci_lower)
gen add=max_upper*0.5
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


graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) (connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) (scatter bloom var if var==1 & treatment==1, color(red) msymbol(O)), yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30)) xline(3.2, lcolor(maroon*.30)) xlabel(-5(1)10) ylabel(-0.25(0.05)0.05, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(off) text(-0.24 1 "Bloom et al. (2013)", size(small) place(n)) graphregion(color(white))
graph export "${directory_results}/figureA4_ln_inventory`1'.pdf", replace

restore


