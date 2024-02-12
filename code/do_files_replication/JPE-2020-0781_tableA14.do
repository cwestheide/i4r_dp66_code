***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A14
***Selection of Firms Entering the Applicants’ Supply Chain

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/vertical_selection.dta", clear


*Do trained firms get better firms at time==0
foreach var of varlist ln_annual_sales ln_tfpr ln_roa ln_plants ln_employees ln_managers ln_acquisition {

if "`var'"=="ln_annual_sales" local command replace
if "`var'"!="ln_annual_sales" local command append

reghdfe `var' treatment_full if time==-1 & new_vertical==1, absorb(app_day app_window district_sector) cluster(cluster) `version'

sum `var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a14`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, YES, Sub-sector FE, NO, Firm FE, NO, Cluster, SubApp) keep(treatment_full) `command'
}
