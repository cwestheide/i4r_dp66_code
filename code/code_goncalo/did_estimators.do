* dofile: did_estimators

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

* PACKAGES
ssc install eventstudyweights
ssc install eventstudyinteract
ssc instal csdid


*-------------------------------------------------------------------------------

* LOAD DATA
cd "$data"
use app_main_outcomes_yearly.dta, clear


// KEEP RESULTS FROM MAIN SPECIFICATIONS

global year_effects treat_post_1-treat_post_4 treat_post_6-treat_post_16 treatment_full


foreach y in ln_annual_sales ln_tfpr ln_roa {

	// Generate matrix for results 
	matrix mat_`y' = J(16,3,.)
	matrix mat_`y' = J(16,3,.)

	reghdfe `y' ${year_effects} if balanced==1 & second_treatment=="", ///
		absorb(app_window app_day county_sector_time) cluster(cluster)

	// Store results into matrix
	forvalues j = 1(1)4{
		matrix mat_`y'[`j',1] = e(b)[1,`j']
		matrix mat_`y'[`j',2] = e(b)[1,`j'] -  invttail(e(df_r),0.025)*sqrt(e(V)[`j',`j'])
		matrix mat_`y'[`j',3] = e(b)[1,`j'] +  invttail(e(df_r),0.025)*sqrt(e(V)[`j',`j'])
		}

		matrix mat_`y'[5,1] = 0
		matrix mat_`y'[5,2] = 0
		matrix mat_`y'[5,3] = 0

	forvalues j = 6(1)16{
		local k = `j' -1
		matrix mat_`y'[`j',1] = e(b)[1,`k']
		matrix mat_`y'[`j',2] = e(b)[1,`k'] -  invttail(e(df_r),0.025)*sqrt(e(V)[`k',`k'])
		matrix mat_`y'[`j',3] = e(b)[1,`k'] +  invttail(e(df_r),0.025)*sqrt(e(V)[`k',`k'])
		}

	matrix rownames mat_`y' = "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
}



************************************
* SUN AND ABRAHAM (2020) ESTIMATOR
************************************

// PREPARE DATA

// Cohort categorical variable - year in which firm first got treated
gen treat_post_year = year if treat_post == 1
bysort id: egen first_treat = min(treat_post_year)
drop treat_post_year

// Relative time variable
gen rt = year - first_treat

// Relative time indicators
forvalues i = 5(-1)2 {
	gen rt_`i' = (rt == -`i')
}
forvalues i = 0(1)10 {
	gen rt`i' = (rt == `i')
}

// Indicator for never treated firms
gen never_treat = (first_treat == .)


// Run SA(2020) estimator

foreach y in ln_annual_sales ln_tfpr ln_roa {

	// Generate matrix for results 
	matrix mat_`y'_1 = J(16,3,.)
	matrix mat_`y'_2 = J(16,3,.)


forvalues i = 1(1)2 {

	if `i'==1 local conditions "absorb(app_window app_day county_sector_time)"
	if `i'==2 local conditions "absorb(id year)"

	eventstudyinteract `y' rt_* rt0-rt10 if balanced == 1 & second_treatment == "", ///
	cohort(first_treat) control_cohort(never_treat) ///
	`conditions' vce(cluster cluster)


	// Store results into matrices
	forvalues j = 1(1)4{
		matrix mat_`y'_`i'[`j',1] = e(b_iw)[1,`j']
		matrix mat_`y'_`i'[`j',2] = e(b_iw)[1,`j'] -  invttail(e(df_r),0.025)*sqrt(e(V_iw)[`j',`j'])
		matrix mat_`y'_`i'[`j',3] = e(b_iw)[1,`j'] +  invttail(e(df_r),0.025)*sqrt(e(V_iw)[`j',`j'])
		}

		matrix mat_`y'_`i'[5,1] = 0
		matrix mat_`y'_`i'[5,2] = 0
		matrix mat_`y'_`i'[5,3] = 0

	forvalues j = 6(1)16{
		local k = `j' -1
		matrix mat_`y'_`i'[`j',1] = e(b_iw)[1,`k']
		matrix mat_`y'_`i'[`j',2] = e(b_iw)[1,`k'] -  invttail(e(df_r),0.025)*sqrt(e(V_iw)[`k',`k'])
		matrix mat_`y'_`i'[`j',3] = e(b_iw)[1,`k'] +  invttail(e(df_r),0.025)*sqrt(e(V_iw)[`k',`k'])
		}

	matrix rownames mat_`y'_`i' = "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
	}
}




******************************************
* CALLAWAY AND SANT'ANNA (2021) ESTIMATOR
******************************************

// Never treated should be coded as zero
replace first_treat = 0 if first_treat == .

foreach y in ln_annual_sales ln_tfpr ln_roa {

		// Generate matrix for results 
		matrix mat_`y'_cs = J(16,3,.)
		matrix mat_`y'_cs = J(16,3,.)


	// Run with never treated as control cohort - use wild bootstrap to compute standard errors 
	csdid `y' if balanced == 1 & second_treatment == "", ///
		wildbootstrap wbtype(mammen) ivar(id) time(year) gvar(first_treat) ///
		reps(199) cluster(cluster) seed (123)

	estat event, window(-5 10)

	// Store results into matrix
	forvalues j = 1(1)4{
		local c = `j' + 2

		matrix mat_`y'_cs[`j',1] = r(bb)[1,`j']
		matrix mat_`y'_cs[`j',2] = r(table)[5,`c']
		matrix mat_`y'_cs[`j',3] = r(table)[6,`c']
		}

		matrix mat_`y'_cs[5,1] = 0
		matrix mat_`y'_cs[5,2] = 0
		matrix mat_`y'_cs[5,3] = 0

	forvalues j = 6(1)16{
		local k = `j' -1
		local c = `k' + 2

		matrix mat_`y'_cs[`j',1] = r(bb)[1,`k']
		matrix mat_`y'_cs[`j',2] = r(table)[5,`c']
		matrix mat_`y'_cs[`j',3] = r(table)[6,`c']
		}

	matrix rownames mat_`y'_cs = "-5" "-4" "-3" "-2" "-1" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
}

*------------------------------------------------------------------------------------------------------
******************
* PRODUCE FIGURES
******************

// Produce figures 
local title_ln_annual_sales "A. Log Annual Sales"
local title_ln_tfpr "B. Log TFP"
local title_ln_roa "C. Log ROA"



cd "${figures}"
foreach y in ln_annual_sales ln_tfpr ln_roa {

coefplot (matrix(mat_`y'[.,1]), ///
 ci((mat_`y'[.,2] mat_`y'[.,3])) ///
 	 color("0 63 92") mfcolor(%30) msymbol(o) msize(small) mlwidth(vthin) lpatter("--...") ciopts(color("0 63 92"))) ///
 (matrix(mat_`y'_2[.,1]), ///
 ci((mat_`y'_2[.,2] mat_`y'_2[.,3])) ///
 	color(green) mfcolor(%30) msymbol(Th) msize(medlarge) mlwidth(vthin) lpatter("--...") ciopts(color(green))) ///
 (matrix(mat_`y'_cs[.,1]), ///
 ci((mat_`y'_cs[.,2] mat_`y'_cs[.,3])) ///
 	color(maroon) mfcolor(%30) msymbol(Sh) msize(medlarge) mlwidth(vthin) lpatter("--...") ciopts(color(maroon))), ///
 	vertical recast(connected) lpattern(dash) ///
 	legend(pos(6) cols(3) size(vsmall) order(2 4 6 8)  label(2 "Main Spec.") label(4 "Sun and Abraham") label(6 "Callaway and Sant'Anna")) ///
 	xtitle("Years after treatment") title("`title_`y''", size(small) color(black)) ///
 	yline(0, lcolor(black)) xline(5.2, lcolor(maroon*.30)) xline(9.2, lcolor(maroon*.30)) offset(0) ///
 	saving(did_est_`y'.gph, replace)

}

// Store figure 
cd "${figures}"
grc1leg did_est_ln_annual_sales.gph did_est_ln_tfpr.gph did_est_ln_roa.gph, ///
	legendfrom(did_est_ln_annual_sales.gph) pos(6) span cols(3)
graph display, ysize(12) xsize(30)
graph export figure_did_estimates.png, width(4000) replace
