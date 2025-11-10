
```
================================================================
NCD-RisC ANALYSIS PROJECT: Surprising Patterns in Global Diabetes
================================================================

Author: Kartikey Sharma (ID: 250559280)
        Aman Rana (ID: 250480674)
        Pratik Pathe (ID: 250580169)
        Kartik Sharma (ID: 250356977)

Date: November 2025
Course: MAS8600/MAS8505

================================================================
PROJECT OVERVIEW
================================================================

This project investigates surprising patterns in global diabetes and 
obesity trends using NCD Risk Factor Collaboration data. The analysis 
follows CRISP-DM methodology across two cycles:

Cycle 1: Baseline understanding of global trends
Cycle 2: Investigation of outliers, improvements, and paradoxes

KEY FINDINGS:
- Several countries successfully REDUCED diabetes (2000-2020)
- Strong BMI-diabetes correlation, but many outliers exist
- Gender patterns in obesity vary dramatically by region
- Regional clustering suggests policy/cultural influences

================================================================
SYSTEM REQUIREMENTS
================================================================

Software:
- R version 4.0 or higher
- RStudio (recommended)

Required R Packages:
- dplyr
- ggplot2
- tidyr
- readr
- knitr
- rmarkdown

Installation:
install.packages(c("dplyr", "ggplot2", "tidyr", "readr", 
                   "knitr", "rmarkdown"))

================================================================
PROJECT STRUCTURE
================================================================

NCD_RisC_Analysis_K/
├── data/                          # Raw CSV data files
│   ├── NCD_RisC_Lancet_2024_Diabetes_age_standardised_countries.csv
│   ├── NCD_RisC_Lancet_2024_BMI_age_standardised_country.csv
│   ├── NCD_RisC_Lancet_2024_BMI_child_adolescent_country_ageStd.csv
│   ├── NCD_RisC_Nature_2020_Cholesterol_age_standardised_countries.csv
│   └── NCD_RisC_Lancet_2017_BP_age_standardised_countries.csv
│
├── munge/                         # Data preprocessing scripts
│   └── 01-clean-data.R           # Cleans and prepares all datasets
│
├── src/                           # Analysis scripts and functions
│   ├── analysis_functions.R      # Reusable plotting functions
│   ├── cycle1_analysis.R         # First CRISP-DM cycle
│   └── cycle2_interesting_insights.R  # Second CRISP-DM cycle
│
├── cache/                         # Cached cleaned data (RData files)
│   ├── diabetes_clean.RData
│   ├── bmi_adult_clean.RData
│   ├── diabetes_bmi.RData
│   └── risk_factors_combined.RData
│
├── graphs/                        # Generated visualizations (PNG)
│   ├── cycle1_diabetes_trends.png
│   ├── cycle1_regional_comparison.png
│   ├── cycle1_top10_countries.png
│   ├── cycle2_time_travelers.png
│   ├── cycle2_bmi_diabetes_correlation.png
│   ├── cycle2_outliers.png
│   └── cycle2_gender_flip.png
│
├── output/                        # Analysis results (CSV)
│   ├── cycle1_summary_stats.csv
│   ├── time_travelers.csv
│   ├── outliers.csv
│   ├── gender_flip.csv
│   └── key_findings.RData
│
├── reports/                       # R Markdown report and output
│   ├── analysis_report.Rmd       # Report source code
│   └── analysis_report.pdf       # Final PDF report
│
└── README.txt                     # This file

================================================================
HOW TO RUN THE ANALYSIS
================================================================

OPTION 1: Run Complete Analysis
--------------------------------
1. Open R/RStudio
2. Set working directory:
   setwd("C:/Users/DELL/Documents/NCD_RisC_Analysis_K")
3. Load data (already done - diabetes, bmi_adult, etc.)
4. Run complete workflow:
   
   source("munge/01-clean-data.R")
   source("src/analysis_functions.R")
   source("src/cycle1_analysis.R")
   source("src/cycle2_interesting_insights.R")
   
5. Generate report:
   library(rmarkdown)
   render("reports/analysis_report.Rmd")

OPTION 2: Step-by-Step
-----------------------
Step 1: Clean data
source("munge/01-clean-data.R")

Step 2: Load functions
source("src/analysis_functions.R")

Step 3: Run Cycle 1
source("src/cycle1_analysis.R")
# Check graphs/ folder for plots

Step 4: Run Cycle 2
source("src/cycle2_interesting_insights.R")
# Check graphs/ and output/ for results

Step 5: Generate PDF
library(rmarkdown)
render("reports/analysis_report.Rmd")

================================================================
DELIVERABLES LOCATION
================================================================

Primary Deliverable:
- Final Report: reports/analysis_report.pdf

Supporting Materials:
- All visualizations: graphs/ folder (7 PNG files)
- Analysis results: output/ folder (4 CSV files)
- Source code: munge/ and src/ folders
- Report source: reports/analysis_report.Rmd

================================================================
RESEARCH QUESTIONS ADDRESSED
================================================================

First CRISP-DM Cycle:
Q1: How has global diabetes prevalence changed (1990-2024)?
Q2: Which regions show the highest diabetes burden?

Second CRISP-DM Cycle:
Q3: Which countries successfully reduced diabetes?
Q4: How strong is the BMI-diabetes relationship?
Q5: Which countries defy the BMI-diabetes pattern (outliers)?
Q6: Where do gender patterns in obesity reverse?

================================================================
KEY RESULTS SUMMARY
================================================================

Time Travelers (Countries That Improved):
- Several countries reduced diabetes 2000-2020
- See: output/time_travelers.csv

BMI-Diabetes Relationship:
- Strong correlation (r ≈ 0.8)
- But ~20+ countries are statistical outliers
- See: output/outliers.csv

Gender Patterns:
- In ~40+ countries, women have higher BMI than men
- Strong regional clustering (Middle East, Oceania)
- See: output/gender_flip.csv

================================================================
REPRODUCIBILITY NOTES
================================================================

All analyses are fully reproducible:
✓ No hard-coded file paths (all relative)
✓ All data cleaning documented in scripts
✓ All intermediate results cached
✓ Complete session info in report appendix
✓ All visualizations generated from code

To test reproducibility:
1. Delete cache/ and graphs/ folders
2. Re-run all scripts in order
3. All results should be identical

================================================================
DATA CITATIONS
================================================================

NCD Risk Factor Collaboration (NCD-RisC). (2024). 
Worldwide trends in diabetes prevalence. The Lancet.

NCD Risk Factor Collaboration (NCD-RisC). (2024). 
Worldwide trends in body-mass index. The Lancet.

NCD Risk Factor Collaboration (NCD-RisC). (2020). 
Worldwide trends in cholesterol. Nature.

================================================================
CONTACT
================================================================

For questions about this analysis:

Kartikey Sharma (ID: 250559280)
Aman Rana (ID: 250480674)
Pratik Pathe (ID: 250580169)
Kartik Sharma (ID: 250356977)

[Email: k.sharma3@newcastle.ac.uk]


================================================================
