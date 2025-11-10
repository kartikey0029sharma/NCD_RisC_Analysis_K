# ============================================
# Create Summary Data for Report
# ============================================

# Key findings for report
key_findings <- list(
  cycle1 = list(
    diabetes_increase = paste0(
      "Global diabetes prevalence increased from ",
      round(mean(diabetes_clean$Prevalence.of.diabetes..18..years.[diabetes_clean$Year==1990 & 
                                             diabetes_clean$Sex=="Men"], na.rm=TRUE), 1),
      "% in 1990 to ",
      round(mean(diabetes_clean$Prevalence.of.diabetes..18..years.[diabetes_clean$Year==2020 & 
                                             diabetes_clean$Sex=="Men"], na.rm=TRUE), 1),
      "% in 2020"
    ),
    highest_region = time_travelers %>% 
      group_by(Region) %>% 
      summarise(Mean_Change = mean(Change)) %>% 
      arrange(desc(Mean_Change)) %>% 
      head(1)
  ),
  cycle2 = list(
    best_improver = time_travelers %>% head(1),
    worst_increaser = time_travelers %>% tail(1),
    correlation = round(cor_result$correlation$estimate, 3),
    outliers_count = nrow(outliers),
    gender_flip_count = nrow(gender_flip)
  )
)

# Save key findings
save(key_findings, file = "output/key_findings.RData")

cat("✓ Summary data created and saved!\n")

