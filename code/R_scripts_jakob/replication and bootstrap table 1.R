### Vienna Replication Games 2023

library(dplyr)
library(tidyr)
library(ggplot2)
library(estimatr)
library(grid)
library(gridExtra)
library(ggplotify)
library(xtable)
options(dplyr.summarise.inform = FALSE)

setwd("/Users/jakob/Documents/docs/PhD/research/replication games 2023")

summary_data = haven::read_dta("datasets/summary_stats.dta")

# Select year 1939
summary_data = summary_data %>% filter(year == 1939)

lm_robust(
  plants ~ treatment_full,
  data = summary_data,
  clusters = cluster
) %>% summary
# p-values in table 1 are based on regressions with clusters on subdistrict and application window

## Panel A
# Reproducing the comparison of treated to non-treated using t-tests without clustering:
output = (panel_a = summary_data %>% select(
  plants, employees, foundation_year, agriculture, 
  manufacturing, transportation, services, annual_sales, 
  current_assets, total_assets,  ln_tfpr, roa, inventory, 
  injuries, repairs, bonus,
  treatment_full
) %>%
    pivot_longer(
      cols = c(plants, employees, foundation_year, agriculture, 
               manufacturing, transportation, services, annual_sales, 
               current_assets, total_assets,  ln_tfpr, roa, inventory, 
               injuries, repairs, bonus),
      names_to = "category"
    ) %>%
    group_by(treatment_full, category) %>%
    summarise(value = list(value)) %>%
    spread(treatment_full, value) %>%
    group_by(category) %>%
    mutate(
      mean_trained = t.test(unlist(`0`), unlist(`1`))$estimate[2],
      mean_untrained = t.test(unlist(`0`), unlist(`1`))$estimate[1],
      dif = mean(unlist(`0`)) - mean(unlist(`1`)),
      t_value = t.test(unlist(`0`), unlist(`1`))$statistic,
      p_value = t.test(unlist(`0`), unlist(`1`))$p.value,
      sig = ifelse(p_value < 0.05, "*", "")
    ) %>% select(-c(`0`, `1`))) %>% 
  mutate(
      category = category %>% recode(
        agriculture = "Agriculture",
        annual_sales = "Sales",
        bonus = "Bonus payments",
        current_assets = "Current assets",
        employees = "Employees",
        foundation_year = "Foundation year",
        injuries = "Injuries",
        inventory = "Inventory",
        ln_tfpr = "TFP",
        manufacturing = "Manufacturing",
        plants = "Plants",
        repairs = "Repairs",
        roa = "ROA",
        services = "Services",
        total_assets = "Total assets",
        transportation = "Transportation"
      ) %>% factor(
        levels = c(
          "Plants",
          "Employees",
          "Foundation year",
          "Agriculture",
          "Manufacturing",
          "Transportation",
          "Services",
          "Sales",
          "Current assets",
          "Total assets",
          "TFP",
          "ROA",
          "Inventory",
          "Injuries",
          "Repairs",
          "Bonus payments"
        )
      )
    ) %>% arrange(category) %>%
  rename(
    Category = category,
    Difference = dif,
    Mean_trained = mean_trained,
    Mean_untrained = mean_untrained
  )
output 

# Print for Latex
dir.create("tables")
print(xtable(output, 
             caption = "Replication of Table 1, panel A",
             label = "tab:table1_replication"), 
      file = "tables/table1_replication.tex")

## Bootstrap: 
# Comparing the true differences between treated and non-treated to 
# the distribution of differences if treatment assignment is random.
strt = Sys.time()
reps = 5000 # number of bootstrap samples
treat = c(rep(0, sum(summary_data$treatment_full == 0)), 
          rep(1, sum(summary_data$treatment_full == 1)))
bs_samples = tibble(plants = numeric(reps), 
                    employees = numeric(reps), 
                    foundation_year = numeric(reps), 
                    agriculture = numeric(reps),
                    manufacturing = numeric(reps), 
                    transportation = numeric(reps), 
                    services= numeric(reps), 
                    annual_sales= numeric(reps), 
                    current_assets= numeric(reps), 
                    total_assets= numeric(reps),  
                    ln_tfpr= numeric(reps), 
                    roa= numeric(reps), 
                    inventory= numeric(reps), 
                    injuries= numeric(reps), 
                    repairs= numeric(reps), 
                    bonus= numeric(reps)
) %>% select(sort(current_vars())) %>% as.matrix()
for(i in 1:reps){
  # Randomly assign treatment to firms
  bs_data = summary_data %>%
    mutate(treatment_full = sample(treat, size = length(treat), replace = F))
  
  # Calculate differences between treated and non-treated
  difs = bs_data %>% select(
    plants, employees, foundation_year, agriculture, 
    manufacturing, transportation, services, annual_sales, 
    current_assets, total_assets,  ln_tfpr, roa, inventory, 
    injuries, repairs, bonus,
    treatment_full
  ) %>%
    pivot_longer(
      cols = c(plants, employees, foundation_year, agriculture, 
               manufacturing, transportation, services, annual_sales, 
               current_assets, total_assets,  ln_tfpr, roa, inventory, 
               injuries, repairs, bonus),
      names_to = "category"
    ) %>%
    group_by(treatment_full, category) %>%
    summarise(value = list(value)) %>%
    spread(treatment_full, value) %>%
    group_by(category) %>%
    mutate(
      dif = mean(unlist(`0`)) - mean(unlist(`1`)),
      t_value = t.test(unlist(`0`), unlist(`1`))$statistic,
      p_value = t.test(unlist(`0`), unlist(`1`))$p.value,
      sig = ifelse(p_value < 0.05, "*", "")
    ) %>% ungroup %>% 
    select(dif) %>%
    mutate(dif = abs(dif)) # absolute value of difference
  
  # Store differences
  bs_samples[i, ] = difs$dif
}

# Density plots
save_graphs = FALSE
if(save_graphs){dir.create("plots")}
for(i in c(
  "plants", "employees", "foundation_year", "agriculture", 
  "manufacturing", "transportation", "services", "annual_sales", 
  "current_assets", "total_assets",  "ln_tfpr", "roa", "inventory", 
  "injuries", "repairs", "bonus"
)){
  print(bs_samples[, i] %>% as.data.frame() %>%
          ggplot(aes(x = .)) +
          geom_density() +
          geom_vline(aes(xintercept = abs((panel_a %>% 
                                             filter(category == i))$dif)),
                     color = "red") + 
          theme_classic() +
          labs(x = i))
  if(save_graphs){
    ggsave(
      paste("plots/bootstrap_dif_", i, ".png", sep = ""),
      height = 9, width = 16, units = "cm", dpi = "retina"
    )
  }
}

Sys.time() - strt

# One plot with all variables
var_names = c(
  "plants", "employees", "foundation_year", "agriculture", 
  "manufacturing", "transportation", "services", "annual_sales", 
  "current_assets", "total_assets",  "ln_tfpr", "roa", "inventory", 
  "injuries", "repairs", "bonus"
)
plotlist = vector("list", 16)
for(j in 1:length(var_names)){
  plotlist[[j]] = local({
    i = var_names[j]
    p1 = as.grob(bs_samples[, i] %>% as.data.frame() %>%
      ggplot(aes(x = .)) +
      geom_density() +
      geom_vline(aes(xintercept = abs((panel_a %>% 
                                         filter(category == i))$dif)),
                 color = "red") + 
      theme_classic() +
        theme(text = element_text(family = "serif")) +
        scale_x_continuous(n.breaks=2) +
        scale_y_continuous(n.breaks=3) +
      labs(x = i))
      
  })
}

g = arrangeGrob(plotlist[[1]],
             plotlist[[2]],
             plotlist[[3]],
             plotlist[[4]],
             plotlist[[5]],
             plotlist[[6]],
             plotlist[[7]],
             plotlist[[8]],
             plotlist[[9]],
             plotlist[[10]],
             plotlist[[11]],
             plotlist[[12]],
             plotlist[[13]],
             plotlist[[14]],
             plotlist[[15]],
             plotlist[[16]],
             nrow = 4)
plot(g)
if(save_graphs){
  ggsave("plots/bootstrap_dif_all.pdf", g, 
         height = 16, width = 16, units = "cm", dpi = "retina")
}

