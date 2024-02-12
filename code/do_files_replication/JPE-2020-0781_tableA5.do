***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A5
***Components of Production Function

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_main_outcomes_yearly.dta", clear


global pre_post treat_post post_2-post_16 treatment_full

global keep_pre_post treat_post



*Pre-post
foreach dep_var of var ln_tfpr ln_annual_sales ln_intermediate_goods ln_capital ln_employees {

if "`dep_var'"=="ln_tfpr" local command replace
if "`dep_var'"!="ln_tfpr" local command append


reghdfe `dep_var' ${pre_post} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a5`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) `command'

}
