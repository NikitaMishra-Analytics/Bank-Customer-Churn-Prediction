# 🏦 Bank Customer Churn Prediction

## 📌 Project Overview
This project focuses on predicting customer churn in the banking sector using Logistic Regression and SMOTE-based class balancing techniques in R. The goal is to identify high-risk customers likely to leave the bank and support proactive customer retention strategies using predictive analytics and machine learning techniques.

---

## 🎯 Business Problem
Customer churn is a major challenge for banks because losing customers directly impacts revenue, profitability, and long-term customer relationships. Acquiring new customers is significantly more expensive than retaining existing ones.

This project helps banks:
- Detect high-risk customers early
- Improve customer retention strategies
- Reduce financial losses from churn
- Support data-driven business decisions

---

## 📊 Dataset Information
- **10,000 customer records**
- **14 variables**
- Customer demographic, financial, and behavioral information

### Key Variables
- Age
- Geography
- Gender
- Credit Score
- Balance
- Number of Products
- Tenure
- Activity Status
- Estimated Salary
- Customer Churn Status (Exited)

---

## 🛠️ Tools & Technologies
- **R Programming**
- Logistic Regression
- SMOTE (Synthetic Minority Oversampling Technique)
- caret
- pROC
- corrplot
- dplyr
- Data Visualization
- Predictive Analytics

---

## 🔍 Project Workflow

### 📌 Data Preparation
- Missing value analysis
- Duplicate record validation
- Data type correction
- Factor conversion for categorical variables

### 📈 Exploratory Data Analysis (EDA)
- Customer churn distribution
- Geography vs churn analysis
- Age and balance analysis
- Correlation analysis
- Customer activity analysis

### 🤖 Predictive Modeling
- Binary Logistic Regression
- Threshold Tuning (0.50 vs 0.30)
- SMOTE Class Balancing
- ROC Curve & AUC Evaluation
- Confusion Matrix Analysis

---

## 📌 Key Insights
✅ Older customers showed significantly higher churn probability  
✅ Germany had the highest churn rate among all regions  
✅ Inactive customers were substantially more likely to churn  
✅ Threshold tuning significantly improved churn detection  
✅ SMOTE improved recall but increased false positives  

---

## 🧠 Final Selected Model
### Threshold-Tuned Logistic Regression (Threshold = 0.30)

### ✔ Why This Model?
- Best balance between recall and overall model stability
- Better churn detection performance
- Reduced operational risk
- More practical for real-world banking deployment

---

## 📊 Model Performance Summary

| Metric | Baseline Model | Threshold Tuned | SMOTE Model |
|---|---|---|---|
| Accuracy | 82.16% | 79.23% | 58.95% |
| Recall | 23.08% | 51.88% | 86.09% |
| Specificity | 97.28% | 86.22% | 52.01% |
| AUC | 0.7796 | 0.7796 | 0.7796 |

---

## 💡 Business Recommendations
- Prioritize retention efforts for inactive customers
- Develop targeted campaigns for Germany-based customers
- Monitor older customers with high balances
- Implement proactive customer engagement strategies
- Use predictive analytics for early churn intervention

---

## 📁 Repository Contents
📄 Bank churn Analysis Report.docx  
📄 Bank churn Analysis.R  
📊 Bank_Churn_Prediction_PPT.pptx  

---

## 👩‍💻 Author
**Nikita Mishra**  
Master’s in Data Analytics  
Northeastern University

---

## ⭐ Project Highlights
- End-to-end predictive analytics project
- Real-world banking churn use case
- Machine learning + business analytics integration
- Strong focus on business impact and decision-making
- Production-oriented evaluation metrics

---
