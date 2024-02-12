***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table C1
***Correlation Between TWI Training and Instructors’ Composition

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/first_stage.dta", clear


***Run regressions - Intensive Margin
***And the order counts
foreach suffix in _op _hr _io _op_hr _hr_op _hr_io _io_hr _op_io _io_op {

foreach instr in max {

if "`suffix'"=="_op" & "`instr'"=="max" local command replace
if "`suffix'"!="_op" | "`instr'"!="max" local command append


reghdfe first`suffix' `instr'`suffix' if applied==1, cluster(cluster) absorb(county_sector app_window app_day) `version'

sum `instr'`suffix' if e(sample)
local mean2=r(mean)	
local mean2=round(`mean2',0.01)
local sd2=r(sd)
local sd2=round(`sd2',0.01)
sum first`suffix' if e(sample)
local mean3=r(mean)	
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_c1`1'.xls", dec(3) keep(`instr'`suffix') addstat(Mean dep var, `mean3', SD dep var, `sd3', Mean share full, `mean2', SD share full, `sd2')  addtext(Spec, OLS, Subd FE, NO, App Window FE, YES, App date FE, YES, TWI District FE, NO, County FE, NO, Subd-sector, NO, County-Sector FE, YES, District-sector FE, NO, Cluster, SubApp) `command'

}

}
