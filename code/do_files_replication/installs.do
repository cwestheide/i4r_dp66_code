cap ssc inst spmap
cap ssc inst addplot
cap ssc inst regsave
cap ssc inst leebounds
cap ssc inst wyoung
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/") replace
net install ivreghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/") replace
global temp_data "${your_path_data}/temp"
cd "$temp_data"
