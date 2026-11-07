# Machine Learning for Cybersecurity — Network Attack Detection

## Project Overview

This project explores the use of machine learning to analyse network session data, classify potentially malicious activity and predict network session duration.

Using Python and a dataset containing 6,000 network session records, I performed exploratory data analysis, data preprocessing, feature engineering, model training and performance evaluation.

The project compares different machine learning algorithms and investigates their strengths and limitations in cybersecurity applications.

## Project Objectives

- Explore network traffic data to identify patterns associated with attacks.
- Clean and prepare data for machine learning.
- Engineer additional features to improve analysis.
- Train classification models to distinguish attack and benign sessions.
- Compare model performance using evaluation metrics.
- Predict session duration using regression models.
- Identify important features influencing attack classification.

## Technologies Used

| Technology | Purpose |
|---|---|
| Python | Data processing and machine learning |
| Jupyter Notebook | Development and documentation |
| Pandas | Data manipulation and cleaning |
| NumPy | Numerical calculations |
| Matplotlib | Data visualisation |
| Seaborn | Statistical visualisation |
| Scikit-learn | Model training and evaluation |

## Dataset

The dataset contains 6,000 network session records with features including:

- Login attempts and failed logins
- Bytes sent and received
- Packet rate
- Session duration
- Anomaly score
- Network protocol
- Signal strength
- Attack or benign classification

The dataset contains approximately 4,500 benign sessions and 1,500 attack sessions, creating a class imbalance.

## Implementation

### 1. Exploratory Data Analysis

I explored the dataset using descriptive statistics, class distribution charts, boxplots and a correlation heatmap.

This helped identify differences between attack and benign sessions and examine relationships between network features.

### 2. Data Preprocessing

I prepared the dataset by:

- Removing the session identifier.
- Standardising protocol names.
- Replacing missing categorical values with the mode.
- Replacing missing numerical values with the median.
- Removing duplicate records.
- Encoding categorical variables for machine learning.

### 3. Feature Engineering

I created two additional features:

**Failed Login Rate:** Calculated using failed logins divided by login attempts plus one.

**Bytes Per Packet:** Calculated using bytes sent divided by packet rate plus one.

These features were designed to provide additional information about authentication behaviour and network activity.

### 4. Attack Classification

I trained and compared two classification models:

- Decision Tree Classifier
- Gaussian Naive Bayes

The dataset was divided into 80% training data and 20% testing data, using a stratified split to preserve the class distribution.

The models were evaluated using classification reports, accuracy, F1-scores and confusion matrices.

### 5. Session Duration Prediction

I implemented two regression models:

- Linear Regression
- Decision Tree Regressor

These models were used to predict session duration.

Performance was evaluated using Mean Absolute Error (MAE), Root Mean Squared Error (RMSE) and R².

### 6. Feature Importance

I examined feature importance using the Decision Tree Classifier.

The analysis highlighted anomaly score and failed login activity as influential features in the classification process.

## Results

### Classification Results

| Model | Accuracy | F1-score |
|---|---:|---:|
| Decision Tree | 64.08% | 0.7575 |
| Gaussian Naive Bayes | 72.17% | 0.8337 |

Gaussian Naive Bayes achieved higher overall accuracy and F1-score in the saved notebook results.

The results demonstrate the importance of comparing multiple models rather than relying on a single algorithm.

### Regression Results

| Model | MAE | RMSE | R² |
|---|---:|---:|---:|
| Linear Regression | 9.7363 | 12.2538 | 0.4587 |
| Decision Tree Regressor | 10.6262 | 13.3810 | 0.3545 |

Linear Regression performed better than the Decision Tree Regressor on the recorded evaluation metrics.

However, neither model explained all the variation in session duration, demonstrating limitations in predictive performance.

## My Contribution

I carried out the dataset exploration, preprocessing, feature engineering, machine learning implementation and evaluation.

My work included preparing the dataset, training classification and regression models, producing visualisations, comparing performance metrics and interpreting the findings.

I also documented the results and discussed the limitations of the models in cybersecurity applications.

## Skills Demonstrated

- Python programming
- Data analysis and preprocessing
- Exploratory Data Analysis
- Machine learning classification
- Regression modelling
- Feature engineering
- Data visualisation
- Model evaluation
- Cybersecurity data interpretation
- Technical documentation

## Project Files

The main project is contained in a Jupyter Notebook:

`Data_Machine_Learning_project.ipynb`

The notebook includes the Python code, analysis, visualisations, model training and saved results.

## Limitations and Future Improvements

- Investigate additional machine learning algorithms.
- Perform hyperparameter tuning and cross-validation.
- Evaluate precision and recall specifically for the attack class.
- Address class imbalance during model development.
- Move preprocessing into training pipelines to reduce data leakage.
- Test the models on additional network datasets.
- Explore more advanced feature engineering techniques.

## Conclusion

This project demonstrated how Python and machine learning can be used to analyse network session data and investigate potential cyberattacks.

It also highlighted the importance of selecting appropriate evaluation metrics, understanding model limitations and considering the consequences of false positives and false negatives in cybersecurity.

---

*Academic Data and Machine Learning project completed as part of my Cybersecurity studies at TU Dublin.*
