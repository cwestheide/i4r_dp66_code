*** This and other files in this folder modified by Christian Westheide

***"The Dynamic and Spillover Effects of Management Interventions: Evidence from the Training Within Industry Program"***
***Authors: Nicola Bianchi and Michela Giorcelli 
***Date: August 2021


*This is the master file to replicate all the figures and tables in the paper and in the appendix
*Disclaimer: The data and codes are distributed with the sole purpose of replication. Any other use, such as novel academic work, is prohibited without the authors' approval.

*Select here path in which the folder with the replication files is located
global your_path ""
global your_path_data ""

*Other paths (do not need to be changed)
global directory_do "${your_path}/do_files_replication"
global directory_data "${your_path_data}/datasets"

global directory_results "${your_path}/results"

do "${directory_do}/installs.do"

foreach version in "" "3" "5" {
	
	timer on 1

	cap log close
	cap log using "${directory_results}/version`version'.log", replace


	*******MAIN TEXT*********
	*Figures
	cap do "${directory_do}/JPE-2020-0781_figure1.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figure2.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figure3.do" `version'

	*Tables
	cap do "${directory_do}/JPE-2020-0781_table1.do" `version'
	cap do "${directory_do}/JPE-2020-0781_table2.do" `version'
	cap do "${directory_do}/JPE-2020-0781_table3.do" `version'
	cap do "${directory_do}/JPE-2020-0781_table4.do" `version'
	cap do "${directory_do}/JPE-2020-0781_table5.do" `version'

	*******APPENDIX*********
	*Figures
	cap do "${directory_do}/JPE-2020-0781_figureA2.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA3.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA4.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA5.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA5_BE_withfixeddata.do" `version'

	cap do "${directory_do}/JPE-2020-0781_figureA6.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA7.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA8.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA9.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA10.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA11.do" `version'
	cap do "${directory_do}/JPE-2020-0781_figureA12.do" `version'

	*Tables
	cap do "${directory_do}/JPE-2020-0781_tableA2.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA3.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA4.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA4_pvalues.do" `version'

	cap do "${directory_do}/JPE-2020-0781_tableA5.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA6.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA7_tableB3.do" `version'
	cap do "${directory_do}/JPE-2020-0781_table_a7_table_b3_v2.do" `version'

	cap do "${directory_do}/JPE-2020-0781_tableA8.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA9.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA11.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA12.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA13.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA14.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA15.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA16.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA17.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableA18.do" `version'

	cap do "${directory_do}/JPE-2020-0781_figureB1.do" `version'

	cap do "${directory_do}/JPE-2020-0781_tableC1.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableC2.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableC3.do" `version'
	cap do "${directory_do}/JPE-2020-0781_tableC4.do" `version'
	
	cap log close
	timer off 1
	quietly timer list
	display as text "Elapsed time: " as result %3.2f `=`r(t1)'/60'
	}

foreach version in "" "3" "5" {
	
	timer on 1

	do "${directory_do}/JPE-2020-0781_tableA10.do" `version'
	
	timer off 1
	quietly timer list
	display as text "Elapsed time: " as result %3.2f `=`r(t1)'/60'
}

foreach version in "" "3" "5" {
	
	timer on 1

	version 13: do "${directory_do}/JPE-2020-0781_tableA10.do" `version'
	
	timer off 1
	quietly timer list
	display as text "Elapsed time: " as result %3.2f `=`r(t1)'/60'
}	
	
foreach version in "" "3" "5" {
	
	timer on 1

	version 13: do "${directory_do}/JPE-2020-0781_tableA10c_withfixeddata.do" `version'
	
	timer off 1
	quietly timer list
	display as text "Elapsed time: " as result %3.2f `=`r(t1)'/60'
}	


*Delete txt files
local txtfiles: dir "${directory_results}/" files "*.txt"
foreach txt in `txtfiles' {
    erase `"${directory_results}/`txt'"'
}
