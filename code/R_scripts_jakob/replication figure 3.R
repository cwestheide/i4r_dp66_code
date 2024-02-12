### Vienna Replication Games 2023
# Replication of figure 3 panels A, B, and C.
library(dplyr)
library(tidyr)
library(ggplot2)
library(fixest)

setwd("/Users/jakob/Documents/docs/PhD/research/replication games 2023")

# Load data
df = haven::read_dta("datasets/app_main_outcomes_yearly.dta")

## Required variables
# Dependent variables
summary(df$ln_annual_sales)
summary(df$ln_tfpr)
summary(df$ln_roa)

# Running Variable
summary(df$time)

# Treatment
summary(df$treatment_full)

df %>% filter(id == 2)

# Log sales
fe_did_sales = feols(
  ln_annual_sales ~ 
    treat_post_1 +
    treat_post_2 +
    treat_post_3 +
    treat_post_4 +
    # treat_post_5 +
    treat_post_6 +
    treat_post_7 +
    treat_post_8 +
    treat_post_9 +
    treat_post_10 +
    treat_post_11 +
    treat_post_12 +
    treat_post_13 +
    treat_post_14 +
    treat_post_15 +
    treat_post_16 +
    treatment_full |
    county_sector_time + app_window + app_day,
  data = df %>% filter(balanced == 1, second_treatment == ""),
  cluster = "cluster",
) 
summary(fe_did_sales)

rbind(
  tibble(coef = fe_did_sales$coefficients[1:4], se = fe_did_sales$se[1:4], time = c(1:4) - 6),
  tibble(coef = 0, se = 0, time = -1),
  tibble(coef = fe_did_sales$coefficients[5:15], se = fe_did_sales$se[5:15], time = c(6:16) - 6)
) %>%
  ggplot(aes(x = time, y = coef)) +
  geom_hline(aes(yintercept = 0), linetype = "dashed", color = "grey") +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = coef - 1.96 * se, ymax = coef + 1.96 * se),
                width = 0.2) +
  theme_classic()

# Log TFP
fe_did_tfp = feols(
  ln_tfpr ~ treat_post_1 +
    treat_post_2 +
    treat_post_3 +
    treat_post_4 +
    # treat_post_5 +
    treat_post_6 +
    treat_post_7 +
    treat_post_8 +
    treat_post_9 +
    treat_post_10 +
    treat_post_11 +
    treat_post_12 +
    treat_post_13 +
    treat_post_14 +
    treat_post_15 +
    treat_post_16 + 
    treatment_full |
    county_sector_time + app_window + app_day,
  data = df %>% filter(balanced == 1, second_treatment == ""),
  cluster = "cluster",
)
summary(fe_did_tfp)

rbind(
  tibble(coef = fe_did_tfp$coefficients[1:4], se = fe_did_tfp$se[1:4], time = c(1:4) - 6),
  tibble(coef = 0, se = 0, time = -1),
  tibble(coef = fe_did_tfp$coefficients[5:15], se = fe_did_tfp$se[5:15], time = c(6:16) - 6)
) %>%
  ggplot(aes(x = time, y = coef)) +
  geom_hline(aes(yintercept = 0), linetype = "dashed", color = "grey") +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = coef - 1.96 * se, ymax = coef + 1.96 * se),
                width = 0.2) +
  theme_classic()


# Log ROA
fe_did_roa = feols(
  ln_roa ~ 
    treat_post_1 +
    treat_post_2 +
    treat_post_3 +
    treat_post_4 +
    # treat_post_5 +
    treat_post_6 +
    treat_post_7 +
    treat_post_8 +
    treat_post_9 +
    treat_post_10 +
    treat_post_11 +
    treat_post_12 +
    treat_post_13 +
    treat_post_14 +
    treat_post_15 +
    treat_post_16 + 
    treatment_full |
    county_sector_time + app_window + app_day,
  data = df %>% filter(balanced == 1, second_treatment == ""),
  cluster = "cluster",
)
summary(fe_did_roa)

rbind(
  tibble(coef = fe_did_roa$coefficients[1:4], se = fe_did_roa$se[1:4], time = c(1:4) - 6),
  tibble(coef = 0, se = 0, time = -1),
  tibble(coef = fe_did_roa$coefficients[5:15], se = fe_did_roa$se[5:15], time = c(6:16) - 6)
) %>%
  ggplot(aes(x = time, y = coef)) +
  geom_hline(aes(yintercept = 0), linetype = "dashed", color = "grey") +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin = coef - 1.96 * se, ymax = coef + 1.96 * se),
                width = 0.2) +
  theme_classic() + 
  ylim(-0.05, 0.25)

