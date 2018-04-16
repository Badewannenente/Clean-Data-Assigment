setwd("C:/Users/Steffen/Desktop/Coursera/Data Science/3. Getting and Cleaning Data/Week 4 - Text and date manipulation in R/UCI HAR Dataset")
library(dplyr)
library(data.table)

#You should create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
  
##Reading Features and activity-labels vector
features <- read.csv("features.txt", sep = "", header = FALSE)
activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)

##Reading and Merging Sets
testSet <- read.csv("test/X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("train/X_train.txt", sep = "", header = FALSE)
mergedSet <- rbind(testSet,trainSet)        

##Reading and Merging Labels
testLabels <- read.csv("test/Y_test.txt", sep = "", header = FALSE)
trainLabels <- read.csv("train/Y_train.txt", sep = "", header = FALSE)
mergedLabels <- rbind(testLabels, trainLabels)

##Reading and Merging PersonID
testPerson <- read.csv("test/subject_test.txt", sep = "", header = FALSE)
trainPerson <- read.csv("train/subject_train.txt", sep = "", header = FALSE)
mergedPerson <- rbind(testPerson, trainPerson)

## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
names(mergedSet) <- features[,2]
mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ] 

## 3.Uses descriptive activity names to name the activities in the data set
mergedLabels <- merge(mergedLabels, activities, by.x = "V1", by.y = "V1")[2]

## 4.Appropriately labels the data set with descriptive variable names.
mergedSet <- cbind(mergedPerson, mergedLabels, mergedSet)
names(mergedSet)[1:2] <- c("PersonID", "Activities")

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- group_by(mergedSet, PersonID, Activities) %>% summarise_all(mean)
write.table(tidyData, "TidyData.txt", row.name=FALSE)