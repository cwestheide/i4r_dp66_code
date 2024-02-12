* dofile: sensitivity_fixed_effects

*-------------------------------------------------------------------------------
* DECRIPTION:

/* Tests sensitivity for changes in the main specification, namely, by changing the 
fixed effects included, adding ROA, for which robustness was not presented in the paper.

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


// COMPARING SPECIFICATIONS WITH DIFFERENT FIXED EFFECT COMBINATIONS
********************************************************************

local title_ln_annual_sales "Panel A. Log Annual Sales"
local title_ln_tfpr "Panel B. Log TFP"
local title_ln_roa "Panel C. Log ROA"

global year_effects treat_post_1-treat_post_4 treat_post_6-treat_post_16 treatment_full



reghdfe ln_tfpr ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster)
gen keep_obs=(e(sample))

foreach y in ln_annual_sales ln_tfpr ln_roa {

forvalues i=1/4 {

if `i'==1 local conditions "absorb(app_window app_day county_sector_time)"
if `i'==2 local conditions "absorb(id year time)"
if `i'==3 local conditions "absorb(app_day county_sector_time)"
if `i'==4 local conditions "absorb(app_window county_sector_time)"


reghdfe `y' ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, `conditions' cluster(cluster)

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
label define alt_treat 1 "Main Spec." 2 "Firm + Year + Time FE" 3 "App Day FE + County-Sector-Time FE" 4 "App Window FE + County-Sector-Time FE"
label values alt_treat alt_treat


cd "${figures}"
graph twoway (rcap ci_upper ci_lower var if treatment==1 & alt_treat==1, color("0 63 92") lwidth(vthin)) ///
	 (connected coef var if treatment==1 & alt_treat==1, color("0 63 92") msymbol(o) msize(small) mlwidth(vthin) lpatter("--..."))  ///
 	(rcap ci_upper ci_lower var if treatment==1 & alt_treat==2, color("0 63 92") lwidth(vthin)) ///
 	 (connected coef var if treatment==1 & alt_treat==2, color("0 63 92") msymbol(Th) msize(medlarge) mlwidth(vthin) lpatter("--..."))  ///
 	(rcap ci_upper ci_lower var if treatment==1 & alt_treat==3, color(green) lwidth(vthin)) ///
 	(connected coef var if treatment==1 & alt_treat==3, color(green) mfcolor(%30) msize(large) msymbol(Dh) mlwidth(vthin) lpatter("--...")) ///
 	(rcap ci_upper ci_lower var if treatment==1 & alt_treat==4, color(maroon) lwidth(vthin)) ///
 	(connected coef var if treatment==1 & alt_treat==4, color(maroon) mfcolor(%30) msize(large) msymbol(Sh) mlwidth(vthin) lpatter("--...")) ///
 	, yline(0, lcolor(black)) xline(-0.8, lcolor(maroon*0.3)) xline(3.2, lcolor(maroon*0.3)) xlabel(-5(1)10) ///
 	 ylabel(, format(%6.2f) nogrid angle(0)) xtitle(Years after training) legend(pos(6) col(2) size(small) order(2 4 6 8) ///
 	  label(2 "Main Spec.") label(4 "Firm + Year + Time FE") label(6 "App Day FE + County-Sector-Time FE") label(8 "App Window FE + County-Sector-Time FE")) graphregion(color(white)) ///
 	 title("`title_`y''", color(black))  saving(sensitivity_fe_`y'.gph, replace)
restore
}

// Combine graphs and save figure
cd "${figures}"
grc1leg sensitivity_fe_ln_annual_sales.gph sensitivity_fe_ln_tfpr.gph sensitivity_fe_ln_roa.gph, ///
	span cols(3) 
graph display, ysize(12) xsize(30)
graph export fig_sensitivity_fe.png, width(4000) replace

// Eliminate auxiliay files
cd "${figures}"
foreach y in ln_annual_sales ln_tfpr ln_roa {
	cap erase sensitivity_fe_`y'.gph
}


// PRODUCE TABLES
*****************
estimates clear 

// Label 
forvalues i = -5(1)10 {
	local j = `i' + 6

	label var treat_post_`j' "Period `i'"
}
label var ln_annual_sales "Log Annual Sales"
	
	qui: {
	// Paper Specification 
	eststo: reghdfe ln_annual_sales ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, ///
		absorb(app_window app_day county_sector_time) cluster(cluster)

	estadd local fe_app_window "Yes"
	estadd local fe_app_day "Yes"
	estadd local fe_county_sector_time "Yes"
	estadd local fe_time "No"
	estadd local fe_year "No"
	estadd local fe_firm "No"


	// Year, Firm FE
	eststo: reghdfe ln_annual_sales ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, ///
		absorb(id time year) cluster(cluster)
	
	estadd local fe_app_window "No"
	estadd local fe_app_day "No"
	estadd local fe_county_sector_time "No"
	estadd local fe_time "Yes"
	estadd local fe_year "Yes"
	estadd local fe_firm "Yes"

	// Application day, county-sector-time
	eststo: reghdfe ln_annual_sales ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, ///
		absorb(app_day county_sector_time) cluster(cluster)
	
	estadd local fe_app_window "No"
	estadd local fe_app_day "Yes"
	estadd local fe_county_sector_time "Yes"
	estadd local fe_time "No"
	estadd local fe_year "No"
	estadd local fe_firm "No"

	// Application day, county-sector-time
	eststo: reghdfe ln_annual_sales ${year_effects} if balanced==1 & second_treatment=="" & keep_obs==1, ///
		absorb(app_window county_sector_time) cluster(cluster)
	
	estadd local fe_app_window "Yes"
	estadd local fe_app_day "No"
	estadd local fe_county_sector_time "Yes"
	estadd local fe_time "No"
	estadd local fe_year "No"
	estadd local fe_firm "No"
}

local table_specs s(N fe_app_window fe_app_day fe_county_sector_time fe_time fe_year fe_firm,  ///
	 label("Observations" "Application Window FE" "Application Day FE" "County-Sector-Time FE" "Time FE" "Year FE" "Firm FE") ///
	 fmt(%9.0fc)) ///
	drop(treatment_full _cons)  ///
	$significance label se(a2) b(a2) mlabel(none) replace

// Show output
esttab est1 est2 est3 est4, `table_specs'

// Save table
cd "${tables}"
foreach f in $formats {
	esttab est1 est2 est3 est4 using tab_sensitivity_fe.`f', `table_specs'
	}
	
