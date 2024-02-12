***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A13
***Effects on Upstream and Downstream Firms, Heterogeneity Analysis

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/vertical_sector.dta", clear


global pre_post_triple op_post hr_post io_post op_post_mnf hr_post_mnf io_post_mnf mnf_post mnf_hr mnf_io mnf_op  post_2-post_16 first_hr first_op first_io manufacturing transportation services
global keep_pre_post_triple op_post_mnf hr_post_mnf io_post_mnf op_post hr_post io_post


*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post_triple} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post_triple}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test op_post_mnf+op_post=op_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test hr_post_mnf+hr_post=hr_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test io_post_mnf+io_post=io_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a13a`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-I eq. across sectors, `p_value_hr_op', J-R eq. across sectors, `p_value_hr_io', J-M eq. across sectors, `p_value_op_io') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) keep(${keep_pre_post_triple}) `command'

}


use "${directory_data}/vertical_size.dta", clear


global pre_post_triple op_post hr_post io_post op_post_mnf hr_post_mnf io_post_mnf mnf_post mnf_hr mnf_io mnf_op  post_2-post_16 first_hr first_op first_io quartile_2
global keep_pre_post_triple op_post_mnf hr_post_mnf io_post_mnf op_post hr_post io_post


*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post_triple} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post_triple}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test op_post_mnf+op_post=op_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test hr_post_mnf+hr_post=hr_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test io_post_mnf+io_post=io_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a13b`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-I eq. across sectors, `p_value_hr_op', J-R eq. across sectors, `p_value_hr_io', J-M eq. across sectors, `p_value_op_io') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) keep(${keep_pre_post_triple}) `command'

}


use "${directory_data}/vertical_geo.dta", clear


global pre_post_triple op_post hr_post io_post op_post_mnf op_post_trp op_post_srv hr_post_mnf hr_post_trp hr_post_srv io_post_mnf io_post_trp io_post_srv mnf_post trp_post srv_post mnf_hr mnf_io mnf_op trp_hr trp_io trp_op srv_hr srv_io srv_op  post_2-post_16 first_hr first_op first_io midwest south west
global keep_pre_post_triple op_post_mnf op_post_trp op_post_srv hr_post_mnf hr_post_trp hr_post_srv io_post_mnf io_post_trp io_post_srv op_post hr_post io_post


*Pre-post
foreach dep_var of var ln_repairs ln_maintenance ln_injuries ln_bonus ln_strikes d_training ln_inventory ln_product_lines d_marketing {

if "`dep_var'"=="ln_repairs" local command replace
if "`dep_var'"!="ln_repairs" local command append


reghdfe `dep_var' ${pre_post_triple} if second_treatment=="", absorb(app_window app_day county_sector_time) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${keep_pre_post_triple}
local p_value=r(p)
local p_value=round(`p_value',0.01)

test op_post_mnf+op_post=op_post_trp+op_post=op_post_srv+op_post=op_post
local p_value_hr_op=r(p)
local p_value_hr_op=round(`p_value_hr_op',0.01)

test hr_post_mnf+hr_post=hr_post_trp+hr_post=hr_post_srv+hr_post=hr_post
local p_value_hr_io=r(p)
local p_value_hr_io=round(`p_value_hr_io',0.01)

test io_post_mnf+io_post=io_post_trp+io_post=io_post_srv+io_post=io_post
local p_value_op_io=r(p)
local p_value_op_io=round(`p_value_op_io',0.01)

outreg2 using "${directory_results}/table_a13c`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value', J-I eq. across sectors, `p_value_hr_op', J-R eq. across sectors, `p_value_hr_io', J-M eq. across sectors, `p_value_op_io') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) keep(${keep_pre_post_triple}) `command'

}
