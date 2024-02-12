***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table C2
***Correlation Between Firm and County Variables and TWI Instructors

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/correlations.dta", clear


*Regressions
global log_ind_var ln_annual_sales ln_value_added ln_employees ln_plants foundation_year ln_inventory ln_capital ln_current_assets ln_investment ln_strikes ln_injuries ln_bonus ln_acquisition i.sector distance_port distance_railroad


*Do with logs and shares
foreach dep_var of var max_op max_hr max_io max_op_hr max_hr_op max_hr_io max_io_hr max_op_io max_io_op {

if "`dep_var'"=="max_op" local command replace
if "`dep_var'"!="max_op" local command append

	 
reghdfe `dep_var' ${log_ind_var}, absorb(app_window app_day county_sector) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${log_ind_var}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_c2a`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Cluster, Sub-App) `command'


}


*Do with logs and shares
foreach dep_var of var max_op max_hr max_io max_op_hr max_hr_op max_hr_io max_io_hr max_op_io max_io_op {

if "`dep_var'"=="max_op" local command replace
if "`dep_var'"!="max_op" local command append

 
reghdfe `dep_var' ${log_ind_var} ln_number_contracts ln_value_contracts, absorb(app_window app_day county_sector) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${log_ind_var} ln_number_contracts ln_value_contracts
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_c2b`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Cluster, Sub-App) `command'

}




use "${directory_data}/correlations_county.dta", clear


*Regressions
global var_manuf_1920 ln_estab_1920 ln_emp_ops_tot_1920 ln_wages_ops_tot_1920 ln_exp_tot_1920 ln_val_prod_tot_1920 ln_val_add_1920 farms_pop_1920

global var_demo_1920 ln_population_1920 ln_area_1920 pop_mile_1920 male_share_1920 black_share_1920  illiterate_share_1920 urban_share_1920


global var_manuf_1930 ln_estab_1930 ln_emp_ops_tot_1930 ln_wages_ops_tot_1930 ln_exp_tot_1930 ln_val_prod_tot_1930 ln_val_add_1930 unemp_share_1930 farms_pop_1930

global var_demo_1930 ln_population_1930 male_share_1930 black_share_1930 ln_area_1930 pop_mile_1930 urban_share_1930 illiterate_share_1930  


global var_manuf_1940 ln_estab_1940 ln_emp_ops_tot_1940 ln_wages_ops_tot_1940 ln_exp_tot_1940 ln_val_prod_tot_1940 ln_val_add_1940 unemp_share_1940 farms_pop_1940

global var_demo_1940 ln_population_1940 ln_area_1940 pop_mile_1940 male_share_1940 black_share_1940 urban_share_1940


*Then for the shares only
foreach year in 1920 1930 1940 {

foreach dep_var of var max_op max_hr max_io max_op_hr max_hr_op max_hr_io max_io_hr max_op_io max_io_op {

if "`dep_var'"=="max_op" & "`year'"=="1920" local command replace
if "`dep_var'"!="max_op" | "`year'"!="1920" local command append


reghdfe `dep_var' ${var_manuf_`year'} ${var_demo_`year'}, absorb(subdistrict_sector app_window app_day) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

testparm ${var_manuf_`year'} ${var_demo_`year'}
local p_value=r(p)
local p_value=round(`p_value',0.01)

outreg2 using "${directory_results}/table_c2c`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of F-test , `p_value') addtext(App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, TWI-Sector FE, NO, Sub-Sector FE, YES, Cluster, Sub-App) `command'


}

}

