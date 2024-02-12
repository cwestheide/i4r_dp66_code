***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table 5
***Effects on Upstream and Downstream Firms

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/vertical_main.dta", clear


global pre_post op_post hr_post io_post post_2-post_16 first_hr first_op first_io old_vertical upstream

global keep_pre_post op_post hr_post io_post


*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

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

outreg2 using "${directory_results}/table_5a`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-R==J-I, `p_value_hr_op', J-R==J-M, `p_value_hr_io', J-I==J-M, `p_value_op_io')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) `command'

}



use "${directory_data}/vertical_main.dta", clear

global pre_post op_post hr_post io_post op_post_up hr_post_up io_post_up hr_up op_up io_up post_up_2 post_up_3 post_up_4 post_up_5 post_up_6 post_up_7 post_up_8 post_up_9 post_up_10 post_up_11 post_up_12 post_up_13 post_up_14 post_up_15 post_up_16 post_2-post_16 first_hr first_op first_io old_vertical upstream

global keep_pre_post op_post hr_post io_post op_post_up hr_post_up io_post_up old_vertical



*Pre-post
foreach dep_var of var ln_annual_sales ln_tfpr ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_annual_sales" local command replace
if "`dep_var'"!="ln_annual_sales" local command append


reghdfe `dep_var' ${pre_post} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

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

outreg2 using "${directory_results}/table_5b`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-R==J-I, `p_value_hr_op', J-R==J-M, `p_value_hr_io', J-I==J-M, `p_value_op_io')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_pre_post}) `command'

}

