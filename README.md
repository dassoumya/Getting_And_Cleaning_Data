Getting and Cleaning Data Course Project
----------------------------------------

### Requirements for the Project:

> Create one R script named run\_analysis.R that does the following:
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

### Overall Process:

The below process was followed to arrive at the two tidy data sets
required for the project.

#### 1. Merge the training and the test sets to create one data set.

I am using the dplyr package to select, rename and mutate data tables in
this R script, so I load the package first. I also load the activity
labels and the features data into data tables.

    # Read the activity labels and features data sets that are common to both train and test data
    activity_labels <- read.table("./activity_labels.txt")
    features <- read.table("./features.txt")

I also read the first set of test data from the files into data tables
X\_test, Y\_test and subject\_test

    # Read test data
    X_test <- read.table("./test/X_test.txt")
    Y_test <- read.table("./test/Y_test.txt")
    subject_test <- read.table("./test/subject_test.txt")

Similar code can be written to read the second set of training data from
the files into data tables X\_train, Y\_train and subject\_train

    # Read training data
    X_train <- read.table("./train/X_train.txt")
    Y_train <- read.table("./train/Y_train.txt")
    subject_train <- read.table("./train/subject_train.txt")

After reading test and train data, they are merged using the rbind()
function. The order of rows have to be maintained in all the resultant
data sets X\_test\_train, Y\_test\_train and subject\_test\_train -
first the test data and then the training data

    X_test_train <- rbind(X_test,X_train)
    Y_test_train <- rbind(Y_test,Y_train)
    subject_test_train <- rbind(subject_test, subject_train)

#### 2. Extract only the measurements on the mean and standard deviation for each measurement.

I have already read the set of features into the features data table
previously. From that set, I filter out the ones that contain "mean" or
"std" (assuming std stands for standard deviation) - using the grep()
function for searching and the filter() verb of dplyr for filtering out
the data set.

NOTE: There are some features(or measurements) which contain something
like meanFreq which I am excluding for my analysis. The resulting
feature set for analysis is stored in a data table called sub\_features

    # Extract only the measurements on the mean and standard deviation for each measurement.
    sub_features <- filter(features, grepl("mean|std",V2), !grepl("meanFreq",V2))

I then use the sub\_features data set to modify the X\_test\_train data
set to only contain variables which have mean or std measurements as
given below.

    # Use only the previously obtained subset of variables/measurements in the final subset
    X_test_train <- X_test_train[,sub_features$V2]

#### 3. Use descriptive activity names to name the activities in the data set

Before the final data set is built, I rename the variables in the
X\_test\_train by using the row values in the V2 column of
sub\_features. These are basically the names of the measurements(mean
and std) that we are considering for this analysis.

I also rename some variables to make more meaningful names like given
below. For example, V1 column of activity\_labels is named activityId
and V2 column is named activityName. These columns are further used to
column bind rows into the final data set.

    names(X_test_train) <- sub_features$V2

    # Rename columns Y_test_train to meaningful/descriptive names
    Y_test_train <- rename(Y_test_train, activity = V1)

    # Rename subject_test column to give descriptive name
    subject_test_train <- rename(subject_test_train, subjectId = V1)
    activity_labels <- rename(activity_labels, activityId = V1, activityName = V2)

I also use the merge() function to join the activity column of
Y\_test\_train and the activityID column of activity\_labels so that I
can get the activityName column in the Y\_test\_train data set.

    # Merge activity labels into Y_test_train
    Y_test_train <- merge(Y_test_train, activity_labels, by.x = "activity", by.y = "activityId", all = TRUE)

#### 4. Combine all the dataset to arrive at the final data set.

Now that the columns/variables have been renamed, I arrive at the final
data set by just combining the columns of the individual data sets using
the cbind() function. I also use the select() function to remove the
activity variable(containing ids or numbers) from the final data set
"final\_data" so that we do not have both activity names and the ids
corresponding to them in the same data set(they represent the same data,
so two columns are not required)

    # Combine all the data by column binding the obtained data tables
    final_data <- cbind(subject_test_train, Y_test_train, X_test_train)
    final_data <- select(final_data, -activity)

#### 5. Appropriately label the data set with descriptive variable names.

For showing descriptive names in the final data set, I use a series of
gsub commands which do the following.

1.  't' at the start of a variable is change to 'Time'
2.  'f' at the start of a variable is change to 'Frequency'
3.  '-', '(' and ')' symbols are removed from the variable names
4.  'mean' is changed to 'Mean'
5.  'std' is changed to 'Standard'
6.  'Acc' is changed to 'Accelerometer'
7.  'Gyro' is changed to 'Gyroscope'
8.  'Mag' is changed to 'Magnitude'
9.  BodyBody' is changed to 'Body'

Example renaming is as below:

    names(final_data)<-gsub("-", "", names(final_data))
    names(final_data)<-gsub("\\(", "", names(final_data))
    names(final_data)<-gsub(")", "", names(final_data))
    names(final_data)<-gsub("mean", "Mean", names(final_data))

I also change the X, Y and Z at the end of the variable names to
'InXaxis', 'InYaxis' and 'InZaxis' to make it more meaningful.

    names(final_data)<-gsub("X$", "InXaxis", names(final_data))

#### 6. Write the data set final\_data to file

I use the following commands to write the final\_data data set to file

    setwd("./")
    write.table(final_data, file = "First_Tidy_Dataset_Unsummarized.txt", row.names = FALSE)

#### 7. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

Now, I use the group\_by and summarize\_each functions to group the data
set final\_data on the basis of activity and subjects and then find the
average of the measurements.

    final_data_summary <- (final_data %>% 
                             group_by(activityName, subjectId) %>% 
                             summarise_each(funs(mean))
                          )

At the end, write the final summarized data set to file

    # Write the second data set to file
    setwd("./")
    write.table(final_data_summary, file = "Second_Independent_Summarized_Dataset.txt", row.names = FALSE)
