Getting and Cleaning Data Course Project
----------------------------------------

### Requirements for the Project:

> Analyze the data collected in the project named - Human Activity
> Recognition Using Smartphones Dataset. Create one R script named
> run\_analysis.R that does the following:
>
> -   The submitted data set is tidy.
> -   Merges the training and the test sets to create one data set.
> -   Extracts only the measurements on the mean and standard deviation
>     for each measurement.
> -   Uses descriptive activity names to name the activities in the data
>     set
> -   Appropriately labels the data set with descriptive variable names.
> -   From the data set in step 4, creates a second, independent tidy
>     data set with the average of each variable for each activity and
>     each subject.

### Additional submission requirements for the Project are:

> -   The submitted data set is tidy.
> -   The Github repo contains the required scripts.
> -   GitHub contains a code book that modifies and updates the
>     available codebooks with the data to indicate all the variables
>     and summaries calculated, along with units, and any other
>     relevant information.
> -   The README that explains the analysis files is clear
>     and understandable.
> -   The work submitted for this project is the work of the student who
>     submitted it.

### Data for the project

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by
applying noise filters and then sampled in fixed-width sliding windows
of 2.56 sec and 50% overlap (128 readings/window). The sensor
acceleration signal, which has gravitational and body motion components,
was separated using a Butterworth low-pass filter into body acceleration
and gravity. The gravitational force is assumed to have only low
frequency components, therefore a filter with 0.3 Hz cutoff frequency
was used. From each window, a vector of features was obtained by
calculating variables from the time and frequency domain.

Full data for the analysis can be downloaded from the below link
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

### Data Overview

The dataset includes the following files:

-   'README.txt'
-   'features\_info.txt': Shows information about the variables used on
    the feature vector.
-   'features.txt': List of all features.
-   'activity\_labels.txt': Links the class labels with their
    activity name.
-   'train/X\_train.txt': Training set.
-   'train/y\_train.txt': Training labels.
-   'test/X\_test.txt': Test set.
-   'test/y\_test.txt': Test labels.

The following files are available for the train and test data. Their
descriptions are equivalent.

-   'train/subject\_train.txt': Each row identifies the subject who
    performed the activity for each window sample. Its range is from 1
    to 30.
-   'train/Inertial Signals/total\_acc\_x\_train.txt': The acceleration
    signal from the smartphone accelerometer X axis in standard gravity
    units 'g'. Every row shows a 128 element vector. The same
    description applies for the 'total\_acc\_x\_train.txt' and
    'total\_acc\_z\_train.txt' files for the Y and Z axis.
-   'train/Inertial Signals/body\_acc\_x\_train.txt': The body
    acceleration signal obtained by subtracting the gravity from the
    total acceleration.
-   'train/Inertial Signals/body\_gyro\_x\_train.txt': The angular
    velocity vector measured by the gyroscope for each window sample.
    The units are radians/second.

### Overall Process:

The below process was followed to arrive at the two tidy data sets
required for the project.

1.  The text files are to be comsumed and filled into data tables for
    the analysis.
2.  The activity\_labels.txt file contains the different activities that
    can be performed
3.  The features.txt file contains the different measurements that can
    be takes
4.  The test/X\_test.txt and test/X\_train.txt files contain 561
    different type of measurements(variables) for about 30 subjects.
    There can be multiple rows for each subject in each file. The number
    of rows in each file are also different.
5.  Data from the two files are merged into a single data
    table(using rbind()). Similaryly, data from y\_test.txt and
    y\_train.txt are merged and subject\_test.txt and subject\_train.txt
    are merged.
6.  Column/Variable names in the resultant data sets are then changed to
    make them more readable and meaningful (instead of names like V1,
    V2, etc)
7.  As the requirement clearly mentions that we only need to analyze
    measurements corresponding to mean and standard deviation, only the
    columns containing "mean" and "std" are taken into consideration
8.  The data sets obtained in step 4 are then merged using cbind() to
    give the final data set.
9.  The final data set obtained in Step 7 is then grouped by Activity
    and Subject columns and summarised using the mean function.
10. Both the data sets produced by the Step 7 and Step 8 are then
    written to file using the row.names = FALSE clause.

Please refer to the README.md file for detailed explanation of how the
result has been arrived at.
