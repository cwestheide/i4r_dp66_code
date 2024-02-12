***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A17
***Adoption of Practices and Managers Leaving

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/practices_managers.dta", clear


*global keep_pre_post_triple_mnf op_post_mnf hr_post_mnf io_post_mnf op_post hr_post io_post
global pre_post_triple_srv op_post hr_post io_post op_post_srv hr_post_srv io_post_srv srv_post srv_hr srv_io srv_op post_2-post_16 first_hr first_op first_io above_median_managers
global keep_pre_post_triple_srv op_post hr_post io_post op_post_srv hr_post_srv io_post_srv 


*Pre-post with triple interactions
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

foreach suffix in  srv {

if "`dep_var'"=="ln_repairs" & "`suffix'"=="srv" local command replace
if "`dep_var'"!="ln_repairs" | "`suffix'"!="srv" local command append

if "`suffix'"=="srv" local variable="Above median"

reghdfe `dep_var' ${pre_post_triple_`suffix'} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post_triple_`suffix'}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a17`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Triple, `variable', Cluster, Sub-App) keep(${keep_pre_post_triple_`suffix'}) `command'

}

}
