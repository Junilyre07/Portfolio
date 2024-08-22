#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import matplotlib.pyplot as plt


# # Machine Learning Algorithms: 

#        Decision Tree
#        Logistic Regression
#        

# Experiment 1: Data Splitting with the hybrid oversampling and undersampling- In the first experiment, we split the dataset into training (80%) and testing (20%) subsets,
#              maintaining class balance through stratification.
#     
#               
# Experiment 2: Stratified Cross-Validation with SMOTE (Oversampling)\
#              For the third experiment, we enhance our stratified cross-validation by incorporating\
#     Synthetic Minority Over-sampling Technique (SMOTE). SMOTE is used to address class\ 
#     imbalance by generating synthetic samples, improving the model's ability to learn from the minority class.

# In[2]:


data = pd.read_csv('credit_card_churn.csv')


# In[3]:


data.head(2)


# In[4]:


data['Attrition_Flag'].value_counts().plot.pie(autopct='%.2f')
#The target variable is not balance


# In[5]:


Finaldata = data[['Attrition_Flag', 'Gender', 'Income_Category', 'Total_Trans_Ct', 'Avg_Utilization_Ratio', 'Total_Revolving_Bal', 'Months_Inactive_12_mon', 'Total_Trans_Amt', 'Total_Amt_Chng_Q4_Q1']]


# In[6]:


Finaldata.dtypes


# In[7]:


from sklearn.preprocessing import LabelEncoder 
le = LabelEncoder()
Finaldata['Gender'] = le.fit_transform(data['Gender'])
Finaldata['Income_Category'] = le.fit_transform(data['Income_Category'])
Finaldata['Attrition_Flag'] = le.fit_transform(data['Attrition_Flag'])


# In[8]:


Finaldata.head(2)


# In[9]:


Finaldata.dtypes


# In[10]:


X = Finaldata.drop('Attrition_Flag', axis = 1)
y = Finaldata['Attrition_Flag']


# Experiment 1: Data Splitting  training (80%) and testing (20%) subsets, stratify=yes, hyperparameters 

# In[11]:


import numpy as np
from sklearn.model_selection import StratifiedKFold, GridSearchCV, train_test_split, cross_val_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, roc_auc_score, precision_score, recall_score, f1_score, confusion_matrix
from imblearn.over_sampling import RandomOverSampler, SMOTE
from imblearn.under_sampling import RandomUnderSampler


# In[12]:


X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)


# In[13]:


print(y_train.value_counts(normalize=True)*100)


# In[14]:


print(y_test.value_counts(normalize=True)*100)


# # Decision Tree

# Experiment 1

# In[15]:


dt_classifier = DecisionTreeClassifier(random_state=42)


# In[16]:


param_grid_dt = {
    'criterion': ['gini', 'entropy'],
    'max_depth': [None, 10, 20, 30],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4],
    'max_features': ['auto', 'sqrt', 'log2']
}


# In[17]:


clf = GridSearchCV(dt_classifier, param_grid_dt)
clf


# In[18]:


clf.fit(X_train, y_train)


# In[19]:


#Get the best Decision Tree classifier with optimized Hyperparameters
best_dt_classifier = clf.best_estimator_
best_dt_classifier


# In[20]:


# Now, apply RandomOverSampler to the training data
ros = RandomOverSampler(sampling_strategy=0.5)  # Adjust the sampling strategy as needed
X_train_resampled, y_train_resampled = ros.fit_resample(X_train, y_train)


# In[21]:


best_dt_classifier.fit(X_train_resampled, y_train_resampled)


# In[22]:


y_pred_d1 = best_dt_classifier.predict(X_test)


# In[26]:


accuracy = accuracy_score(y_test, y_pred_d1)
precision = precision_score(y_test, y_pred_d1)
recall = recall_score(y_test,y_pred_d1)
f1 = f1_score(y_test, y_pred_d1)
confusion = confusion_matrix(y_test, y_pred_d1)


print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("f1_score:", f1_score)
print("confusion matrix\n", confusion)


# Undersampling

# In[27]:


# Now, apply RandomOverSampler to the training data
rus = RandomUnderSampler(sampling_strategy=0.5)  # Adjust the sampling strategy as needed
X_train_resampled_U, y_train_resampled_U = rus.fit_resample(X_train, y_train)


# In[28]:


best_dt_classifier.fit(X_train_resampled_U, y_train_resampled_U)


# In[29]:


y_pred_d2 = best_dt_classifier.predict(X_test)


# In[31]:


accuracy = accuracy_score(y_test, y_pred_d2)
precision = precision_score(y_test, y_pred_d2)
recall = recall_score(y_test,y_pred_d2)
f1 = f1_score(y_test, y_pred_d2)
confusion = confusion_matrix(y_test, y_pred_d2)


print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("f1_score:", f1_score)
print("confusion matrix\n", confusion)


# Experiment 2: Decision Tree with Stratified Cross Validation

# In[32]:


cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)


# In[33]:


clf_S = GridSearchCV(dt_classifier, param_grid_dt, cv=cv)
clf_S


# In[34]:


clf_S.fit(X_train, y_train)


# In[38]:


best_dt_classifier = clf_S.best_estimator_
best_dt_classifier


# In[39]:


smote = SMOTE(sampling_strategy='auto')
X_train_smote, y_train_smote = smote.fit_resample(X_train, y_train)


# In[40]:


best_dt_classifier.fit(X_train_smote, y_train_smote)


# In[41]:


y_pred_d3 = best_dt_classifier.predict(X_test)


# In[44]:


cv_metrics_P = cross_val_score(best_dt_classifier, X_train_smote, y_train_smote, cv=cv, scoring='precision')
cv_metrics_P


# In[45]:


cv_metrics_R = cross_val_score(best_dt_classifier, X_train_smote, y_train_smote, cv=cv, scoring='recall')
cv_metrics_R


# In[46]:


print('mean_precision:', np.mean(cv_metrics_P))
print('mean_recall:',np.mean(cv_metrics_R))   


# # Logistic Regression

# Experiment 1

# In[47]:


LR_classifier = LogisticRegression()


# In[48]:


param_grid_LR = {
    'penalty' : ['l1', 'l2'],
    'C' : [0.001, 0.01, 0.1, 1.0],
    'solver' : ['newton-cg', 'lbfgs', 'liblinear', 'sag', 'saga'],
    'max_iter':[100, 200, 300]  
}


# In[49]:


R_clf = GridSearchCV(LR_classifier, param_grid_LR)


# In[50]:


R_clf.fit(X_train, y_train)


# In[51]:


LR_best_parameter = R_clf.best_estimator_
LR_best_parameter


# In[52]:


LR_ros = RandomOverSampler(sampling_strategy = 'auto')
X_train_L, y_train_L = LR_ros.fit_resample(X_train, y_train)


# In[53]:


LR_best_parameter.fit(X_train_L, y_train_L)


# In[54]:


y_pred_LR = LR_best_parameter.predict(X_test)


# In[56]:


accuracy = accuracy_score(y_test, y_pred_LR)
precision = precision_score(y_test, y_pred_LR)
recall = recall_score(y_test,y_pred_LR)
f1 = f1_score(y_test, y_pred_LR)
confusion = confusion_matrix(y_test, y_pred_LR)


print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("f1_score:", f1_score)
print("confusion matrix\n", confusion)


# Undersampling

# In[57]:


LR_rus = RandomUnderSampler(sampling_strategy = 'auto')
X_train_LR, y_train_LR = LR_rus.fit_resample(X_train, y_train)


# In[58]:


LR_best_parameter.fit(X_train_LR, y_train_LR)


# In[59]:


y_pred_LR2 = LR_best_parameter.predict(X_test)


# In[61]:


accuracy = accuracy_score(y_test, y_pred_LR2)
precision = precision_score(y_test, y_pred_LR2)
recall = recall_score(y_test,y_pred_LR2)
f1 = f1_score(y_test, y_pred_LR2)
confusion = confusion_matrix(y_test, y_pred_LR2)

print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("f1_score:", f1_score)
print("confusion matrix\n", confusion)


# Experiment 2

# In[62]:


smote_LR = SMOTE(sampling_strategy='auto')


# In[63]:


R_clf = GridSearchCV(LR_classifier, param_grid_LR, cv=cv)


# In[64]:


R_clf.fit(X_train, y_train)


# In[117]:


X_train_LRsmote, y_train_LRsmote = smote_LR.fit_resample(X_train, y_train)


# In[118]:


LR_best_parameter.fit(X_train_LRsmote, y_train_LRsmote)


# In[119]:


y_pred_smlr = LR_best_parameter.predict(X_test)


# In[114]:


LR_metrics_P = cross_val_score(LR_best_parameter, X_train_LRsmote, y_train_LRsmote, cv=cv, scoring='precision')
LR_metrics_P


# In[115]:


LR_metrics_R = cross_val_score(LR_best_parameter, X_train_LRsmote, y_train_LRsmote, cv=cv, scoring='recall')
LR_metrics_R


# In[116]:


print('Precision_Logistic Regression:', np.mean(LR_metrics_P))
print('Recall_Logistic Regression:', np.mean(LR_metrics_R))


# In[ ]:




