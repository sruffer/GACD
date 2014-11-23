# Getting and Cleaning Data Course Project - sruffer
# Assignment instructions:
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# the following lines are needed to download the data initially but not required to perform the analysis each time
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#setInternet2(use = TRUE)
#download.file(fileUrl, destfile = "./HARData.zip")

# read data from text files
subjecttrain <- read.table("./subject_train.txt") # subjects for training data
Xtrain <- read.table("./X_train.txt") # training dataset data
ytrain <- read.table("./y_train.txt") # training dataset activity codes
subjecttest <- read.table("./subject_test.txt") # subjects for testing data
Xtest <- read.table("./X_test.txt") # testing dataset data
ytest <- read.table("./y_test.txt") # testing dataset activity codes
actlabels <- read.table("./activity_labels.txt") # activity labels
features <- read.table("./features.txt") # data column names

# remove special characters from column names and add column names to data sets:
newnames <- make.names(features$V2, unique=TRUE)
names(Xtrain) <- newnames
names(Xtest) <- newnames

# add activity codes and subjects to xtrain and xtest
library(dplyr)
train <- tbl_df(Xtrain)
train <- mutate(train, Subject = subjecttrain$V1, ActCode = ytrain$V1)
test <- tbl_df(Xtest)
test <- mutate(test, Subject = subjecttest$V1, ActCode = ytest$V1)

# remove other measurements besides mean and std columns 
train <- select(train, Subject, ActCode, contains(".mean."), contains(".std."))
test <- select(test, Subject, ActCode, contains(".mean."), contains(".std."))

# merge xtrain and xtest
total <- rbind(train, test)

# add activity names; approach taken from David Hood's suggestion here: https://class.coursera.org/getdata-009/forum/thread?thread_id=141
total$Activity <- "Walking"
total$Activity[total$ActCode == 2] <- "Walking Upstairs"
total$Activity[total$ActCode == 3] <- "Walking Downstairs"
total$Activity[total$ActCode == 4] <- "Sitting"
total$Activity[total$ActCode == 5] <- "Standing"
total$Activity[total$ActCode == 6] <- "Laying"

# move Activity to the 2nd column
total <- select(total, Subject, Activity, tBodyAcc.mean...X:fBodyBodyGyroJerkMag.std..)

# remove periods from column names
cleannames <- names(total)
cleannames <- gsub("[.]","",cleannames)
names(total) <- cleannames

# create 2nd data set with averages for each activity and each subject
averages <- aggregate(total[,3:68], by = list(total$Subject, total$Activity), FUN = mean, na.rm = TRUE)

# rename first 2 columns back to Subject and Activity
names(averages)[1:2] <- c("Subject", "Activity")

# create output file for averages
write.table(averages, file = "run_analsyis_averages.txt", row.name=FALSE)
