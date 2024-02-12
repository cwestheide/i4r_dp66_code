* Project: REPLICATION BIANCHI AND GIOORCELLI (2022)
*
* Date: May 2023
*
* Description: Environment file
*
* -----------------------------------------------------------------------------
* HOUSEKEEPING
* version 17
set matsize 4000
set more off

global root "${root_replication_bg}"

* DIRECTORIES

// Data folder
global data "${root}/datasets"

global code "${root}/code"

global results "${root}/results"
cap mkdir "${root}/results"

global tables "$results/Tables"
cap mkdir "$results/Tables"

global figures "$results/Figures"
cap mkdir "$results/Figures"


