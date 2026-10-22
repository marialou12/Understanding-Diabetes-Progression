################################################################################
# DATA ANALYTICS AND STATISTICS WITH APPLICATIONS — FINAL PROJECT
# SCENARIO 1: UNDERSTANDING DIABETES PROGRESSION
# Fully Reproducible, Documented, and Commented R Script
# Author: Maria Lithoxopoulou
# Date: 2026-10-22
################################################################################

# ==============================================================================
# 0. SETUP AND AUTOMATIC PACKAGE MANAGEMENT
# ==============================================================================

# List of required packages for the data analysis workflow
needed_packages <- c("ggplot2", "dplyr", "broom")

# Automatically check for, install, and load missing dependencies
for (pkg in needed_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Load libraries into the active working environment
library(ggplot2)
library(dplyr)
library(broom)

# Optimize print formatting for numeric summaries (4 significant digits)
options(digits = 4)

# ==============================================================================
# QUESTION 1. UNDERSTAND AND PREPARE THE DATA
# ==============================================================================

# Define the source data file name (must reside in the same working directory)
data_file <- "diabetes.tab.txt"

# Dynamic path error handling: fallback to manual file selection dialog
if (!file.exists(data_file)) {
  message("WARNING: 'diabetes.tab.txt' was not found in the current working directory.")
  message("Please select the supplied data file manually using the dialog box.")
  data_file <- file.choose()
}

# Import the official tab-separated dataset (NCSU Source)
diabetes <- read.table(data_file, header = TRUE, sep = "\t")

# Convert column names to lowercase for typing consistency and fewer syntax errors
names(diabetes) <- tolower(names(diabetes))

# Rename the outcome variable 'y' to 'progression' for clinical clarity
if ("y" %in% names(diabetes)) {
  diabetes <- diabetes %>% rename(progression = y)
}

# Preliminary structure and dimension audit of the data frame
dim(diabetes)  # Expected output: 442 observations and 11 variables
names(diabetes)
str(diabetes)

# Explicitly encode the 'sex' variable as a factor (categorical attribute)
diabetes$sex <- factor(diabetes$sex)

# Data Quality Audit: Check for missing data cells (NAs) or duplicate records
missing_summary <- colSums(is.na(diabetes))
print("--- Missing Values Audit Summary ---")
print(missing_summary) # Should show 0 for all columns

total_duplicates <- sum(duplicated(diabetes))
print(paste("Duplicate records detected:", total_duplicates)) # Should equal 0

# ==============================================================================
# QUESTION 2. EXPLORE THE DATA
# ==============================================================================

# Define a helper function to calculate comprehensive core numeric summaries
describe_numeric <- function(x) {
  c(
    n = sum(!is.na(x)),
    mean = mean(x, na.rm = TRUE),
    median = median(x, na.rm = TRUE),
    sd = sd(x, na.rm = TRUE),
    min = min(x, na.rm = TRUE),
    q1 = as.numeric(quantile(x, 0.25, na.rm = TRUE)),
    q3 = as.numeric(quantile(x, 0.75, na.rm = TRUE)),
    max = max(x, na.rm = TRUE),
    iqr = IQR(x, na.rm = TRUE)
  )
}

# Compute baseline descriptive metrics for the outcome and key predictors
print("--- Disease Progression Metrics ---")
print(describe_numeric(diabetes$progression))

print("--- Body Mass Index (BMI) Metrics ---")
print(describe_numeric(diabetes$bmi))

print("--- Patient Age Distribution Metrics ---")
print(describe_numeric(diabetes$age))

# Visualization 1: Histogram mapping diabetes progression distribution
ggplot(diabetes, aes(x = progression)) +
  geom_histogram(bins = 25, fill = "#2c3e50", colour = "white", alpha = 0.8) +
  labs(
    title = "Distribution of One-Year Diabetes Progression",
    subtitle = "Cohort of 442 patients — Evidence of moderate right-skewness",
    x = "Disease Progression Metric (One Year Post-Baseline)",
    y = "Patient Count (Frequency)"
  ) +
  theme_minimal()

# Visualization 2: Histogram mapping baseline BMI metrics
ggplot(diabetes, aes(x = bmi)) +
  geom_histogram(bins = 25, fill = "#16a085", colour = "white", alpha = 0.8) +
  labs(
    title = "Distribution of Baseline Body Mass Index (BMI)",
    subtitle = "Clinical overweight threshold indicated at BMI > 25",
    x = "Body Mass Index (kg/m²)",
    y = "Patient Count (Frequency)"
  ) +
  geom_vline(xintercept = 25, linetype = "dashed", color = "#e74c3c", size = 1) +
  theme_minimal()

# Visualization 3 (Additional visual requirement): Boxplot of progression stratified by sex
ggplot(diabetes, aes(x = sex, y = progression, fill = sex)) +
  geom_boxplot(alpha = 0.7, outlier.colour = "#e74c3c") +
  scale_fill_manual(values = c("#3498db", "#9b59b6"), labels = c("Category 1", "Category 2")) +
  labs(
    title = "Diabetes Progression Stratified by Encoded Sex Factor",
    x = "Patient Sex Classification Category",
    y = "Disease Progression Metric",
    fill = "Sex Category"
  ) +
  theme_minimal()

# ==============================================================================
# QUESTION 3. INVESTIGATE RELATIONSHIPS
# ==============================================================================

# Isolate numeric continuous attributes only (excluding factor 'sex' from Pearson matrix)
numeric_data <- diabetes %>% select(where(is.numeric))

# Calculate and print the bivariate linear Pearson correlation matrix
cor_matrix <- cor(numeric_data, use = "complete.obs", method = "pearson")
print("--- Rounded Pearson Correlation Matrix ---")
print(round(cor_matrix, 2))

# Rank associations linked with the primary progression esito in descending order
progression_correlations <- sort(cor_matrix[, "progression"], decreasing = TRUE)
print("--- Ranked Direct Linear Correlations with Progression ---")
print(progression_correlations)

# Scatterplot 1: Linear relationship evaluation between BMI and Progression
ggplot(diabetes, aes(x = bmi, y = progression)) +
  geom_point(color = "#2c3e50", alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, color = "#e74c3c", se = TRUE) +
  labs(
    title = "Bivariate Analysis: Disease Progression vs. BMI",
    subtitle = "Strong direct baseline correlation observed (r = 0.59)",
    x = "Body Mass Index (BMI)",
    y = "Diabetes Progression Score"
  ) +
  theme_minimal()

# Scatterplot 2: Linear relationship evaluation between Blood Pressure and Progression
ggplot(diabetes, aes(x = bp, y = progression)) +
  geom_point(color = "#2c3e50", alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, color = "#3498db", se = TRUE) +
  labs(
    title = "Bivariate Analysis: Disease Progression vs. Mean Blood Pressure (BP)",
    subtitle = "Moderate continuous linear association noted (r = 0.44)",
    x = "Mean Blood Pressure (BP)",
    y = "Diabetes Progression Score"
  ) +
  theme_minimal()

# ==============================================================================
# QUESTION 4. BUILD AND INTERPRET REGRESSION MODELS
# ==============================================================================

# 1. Fit the Baseline Simple Linear Regression Model (Single Predictor: BMI)
simple_model <- lm(progression ~ bmi, data = diabetes)
print("--- SIMPLE LINEAR REGRESSION MODEL SUMMARY (SOLO BMI) ---")
summary(simple_model)

# 2. Fit the Optimized Structural Multiple Linear Regression Model (Three Pillars)
multiple_model <- lm(progression ~ bmi + bp + s5, data = diabetes)
print("--- OPTIMIZED MULTIPLE LINEAR REGRESSION MODEL SUMMARY ---")
summary(multiple_model)

# Extract and bundle performance fit parameters (R-squared and Residual Error)
model_comparison <- bind_rows(
  glance(simple_model) %>% mutate(model = "Simple Linear: Solo BMI"),
  glance(multiple_model) %>% mutate(model = "Multiple Linear: BMI + BP + S5")
) %>%
  select(model, r.squared, adj.r.squared, sigma)

print("--- PREDICTIVE PERFORMANCE COMPONENT COMPARISON ---")
print(model_comparison)

# ==============================================================================
# QUESTION 5. EVALUATE THE ANALYSIS
# ==============================================================================

# Extract diagnostic mapping variables (Fitted estimates and Residual distances)
diagnostic_data <- augment(multiple_model)

# Residual Diagnostic Mapping: Residuals vs. Fitted Plot (Homoscedasticity Audit)
ggplot(diagnostic_data, aes(x = .fitted, y = .resid)) +
  geom_point(color = "#2c3e50", alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "#e74c3c", size = 0.8) +
  geom_smooth(method = "loess", formula = y ~ x, color = "#2ecc71", se = FALSE) +
  labs(
    title = "Residuals vs. Fitted Values Diagnostic Plot",
    subtitle = "Random scatter around the zero reference line satisfies homoscedasticity",
    x = "Model Fitted Predictive Estimates (.fitted)",
    y = "Calculated Residual Divergences (.resid)"
  ) +
  theme_minimal()

# Code loop block to compute the Variance Inflation Factor (VIF) manually
manual_vif <- function(model) {
  X <- model.matrix(model)[, -1, drop = FALSE] # Remove intercept term
  vif_values <- sapply(seq_len(ncol(X)), function(i) {
    target <- X[, i]
    others <- X[, -i, drop = FALSE]
    if (ncol(others) == 0) return(1)
    r2 <- summary(lm(target ~ others))$r.squared
    1 / (1 - r2)
  })
  setNames(vif_values, colnames(X))
}

print("--- MULTICOLLINEARITY STRUCTURAL AUDIT (VIF) ---")
print(manual_vif(multiple_model)) # VIF scores around 1.3 verify stable predictors

print("--- 95% STATISTICAL CONFIDENCE INTERVALS FOR COEFFICIENTS ---")
print(confint(multiple_model, level = 0.95))

# ==============================================================================
# QUESTION 6. DRAW APPROPRIATE CONCLUSIONS
# ==============================================================================



