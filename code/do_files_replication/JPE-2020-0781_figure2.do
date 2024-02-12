***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure 2
***Distribution of TWI Training Among Applicant Firms


use "${directory_data}/histograms.dta", clear

*Panel A: Type of TWI training
preserve
by simple_treat_2, s: egen count_id=count(id)
egen tot_id=count(id)
gen share=count_id/tot_id

collapse share, by(simple_treat_2)
graph bar share, over(simple_treat_2) bar(1, color("211 94 96")) bargap(30) blabel(bar, format(%6.2f) position(outside)) ylabel(0(.1).6, angle(0)) ytitle("") graphregion(color(white))
graph export "${directory_results}/figure2_panelA.pdf", replace
restore

*Panel B: Year of training
preserve
by alt_treatment, s: egen count_id=count(id)
egen tot_id=count(id)
gen share=count_id/tot_id

collapse share, by(alt_treatment)
graph bar share, over(alt_treatment, label(labsize(small) angle(0))) bar(1, color("132 186 91")) bargap(1000) blabel(bar, format(%6.2f) position(outside)) ylabel(0(.1).6, angle(0)) ytitle("") graphregion(color(white))
graph export "${directory_results}/figure2_panelB.pdf", replace

restore
