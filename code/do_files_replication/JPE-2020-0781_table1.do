***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Table 1
***Summary Statistics for 11,575 Applicants to the TWI Program

use "${directory_data}/summary_stats.dta", clear

global sum_variables plants employees foundation_year agriculture manufacturing transportation services annual_sales current_assets total_assets  ln_tfpr roa inventory injuries repairs bonus 

global sum_war_variables share_afr share_women education age_workers share_drafted_tot switch_3_digit switch_industry switch_sector number_contracts value_contracts 

global sum_war_variables_nonapp share_afro share_women education age_workers share_drafted_tot switch_3_digit switch_industry switch_sector number_contracts value_contracts


***********************************************************************
*Keep year 1939
preserve
keep if year==1939

eststo clear
eststo: estpost sum ${sum_variables}
eststo: estpost sum ${sum_variables} if treatment_full==1
eststo: estpost sum ${sum_variables} if treatment_full==0
esttab using "${directory_results}/table_1_a1.csv", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") replace nomtitles onecell nonumbers

foreach var of varlist plants employees foundation_year agriculture manufacturing transportation services annual_sales current_assets total_assets ln_tfpr roa inventory injuries repairs bonus  {

if "`var'"=="plants" local command replace
if "`var'"!="plants" local command append

reg `var' treatment_full, cluster(cluster)

sum `var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

local t = _b[treatment_full]/_se[treatment_full]
local p_value=2*ttail(e(df_r),abs(`t'))
local p_value=round(`p_value',0.001)

outreg2 using "${directory_results}/table_1_a2.xls", dec(4) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of treatment coefficient, `p_value') addtext(Sector FE, NO, App Window FE, NO, App date FE, NO, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, SubApp) keep(treatment_full) `command'

}
restore

*Primo anno dei replacement
preserve
keep if year==1941

eststo clear
eststo: estpost sum share_afr share_women education age_workers share_drafted_tot switch_industry switch_sector
eststo: estpost sum share_afr share_women education age_workers share_drafted_tot switch_industry switch_sector if treatment_full==1
eststo: estpost sum share_afr share_women education age_workers share_drafted_tot switch_industry switch_sector if treatment_full==0
esttab using "${directory_results}/table_1_b1.csv", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") replace nomtitles onecell nonumbers

foreach var of varlist share_afr share_women education age_workers share_drafted_tot switch_industry switch_sector {

if "`var'"=="share_afro" local command replace
if "`var'"!="share_afro" local command append

reg `var' treatment_full, cluster(cluster)

sum `var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

local t = _b[treatment_full]/_se[treatment_full]
local p_value=2*ttail(e(df_r),abs(`t'))
local p_value=round(`p_value',0.001)

outreg2 using "${directory_results}/table_1_b2.xls", dec(4) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of treatment coefficient, `p_value') addtext(Sector FE, NO, App Window FE, NO, App date FE, NO, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, SubApp) keep(treatment_full) `command'

}
restore

*tutti anni war
preserve
keep if year>=1940 & year<=1945

eststo clear
eststo: estpost sum number_contracts value_contracts
eststo: estpost sum number_contracts value_contracts if treatment_full==1
eststo: estpost sum number_contracts value_contracts if treatment_full==0
esttab using "${directory_results}/table_1_c1.csv", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") replace nomtitles onecell nonumbers

foreach var of varlist number_contracts value_contracts {

if "`var'"=="number_contracts" local command replace
if "`var'"!="number_contracts" local command append

reg `var' treatment_full, cluster(cluster)

sum `var' if e(sample)
local mean3=r(mean)
local mean3=round(`mean3',0.01)
local sd3=r(sd)
local sd3=round(`sd3',0.01)

local t = _b[treatment_full]/_se[treatment_full]
local p_value=2*ttail(e(df_r),abs(`t'))
local p_value=round(`p_value',0.001)

outreg2 using "${directory_results}/table_1_c2.xls", dec(4) addstat(Mean dep var, `mean3', SD dep var, `sd3', P-value of treatment coefficient, `p_value') addtext(Sector FE, NO, App Window FE, NO, App date FE, NO, County FE, NO, Subd FE, NO, TWI FE, NO, County-Sector FE, NO, TWI-Sector FE, NO, Sub-sector FE, NO, Firm FE, NO, Cluster, SubApp) keep(treatment_full) `command'

}
restore
***********************************************************************





