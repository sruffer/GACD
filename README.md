## Getting and Cleaning Data Course Project

The script run_analysis.R is intended to satisfy these assignment requirements:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The 8 data files are read and stored in 8 separate variables using the read.table function.

The commands in the dplyr library error out due to the special characters in the features.txt file, so the make.names function
removes the special characters from column names.

The activity codes and subjects are stored in separate files, so they are added to the training and testing data sets
using the mutate function.

The measurements besides mean and std columns are removed from the data using the select function.

The training and testing data sets are merged using the rbind function.

To add the activity names, the approach was taken from David Hood's suggestion at https://class.coursera.org/getdata-009/forum/thread?thread_id=141

In order to tidy up the column names, the periods are removed using the gsub function.

To create the 2nd data set with averages for each activity and each subject, the aggregate function is used.

Finally, the write.table function is used to create the tidy data set output file.