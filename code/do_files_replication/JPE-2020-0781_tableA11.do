***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A11
***Complementarity Effects, Alternative Specification 1

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/complementarity_alt2.dta", clear


global pre_post op_post hr_post io_post hr_op_post hr_io_post op_io_post hr_io_op_post post_2-post_16 hr op io hr_op hr_io op_io hr_io_op

global keep_pre_post op_post hr_post io_post hr_op_post hr_io_post op_io_post hr_io_op_post


*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post} if balanced==1, absorb(app_window app_day county_sector_time) cluster(cluster) `version'

gen keep_obs=(e(sample))

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test op_post + hr_post = hr_op_post
local p_value_hr_op_post=r(p)
local p_value_hr_op_post=round(`p_value_hr_op_post',0.01)

test io_post + hr_post = hr_io_post
local p_value_hr_io_post=r(p)
local p_value_hr_io_post=round(`p_value_hr_io_post',0.01)

test io_post + op_post = op_io_post
local p_value_op_io_post=r(p)
local p_value_op_io_post=round(`p_value_op_io_post',0.01)

test io_post + op_post +hr_post = hr_io_op_post
local p_value_hr_io_op_post=r(p)
local p_value_hr_io_op_post=round(`p_value_hr_io_op_post',0.01)

local op_hr=_b[op_post] + _b[hr_post]
local op_io=_b[op_post] + _b[io_post]
local io_hr=_b[io_post] + _b[hr_post]
local hr_io_op=_b[io_post] + _b[hr_post] + _b[op_post]

outreg2 using "${directory_results}/table_a11`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', JI and JR=JR+JI, `p_value_hr_op_post', JR and JM=JR+JM, `p_value_hr_io_post', JI and JM=JI+JM, `p_value_op_io_post', JI and JM and JR=JI+JM+JR, `p_value_hr_io_op_post', JI and JR, `op_hr', JI and JM, `op_io', JM and JR, `io_hr', All, `hr_io_op')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) keep(${keep_pre_post}) `command'

*Drop keep obs
drop keep_obs
}

