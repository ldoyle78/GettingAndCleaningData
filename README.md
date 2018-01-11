# README

The goal of this project is to take data from an Human Activity Recognition(HAR) database built from the recordings of 30 subjects doing Activites of Daily Living(ADL) while carrying a Smartphone embedded with acceleromter and gyroscope (data 
can be downloaded from the below address) and transform it into a tidy dataset that takes the **average of the mean and standard deviation variables for each activity and each subject.**   

[Original Data Link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## CodeBook
The Codebook is a comprehensive document containing:
* Description of the "Original Dataset" files and variables with references for further reading on how the original data was obtained
* Description of the run_analysis.R script and transformations it performs on the "Original Dataset"
* Description of the variables in the new tidy dataset TidySummary and their units

## Assumptions before running run_analyis.R script:
The folder from above link has been downloaded and saved in a file in the users working directory

## The run_analysis.R script will

load data into RStudio from the following files (see CodeBook.md for description of files):
* "features.txt" 
* "activity_labels.txt"
* "test/X_test.txt"
* "test/Y_test.txt"
* "test/subject_test.txt"
* "train/X_train.txt"
* "train/Y_train.txt"
* "train/subject_train.txt"

It will then perform various transforms on the data as detailed in CodeBook.md and produce a Tidy Dataset that is the average of the mean and standard deviation of the recordings of the 30 subjects doing ADL, grouped by subject and activity.

## The TidySummary dataset can be loaded into RStudio using the following code:

TidySummary <- read.table("*yourfolderhere*/TidySummary.txt", header = TRUE)
