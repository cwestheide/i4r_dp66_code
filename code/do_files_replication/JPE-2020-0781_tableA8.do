***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A8
***Effects of TWI Training on Responses to TWI Surveys

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/survey_data.dta", clear


global year_effects op_post_2 op_post_3 op_post_4 op_post_5 hr_post_2 hr_post_3 hr_post_4 hr_post_5 post_2 post_3 post_4 post_5 first_hr first_op first_io

global keep_year_effects op_post_2 op_post_3 op_post_4 op_post_5 hr_post_2 hr_post_3 hr_post_4 hr_post_5 post_2 post_3 post_4 post_5


*Yearly effects
foreach dep_var of var ln_machine_repairs_op ln_workers_injuries_op breakdown_op job_description_managers_hr job_description_workers_hr training_hr bonus_hr suggestions_workers_hr ln_unused_inputs_io production_planning_io marketing_io {

if "`dep_var'"=="ln_machine_repairs_op" local command replace
if "`dep_var'"!="ln_machine_repairs_op" local command append
	 

reghdfe `dep_var' ${year_effects} if second_treatment=="", absorb(app_window app_day county_sector) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_year_effects}
local p_value=r(p)
local p_value=round(`p_value',0.01)

lincom _b[post_2]+_b[hr_post_2]
local hr_est=r(estimate)
local hr_est=round(`hr_est',0.001)
local hr_se=r(se)
local hr_se=round(`hr_se',0.001)
local hr_p=r(p)
local hr_p=round(`hr_p',0.001)

lincom _b[post_5]+_b[hr_post_5]
local hr_est_5=r(estimate)
local hr_est_5=round(`hr_est_5',0.001)
local hr_se_5=r(se)
local hr_se_5=round(`hr_se_5',0.001)
local hr_p_5=r(p)
local hr_p_5=round(`hr_p_5',0.001)

lincom _b[post_2]+_b[op_post_2]
local op_est=r(estimate)
local op_est=round(`op_est',0.001)
local op_se=r(se)
local op_se=round(`op_se',0.001)
local op_p=r(p)
local op_p=round(`op_p',0.001)

lincom _b[post_5]+_b[op_post_5]
local op_est_5=r(estimate)
local op_est_5=round(`op_est_5',0.001)
local op_se_5=r(se)
local op_se_5=round(`op_se_5',0.001)
local op_p_5=r(p)
local op_p_5=round(`op_p_5',0.001)

outreg2 using "${directory_results}/table_a8`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', Effect JR 1, `hr_est', SE JR 1, `hr_se', P-value JR 1, `hr_p', Effect JR 4, `hr_est_5', SE JR 4, `hr_se_5', P-value JR 4, `hr_p_5', Effect JI 1, `op_est', SE JI 1, `op_se', P-value JI 1, `op_p', Effect JI 4, `op_est_5', SE JI 4, `op_se_5', P-value JI 4, `op_p_5')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Balanced, YES) keep(${keep_year_effects}) `command'

}

