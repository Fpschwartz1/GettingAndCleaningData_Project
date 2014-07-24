#################################################################################
# This project is a requirement of the Getting and Cleaning Data course.
# This script builds tidy data from data collected from the accelerometers 
# from the Samsung Galaxy S smartphones. 
#
# According to the statement of the project, five steps must be followed. In this
# implementation, all of them were followed, however, in a slightly different 
# order, as documented bellow.
#################################################################################

rm(list = ls(all = TRUE)) # clear all variables

####
# 1. Merges the training and the test sets to create one data set.
####

# Reads from both sets (training and test) the ID of the subjects for each 
# activity performed. The parameter col.names was labeled as "subject" which
# is a descriptive name.
subject_train<-read.table(col.names="subject", 
                          file="UCI HAR Dataset\\train\\subject_train.txt")
subject_test <-read.table(col.names="subject", 
                          file="UCI HAR Dataset\\test\\subject_test.txt")

# Reads training and test sets adjusting the name of variables to meaningful ones.
# The labels used were the ones available in the "list of all features" 
# (features.txt file). Characters like "-", "(", and ")" are converted to "." by
# the read.table function. 
# For example, "tBodyAcc-mean()-X" results in "tBodyAcc.mean...X"
# This labeling action corresponds to the step 4 requirement.
    ####
    # 4. Appropriately labels the data set with descriptive variable names.
    ####
features<-read.table(file="UCI HAR Dataset\\features.txt")
X_train<-read.table(col.names=features$V2, # features names
                    file="UCI HAR Dataset\\train\\X_train.txt")
X_test <-read.table(col.names=features$V2, # feature names
                    file="UCI HAR Dataset\\test\\X_test.txt")

# Takes the activity which corresponds to each observation (row) in X_train 
# and X_test dataframes. The parameter col.names was labeled as "id_activity"
# which is a descriptive name.
y_train<-read.table(col.names="id_activity",
                    file="UCI HAR Dataset\\train\\y_train.txt")
y_test <-read.table(col.names="id_activity",
                    file="UCI HAR Dataset\\test\\y_test.txt")

# Assembles the elements of each data set: training and test
# Training data set: subject_train + y_train + X_train
train<-cbind(subject_train,y_train)
train<-cbind(train,X_train)
# Test data set: subject_test + y_test + X_test
test <-cbind(subject_test,y_test)
test <-cbind(test,X_test)

# Merges the training and the test sets
merged_data<-rbind(train,test)



####
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
####

# Uses the "grep" function to Verify the variables (columns) of "merged_data"
# whose names contain the strings "mean." or "std.". The result is used to extract
# only the measurements on the mean and standard deviation 
i_var<-c(grep("mean\\.",names(merged_data)), grep("std\\.",names(merged_data)))
merged_data<-merged_data[,c(1:2,sort(i_var))]



####
# 3. Uses descriptive activity names to name the activities in the data set
####

# Reads the "activity_labels.txt" file. The parameter col.names was labeled with
# two elements ("id_activity","activity") which are descriptive names.
activity_labels<-read.table(col.names=c("id_activity","activity"),
                            file="UCI HAR Dataset\\activity_labels.txt")
# Merges data and activity labels
merged_data<-merge(merged_data,activity_labels,by.x="id_activity",by.y="id_activity",
             all=FALSE)
# Sets the new order of the columns: subject, id_activity, activity ...
merged_data<-merged_data[,c(2,1,ncol(merged_data),3:(ncol(merged_data)-1))] # adjusts column order
# Order the merged_data by "subject" and "id_activity"
merged_data<-merged_data[with(merged_data, order(subject, id_activity)), ]
# Removes the rownames of merged_data
rownames(merged_data)<-c()



####
# 4. Appropriately labels the data set with descriptive variable names.
####

# this step was already done inside step 1



###############################################################################
# 5. Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
###############################################################################

# Gets the id of the subjects
s<-as.numeric(levels(as.factor(merged_data[,"subject"])))
# Gets the id of the activities
a<-as.numeric(levels(as.factor(merged_data[,"id_activity"])))

tidy_data<-c() # initializes a data.frame

for(i in s){ # for each subject
    for(j in a){ # estimates de mean for each activity
        # Determines the mean of numeric columns. It results a named vector column vector.
        df<-colMeans(merged_data[merged_data$subject==i & merged_data$id_activity==j,4:length(merged_data)])
        # Converts the named vector to a data.frame with several named rows. Then,
        # transposes the dataframe to a row with several columns
        df<-t(data.frame(df))
        # Join non-numeric variables with numeric ones.
        df<-data.frame(merged_data[merged_data$subject==i & merged_data$id_activity==j,1:3][1,],df)
        # Adds the resulting dataframe to tidy_data dataframe
        tidy_data<-rbind(tidy_data,df)
    }
}
rownames(tidy_data)<-c() # clear the row names

# Adds the sufix "_avg" (average) to the column names
colnames(tidy_data)<-c(names(tidy_data[,1:3]),
                       sapply(names(tidy_data[,4:ncol(tidy_data)]),
                        paste2<-function(x) paste(x,"_avg",sep="")))

# write the tidy data in a file
write.table(tidy_data,file="tidy_data.txt")

# You can check the success of this script by running the code below and verifying the "check" data frame
# rm(list = ls(all = TRUE))
# check<-read.table(file="tidy_data.txt")
