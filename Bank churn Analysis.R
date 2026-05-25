############################################################
## CUSTOMER CHURN ANALYSIS PROJECT
## Logistic Regression Model for Customer Churn Prediction
############################################################


################################################################################
## SECTION 1 — LOAD REQUIRED LIBRARIES
################################################################################


required_packages <- c(
  "readxl",
  "dplyr",
  "caret",
  "car",
  "corrplot",
  "pROC",
  "smotefamily"
)

install_if_missing <- function(pkg) {
  
  if (!require(pkg, character.only = TRUE)) {
    
    install.packages(pkg, dependencies = TRUE)
    
  }
  
  library(pkg, character.only = TRUE)
}

lapply(required_packages, install_if_missing)

# Explanation
# This section loads all required libraries used for
# data cleaning, visualization, logistic regression,
# model evaluation, correlation analysis,
# ROC analysis, and SMOTE class balancing.


################################################################################
## SECTION 2 — IMPORT DATASET
################################################################################

# Import dataset
churn <- read_excel("churn.xlsx")

# View dataset structure
str(churn)

# View dimensions
dim(churn)

# Check missing values
colSums(is.na(churn))

# Check duplicate rows
sum(duplicated(churn))


# Explanation
# This section imports the customer churn dataset
# and performs initial inspection to understand
# the structure, dimensions, missing values,
# and duplicate records in the dataset.


################################################################################
## SECTION 3 — DATA CLEANING
################################################################################

# Convert categorical variables into factors
churn <- churn %>%
  mutate(
    Geography = as.factor(Geography),
    Gender = as.factor(Gender),
    Exited = as.factor(Exited),
    HasCrCard = as.factor(HasCrCard),
    IsActiveMember = as.factor(IsActiveMember)
  )

# Summary statistics
summary(churn)

# Confirm updated data types
str(churn)


# Explanation
# This section converts categorical variables into factors
# so they can be properly used in statistical analysis
# and logistic regression modeling.


################################################################################
## SECTION 4 — EXPLORATORY DATA ANALYSIS (EDA)
################################################################################


#-------------------------------------------------------------------------------
## 4.1 — CHURN DISTRIBUTION
#-------------------------------------------------------------------------------

# Frequency table
table(churn$Exited)

# Proportions
prop.table(table(churn$Exited))

# Bar plot
counts <- table(churn$Exited)

pct <- round(prop.table(counts) * 100, 1)

barplot(
  counts,
  col = c("skyblue", "salmon"),
  main = "Customer Churn Distribution",
  names.arg = c("Stayed", "Churned"),
  xlab = "Customer Status",
  ylab = "Number of Customers"
)

text(
  x = c(0.7, 1.9),
  y = counts,
  label = paste0(pct, "%"),
  pos = 3
)

# Explanation
# This section analyzes the overall distribution
# of churned and retained customers and visualizes
# the percentage of customer churn.


#-------------------------------------------------------------------------------
## 4.2 — AGE VS CHURN
#-------------------------------------------------------------------------------

boxplot(
  Age ~ Exited,
  data = churn,
  col = c("skyblue", "salmon"),
  names = c("Stayed", "Churned"),
  main = "Age Distribution by Churn Status",
  xlab = "Customer Status",
  ylab = "Age"
)


# Explanation
# This boxplot compares the age distribution
# between churned and retained customers
# to identify whether age impacts churn behavior.


#-------------------------------------------------------------------------------
## 4.3 — BALANCE VS CHURN
#-------------------------------------------------------------------------------

boxplot(
  Balance ~ Exited,
  data = churn,
  col = c("skyblue", "salmon"),
  names = c("Stayed", "Churned"),
  main = "Account Balance by Churn Status",
  xlab = "Customer Status",
  ylab = "Balance"
)

# Explanation
# This boxplot compares account balance distribution
# between churned and retained customers
# to examine whether balance influences churn.


#-------------------------------------------------------------------------------
## 4.4 — GEOGRAPHY VS CHURN
#-------------------------------------------------------------------------------

# Churn rate by geography
geo_churn <- prop.table(
  table(churn$Geography, churn$Exited),
  1
)

# Convert to percentages
geo_churn_pct <- round(geo_churn * 100, 1)

# View table
geo_churn_pct

# Bar plot
barplot(
  geo_churn[, 2],
  col = "salmon",
  main = "Churn Rate by Geography",
  xlab = "Geography",
  ylab = "Churn Rate",
  ylim = c(0, max(geo_churn[, 2]) * 1.2)
)

# Add labels
text(
  x = 1:3,
  y = geo_churn[, 2],
  label = paste0(geo_churn_pct[, 2], "%"),
  pos = 3
)


# Explanation
# This section analyzes churn rates across different
# geographic regions to identify locations
# with higher customer churn.


#-------------------------------------------------------------------------------
## 4.5 — ACTIVE MEMBER VS CHURN
#-------------------------------------------------------------------------------

# Churn rate by activity status
active_churn <- prop.table(
  table(churn$IsActiveMember, churn$Exited),
  1
)

# Convert to percentages
active_churn_pct <- round(active_churn * 100, 1)

# Bar plot
barplot(
  active_churn[, 2],
  col = "salmon",
  main = "Churn Rate by Activity Status",
  names.arg = c("Inactive", "Active"),
  xlab = "Customer Activity Status",
  ylab = "Churn Rate",
  ylim = c(0, max(active_churn[, 2]) * 1.2)
)

# Add labels
text(
  x = 1:2,
  y = active_churn[, 2],
  label = paste0(active_churn_pct[, 2], "%"),
  pos = 3
)


# Explanation
# This section evaluates whether customer activity status
# influences churn by comparing churn rates
# between active and inactive members.


#-------------------------------------------------------------------------------
## 4.6 — NUMBER OF PRODUCTS VS CHURN
#-------------------------------------------------------------------------------

# Create churn rate table
product_churn <- prop.table(
  table(churn$NumOfProducts, churn$Exited),
  1
)

# Convert to percentages
product_churn_pct <- round(product_churn * 100, 1)

# Create bar plot
barplot(
  product_churn[, 2],
  col = "orange",
  main = "Churn Rate by Number of Products",
  xlab = "Number of Products",
  ylab = "Churn Rate",
  ylim = c(0, max(product_churn[, 2]) * 1.2)
)

# Add percentage labels
text(
  x = 1:nrow(product_churn),
  y = product_churn[, 2],
  label = paste0(product_churn_pct[, 2], "%"),
  pos = 3
)


# Explanation
# This section measures relationships between
# numeric variables using a correlation matrix
# and visualizes the strength of correlations.


#-------------------------------------------------------------------------------
## 4.8 — AGE AND BALANCE BY CHURN STATUS
#-------------------------------------------------------------------------------

plot(
  churn$Age,
  churn$Balance,
  col = ifelse(churn$Exited == "1", "salmon", "skyblue"),
  pch = 16,
  xlab = "Age",
  ylab = "Balance",
  main = "Age and Balance by Churn Status"
)

legend(
  "topright",
  legend = c("Stayed", "Churned"),
  col = c("skyblue", "salmon"),
  pch = 16
)


# Explanation
# This scatter plot visualizes the relationship
# between age and account balance
# for churned and retained customers.


################################################################################
## SECTION 5 — PREPARING DATA FOR MODELLING
################################################################################

# Remove unnecessary columns
churn_model <- churn %>%
  select(
    -RowNumber,
    -CustomerId,
    -Surname
  )


# Explanation
# This section removes unnecessary variables
# that do not contribute to churn prediction
# and prepares the dataset for modeling.


################################################################################
## SECTION 6 — TRAIN TEST SPLIT
################################################################################

set.seed(123)

train_index <- createDataPartition(
  churn_model$Exited,
  p = 0.70,
  list = FALSE
)

train_data <- churn_model[train_index, ]

test_data <- churn_model[-train_index, ]

# Check split proportions
prop.table(table(train_data$Exited))

prop.table(table(test_data$Exited))


# Explanation
# This section splits the dataset into
# training and testing sets to evaluate
# model performance on unseen data.


################################################################################
## SECTION 7 — LOGISTIC REGRESSION MODEL
################################################################################

log_model <- glm(
  Exited ~ CreditScore +
    Geography +
    Gender +
    Age +
    Tenure +
    Balance +
    NumOfProducts +
    HasCrCard +
    IsActiveMember +
    EstimatedSalary,
  
  data = train_data,
  family = binomial
)

# Model summary
summary(log_model)


# Explanation
# This section builds a logistic regression model
# to predict customer churn using customer attributes
# and banking behavior variables.


################################################################################
## SECTION 8 — MULTICOLLINEARITY CHECK (VIF)
################################################################################

vif(log_model)


# Explanation
# This section checks multicollinearity among predictors
# using Variance Inflation Factor (VIF)
# to ensure predictor variables are not highly correlated.



################################################################################
## SECTION 9 — ODDS RATIO
################################################################################

round(exp(coef(log_model)), 3)


# Explanation
# This section converts logistic regression coefficients
# into odds ratios to interpret the impact
# of each predictor on customer churn.


################################################################################
## SECTION 10 — VARIABLE IMPORTANCE
################################################################################

# Calculate variable importance
importance <- varImp(log_model)

# View importance values
importance

# Plot variable importance
plot(
  importance,
  main = "Variable Importance for Customer Churn Prediction"
)


# Explanation
# This section identifies the most influential variables
# affecting customer churn prediction
# using variable importance analysis.


################################################################################
## SECTION 11 — PREDICT CHURN PROBABILITIES
################################################################################

pred_prob <- predict(
  log_model,
  newdata = test_data,
  type = "response"
)

head(pred_prob)

# Explanation
# This section generates predicted probabilities
# of customer churn for the testing dataset
# using the logistic regression model.


################################################################################
## SECTION 12 — CONFUSION MATRIX (THRESHOLD = 0.5)
################################################################################

pred_class <- ifelse(
  pred_prob > 0.5,
  "1",
  "0"
)

pred_class <- factor(
  pred_class,
  levels = levels(test_data$Exited)
)

confusionMatrix(
  data = pred_class,
  reference = test_data$Exited,
  positive = "1"
)


# Explanation
# This section evaluates model performance
# using a confusion matrix with a classification
# threshold of 0.5.


################################################################################
## SECTION 13 — THRESHOLD TUNING (0.3)
################################################################################

pred_class_03 <- ifelse(
  pred_prob > 0.3,
  "1",
  "0"
)

pred_class_03 <- factor(
  pred_class_03,
  levels = levels(test_data$Exited)
)

confusionMatrix(
  data = pred_class_03,
  reference = test_data$Exited,
  positive = "1"
)


# Explanation
# This section adjusts the classification threshold
# from 0.5 to 0.3 to improve churn detection
# and model sensitivity.



################################################################################
## SECTION 14 — CLASS BALANCING USING SMOTE
################################################################################

# Create dummy variables
train_numeric <- as.data.frame(
  model.matrix(
    Exited ~ .,
    data = train_data
  )[, -1]
)

# Target variable
train_target <- as.factor(train_data$Exited)

# Apply SMOTE
smote_data <- SMOTE(
  X = train_numeric,
  target = train_target,
  K = 5,
  dup_size = 2
)

# Create balanced dataset
train_smote <- smote_data$data

# Rename target column
colnames(train_smote)[ncol(train_smote)] <- "Exited"

# Convert target back to factor
train_smote$Exited <- as.factor(train_smote$Exited)

# Check distribution
table(train_smote$Exited)

prop.table(table(train_smote$Exited))


# Explanation
# This section applies SMOTE (Synthetic Minority Oversampling Technique)
# to balance the churn classes
# and improve model learning for minority cases.


################################################################################
## SECTION 15 — LOGISTIC REGRESSION USING SMOTE DATA
################################################################################

log_model_smote <- glm(
  Exited ~ .,
  data = train_smote,
  family = binomial
)

summary(log_model_smote)


# Explanation
# This section applies SMOTE (Synthetic Minority Oversampling Technique)
# to balance the churn classes
# and improve model learning for minority cases.


################################################################################
## SECTION 16 — TEST DATA TRANSFORMATION
################################################################################

test_numeric <- as.data.frame(
  model.matrix(
    Exited ~ .,
    data = test_data
  )[, -1]
)


# Explanation
# This section converts testing data
# into dummy variable format
# to match the structure of the SMOTE training data.


################################################################################
## SECTION 17 — PREDICTIONS USING SMOTE MODEL
################################################################################

pred_prob_smote <- predict(
  log_model_smote,
  newdata = test_numeric,
  type = "response"
)

pred_class_smote <- ifelse(
  pred_prob_smote > 0.3,
  "1",
  "0"
)

pred_class_smote <- factor(
  pred_class_smote,
  levels = levels(test_data$Exited)
)

confusionMatrix(
  data = pred_class_smote,
  reference = test_data$Exited,
  positive = "1"
)


# Explanation
# This section generates churn predictions
# using the logistic regression model trained
# on the SMOTE-balanced dataset.


################################################################################
## SECTION 18 — ROC CURVE AND AUC
################################################################################

roc_obj <- roc(
  test_data$Exited,
  pred_prob
)

plot(
  roc_obj,
  col = "blue",
  main = "ROC Curve for Logistic Regression Model"
)

auc(roc_obj)

# Explanation
# This section evaluates model discrimination ability
# using the ROC curve and Area Under the Curve (AUC)
# metrics.