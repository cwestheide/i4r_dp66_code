***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A9
***Clustering Standard Errors at Subdistrict Level

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_other_outcomes_yearly.dta", clear


global year_effects op_post_1 op_post_2 op_post_3 op_post_4 op_post_6 op_post_7 op_post_8 op_post_9 op_post_10 op_post_11 op_post_12 op_post_13 op_post_14 op_post_15 op_post_16 hr_post_1 hr_post_2 hr_post_3 hr_post_4 hr_post_6 hr_post_7 hr_post_8 hr_post_9 hr_post_10 hr_post_11 hr_post_12 hr_post_13 hr_post_14 hr_post_15 hr_post_16 io_post_1 io_post_2 io_post_3 io_post_4 io_post_6 io_post_7 io_post_8 io_post_9 io_post_10 io_post_11 io_post_12 io_post_13 io_post_14 io_post_15 io_post_16 post_2-post_16 first_hr first_op first_io
global keep_year_effects op_post_1 op_post_2 op_post_3 op_post_4 op_post_6 op_post_7 op_post_8 op_post_9 op_post_10 op_post_11 op_post_12 op_post_13 op_post_14 op_post_15 op_post_16 hr_post_1 hr_post_2 hr_post_3 hr_post_4 hr_post_6 hr_post_7 hr_post_8 hr_post_9 hr_post_10 hr_post_11 hr_post_12 hr_post_13 hr_post_14 hr_post_15 hr_post_16 io_post_1 io_post_2 io_post_3 io_post_4 io_post_6 io_post_7 io_post_8 io_post_9 io_post_10 io_post_11 io_post_12 io_post_13 io_post_14 io_post_15 io_post_16


foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing  {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${year_effects} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(subdistrict) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_year_effects}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a9a`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub) keep(${keep_year_effects}) `command'

}



use "${directory_data}/complementarity_main.dta", clear


global pre_post treatment_op_post treatment_hr_post treatment_io_post other_op_post other_hr_post other_io_post post_2-post_16 treatment_hr treatment_op treatment_io other_hr other_op other_io
global keep_pre_post treatment_op_post treatment_hr_post treatment_io_post other_op_post other_hr_post other_io_post


foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post} if balanced==1, absorb(app_window app_day county_sector_time) cluster(subdistrict) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_a9b`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub) keep(${keep_pre_post}) `command'

}


use "${directory_data}/vertical_main.dta", clear


global pre_post op_post hr_post io_post post_2-post_16 first_hr first_op first_io old_vertical upstream

global keep_pre_post op_post hr_post io_post

foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(subdistrict) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test hr_post=op_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test hr_post=io_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test op_post=io_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a9c`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-R==J-I, `p_value_hr_op', J-R==J-M, `p_value_hr_io', J-I==J-M, `p_value_op_io')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) `command'
}

