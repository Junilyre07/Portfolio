#!/usr/bin/env python
# coding: utf-8

# In[26]:


import pandas as pd
import seaborn as sns


# In[30]:


data = pd.read_csv('Sales1.csv')


# In[31]:


data.head(5)


# In[32]:


print('Number of columns:',data.shape[1])
print('Number of rows:',data.shape[0])


# In[33]:


data.dtypes


# Checking if there are null values

# In[34]:


data.isnull().sum()


# Checking duplicates

# In[35]:


duplicated = data.duplicated().sum()
print('Number of duplicates:',duplicated)


# Dropping duplicates

# In[10]:


data.drop_duplicates( keep='first', inplace=True, ignore_index=False)


# In[11]:


print('Number of rows after removing duplicates:',data.shape[0])


# Summary Statistics 

# In[12]:


data.describe()


# Checking correlation 

# In[13]:


corr_data = data.corr()


# In[14]:


corr_data 


# In[15]:


sns.heatmap(corr_data, cbar=True, annot=True)


# Checking outliers

# In[16]:


sns.boxplot(data=data, x="Profit", y="Country")


# In[17]:


sns.boxplot(data=data, y="Profit")


# In[18]:


sns.boxplot(data=data, y="Unit_Price")


# In[19]:


from scipy import stats
from scipy.stats import skew
import matplotlib.pyplot as plt


# In[24]:


num_bikes = data[['Customer_Age','Order_Quantity', 'Unit_Cost', 'Unit_Price','Profit', 'Revenue']]
num_bikes.head(2)


# Checking Distribution

# In[25]:


for col in num_bikes:
    print(col)
    print(skew(num_bikes[col]))
    
    plt.figure()
    sns.distplot(num_bikes[col])


# In[ ]:





# In[ ]:





# In[ ]:




