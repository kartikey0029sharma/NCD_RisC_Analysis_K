# ============================================
# ANALYSIS FUNCTIONS
# File: src/analysis_functions.R
# ============================================

library(ggplot2)
library(dplyr)

# ----- Function 1: Basic Time Trend -----
plot_time_trend <- function(data, y_var, title, y_label) {
  trend_data <- data %>%
    group_by(Year, Sex) %>%
    summarise(Mean_Value = mean(.data[[y_var]], na.rm = TRUE), .groups = "drop")
  
  p <- ggplot(trend_data, aes(x = Year, y = Mean_Value, color = Sex)) +
    geom_line(size = 1.2) +
    geom_point(size = 2) +
    labs(title = title, x = "Year", y = y_label, color = "Sex") +
    theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold"),
      legend.position = "bottom"
    )
  
  return(p)
}

# ----- Function 2: Regional Comparison -----
plot_regional_comparison <- function(data, y_var, year, title, y_label) {
  regional_data <- data %>%
    filter(Year == year, Sex == "Men") %>%
    group_by(Region) %>%
    summarise(Mean_Value = mean(.data[[y_var]], na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(Mean_Value)) %>%
    filter(Region != "Other")
  
  p <- ggplot(regional_data, aes(x = reorder(Region, Mean_Value), 
                                 y = Mean_Value, fill = Region)) +
    geom_col(alpha = 0.8) +
    coord_flip() +
    labs(title = title, x = "Region", y = y_label) +
    theme_minimal() +
    theme(legend.position = "none", plot.title = element_text(size = 12, face = "bold"))
  
  return(p)
}

# ----- Function 3: Top Countries -----
plot_top_countries <- function(data, y_var, year, n = 10, top = TRUE) {
  country_data <- data %>%
    filter(Year == year, ) %>%
    arrange(if(top) desc(.data[[y_var]]) else .data[[y_var]]) %>%
    head(n)
  
  p <- ggplot(country_data, aes(x = reorder(Country, .data[[y_var]]), 
                                y = .data[[y_var]])) +
    geom_col(fill = if(top) "#d73027" else "#4575b4", alpha = 0.8) +
    coord_flip() +
    labs(title = paste(if(top) "Highest" else "Lowest", n, "Countries"), 
         x = "Country", y = y_var) +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"))
  
  return(p)
}

# ----- Function 4: Correlation Plot -----
plot_correlation <- function(data, x_var, y_var, title, x_label, y_label, year) {
  plot_data <- data %>%
    filter(Year == year, Sex == "Men", 
           !is.na(.data[[x_var]]), !is.na(.data[[y_var]]))
  
  cor_result <- cor.test(plot_data[[x_var]], plot_data[[y_var]])
  cor_text <- paste0("r = ", round(cor_result$estimate, 3), 
                     "\np ", ifelse(cor_result$p.value < 0.001, "< 0.001", 
                                    paste("=", round(cor_result$p.value, 3))))
  
  p <- ggplot(plot_data, aes(x = .data[[x_var]], y = .data[[y_var]])) +
    geom_point(alpha = 0.5, size = 3, aes(color = Region)) +
    geom_smooth(method = "lm", color = "red", se = TRUE, size = 1.2) +
    annotate("text", x = Inf, y = Inf, label = cor_text, 
             hjust = 1.1, vjust = 1.5, size = 5) +
    labs(title = title, x = x_label, y = y_label, color = "Region") +
    theme_minimal() +
    theme(plot.title = element_text(size = 12, face = "bold"))
  
  return(list(plot = p, correlation = cor_result))
}

cat("✓ Analysis functions loaded!\n")


