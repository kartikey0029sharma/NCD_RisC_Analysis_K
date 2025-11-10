library(dplyr)
library(tidyr)

cat("Starting data cleaning...\n")

# ----- Region Assignment Function -----
assign_region <- function(country) {
  case_when(
    country %in% c("United States of America", "Canada", "Mexico") ~ "North America",
    country %in% c("United Kingdom", "Germany", "France", "Italy", "Spain", 
                   "Netherlands", "Belgium", "Sweden", "Norway", "Denmark",
                   "Finland", "Ireland", "Switzerland", "Austria", "Portugal") ~ "Western Europe",
    country %in% c("Poland", "Romania", "Czech Republic", "Hungary", "Bulgaria",
                   "Slovakia", "Croatia", "Serbia", "Ukraine", "Russia") ~ "Eastern Europe",
    country %in% c("China", "Japan", "South Korea", "India", "Indonesia", 
                   "Thailand", "Vietnam", "Philippines", "Malaysia", "Pakistan",
                   "Bangladesh", "Singapore") ~ "Asia",
    country %in% c("Brazil", "Argentina", "Chile", "Colombia", "Peru", "Venezuela",
                   "Ecuador", "Bolivia", "Uruguay") ~ "South America",
    country %in% c("Australia", "New Zealand", "Papua New Guinea", "Fiji") ~ "Oceania",
    country %in% c("Egypt", "South Africa", "Nigeria", "Kenya", "Ethiopia",
                   "Ghana", "Morocco", "Tunisia", "Algeria", "Tanzania") ~ "Africa",
    country %in% c("Saudi Arabia", "United Arab Emirates", "Turkey", "Iran",
                   "Iraq", "Israel", "Jordan", "Lebanon", "Kuwait") ~ "Middle East",
    TRUE ~ "Other"
  )
}

# ----- Clean Diabetes Data -----
diabetes_clean <- diabetes %>%
  filter(!is.na(`Prevalence.of.diabetes..18..years.`)) %>%
  mutate(
    Country = trimws(`Country.Region.World`),
    Region = assign_region(Country)
  ) %>%
  filter(Year >= 1990)

# ----- Clean BMI Adult Data -----
bmi_adult_clean <- bmi_adult %>%
  filter(!is.na(`Prevalence.of.BMI..30.kg.m...obesity.`)) %>%
  mutate(
    Country = trimws(`Country.Region.World`),
    Region = assign_region(Country)
  ) %>%
  filter(Year >= 1990)

# ----- Clean BMI Child Data -----
bmi_child_clean <- bmi_child %>%
  filter(!is.na(`Prevalence.of.BMI...2SD..obesity.`)) %>%
  mutate(
    Country = trimws(`Country.Region.World`),
    Region = assign_region(Country)
  ) %>%
  filter(Year >= 1990)

# ----- Clean Cholesterol Data -----
cholesterol_clean <- cholesterol %>%
  filter(!is.na(`Mean.total.cholesterol..mmol.L.`)) %>%
  mutate(
    Country = trimws(`Country.Region.World`),
    Region = assign_region(Country)
  ) %>%
  filter(Year >= 1990)

# ----- Clean Blood Pressure Data -----
blood_pressure_clean <- blood_pressure %>%
  filter(!is.na(`Mean.systolic.blood.pressure..mmHg.`)) %>%
  mutate(
    Country = trimws(`Country.Region.World`),
    Region = assign_region(Country)
  ) %>%
  filter(Year >= 1990)

# ----- Create Combined Diabetes-BMI Dataset -----
diabetes_bmi <- diabetes_clean %>%
  inner_join(
    bmi_adult_clean %>% select(Country, Year, Sex, Mean_BMI = `Prevalence.of.BMI..30.kg.m...obesity.`),
    by = c("Country", "Year", "Sex")
  )

# ----- Create Multi-Factor Combined Dataset -----
risk_factors_combined <- diabetes_clean %>%
  select(Country, Year, Sex, Region, Diabetes_Prev = `Prevalence.of.diabetes..18..years.`) %>%
  left_join(
    bmi_adult_clean %>% select(Country, Year, Sex, Mean_BMI = `Prevalence.of.BMI..30.kg.m...obesity.`),
    by = c("Country", "Year", "Sex")
  ) %>%
  left_join(
    blood_pressure_clean %>% select(Country, Year, Sex,
                                    Mean_SBP = `Mean.systolic.blood.pressure..mmHg.`,
                                    Mean_DBP = `Mean.diastolic.blood.pressure..mmHg.`),
    by = c("Country", "Year", "Sex")
  ) %>%
  left_join(
    cholesterol_clean %>% select(Country, Year, Sex, Mean_TC = `Mean.total.cholesterol..mmol.L.`),
    by = c("Country", "Year", "Sex")
  )

# Save to cache
save(diabetes_clean, file = "cache/diabetes_clean.RData")
save(bmi_adult_clean, file = "cache/bmi_adult_clean.RData")
save(bmi_child_clean, file = "cache/bmi_child_clean.RData")
save(cholesterol_clean, file = "cache/cholesterol_clean.RData")
save(blood_pressure_clean, file = "cache/blood_pressure_clean.RData")
save(diabetes_bmi, file = "cache/diabetes_bmi.RData")
save(risk_factors_combined, file = "cache/risk_factors_combined.RData")

cat("✓ Data cleaning complete!\n")
cat("  - diabetes_clean:", nrow(diabetes_clean), "rows\n")
cat("  - bmi_adult_clean:", nrow(bmi_adult_clean), "rows\n")
cat("  - diabetes_bmi:", nrow(diabetes_bmi), "rows\n")
cat("  - risk_factors_combined:", nrow(risk_factors_combined), "rows\n")

