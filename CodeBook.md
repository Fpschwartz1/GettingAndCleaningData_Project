##CodeBook

In a general way, the following steps were performed to get tidy data:
- getting the subjects' identification: files **subject_train.txt** and **subject_test.txt**;
- getting the training and test sets with meaningful names of variables: files **features.txt**, **X_train.txt**, and **X_test.txt**;
- associating activities to each observation: files **y_train.txt** and **y_test.txt**;
- merging files in an only data frame;
- extracting only the measurements on the mean and standard deviation;
- grouping data by **subject** and **activity** to estimate the mean of the selected measurements.