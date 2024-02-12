

****Panels B and E: Sales and TFP, alternative clustering
use "${directory_data}/app_main_outcomes_yearly.dta", clear


global year_effects treat_post_1 treat_post_2 treat_post_3 treat_post_4 treat_post_6 treat_post_7 treat_post_8 treat_post_9 treat_post_10 treat_post_11 treat_post_12 treat_post_13 treat_post_14 treat_post_15 treat_post_16 post_2-post_16 treatment_full


*Yearly effects
reghdfe ln_tfpr ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) old
gen keep_obs=(e(sample))


foreach dep_var of var ln_tfpr ln_annual_sales {

forvalues i=1/4 {

if `i'==1 local conditions "cluster"		// group(subdistrict app_window)
if `i'==2 local conditions "subdistrict"
if `i'==3 local conditions "county_sector_time"	// doesn't exist. only county_sector_time
if `i'==4 local conditions "id"

reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, absorb(app_window app_day county_sector_time) cluster(`conditions') old
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
graph export "${directory_results}/figureA5_`dep_var'_clustering.eps", replace

restore

}

