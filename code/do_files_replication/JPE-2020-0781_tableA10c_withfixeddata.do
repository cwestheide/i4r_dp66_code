***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A10
***Multiple Hypotheses Testing

foreach 1 in "" 3 5 {
if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/app_other_outcomes_yearly.dta", clear

global year_effects op_post_1 op_post_2 op_post_3 op_post_4 op_post_6 op_post_7 op_post_8 op_post_9 op_post_10 op_post_11 op_post_12 op_post_13 op_post_14 op_post_15 op_post_16 hr_post_1 hr_post_2 hr_post_3 hr_post_4 hr_post_6 hr_post_7 hr_post_8 hr_post_9 hr_post_10 hr_post_11 hr_post_12 hr_post_13 hr_post_14 hr_post_15 hr_post_16 io_post_1 io_post_2 io_post_3 io_post_4 io_post_6 io_post_7 io_post_8 io_post_9 io_post_10 io_post_11 io_post_12 io_post_13 io_post_14 io_post_15 io_post_16 post_2-post_16 first_hr first_op first_io


cap log close


use "${directory_data}/vertical_main_v2.dta", clear

global pre_post op_post hr_post io_post post_2-post_16 first_hr first_op first_io old_vertical upstream

cap log close
cap log using "${directory_results}/table_a10c`1'_v2", replace

capture noisily {

	wyoung ln_inventory ln_strikes ln_product_lines ln_injuries ln_maintenance ln_repairs ln_bonus d_training d_marketing, cmd(reghdfe OUTCOMEVAR ${pre_post} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version') familyp(op_post) bootstrap(50) seed(26) cluster(cluster)

	wyoung ln_inventory ln_strikes ln_product_lines ln_injuries ln_maintenance ln_repairs ln_bonus d_training d_marketing, cmd(reghdfe OUTCOMEVAR ${pre_post} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version') familyp(hr_post) bootstrap(50) seed(26) cluster(cluster)

	wyoung ln_inventory ln_strikes ln_product_lines ln_injuries ln_maintenance ln_repairs ln_bonus d_training d_marketing, cmd(reghdfe OUTCOMEVAR ${pre_post} if balanced==1 & second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version') familyp(io_post) bootstrap(50) seed(26) cluster(cluster)
}
cap log close
}
