# -*- coding: utf-8 -*-
"""
Created on Fri Oct 18 09:28:06 2019

@author: AliKelkawi
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# Importing the dataset
dataset = pd.read_csv('WildFire_Prediction_Data_Set.csv')
X = dataset.iloc[:, 0:3].values
y = dataset.iloc[:, 3].values
feature_names = list(dataset.columns)

# Import label encoder 
from sklearn import preprocessing 
  
# label_encoder object knows how to understand word labels. 
label_encoder = preprocessing.LabelEncoder() 
  
# Encode labels in column 'species'. 
dataset['CLASS']= label_encoder.fit_transform(dataset['CLASS']) 
y = dataset.iloc[:, 3].values


# For splitting data into train and test data 
from sklearn.model_selection import train_test_split 
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# Fitting Random Forest Classification to the Training set
from sklearn.ensemble import RandomForestClassifier
classifier = RandomForestClassifier(n_estimators = 200, criterion = 'entropy', random_state = 0)

classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix for RF
from sklearn.metrics import confusion_matrix
cmRF = confusion_matrix(y_test, y_pred)

ax= plt.subplot()
sns.heatmap(cmRF, cmap = 'Reds', annot=True, ax = ax, fmt = 'g'); #annot=True to annotate cells
plt.title("Confusion Matrix for Random Forest Classification")
plt.xlabel("Predicted Class")
plt.ylabel("Actual Class")

# Metrics

def accuracy(confusion_matrix):
    diagonal_sum = confusion_matrix.trace()
    sum_of_all_elements = confusion_matrix.sum()
    return diagonal_sum / sum_of_all_elements

from sklearn.metrics import recall_score
from sklearn.metrics import precision_score
cmToTest = cmRF
print("Accuracy: " + str(accuracy(cmToTest)))
print("Precision: " + str(precision_score(y_test, y_pred)))
print("Recall: " + str(recall_score(y_test, y_pred)))
