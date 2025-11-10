# ============================================
# FIRST CRISP-DM CYCLE
# File: src/cycle1_analysis.R
# ============================================

library(ggplot2)
library(dplyr)

cat("\n=== FIRST CRISP-DM CYCLE ===\n\n")

# Research Questions:
# Q1: How has diabetes prevalence changed globally?
# Q2: Which regions have the highest diabetes burden?


head(diabetes_clean$`Prevalence.of.diabetes..18..years.`)
unique(diabetes_clean$`Prevalence.of.diabetes..18..years.`)[1:20]

diabetes_clean$Prevalence_numeric <- as.numeric(
  gsub("[^0-9\\.]", "", diabetes_clean$`Prevalence.of.diabetes..18..years.`)
)

summary(diabetes_clean$Prevalence_numeric)
sum(is.na(diabetes_clean$Prevalence_numeric))


# ----- PLOT 1: Global Diabetes Trends -----
cat("Creating Plot 1: Diabetes time trends...\n")
plot1 <- plot_time_trend(
  diabetes_clean,
  "Prevalence_numeric",
  "Global Diabetes Prevalence Trends (1990-2024)",
  "Diabetes Prevalence (%)"
)
ggsave("graphs/cycle1_diabetes_trends.png", plot1, width = 10, height = 6, dpi = 300)
print(plot1)

# ----- PLOT 2: Regional Comparison 2020 -----
cat("Creating Plot 2: Regional comparison...\n")
plot2 <- plot_regional_comparison(
  diabetes_clean,
  "Prevalence_numeric",
  2020,
  "Diabetes Prevalence by Region (2020)",
  "Prevalence (%)"
)
ggsave("graphs/cycle1_regional_comparison.png", plot2, width = 10, height = 6, dpi = 300)
print(plot2)

# ----- PLOT 3: Top 10 Countries -----
cat("Creating Plot 3: Top 10 countries...\n")
plot3 <- plot_top_countries(diabetes_clean, "Prevalence_numeric", 2020, n = 10, top = TRUE)
ggsave("graphs/cycle1_top10_countries.png", plot3, width = 10, height = 6, dpi = 300)
print(plot3)


# ----- Summary Statistics -----
cat("\nCalculating summary statistics...\n")
summary_stats <- diabetes_clean %>%
  filter(Year == 2017, Sex == "Men") %>%
  summarise(
    Mean = round(mean(Prevalence_numeric, na.rm = TRUE), 2),
    Median = round(median(Prevalence_numeric, na.rm = TRUE), 2),
    SD = round(sd(Prevalence_numeric, na.rm = TRUE), 2),
    Min = round(min(Prevalence_numeric, na.rm = TRUE), 2),
    Max = round(max(Prevalence_numeric, na.rm = TRUE), 2)
  )

print(summary_stats)
write.csv(summary_stats, "output/cycle1_summary_stats.csv", row.names = FALSE)

cat("\n✓ Cycle 1 Analysis Complete!\n")
cat("  - 3 plots saved to graphs/\n")
cat("  - Summary stats saved to output/\n")
