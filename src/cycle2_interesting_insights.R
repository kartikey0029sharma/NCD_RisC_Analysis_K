# ============================================
# SECOND CRISP-DM CYCLE: Interesting Insights
# File: src/cycle2_interesting_insights.R
# ============================================

library(ggplot2)
library(dplyr)
library(tidyr)

cat("\n=== SECOND CRISP-DM CYCLE: INTERESTING INSIGHTS ===\n\n")

# Research Questions:
# Q3: Which countries improved their diabetes rates (time travelers)?
# Q4: Is there a relationship between BMI and diabetes?
# Q5: Which countries defy the BMI-diabetes relationship (outliers)?

# ----- ANALYSIS 1: Time Travelers (Countries that Improved) -----
cat("Analysis 1: Finding time travelers...\n")
time_travelers <- diabetes_clean %>%
  filter(Sex %in% c("Men", "Women"), Year %in% c(2000, 2020)) %>%
  group_by(Country, Year, Region) %>%
  summarise(Diabetes = mean(Prevalence_numeric, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = Year, 
    values_from = Diabetes,
    names_glue = "Year_{Year}"
  ) %>%
  filter(!is.na(Year_2000) & !is.na(Year_2020)) %>%  # keep only countries with both years
  mutate(Change = Year_2020 - Year_2000) %>%
  arrange(Change)


# Save results
write.csv(time_travelers, "output/time_travelers.csv", row.names = FALSE)

# Plot time travelers
plot4 <- ggplot(rbind(head(time_travelers, 10), tail(time_travelers, 10)),
                aes(x = reorder(Country, Change), y = Change, fill = Change > 0)) +
  geom_col(alpha = 0.8) +
  scale_fill_manual(values = c("TRUE" = "#d73027", "FALSE" = "#4575b4"),
                    labels = c("Decreased", "Increased")) +
  coord_flip() +
  labs(
    title = "Diabetes Time Travelers: Biggest Changes (2000-2020)",
    subtitle = "Winners: Decreased | Losers: Increased",
    x = "Country",
    y = "Change in Diabetes Prevalence (%)",
    fill = "Direction"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 13, face = "bold"))

ggsave("graphs/cycle2_time_travelers.png", plot4, width = 10, height = 8, dpi = 300)
print(plot4)

cat("  Winners (Decreased):", nrow(time_travelers %>% filter(Change < 0)), "\n")
cat("  Losers (Increased):", nrow(time_travelers %>% filter(Change > 0)), "\n")

# ----- ANALYSIS 2: BMI-Diabetes Correlation -----
cat("\nAnalysis 2: BMI-Diabetes correlation...\n")

cor_result <- plot_correlation(
  diabetes_bmi,
  "Mean_BMI",
  "Prevalence.of.diabetes..18..years.",
  "Relationship Between BMI and Diabetes (2020)",
  "Mean BMI (kg/m²)",
  "Diabetes Prevalence (%)",
  2020
)

ggsave("graphs/cycle2_bmi_diabetes_correlation.png", cor_result$plot, 
       width = 10, height = 7, dpi = 300)
print(cor_result$plot)

cat("  Correlation: r =", round(cor_result$correlation$estimate, 3), "\n")
cat("  P-value:", cor_result$correlation$p.value, "\n")

# ----- ANALYSIS 3: Outliers (Rule Breakers) -----
cat("\nAnalysis 3: Finding outliers...\n")



model_data <- diabetes_bmi %>%
  filter(Year == 2020, Sex == "Men", 
         !is.na(Mean_BMI), !is.na(Prevalence.of.diabetes..18..years.))

lm_model <- lm(Prevalence.of.diabetes..18..years. ~ Mean_BMI, data = model_data)
model_data$predicted <- predict(lm_model)
model_data$residual <- residuals(lm_model)
model_data$residual_sd <- model_data$residual / sd(model_data$residual)

outliers <- model_data %>%
  mutate(
    Outlier_Type = case_when(
      residual_sd > 2 ~ "Higher Diabetes Than Expected",
      residual_sd < -2 ~ "Lower Diabetes Than Expected",
      TRUE ~ "Normal"
    )
  ) %>%
  filter(Outlier_Type != "Normal") %>%
  select(Country, Region, Mean_BMI, Prevalence, predicted, residual, Outlier_Type) %>%
  arrange(desc(abs(residual)))

write.csv(outliers, "output/outliers.csv", row.names = FALSE)

# Plot outliers
plot5 <- ggplot(model_data, aes(x = Mean_BMI, y = Prevalence)) +
  geom_point(aes(color = abs(residual_sd) > 2), alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", color = "red", se = TRUE, size = 1.2) +
  geom_text(data = head(outliers, 15), aes(label = Country), 
            size = 2.5, hjust = -0.1, check_overlap = TRUE) +
  scale_color_manual(values = c("FALSE" = "gray50", "TRUE" = "#e91e63"),
                     labels = c("Normal", "Outlier")) +
  labs(
    title = "Rule Breakers: Countries That Defy BMI-Diabetes Relationship",
    subtitle = "Outliers are >2 SD from predicted values (2020)",
    x = "Mean BMI (kg/m²)",
    y = "Diabetes Prevalence (%)",
    color = "Status"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold"))

ggsave("graphs/cycle2_outliers.png", plot5, width = 12, height = 8, dpi = 300)
print(plot5)

cat("  Total outliers found:", nrow(outliers), "\n")
cat("  - Higher than expected:", sum(outliers$Outlier_Type == "Higher Diabetes Than Expected"), "\n")
cat("  - Lower than expected:", sum(outliers$Outlier_Type == "Lower Diabetes Than Expected"), "\n")

# ----- ANALYSIS 4: Gender Differences -----
cat("\nAnalysis 4: Gender differences in BMI...\n")

gender_flip <- bmi_adult_clean %>%
  filter(Year == 2020, Sex %in% c("Men", "Women")) %>%
  select(Country, Region, Sex, Prevalence.of.BMI.18.5.kg.m...underweight.) %>%
  pivot_wider(names_from = Sex, values_from = Prevalence.of.BMI.18.5.kg.m...underweight.) %>%
  mutate(
    Women_Heavier = Women > Men,
    Difference = Women - Men
  ) %>%
  filter(Women_Heavier == TRUE) %>%
  arrange(desc(Difference))

write.csv(gender_flip, "output/gender_flip.csv", row.names = FALSE)

plot6 <- ggplot(head(gender_flip, 15), 
                aes(x = reorder(Country, Difference), y = Difference)) +
  geom_col(fill = "#e91e63", alpha = 0.8) +
  coord_flip() +
  labs(
    title = "Gender Flip: Countries Where Women Have Higher BMI",
    subtitle = "Difference in BMI points (Women - Men), 2020",
    x = "Country",
    y = "BMI Difference (Women - Men)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 13, face = "bold"))

ggsave("graphs/cycle2_gender_flip.png", plot6, width = 10, height = 8, dpi = 300)
print(plot6)

cat("  Countries where women heavier:", nrow(gender_flip), "\n")

cat("\n✓ Cycle 2 Analysis Complete!\n")
cat("  - 3 additional plots saved\n")
cat("  - 3 CSV files with detailed results\n")

