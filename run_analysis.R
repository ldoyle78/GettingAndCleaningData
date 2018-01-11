
# Read in data files to r
    activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
    features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

    x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
    y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
    subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

    x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
    y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
    subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# check for any missing data
    missingdatatest <- any(is.na(x_test))
    missingdatatrain <- any(is.na(x_train))

# give the x_test, x_train, y_test, y_train, subject_test and subject_train dataframes appropriate variable names to make indexing easier
    library(dplyr)
    colnames(x_test) <- features[ , 2]
    colnames(x_train) <- features[ ,2]
    colnames(y_test) <- "activity"
    colnames(y_train) <- "activity"
    colnames(subject_train) <- "subject"
    colnames(subject_test) <- "subject"

# Add activity(y_test, y_train) and subject (subject_test, subject_train) columns to respective test and train df
    library(plyr)
    x_test <- cbind(subject_test, y_test, x_test)
    x_train <- cbind(subject_train, y_train, x_train)

#  Add a VolunteerGroup column to the test and train dF's in order to not lose data when the two dataframes are merged
#  Since the VolunteerGroup is a fixed variable move it to the 3rd column in the dF according to TidyData principals
    x_test <- mutate(x_test, VolunteerGroup = "test")
    x_test <- x_test[c(1,2,564,3:563)]
    x_train <- mutate(x_train, VolunteerGroup = "train")
    x_train <- x_train[c(1,2,564,3:563)]

# Join the test and train datasets, rows are individual observations and should not be combined so use rbind
    AllSubjects <- rbind(x_test, x_train)

# Creating the MeanStdDF subset of AllSubjects dataframe. Do not include "meanFreq()" as this is listed as a separate variable
# in the "set of variables estimated from signals" (see CodeBook).  Do not include "angle" columns since these are not listed in the
# initial set of variables estimated from the signals.  Include both time and frequency domain variables as I believe that it is 
# beyond the scope of this course to understand that frequency domain variables are simply a different representation of the same data.

    MeanStdDF <- select(AllSubjects, grep("\\bmean()\\b|\\bstd()\\b|\\bactivity\\b|\\bsubject\\b|\\VolunteerGroup\\b", colnames(AllSubjects), value = TRUE))

# change activity column numbers to descriptive names using the numbers in the "activity" column of the dF as 
# element indexes in the activity_labels$V2 vector 
    MeanStdDF$activity <- activity_labels$V2[MeanStdDF$activity]

# create a summary dataset of the averages of each mean() and std() variable for each activity for each subject
# first group the data by subject, activity and Volunteer Group (include VolunteerGroup so summarize_all does not include it)
    MeanStdDF <- group_by(MeanStdDF, subject, activity, VolunteerGroup)
    SummaryDF <- summarize_all(MeanStdDF, mean)

# Transforming text into TidyData format. Include long column names sacrificing succinctness for clarity
# given the audience (peer-graders) are not likely experts in Human Activity Recognition using SmartPhone
# tri-axial accelerometer and gyroscope
    library(stringr)
    names(SummaryDF) <- gsub("^t", "Time", names(SummaryDF))
    names(SummaryDF) <- gsub("^f", "Frequency", names(SummaryDF))
    names(SummaryDF) <- gsub("[()]", "", names(SummaryDF))
    names(SummaryDF) <- gsub("-", "", names(SummaryDF))
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "mean", "Mean")
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "std", "Std")
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "BodyBody", "Body")
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "Acc", "Acceleration")
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "Mag", "Magnitude")
    names(SummaryDF) <- str_replace_all(names(SummaryDF), "Gyro", "Gyroscope")

# Write the resulting SummaryDF to a file for uploading to Getting And Cleaning Data project submission    
    TidySummary <- write.table(SummaryDF, file = "./GettingAndCleaningData/Project/TidySummary.txt", row.names = FALSE)

