***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A4
***Exit Regressions

local version "version(3)"

use "${directory_data}/exit.dta", clear

// most firms get treated late. so consider only survival after year 5

local selection 5

foreach alive in 0 `selection' {
	local cond "& periods_alive > `alive'"

	reghdfe exit treatment_full if second_treatment=="" `cond', absorb(app_window app_day county_sector) cluster(cluster) `version'
	cap drop keep_obs
	gen keep_obs=(e(sample))

	sum exit if e(sample)
	local mean3=r(mean)
	local mean3=round(`mean3',0.01)
	local sd3=r(sd)
	local sd3=round(`sd3',0.01)

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(treatment_full) replace


	reghdfe exit treatment_full if second_treatment=="" & keep_obs==1 `cond', absorb(app_window app_day district_sector) cluster(cluster) `version'

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, YES, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(treatment_full) append


	reghdfe exit treatment_full if second_treatment=="" & keep_obs==1 `cond', absorb(app_window app_day subdistrict_sector) cluster(cluster) `version'

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, YES, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(treatment_full) append


	reghdfe exit first_op first_hr first_io if second_treatment=="" `cond', absorb(app_window app_day county_sector) cluster(cluster) `version'

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(first_op first_hr first_io) append


	reghdfe exit first_op first_hr first_io if second_treatment=="" & keep_obs==1 `cond', absorb(app_window app_day district_sector) cluster(cluster) `version'

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, YES, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(first_op first_hr first_io) append


	reghdfe exit first_op first_hr first_io if second_treatment=="" & keep_obs==1 `cond', absorb(app_window app_day subdistrict_sector) cluster(cluster) `version'

	outreg2 using "${directory_results}/table_a4`selection'`1'p`alive'.xls", stats(coef pval) dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3')  addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, YES, Firm FE, NO, Cluster, Sub-App, Only 1 treat, YES) keep(first_op first_hr first_io) append

}
