# Title : Getting and Cleaning data Course Project
# R file Name : run_analysis.R
# This R Script will do the following:
#       (1) Merges the training and the test sets to create one data set.
#       (2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#       (3) Uses descriptive activity names to name the activities in the data set
#       (4) Appropriately labels the data set with descriptive variable names. 
#       (5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Date : 07/27/2014

# Initial prep work includes 
#       (1) Read Readme.txt and feastures_info.txt files for an understanding on background of the project
#       (2) Setting working directory   
#       (3) Include necessary libraries for this project

library(data.table)
library(reshape2)

# The following steps download and unzip's the source zip file in working directory
wrkdir <- getwd()
zipfileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfileUrl,destfile="./UCI-HAR-Dataset.zip")
unzip("UCI-HAR-Dataset.zip")

# Capture data directory and sub-directory details
dirHARData <- paste(wrkdir, "UCI HAR Dataset", sep="/")
list.files(path = wrkdir,recursive = TRUE)

# Read features file into R and filter features i.e., "mean" and "std" features only
dsetFeatures <- read.table(file.path(dirHARData,"features.txt"))
names(dsetFeatures) <- c("FeatureSNo","FeatureName")
dsetFilterFeaturesLogical <- (grepl("mean\\(\\)", dsetFeatures$FeatureName) | grepl("std\\(\\)", dsetFeatures$FeatureName))
dsetFilterFeatures <- as.character(dsetFeatures[dsetFilterFeaturesLogical,2])

# Read TRAIN subject (subject_train.txt) , activity label (y_train.txt) and activity (X_train.txt) data files
# Files with in "Inertial Signals" folder are not used for this project
dsetTrainSubject <- read.table(file.path(dirHARData, "train", "subject_train.txt"))
names(dsetTrainSubject) <- c("Subject")
dsetTrainActivityLbl <- read.table(file.path(dirHARData, "train", "Y_train.txt"))
names(dsetTrainActivityLbl) <- c("ActivityLbl")
# Read only filtered features in above steps for activity data file
Colwidth = (2*as.numeric(dsetFilterFeaturesLogical)-1)*16
dsetTrainActivitySet <- read.fwf(file.path(dirHARData, "train", "X_train.txt"), width=Colwidth, sep="", comment.char="", colClasses="numeric")
dsetTrain <- cbind(dsetTrainSubject, dsetTrainActivityLbl, dsetTrainActivitySet)

# Read TEST subject (subject_test.txt) , activity label (y_test.txt) and activity (X_test.txt) data files
# Files with in "Inertial Signals" folder are not used for this project
dsetTestSubject <- read.table(file.path(dirHARData, "test", "subject_test.txt"))
names(dsetTestSubject) <- c("Subject")
dsetTestActivityLbl <- read.table(file.path(dirHARData, "test", "Y_test.txt"))
names(dsetTestActivityLbl) <- c("ActivityLbl")
# Read only filtered features in above steps for activity data file
Colwidth = (2*as.numeric(dsetFilterFeaturesLogical)-1)*16
dsetTestActivitySet <- read.fwf(file.path(dirHARData, "test", "X_test.txt"), width=Colwidth, sep="", comment.char="", colClasses="numeric")
dsetTest <- cbind(dsetTestSubject, dsetTestActivityLbl, dsetTestActivitySet)

# Merge TRAIN and TEST datasets 
dsetAllData <- rbind(dsetTrain, dsetTest)
colnames(dsetAllData) <- c(c("Subject","ActivityLbl"),dsetFilterFeatures)

# Merge descriptive activity names in the dataset and set key for tidy data set
dsetActivityLables <- read.table(file.path(dirHARData, "activity_labels.txt"))
names(dsetActivityLables) <- c("ActivityLbl", "ActivityName")
dsetAllData <- merge(dsetActivityLables, dsetAllData, by = "ActivityLbl", all.x = TRUE)
dsetAllData <- data.table(dsetAllData)
setkey(dsetAllData, Subject , ActivityLbl, ActivityName)

# Compute average of each variable for each activity and each subject
dsetMeltData <- melt(dsetAllData, key(dsetAllData), measure.vars = c(dsetFilterFeatures))
dsetMeanData <- dcast(dsetMeltData, Subject + ActivityLbl + ActivityName ~ variable, mean)

# Write Tidy data set and computed mean data set to the working directory as csv files
fileTidyData = paste(wrkdir, "Tidy_Data.csv", sep="/")
write.csv(dsetAllData, fileTidyData, row.names=FALSE)
fileMeanData = paste(wrkdir, "Mean_Data.csv", sep="/")
write.csv(dsetMeanData, fileMeanData, row.names=FALSE)

