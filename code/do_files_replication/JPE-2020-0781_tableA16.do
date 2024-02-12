***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A16
***Spillover of Practices to Nonapplicant Firms

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/horizontal_main.dta", clear


*Globals for simple specifications with just treated (same vs. diff) and nontreated (same vs. diff)
global year_simple num_same_treat_post_1 num_same_treat_post_2 num_same_treat_post_3 num_same_treat_post_4 num_same_treat_post_6 num_same_treat_post_7 num_same_treat_post_8 num_same_treat_post_9 num_same_treat_post_10 num_same_treat_post_11 num_same_treat_post_12 num_same_treat_post_13 num_same_treat_post_14 num_same_treat_post_15 num_same_treat_post_16 num_diff_treat_post_1 num_diff_treat_post_2 num_diff_treat_post_3 num_diff_treat_post_4 num_diff_treat_post_6 num_diff_treat_post_7 num_diff_treat_post_8 num_diff_treat_post_9 num_diff_treat_post_10 num_diff_treat_post_11 num_diff_treat_post_12 num_diff_treat_post_13 num_diff_treat_post_14 num_diff_treat_post_15 num_diff_treat_post_16 num_same_na_post_1 num_same_na_post_2 num_same_na_post_3 num_same_na_post_4 num_same_na_post_6 num_same_na_post_7 num_same_na_post_8 num_same_na_post_9 num_same_na_post_10 num_same_na_post_11 num_same_na_post_12 num_same_na_post_13 num_same_na_post_14 num_same_na_post_15 num_same_na_post_16 num_diff_na_post_1 num_diff_na_post_2 num_diff_na_post_3 num_diff_na_post_4 num_diff_na_post_6 num_diff_na_post_7 num_diff_na_post_8 num_diff_na_post_9 num_diff_na_post_10 num_diff_na_post_11 num_diff_na_post_12 num_diff_na_post_13 num_diff_na_post_14 num_diff_na_post_15 num_diff_na_post_16 post_2-post_16 num_same_treat num_diff_treat num_same_na num_diff_na
global pre_post_simple num_same_treat_post num_diff_treat_post num_same_na_post num_diff_na_post post_2-post_16 num_same_treat num_diff_treat num_same_na num_diff_na


global keep_year_simple num_same_treat_post_1 num_same_treat_post_2 num_same_treat_post_3 num_same_treat_post_4 num_same_treat_post_6 num_same_treat_post_7 num_same_treat_post_8 num_same_treat_post_9 num_same_treat_post_10 num_same_treat_post_11 num_same_treat_post_12 num_same_treat_post_13 num_same_treat_post_14 num_same_treat_post_15 num_same_treat_post_16 num_diff_treat_post_1 num_diff_treat_post_2 num_diff_treat_post_3 num_diff_treat_post_4 num_diff_treat_post_6 num_diff_treat_post_7 num_diff_treat_post_8 num_diff_treat_post_9 num_diff_treat_post_10 num_diff_treat_post_11 num_diff_treat_post_12 num_diff_treat_post_13 num_diff_treat_post_14 num_diff_treat_post_15 num_diff_treat_post_16 num_same_na_post_1 num_same_na_post_2 num_same_na_post_3 num_same_na_post_4 num_same_na_post_6 num_same_na_post_7 num_same_na_post_8 num_same_na_post_9 num_same_na_post_10 num_same_na_post_11 num_same_na_post_12 num_same_na_post_13 num_same_na_post_14 num_same_na_post_15 num_same_na_post_16 num_diff_na_post_1 num_diff_na_post_2 num_diff_na_post_3 num_diff_na_post_4 num_diff_na_post_6 num_diff_na_post_7 num_diff_na_post_8 num_diff_na_post_9 num_diff_na_post_10 num_diff_na_post_11 num_diff_na_post_12 num_diff_na_post_13 num_diff_na_post_14 num_diff_na_post_15 num_diff_na_post_16
global keep_pre_post_simple num_same_treat_post num_diff_treat_post num_same_na_post num_diff_na_post



*Globals for simple specifications with just treated (same vs. diff) and nontreated (same vs. diff) using mean distance, not number of firms
global dist_year_simple dist_same_treat_post_1 dist_same_treat_post_2 dist_same_treat_post_3 dist_same_treat_post_4 dist_same_treat_post_6 dist_same_treat_post_7 dist_same_treat_post_8 dist_same_treat_post_9 dist_same_treat_post_10 dist_same_treat_post_11 dist_same_treat_post_12 dist_same_treat_post_13 dist_same_treat_post_14 dist_same_treat_post_15 dist_same_treat_post_16 dist_diff_treat_post_1 dist_diff_treat_post_2 dist_diff_treat_post_3 dist_diff_treat_post_4 dist_diff_treat_post_6 dist_diff_treat_post_7 dist_diff_treat_post_8 dist_diff_treat_post_9 dist_diff_treat_post_10 dist_diff_treat_post_11 dist_diff_treat_post_12 dist_diff_treat_post_13 dist_diff_treat_post_14 dist_diff_treat_post_15 dist_diff_treat_post_16 dist_same_na_post_1 dist_same_na_post_2 dist_same_na_post_3 dist_same_na_post_4 dist_same_na_post_6 dist_same_na_post_7 dist_same_na_post_8 dist_same_na_post_9 dist_same_na_post_10 dist_same_na_post_11 dist_same_na_post_12 dist_same_na_post_13 dist_same_na_post_14 dist_same_na_post_15 dist_same_na_post_16 dist_diff_na_post_1 dist_diff_na_post_2 dist_diff_na_post_3 dist_diff_na_post_4 dist_diff_na_post_6 dist_diff_na_post_7 dist_diff_na_post_8 dist_diff_na_post_9 dist_diff_na_post_10 dist_diff_na_post_11 dist_diff_na_post_12 dist_diff_na_post_13 dist_diff_na_post_14 dist_diff_na_post_15 dist_diff_na_post_16 post_2-post_16 dist_same_treat dist_diff_treat dist_same_na dist_diff_na
global dist_pre_post_simple dist_same_treat_post dist_diff_treat_post dist_same_na_post dist_diff_na_post post_2-post_16 dist_same_treat dist_diff_treat dist_same_na dist_diff_na


global dist_keep_year_simple dist_same_treat_post_1 dist_same_treat_post_2 dist_same_treat_post_3 dist_same_treat_post_4 dist_same_treat_post_6 dist_same_treat_post_7 dist_same_treat_post_8 dist_same_treat_post_9 dist_same_treat_post_10 dist_same_treat_post_11 dist_same_treat_post_12 dist_same_treat_post_13 dist_same_treat_post_14 dist_same_treat_post_15 dist_same_treat_post_16 dist_diff_treat_post_1 dist_diff_treat_post_2 dist_diff_treat_post_3 dist_diff_treat_post_4 dist_diff_treat_post_6 dist_diff_treat_post_7 dist_diff_treat_post_8 dist_diff_treat_post_9 dist_diff_treat_post_10 dist_diff_treat_post_11 dist_diff_treat_post_12 dist_diff_treat_post_13 dist_diff_treat_post_14 dist_diff_treat_post_15 dist_diff_treat_post_16 dist_same_na_post_1 dist_same_na_post_2 dist_same_na_post_3 dist_same_na_post_4 dist_same_na_post_6 dist_same_na_post_7 dist_same_na_post_8 dist_same_na_post_9 dist_same_na_post_10 dist_same_na_post_11 dist_same_na_post_12 dist_same_na_post_13 dist_same_na_post_14 dist_same_na_post_15 dist_same_na_post_16 dist_diff_na_post_1 dist_diff_na_post_2 dist_diff_na_post_3 dist_diff_na_post_4 dist_diff_na_post_6 dist_diff_na_post_7 dist_diff_na_post_8 dist_diff_na_post_9 dist_diff_na_post_10 dist_diff_na_post_11 dist_diff_na_post_12 dist_diff_na_post_13 dist_diff_na_post_14 dist_diff_na_post_15 dist_diff_na_post_16
global dist_keep_pre_post_simple dist_same_treat_post dist_diff_treat_post dist_same_na_post dist_diff_na_post



********************************************************************************
*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post_simple}, absorb(id) cluster(subdistrict) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post_simple}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test num_same_treat_post=num_diff_treat_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test num_same_treat_post=num_same_na_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test num_same_treat_post=num_diff_na_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a16a`1'.xls", dec(5) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', Same treat=Different treat, `p_value_hr_op', Same treat=Same not treat, `p_value_hr_io', Same treat=Different not treat, `p_value_op_io')  addtext(Sector FE, NO, App Window FE, NO, App date FE, NO, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, YES, Cluster, Sub, Balanced, NO) keep(${keep_pre_post_simple}) `command'

}
********************************************************************************


********************************************************************************
*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${dist_pre_post_simple}, absorb(id) cluster(subdistrict) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${dist_keep_pre_post_simple}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test dist_same_treat_post=dist_diff_treat_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test dist_same_treat_post=dist_same_na_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test dist_same_treat_post=dist_diff_na_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a16b`1'.xls", dec(5) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', Same treat=Different treat, `p_value_hr_op', Same treat=Same not treat, `p_value_hr_io', Same treat=Different not treat, `p_value_op_io')  addtext(Sector FE, NO, App Window FE, NO, App date FE, NO, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, YES, Cluster, Sub, Balanced, NO) keep(${dist_keep_pre_post_simple}) `command'

}
********************************************************************************
