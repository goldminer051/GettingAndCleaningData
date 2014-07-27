### Codebook.md for Getting and cleaning data - Course Project

Initial prep work has been performed as follows:
(1) Read Readme.txt and feastures_info.txt files for an understanding on background of the project
(2) Setting working directory   
(3) Include necessary libraries for this project. For this project packages data.table and reshape2 

have been used

Here is an explanation of how "run_analysis.R" script file works:

(1) Download source data from the source website (https://d396qusza40orc.cloudfront.net/getdata

%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
(2) Unzip files into the working directory
(3) Files are unzipped into a sub-directory called "UCI HAR Dataset". This sub-directory path has been 

captured in variable "dirHARData"
(4) Read features file into R and filter features i.e., "mean" and "std" features only. Features files 

read into variable "dsetFeatures" and then filtered features captured in variable "dsetFilterFeatures".
(5) Merge TRAIN subject (subject_train.txt) , activity label (y_train.txt) and activity (X_train.txt) 

data files. Apply feature filters to activity data file. This has been captured in data frame 

"dsetTrain".
(6) Merge TEST subject (subject_test.txt) , activity label (y_test.txt) and activity (X_test.txt) data 

files. Apply feature filters to activity data file. This has been captured in data frame "dsetTest".
(7) Merge TRAIN and TEST datasets. This data set is captured in data frame "dsetAllData".
(8) Add meaningful activity names to the above data set by using "activity_labels.txt" supplied in the 

data files. Assign key to this data set.
(9) Compute average of each variable for each activity and each subject by melting the data set. Melted 

data set is captured in data table "dsetMeltData" and computed mean is captured in data table 

"dsetMeanData".
(10) Finally, tidy data set (dsetAllData) and computed mean data set (dsetMeanData) are written to a 

csv file in the working directory. 

