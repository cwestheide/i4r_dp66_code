* dofile: sensitivity_outcome

*-------------------------------------------------------------------------------
* DECRIPTION:

/* Tests sensitivity of the results to transformation of outcome variables. Test for
parallel trends when outcome is measured in levels. 

Uses as basis the specifications depicted in Figure 3 of the paper.
*/

*-------------------------------------------------------------------------------
* HOUSEKEEPING
* ROOT
if ("${root_replication_bg}" == "") do `"`c(sysdir_personal)'profile.do"'
do "${root_replication_bg}/code/set_environment.do"

* PACKAGES

* PARAMETERS
global significance star(* .10 ** .05 *** .01) // Option on whether to include stars in regression tables
global formats tex rtf // Formats to store tables (TeX and Word)

*-------------------------------------------------------------------------------

* LOAD DATA

cd "$data"
use app_main_outcomes_yearly.dta, clear

***********************************************************
// TESTING OUTCOME CHANGE TO LEVELS OF ROA AND ANNUAL SALES
***********************************************************

// DID FIGURES
**************

global year_effects treat_post_1-treat_post_4 treat_post_6-treat_post_16 treatment_full

// Express annual sales in millions
replace annual_sales = annual_sales / 1000000

// Back out ROA
gen roa = exp(ln_roa)

local title_annual_sales "Panel A. Annual Sales (in Millions), DID"
local title_roa "Panel B. ROA, DID"

// PRODUCE FIGURES 
foreach y in annual_sales roa {
	reghdfe `y' ${year_effects} if balanced==1 & second_treatment=="", ///
	absorb(app_window app_day county_sector_time) cluster(cluster)

	sum `y' if post_4 == 1 & treat_post_4 == 0 & balanced == 1 & second_treatment == ""
	local mean_cntrl: di %6.3f `r(mean)'

	preserve
	regsave, ci

keep if regexm(var, "_post_")

*Define treatment
gen treatment=1 if regexm(var, "^treat_")
label define treat 1 "TWI"
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


cd "$figures"
graph twoway (rcap ci_upper ci_lower var if treatment==1, color("0 63 92")) ///
	(connected coef var if treatment==1, color("0 63 92") msymbol(o) msize(small) lpatter("--...")), ///
	 yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30)) xline(3.2, lcolor(maroon*.30)) ///
	 xlabel(-5(1)10) ylabel(, nogrid angle(0)) xtitle(Years after training) ///
	  legend(off) graphregion(color(white)) title("`title_`y''", color(black)) subtitle("Mean Control in t = -1: `mean_cntrl' ") ///
	  saving(sensitivity_outcome_`y'.gph, replace)
restore
}

cd "${figures}"
graph combine sensitivity_outcome_annual_sales.gph sensitivity_outcome_roa.gph, ///
	ysize(10cm) xsize(20cm) saving(sensitivity_outcome.gph, replace)
graph export sensitivity_outcome.png, width(4000) replace

// SINGLE DIFFERENCES FIGURES
*****************************

global single_diff post_1-post_4 post_6-post_16 

local title_annual_sales "Panel C. Annual Sales (in Millions), Single Difference"
local title_roa "Panel D. ROA, Single Difference"

foreach y in annual_sales roa {
	reghdfe `y' ${single_diff} if balanced==1 & first_na==1 & second_treatment=="", ///
	absorb(id) cluster(cluster)

preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=4

tempfile part_1
save `part_1'
restore

reghdfe `y' ${single_diff} if balanced==1 & treatment_full==1 & second_treatment=="", absorb(id) cluster(cluster) 
preserve
regsave, ci

keep if regexm(var, "post_")

*Define treatment
gen treatment=3

*Append others
append using `part_1'

*Label on treatment
label define treat 3 "Treated" 4 "No training"
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


cd "$figures"
graph twoway (rcap ci_upper ci_lower var if treatment==3, color("0 63 92")) ///
 (connected coef var if treatment==3, color("0 63 92") msymbol(o) msize(small) lpatter("--...")) ///
 (rcap ci_upper ci_lower var if treatment==4, color("51 160 44")) ///
  (connected coef var if treatment==4, color("51 160 44") msymbol(+) msize(small) lpatter("dot")), ///
	 yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*.30)) xline(3.2, lcolor(maroon*.30)) ///
	 xlabel(-5(1)10) ylabel(, nogrid angle(0)) xtitle(Years after training) ///
	  legend(ring(0) pos(11) col(1) order(2 4) label(2 "TWI") label(4 "No TWI")) ///
	   graphregion(color(white)) title("`title_`y''", color(black)) saving(sensitivity_outcome_single_diff_`y'.gph, replace)
restore
}

cd "${figures}"
graph combine sensitivity_outcome_single_diff_annual_sales.gph sensitivity_outcome_single_diff_roa.gph, ///
	ysize(10cm) xsize(20cm) saving(sensitivity_outcome_single_diff.gph, replace)
graph export sensitivity_outcome_single_diff.png, width(4000) replace


// COMBINE DID AND SINGLE DIFFERENCES FIGURES
**********************************************
cd "${figures}"
graph combine sensitivity_outcome.gph sensitivity_outcome_single_diff.gph, ///
	rows(2)
graph export figure_sensitivity_outcome.png, width(4000) replace

// Erase auxiliary files
foreach f in gph png {
 cap erase sensitivity_outcome_single_diff.`f'
 cap erase sensitivity_outcome.`f'
 cap erase sensitivity_outcome_single_diff_annual_sales.`f'
 cap erase sensitivity_outcome_single_diff_roa.`f'
 cap erase sensitivity_outcome_annual_sales.`f'
 cap erase sensitivity_outcome_roa.`f'
}

// PRODUCE TABLES
*****************

	// Label 
	forvalues i = -5(1)10 {
		local j = `i' + 6

		label var treat_post_`j' "Period `i'"
	}
	label var ln_annual_sales "Log Annual Sales"
	label var ln_roa "Log ROA"
	label var annual_sales "Annual Sales (in Millions)"
	label var roa "ROA"

	qui foreach y in ln_annual_sales ln_roa annual_sales roa {

		sum `y' if post_4 == 1 & treat_post_4 == 0 & balanced == 1 & second_treatment == ""
		local mean_cntrl: di %6.3f `r(mean)'

		eststo est_`y': reghdfe `y' ${year_effects} if balanced==1 & second_treatment=="", ///
		absorb(app_window app_day county_sector_time) cluster(cluster)
		estadd local mean_cntrl = `mean_cntrl'
		estadd local sample "Same as Figure 3"
	}

	local table_specs s(N sample mean_cntrl, label("Observations" "Sample" "Mean Control Group in t = -1") ///
		 fmt(%9.0fc)) ///
		drop(treatment_full _cons)  ///
		$significance label se(a2) b(a2) replace

	// Show output
	esttab est_ln_annual_sales est_ln_roa est_annual_sales est_roa, `table_specs'

	// Save table
	cd "${tables}"
	foreach f in $formats {
		esttab est_ln_annual_sales est_ln_roa est_annual_sales est_roa using tab_sensitivity_outcomes.`f', `table_specs'
		}
		
