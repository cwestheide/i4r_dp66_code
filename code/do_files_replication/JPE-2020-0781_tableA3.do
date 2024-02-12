***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A3
***Autocorrelation of the TWI Trainings

use "${directory_data}/subdistricts_1.dta", clear


***Test for autocorrelation (not enough observations to run it within subdistricts)
foreach var of varlist treatment_full op hr io hr_op hr_io op_io hr_io_op {

reg `var' l.`var', cluster(subdistrict)

if "`var'"=="treatment_full" local command replace
if "`var'"!="treatment_full" local command append

sum `var' if e(sample)
local mean4=r(mean)
local mean4=round(`mean4',0.01)
local sd4=r(sd)
local sd4=round(`sd4', 0.01)

outreg2 using "${directory_results}/table_a3`1'.xls", dec(3) addstat(Mean share full, `mean4', SD share full, `sd4') addtext(App Window FE, NO, Subd FE, NO, TWI FE, NO, Cluster, Subdistrict) `command'
	
}
