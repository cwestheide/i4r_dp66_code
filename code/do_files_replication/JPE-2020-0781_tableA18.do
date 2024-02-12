***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table A18
***Relationship with the Government

if inlist(`1', 3, 5) {
	local version "version(`1')"
}

use "${directory_data}/war_variables_2.dta", clear


*Both pre-wwii and post-wwii variables
global pre_post treat_post post_2-post_16 treatment_full
global keep_pre_post treat_post


****************************************
*Minus 3 and plus 2
****************************************

*Pre-post
foreach dep_var of var having_contract ln_value_contracts ln_number_contracts med_ln_value_contracts ter_ln_value_contracts {

if "`dep_var'"=="having_contract" local command replace
if "`dep_var'"!="having_contract" local command append

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local upper 2
if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local lower -3
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local upper 8
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local lower 1

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local controls "${pre_post} if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local controls "post_2-post_16 treatment_full if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"


reghdfe `dep_var' `controls' cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a18a`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) `command' keep(${keep_pre_post})

}

foreach dep_var of var ln_post_wwii_refunds {

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local upper 2
if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local lower -3
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local upper 8
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local lower 1

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local controls "${pre_post} if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local controls "post_2-post_16 treatment_full if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"


reghdfe `dep_var' `controls' cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a18d`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) replace keep(treatment_full)

}

*-4 to 2
foreach dep_var of var having_contract ln_value_contracts ln_number_contracts med_ln_value_contracts ter_ln_value_contracts {

if "`dep_var'"=="having_contract" local command replace
if "`dep_var'"!="having_contract" local command append

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local upper 2
if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local lower -4
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local upper 8
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local lower 1

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local controls "${pre_post} if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local controls "post_2-post_16 treatment_full if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"


reghdfe `dep_var' `controls' cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a18b`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) `command' keep(${keep_pre_post})

}


*-5 to 2
foreach dep_var of var having_contract ln_value_contracts ln_number_contracts med_ln_value_contracts ter_ln_value_contracts {

if "`dep_var'"=="having_contract" local command replace
if "`dep_var'"!="having_contract" local command append

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local upper 2
if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local lower -5
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local upper 8
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local lower 1

if "`dep_var'"!="ln_post_wwii_refunds" & "`dep_var'"!="gr_post_wwii_refunds" local controls "${pre_post} if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"
if "`dep_var'"=="ln_post_wwii_refunds" | "`dep_var'"=="gr_post_wwii_refunds" local controls "post_2-post_16 treatment_full if balanced==1 & second_treatment=="" & time>=`lower' & time<=`upper', absorb(app_window app_day county_sector_time)"


reghdfe `dep_var' `controls' cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a18c`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, YES, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, Sub-App) `command' keep(${keep_pre_post})

}

*Total contracts given to a county

foreach dep_var of var ln_var88 ln_var89 ln_var90 ln_var91 {

if "`dep_var'"=="ln_var88" local command replace
if "`dep_var'"!="ln_var88" local command append


reghdfe `dep_var' treatment_full if time==0 & balanced==1 & second_treatment=="", absorb(app_window app_day subdistrict_sector) cluster(cluster) `version'

sum `dep_var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

outreg2 using "${directory_results}/table_a18d`1'.xls", dec(3) addstat(Mean dep var, `mean3', SD dep var, `sd3') addtext(Sector FE, NO, App Window FE, YES, App date FE, YES, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, YES, Firm FE, NO, Cluster, Sub-App) append keep(treatment_full)

}
