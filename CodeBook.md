# CODEBOOK

## Original Dataset Information

>A set of experiments was carried out on a group of 30 volunteers within the age range of 19-48years.  
Each person was instructed to perform 6 different Activities of Daily Living(ADL) while wearing a waist-mounted Samsung Galaxy S II smartphone as described in the "Methodology" section of the paper cited below [1].

[1] Anguita D., Ghio A., Oneto L., Parra X. and Reyes-Ortiz J.L., (2013) Public Domain Dataset for Human Activity Recognition Using Smartphones, European Symposium on Artificial Neural Networks, Computational Intelligence
and Machine Learning
[link to paper](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf)

>Using the phones accelerometer and gyroscope 3 raw tri-axial time domain signals were captured (BodyXYZ and GravityXYZ Acceleration signals from the accelerometer and the Body GyroscopeXYZ from the gyroscope).
Two more time domain signals were derived from the raw signals (the BodyAccelerationJerkXYZ and the BodyGyroJerkXYZ) and the magnitude of all 5 of these time domain signals was calculated (BodyAccMag, 
GravityAccMag, BodyGyroMag, BodyAccJerkMag, BodyGyroJerkMag), note magnitude signals do not have an XYZ component. 

>A Fast Fourier Transform(FFT) was applied to 7 of the time domain signals to get 7 frequency domain signals (fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag
fBodyGyroJerkMag).

>This creates a total of 17 reported time and frequency domain signals as listed below.  See "Section 2.1 Signal Processing" in the above cited paper[1] for further explanation on how these signals were obtained.


#### These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

#### The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

#### Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
tBodyGyroJerkMean

#### License:

Use of this dataset in publications must be acknowledged by referencing the following publication
>[2] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.  
   International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012  
   
This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


## Assumptions before running run_analysis.R script:
Files were downloaded into the users Working Directory from the below address.  
   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## The run_analysis.R script: 

### Loads "Original Dataset" from the following files: 
* "features.txt": variable headings for x_test and x_train
* "activity_labels.txt": indexing the Activities of Daily Living(ADL) labels with numbers from the y_test and y_train files
* "test/X_test.txt": set of variable values for the test group estimated from the time and frequency domain signals as discussed above
* "test/Y_test.txt": each row identifies the number indexed activity of daily living (ADL)for the observed sample measurement in the test group
* "test/subject_test.txt": each row identifies the subject from the test group who performed the activity for each sample observation
* "train/X_train.txt": set of variable values for the train group estimated from the time and frequency domain signals as discussed above
* "train/Y_train.txt": each row identifies the number indexed activity of daily living (ADL)for the observed sample measurement in the train group
* "train/subject_train.txt": each row identifies the subject from the train group who performed the activity for each sample observation

### Transforms "Original Dataset" in the following ways:
1. `colnames()`: Assign the x_test, x_train, y_test, y_train, subject_test and subject_train dataframes appropriate variable names to make indexing easier
2. `cbind()`: Add "activity" (y_test, y_train) and "subject" (subject_test, subject_train) columns to respective test (x_test) and train (x_train) dF
3. `mutate()`: Add a "VolunteerGroup" column to the x_test and x_train dF's in order to not lose data when the two dFs are merged.  Since the VolunteerGroup is a   
   fixed variable move it to the 3rd column in the dF according to TidyData principals (Wickham, 2014 [3])
4. `rbind()`: Join the x_test and x_train datasets into a dataframe called "AllSubjects", rows are individual observations and should not be combined so use rbind
5. `select()`, `grep()`: Create a "MeanStdDF" subset of "AllSubjects" dF. Do not include "meanFreq()" as this is listed as a separate variable  
   in the "set of variables estimated from signals" (see "Original Dataset Information" above).  Do not include "angle" columns since these are not listed in the  
   initial set of variables estimated from the signals.  Include both time and frequency domain variables as I believe that it is   
   beyond the scope of this course to understand that frequency domain variables are simply a different representation of the same data.
6. `activity_labels$V2[]`: Change activity column numbers to descriptive names using the numbers in the "activity" column of the dF as   
   element indexes in the activity_labels$V2 vector 
7. `summarize_all()`, `group_by()`, `mean()`: Create a summary dataset of the averages of each mean() and std() variable for each activity for each subject  
   first group the data by subject, activity and Volunteer Group (include VolunteerGroup so summarize_all does not include it)
8. `names()`, `gsub()`, `str_replace_all()`: Transforming text into TidyData format. Include long column names sacrificing succinctness for clarity given the audience (peer-graders) are not likely experts 
   in Human Activity Recognition using SmartPhone tri-axial accelerometer and gyroscope

[3] Wickham, H (2014).  Tidy Data.  Journal of Statistical Software, August 2014, Volume 59, Issue 10.

## Variables in Tidy DataSet produced by run_analysis.R
* subject: refers to which of the 30 volunteers performed the activity
* activity: refers to the activity of daily living being measured
* VolunteerGroup: refers to whether the subject was in the test or train group
* TimeBodyAccelerationMean-XYZ: refers to the **mean** of the time domain body acceleration mean variable in the X, Y and Z directions respectively for the measured subject and activity
* TimeBodyAccelerationStd-XYZ: refers to the **mean** of the time domain body acceleration standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* TimeGravityAccelerationMean-XYZ: refers to the **mean** of the time domain gravity acceleration mean variable in the X, Y and Z direction respectively for the measured subject and activity
* TimeGravityAccelerationStd-XYZ: refers to the **mean** of the time domain gravity acceleration standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* TimeBodyAccelerationJerkMean-XYZ: refers to the **mean** of the time domain acceleration jerk mean variable in the X, Y and Z direction respectively for the measured subject and activity
* TimeBodyAccelerationJerkStd-XYZ: refers to the **mean** of the time domain acceleration jerk standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* TimeBodyGyroscopeMean-XYZ: refers to the **mean** of the time domain body gyroscope mean variable in the X, Y and Z direction respectively for the measured subject and activity
* TimeBodyGyroscopeStd-XYZ: refers to the **mean** of the time domain body gyroscope standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* TimeBodyGyroscopeJerkMean-XYZ: refers to the **mean** of the time domain body gyroscope jerk mean variable in the X, Y and Z direction respectively for the measured subject and activity
* TimeBodyGyroscopeJerkStd-XYZ: refers to the **mean** of the time domain body gyroscope jerk standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* TimeBodyAccelerationMagnitudeMean: refers to the **mean** of the time domain body acceleration magnitude mean for the measured subject and activity
* TimeBodyAccelerationMagnitudeStd: refers to the **mean** of the time domain body acceleration magnitude standard deviation for the measured subject and activity
* TimeGravityAccelerationMagnitudeMean: refers to the **mean** of the time domain gravity acceleration magnitude mean for the measured subject and activity
* TimeGravityAccelerationMagnitudeStd: refers to the **mean** of the time domain gravity acceleration magnitude standard deviation for the measured subject and activity
* TimeBodyAccelerationJerkMagnitudeMean: refers to the **mean** of the time domain body acceleration jerk magnitude mean for the measured subject and activity
* TimeBodyAccelerationJerkMagnitudeStd: refers to the **mean** of the time domain body acceleration jerk magnitude standard deviation for the measured subject and activity
* TimeBodyGyroscopeMagnitudeMean: refers to the **mean** of the time domain body gyroscope magnitude mean for the measured subject and activity
* TimeBodyGyroscopeMagnitudeStd: refers to the **mean** of the time domain body gyroscope magnitude standard deviation for the measured subject and activity
* TimeBodyGyroscopeJerkMagnitudeMean: refers to the **mean** of the time domain body gyroscope jerk magnitude mean for the measured subject and activity
* TimeBodyGyroscopeJerkMagnitudeStd: refers to the **mean** of the time domain body gyroscope jerk magnitude standard deviation for the measured subject and activity
* FrequencyBodyAccelerationMean-XYZ: refers to the **mean** of the frequency domain body acceleration mean variable in the X, Y and Z direction respectively for the measured subject and activity
* FrequencyBodyAccelerationStd-XYZ: refers to the **mean** of the frequency domain body acceleration standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* FrequencyBodyAccelerationJerkMean-XYZ: refers to the **mean** of the frequency domain acceleration jerk mean variable in the X, Y and Z direction respectively for the measured subject and activity
* FrequencyAccelerationJerkStd-XYZ: refers to the **mean** of the frequency domain acceleration jerk standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* FrequencyBodyGyroscopeMean-XYZ: refers to the **mean** of the frequency domain body gyroscope mean variable in the X, Y and Z direction respectively for the measured subject and activity
* FrequencyBodyGyroscopeStd-XYZ: refers to the **mean** of the frequency domain body gyroscope standard deviation variable in X, Y and Z direction respectively for the measured subject and activity
* FrequencyBodyAccelerationMagnitudeMean: refers to the **mean** of the frequency domain body acceleration magnitude mean for the measured subject and activity
* FrequencyBodyAccelerationMagnitudeStd: refers to the **mean** of the frequency domain body acceleration magnitude standard deviation for the measured subject and activity
* FrequencyBodyAccelerationJerkMagnitudeMean: refers to the **mean** of the frequency domain body acceleration jerk magnitude mean for the measured subject and activity
* FrequencyBodyAccelerationJerkMagnitudeStd: refers to the **mean** of the frequency domain body acceleration jerk magnitude standard deviation for the measured subject and activity
* FrequencyBodyGyroscopeMagnitudeMean: refers to the **mean** of the frequency domain body gyroscope magnitude mean for the measured subject and activity
* FrequencyBodyGyroscopeMagnitudeStd: refers to the **mean** of the frequency domain body gyroscope magnitude standard deviation for the measured subject and activity
* FrequencyBodyGyroscopeJerkMagnitudeMean: refers to the **mean** of the frequency domain body gyroscope jerk magnitude mean for the measured subject and activity
* FrequencyBodyGyroscopeJerkMagnitudeStd: refers to the **mean** of the frequency domain body gyroscope jerk magnitude standard deviation for the measured subject and activity


## Variable Units
* Acceleration signal from Smartphone Accelerometer in standard gravity units 'g'
* Angular velocity vector measured by the Smartphone gyroscope in radians/second
* Note Variables of "Original Dataset" have been normalized and bounded between[-1,1].
