#!/usr/bin/env python
# coding: utf-8

# In[60]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats


# In[61]:


data = pd.read_csv('credit_card_churn.csv')
data.head(2)


# # Checking nulls and duplicates

# In[3]:


data.isnull().sum()


# In[4]:


data.duplicated().sum()


# In[5]:


data.dtypes


# # Summary Statistics

# In[6]:


data.describe()


# # Checking Outliers

# In[7]:


data_number1= data[['Customer_Age', 'Dependent_count', 'Total_Relationship_Count','Months_on_book']]


# In[8]:


plt.figure(figsize=(10,6))
sns.boxplot(data= data_number1)
plt.show()


# In[9]:


data_number2 = data[['Months_Inactive_12_mon','Contacts_Count_12_mon', 'Credit_Limit', 'Total_Revolving_Bal', 'Avg_Open_To_Buy']]


# In[10]:


plt.figure(figsize=(10,6))
sns.boxplot(data=data_number2)


# In[11]:


data_number3 = data[['Total_Amt_Chng_Q4_Q1', 'Total_Trans_Amt','Total_Trans_Ct', 'Total_Ct_Chng_Q4_Q1', 'Avg_Utilization_Ratio']]


# In[12]:


plt.figure(figsize=(10,12))

sns.boxplot(data=data_number3)


# In[13]:


data['Attrition_Flag'].value_counts().plot.pie(autopct='%.2f')
#The data is not balance


# In[112]:


counts = data.groupby(['Attrition_Flag','Gender']).size().unstack(fill_value=0)
counts


# In[113]:


counts.plot(kind='barh', stacked=True)


# In[114]:


counts_2 = data.groupby(['Attrition_Flag','Income_Category']).size().unstack(fill_value=0)
counts_2


# In[116]:


counts_2.plot(kind='barh', stacked=True)


# In[14]:


from sklearn.preprocessing import LabelEncoder 


# In[15]:


le = LabelEncoder()
data['Attrition_Flag'] = le.fit_transform(data['Attrition_Flag'])
data.head(2)


# # Checking the correlation 

# In[16]:


data_corr = data.corr()


# In[17]:


plt.figure(figsize=(14,12))
sns.heatmap(data_corr, cbar=True, annot=True)


# # Checking the skewness

# In[18]:


from scipy.stats import skew


# In[19]:


Num_data = data[['Customer_Age', 'Dependent_count', 'Months_on_book',              
'Total_Relationship_Count',      
'Months_Inactive_12_mon',        
'Contacts_Count_12_mon',        
'Credit_Limit',               
'Total_Revolving_Bal',          
'Avg_Open_To_Buy',             
'Total_Amt_Chng_Q4_Q1',        
'Total_Trans_Amt',               
'Total_Trans_Ct',                
'Total_Ct_Chng_Q4_Q1',         
'Avg_Utilization_Ratio']]


# In[20]:


for col in Num_data:
    print(col)
    print(skew(Num_data[col]))
    
    plt.figure()
    sns.distplot(Num_data[col])


# # Feature Selection

# In[ ]:





# We will use Point Biserial. The point biserial correlation coefficient, which is a special case of Pearson’s correlation coefficient.\
# It measures the relationship between two variables\
# One continuous variable and One naturally binary variable.\
# In our dataset, the "ATTRITION FLAG" is a binary variable.\
# We will examine the correlation of numerical variables with the "Attrition_flag.

# In[21]:


data['Attrition_Flag'].dtypes


# In[22]:


target = data['Attrition_Flag']
feature = data[['Customer_Age', 'Dependent_count', 'Months_on_book',              
'Total_Relationship_Count',      
'Months_Inactive_12_mon',        
'Contacts_Count_12_mon',        
'Credit_Limit',               
'Total_Revolving_Bal',          
'Avg_Open_To_Buy',             
'Total_Amt_Chng_Q4_Q1',        
'Total_Trans_Amt',               
'Total_Trans_Ct',                
'Total_Ct_Chng_Q4_Q1',         
'Avg_Utilization_Ratio']]


# In[23]:


from sklearn.preprocessing import LabelEncoder


# In[24]:


le = LabelEncoder()


# In[25]:


data['Attrition_Flag'] = le.fit_transform(target)
data['Attrition_Flag']


# In[26]:


feature.astype('int32').dtypes


# In[27]:


print("Target Shape:", target.shape)
print("Feature Shape:", feature.shape)


# In[28]:


for column in feature.columns:
    point_biserial_corr, p_value = stats.pointbiserialr(target, feature[column])
    print(f'Feature: {column}')
    print(f'Point-Biserial Correlation: {point_biserial_corr}')
    print(f'P-value: {p_value}')


# In[29]:


data


# In[30]:


from sklearn.preprocessing import LabelEncoder as le

le = LabelEncoder()
data['Marital_Status'] = le.fit_transform(data['Marital_Status'])

le = LabelEncoder()
data['Education_Level'] = le.fit_transform(data['Education_Level'])

le = LabelEncoder()
data['Card_Category'] = le.fit_transform(data['Card_Category'])

# Encode 'Gender'
data['Gender'] = le.fit_transform(data['Gender'])

# Encode 'Income_Category'
data['Income_Category'] = le.fit_transform(data['Income_Category'])
data.head(2)


# In[31]:


data.columns


# In[32]:


target.dtypes


# In[33]:


categorical_fetaures = data[['Gender', 'Education_Level', 'Marital_Status', 'Income_Category', 'Card_Category']]


# In[34]:


from sklearn.feature_selection import chi2


# In[35]:


Chi_scores = chi2(categorical_fetaures, target)


# In[36]:


Chi_scores[0]


# In[37]:


Chi_scores[1]


# In[38]:


Chi_values = pd.Series(Chi_scores[0], categorical_fetaures.columns)
Chi_values.sort_values(ascending=False, inplace=True)
Chi_values.plot(kind='barh') #the higher the better


# In[39]:


P_values = pd.Series(Chi_scores[1], categorical_fetaures.columns)
P_values.sort_values(ascending=False, inplace=True)
P_values


# In[40]:


P_values.plot(kind='barh', color='red') #The lower the better


# In[41]:


Finaldata = data[['Attrition_Flag', 'Gender', 'Income_Category', 'Total_Trans_Ct', 'Avg_Utilization_Ratio', 'Total_Revolving_Bal', 'Months_Inactive_12_mon', 'Total_Trans_Amt', 'Total_Amt_Chng_Q4_Q1']]


# In[42]:


X = Finaldata.drop('Attrition_Flag', axis=1)
y = Finaldata['Attrition_Flag']


# In[49]:


data.head(2)

