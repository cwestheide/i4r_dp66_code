**** MASTER DO-FILE  ****

/*
Master do-file for Stata code replication.

The master do-file runs all the replication analyses. 


REQUIREMENTS
------------
 - All code was run on Stata Version 17, but should work in earlier versions of 
Stata. 


 - To correctly set up the directory in your computer, create a global in your 
 Stata profile do-file, setting up the location of the parent directory in your
 computer. You can follow these steps:

 	1. Open your profile do-file by typing in the Stata command prompt: 
 		doedit `"`c(sysdir_personal)'profile.do"'

 	2. Write in the profile do-file the global root_replication_bg with the location of 
 	the parent directory in your computer (notice, this should be the location of 
 	the replication_bianchi_giorcelli repo):
 		global root_replication_bg "location of the directory"

	3. Save the do-file and close. 

*/

******************************************************************************** 
******************************************************************************** 


********************
*** 0) HOUSEKEEPING
********************
* Also runs in the beginning of every do-file

* HOUSEKEEPING
clear
clear frames

if ("${root_replication_bg" == "") do `"`c(sysdir_personal)'profile.do"' // Run profile.do if the directory global is empty
do "${root_replication_bg}/code/set_environment.do" // Set environment

*****************************
*** 1)  Sensitivity analyses
*****************************

// Sensitivity to changes in the outcome variable  (levels)
cd "${code}"
qui do sensitivity_outcome.do

// Sensitivity to changes in fixed effects included
cd "${code}"
qui do sensitivity_fixed_effects.do

// Sensitivity to different DiD estimators
cd "${code}"
qui do did_estimators.do

// Compute the original pvalues of the original paper's Table 3
cd "${code}"
qui do original_pvalues_table3.do



