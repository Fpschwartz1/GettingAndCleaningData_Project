##Getting and Cleaning Data - Course Project

This repository contains the material required for peer reviewing. The main goal was to make tidy the data obtained from **Human Activity Recognition Using Smartphones Dataset**.

All the code needed for the tidying task is included in the **run_analysis.R** script. Each step is fully commented in order to make easy the code understanding.

In a general way, the following steps were performed:
- getting the subjects' identification: files **subject_train.txt** and **subject_test.txt**;
- getting the training and test sets with meaningful names of variables: files **features.txt**, **X_train.txt**, and **X_test.txt**;
- associating activities to each observation: files **y_train.txt** and **y_test.txt**;
- merging files in an only data frame;
- extracting only the measurements on the mean and standard deviation;
- grouping data by **subject** and **activity** to estimate the mean of the selected measurements.