Getting and Cleaning Data
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.You will be required to submit:

a tidy data set as described below
a link to a Github repository with your script for performing the analysis
codeBook.md that describes the variables, the data, and any work that you performed to clean up the data
README.md that explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Good luck!

=====================================================

Code explanations:
Applied the same read format to all the files. (read.csv, with header=FALSE)

Reads these two files from the UCI HAR Dataset. No header available.

   features <- read.csv("features.txt", sep = "", header = FALSE)
   activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)

Again reads from same location and combine test and train set with rbind function.

   ##Reading Sets
   testSet <- read.csv("test/X_test.txt", sep = "", header = FALSE)
   trainSet <- read.csv("train/X_train.txt", sep = "", header = FALSE)
   mergedSet <- rbind(testSet,trainSet)

   ##Reading Labels
   testLabels <- read.csv("test/Y_test.txt", sep = "", header = FALSE)
   trainLabels <- read.csv("train/Y_train.txt", sep = "", header = FALSE)
   mergedMoves <- rbind(testLabels, trainLabels)

   ##Reading PersonID
   testPerson <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
   trainPerson <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
   mergedPerson <- rbind(testPerson, trainPerson)

Assigns descriptive column names that are kept in features vector to mergedSet. After that, all columns are selected that contain a mean or std attribute.
The first column of features contains only the number of rows, which we don't need. The second contains the column names.

   names(mergedSet) <- features[ ,2]
   mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ]

Descriptive values for activity column (mergedLabels).

   mergedLabels <- merge(mergedLabels, activities, by.x = "V1", by.y = "V1")[2]

Merges (column-binds) all 3 merged databases into 1 and names first two columns correctly (not named by features)

   mergedSet <- cbind(mergedPerson, mergedLabels, mergedSet)
   names(mergedSet)[1:2] <- c("PersonID", "Activities")

Tidying set according to personID and activities, calculating the average of each variable for each activity and each subject
and writing out tidy data set.

tidyData <- group_by(mergedSet, PersonID, Activities) %>% summarise_all(mean)
write.table(tidyData, "TidyData.csv", row.name=FALSE)
