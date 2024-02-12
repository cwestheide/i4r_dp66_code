### Vienna Replication Games 2023
# Replication of table 3
library(dplyr)
library(tidyr)
library(fixest)
library(xtable)

setwd("/Users/jakob/Documents/docs/PhD/research/replication games 2023")

# Load data
df = haven::read_dta("datasets/app_other_outcomes_yearly.dta")

dep_vars = c("ln_repairs", "ln_maintenance", "ln_injuries", 
             "ln_bonus", "ln_strikes", "d_training", "ln_inventory", 
             "ln_product_lines", "d_marketing")
for(i in 1:length(dep_vars)){
  dv = dep_vars[i]
  
  fe_model = feols(
    formula(
      paste(dv, "~",
            "op_post_1 +
             op_post_2 +
             op_post_3 +
             op_post_4 +
             op_post_6 +
             op_post_7 +
             op_post_8 +
             op_post_9 +
             op_post_10 +
             op_post_11 +
             op_post_12 +
             op_post_13 +
             op_post_14 +
             op_post_15 +
             op_post_16 +
             hr_post_1 +
             hr_post_2 +
             hr_post_3 +
             hr_post_4 +
             hr_post_6 +
             hr_post_7 +
             hr_post_8 +
             hr_post_9 +
             hr_post_10 +
             hr_post_11 +
             hr_post_12 +
             hr_post_13 +
             hr_post_14 +
             hr_post_15 +
             hr_post_16 +
             io_post_1 +
             io_post_2 +
             io_post_3 +
             io_post_4 +
             io_post_6 +
             io_post_7 +
             io_post_8 +
             io_post_9 +
             io_post_10 +
             io_post_11 +
             io_post_12 +
             io_post_13 +
             io_post_14 +
             io_post_15 +
             io_post_16 +
             first_hr + first_op + first_io |
             county_sector_time + app_window + app_day")
    ),
    data = df %>% filter(balanced == 1 & second_treatment == ""),
    cluster = "cluster"
  )
  print(summary(fe_model))
  
  coef_numbers = c(5, 10, 15, 20, 25, 30, 35, 40, 45)
  new_coefs = tibble(
    "variable" = names(fe_model$coefficients[coef_numbers]),
    "coef" = fe_model$coefficients[coef_numbers],
    "se" = fe_model$se[coef_numbers],
    "p" = fe_model$coeftable[coef_numbers, 4],
    "sig" = ifelse(fe_model$coeftable[coef_numbers, 4] < 0.01, "***",
                   ifelse(fe_model$coeftable[coef_numbers, 4] < 0.05, "**",
                          ifelse(fe_model$coeftable[coef_numbers, 4] < 0.1, "*",
                                 ""))),
    "coef_sig" = paste(
      round(coef, 3), sig
    )
  ) %>%
    rename_with(
      function(x){paste(x, "_", dv, sep = "")},
      .cols = c(coef, se, p, sig, coef_sig)
    )
  if(i == 1){
    output = new_coefs
  } else {
    output = full_join(
      output, 
      new_coefs,
      by = "variable"
    )
  }
}
output = output %>% mutate(
  variable = c(
    "1 J-I x Period 1",
    "2 J-I x Period 5",
    "3 J-I x Period 10",
    "4 J-R x Period 1",
    "5 J-R x Period 5",
    "6 J-R x Period 10",
    "7 J-M x Period 1",
    "8 J-M x Period 5",
    "9 J-M x Period 10"
  )
)
output_p = output %>% select(-contains("se"))
output = output %>% select(-contains("p_"))
output

# Coefficients
output %>% select(variable, contains("coef_sig")) %>% 
  rename_with(.fn = 
                function(name){gsub(x = name, "coef_sig_", "")})
# Standard errors
output %>% select(variable, contains("se")) %>%
  rename_with(.fn = 
                function(name){gsub(x = name, "se_", "")})

## Table with standard errors
final_table = rbind(
  output %>% select(variable, contains("coef_sig")) %>% 
    rename_with(.fn = 
                  function(name){gsub(x = name, "coef_sig_", "")}),
  output %>% select(variable, contains("se")) %>%
    mutate_at(
      .funs = function(x){as.character(round(x, 3))},
      .vars = vars(contains("se"))
    ) %>%
    rename_with(.fn = 
                  function(name){gsub(x = name, "se_", "")})
) %>% arrange(variable) %>%
  mutate(
    variable = substr(variable, 3, nchar(variable))
  ) 
final_table

# Print for Latex
dir.create("tables")
print(xtable(final_table,
             caption = "Replication of Table 3",
             label = "tab:table3_replication"), 
      file = "tables/table3_replication.tex")

## Table with p-values
final_table_p = rbind(
  output_p %>% select(variable, contains("coef_sig")) %>% 
    rename_with(.fn = 
                  function(name){gsub(x = name, "coef_sig_", "")}),
  output_p %>% select(variable, contains("p_")) %>%
    mutate_at(
      .funs = function(x){as.character(round(x, 3))},
      .vars = vars(contains("p_"))
    ) %>%
    rename_with(.fn = 
                  function(name){gsub(x = name, "p_", "")})
) %>% arrange(variable) %>%
  mutate(
    variable = substr(variable, 3, nchar(variable))
  ) 
final_table_p

# Print for Latex
print(xtable(final_table_p,
             caption = "Replication of Table 3",
             label = "tab:table3_replication"), 
      file = "tables/table3_replication_p.tex")
