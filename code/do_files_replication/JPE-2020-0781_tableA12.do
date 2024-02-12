***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A12
***Complementarity Effects, Alternative Specification 2

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/complementarity_alt1.dta", clear


global pre_post treatment_op_post treatment_hr_post treatment_io_post op_hr_post hr_io_post op_io_post post_2-post_16 treatment_hr treatment_op treatment_io hr_io op_hr op_io

global keep_pre_post treatment_op_post treatment_hr_post treatment_io_post op_hr_post hr_io_post op_io_post


*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post} if balanced==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a12`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) keep(${keep_pre_post}) `command'

}
