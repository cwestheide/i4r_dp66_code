***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021

***Description: Replication of Figure 1
***TWI Districts


use "${directory_data}/subdistricts_maps.dta", clear

****************************************************
*Panel A: Applicant and nonapplicant eligible firms
gen nodata3=.
label var nodata3 "Not applied"
gen nodata4=.
label var nodata4 "Applied"

spmap twi_district using "${directory_data}/subdistricts_coord.dta", id(_ID) clmethod(custom) clnumber(22) fcolor("255 237 111" "254 232 200" "204 235 197" "178 223 138" "188 128 189" "217 217 217" "252 205 229" "217 217 217" "128 177 211" "190 186 218" "255 255 179" "141 211 199" "166 206 227" "251 154 153" "253 191 111" "202 178 214" "246 232 195" "199 234 229" "241 182 218" "230 245 152" "191 211 230") clbreaks(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22) ocolor(gs1 ...) osize(vvthin ...) ndocolor(gs8) ndsize(vvthin) ndfcolor(white) point(data("${directory_data}/firms_maps.dta") by(applied) xc(_X) yc(_Y) size(tiny vtiny) shape(Th X) fcolor("23 68 154" "150 1 108") legenda(off)) 

addplot: (scatter nodata3 subdistrict, msize(*1.5) mcolor("23 68 154") msymbol(Th)) || (scatter nodata4 subdistrict, msize(*1.5) mcolor("150 1 108") msymbol(X)), legend(order(26 25) size(medium)) norescaling

drop nodata3 nodata4

graph export "${directory_results}/figure_1a.png", replace


****************************************************
*Panel B: Trained and nontrained applicant firms
gen nodata1=.
label var nodata1 "Not trained"
gen nodata2=.
label var nodata2 "Trained"

spmap twi_district using "${directory_data}/subdistricts_coord.dta", id(_ID) clmethod(custom) clnumber(22) fcolor("255 237 111" "254 232 200" "204 235 197" "178 223 138" "188 128 189" "217 217 217" "252 205 229" "217 217 217" "128 177 211" "190 186 218" "255 255 179" "141 211 199" "166 206 227" "251 154 153" "253 191 111" "202 178 214" "246 232 195" "199 234 229" "241 182 218" "230 245 152" "191 211 230") clbreaks(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22) ocolor(gs1 ...) osize(vvthin ...) ndocolor(gs8) ndsize(vvthin) ndfcolor(white) point(data("${directory_data}/firms_maps.dta") by(treatment) xc(_X) yc(_Y) size(tiny vtiny) shape(Th X) fcolor(red green) legenda(off)) 

addplot: (scatter nodata1 subdistrict, msize(*1.5) mcolor(red) msymbol(Th)) || (scatter nodata2 subdistrict, msize(*1.5) mcolor(green) msymbol(X)), legend(order(26 25) size(medium)) norescaling

drop nodata1 nodata2

graph export "${directory_results}/figure_1b.png", replace



