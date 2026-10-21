
# Understanding-Diabetes-Progression
Exploratory data analysis (EDA) and regression modeling on 442 diabetes patients to identify key modifiable clinical risk factors.

---

## 📌 Project Purpose
This project analyzes clinical and demographic data from **442 diabetes patients** to understand the key baseline risk factors associated with quantitative disease progression over a one-year period. By employing exploratory data analysis (EDA) and multiple linear regression, the study provides actionable, data-driven insights to help healthcare decision-makers optimize patient intervention strategies.

---

## 📂 Portfolio Structure
The project repository is organized as follows:
*   **`diabete-project.R`**: The clean, reproducible R script containing the full analysis workflow (data preparation, EDA, correlations, and regression diagnostics).
*   **`diabete-project.pdf`**: The final comprehensive analytical report detailing statistical interpretations and methodology.
*   **`diabetes.tab.txt`**: The tab-separated source dataset containing baseline clinical measurements.
*   **`Decision_Maker_Presentation.pdf`**: A non-technical, high-level slide deck tailored for health-service administrative leaders.

---

## 📈 Key Findings
*   **Three-Pillar Risk Model**: The optimal predictive model combines **Body Mass Index (BMI)**, **Mean Blood Pressure (BP)**, and **Blood Serum Measurement (S5)**. This model explains **48.0% of the total variance** in diabetes progression (R² = 0.480), significantly outperforming a simple weight-only model (R² = 0.344).
*   **Quantifiable Impact**: Holding other clinical factors constant, each single-unit increase in BMI is associated with an average disease progression increase of **6.50 units**. Blood serum marker S5 exhibited the largest independent statistical effect (**49.58 units** per unit increase).
*   **Clinical Policy Action**: While serum metrics are vital diagnostic markers, **BMI represents the most critical public health lever** because body weight is a modifiable lifestyle risk factor that healthcare systems can actively target.

---

## 🛠️ Statistical Methodology
1.  **Data Quality Audit**: Verification of data completeness (**0 missing values**, **0 duplicate records**). Categorical encoding fixed for the `sex` variable.
2.  **Exploratory Data Analysis**: Mapping distributions (noting the moderate right-skewness of disease progression) and plotting bivariate relationships.
3.  **Collinearity Diagnostics**: Calculated Variance Inflation Factors (VIF). The three key predictors show optimal independence (VIF ≈ 1.3), eliminating data redundancy issues found among other blood serum metrics (e.g., S1 and S2 where r = 0.90).
4.  **Residual Diagnostics**: Residuals vs. Fitted value analysis confirmed satisfying compliance with linearity and homoscedasticity assumptions.

---

## 🚀 How to Run the Analysis Locally

### Prerequisites
Ensure you have **R** and **RStudio** installed. The script will automatically check for and install the following required packages if they are missing:
*   `ggplot2` (Data Visualization)
*   `dplyr` (Data Manipulation)
*   `broom` (Tidy Model Summaries)

### Execution Steps
1.  Clone this repository or download the files into a single local folder.
2.  Ensure `diabetes.tab.txt` is stored in the **same directory** as the R script.
3.  Open `diabete-project.R` in RStudio.
4.  Run the script from top to bottom, or use `knitr::spin("diabete-project.R")` to recompile the full HTML/PDF report seamlessly.
