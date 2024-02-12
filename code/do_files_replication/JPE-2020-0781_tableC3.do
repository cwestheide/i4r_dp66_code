***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table C3
***Autocorrelation between Current and Past TWI Instructors

use "${directory_data}/subdistricts_2.dta", clear


***Test for autocorrelation (not enough observations to run it within subdistricts)
foreach suffix in _op _hr _io _op_hr _hr_op _hr_io _io_hr _op_io _io_op {

foreach treat in max {

reg `treat'`suffix' l.`treat'`suffix', cluster(subdistrict)

sum `treat'`suffix' if e(sample)
local mean4=r(mean)
local mean4=round(`mean4',0.01)
local sd4=r(sd)
local sd4=round(`sd4', 0.01)

outreg2 using "${directory_results}/table_c3.xls", dec(3) addstat(Mean share full, `mean4', SD share full, `sd4') addtext(App Window FE, NO, Subd FE, NO, TWI FE, NO, Cluster, Subdistrict) append
	
}

}
