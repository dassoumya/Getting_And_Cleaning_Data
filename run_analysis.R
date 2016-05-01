setwd("/Users/soumyadas/Downloads/UCI HAR Dataset/")

# Load the dplyr library so that select, filter and rename functions can be used from the package
library(dplyr)

# Read the activity labels and features data sets that are common to both train and test data
activity_labels <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/activity_labels.txt")
features <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/features.txt")

# Read test data
X_test <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/test/subject_test.txt")

# Read training data
X_train <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("/Users/soumyadas/Downloads/UCI HAR Dataset/train/subject_train.txt")

# Merge the data by row 
X_test_train <- rbind(X_test,X_train)
Y_test_train <- rbind(Y_test,Y_train)
subject_test_train <- rbind(subject_test, subject_train)

# Extract only the measurements on the mean and standard deviation for each measurement.
sub_features <- filter(features, grepl("mean|std",V2), !grepl("meanFreq",V2))

# Use only the previously obtained subset of variables/measurements in the final subset
X_test_train <- X_test_train[,sub_features$V2]

# Rename columns X_test_train to meaningful names
names(X_test_train) <- sub_features$V2

# Rename columns Y_test_train to meaningful/descriptive names
Y_test_train <- rename(Y_test_train, activity = V1)

# Rename subject_test column to give descriptive name
subject_test_train <- rename(subject_test_train, subjectId = V1)
activity_labels <- rename(activity_labels, activityId = V1, activityName = V2)

# Merge activity labels into Y_test_train
Y_test_train <- merge(Y_test_train, activity_labels, by.x = "activity", by.y = "activityId", all = TRUE)

# Combine all the data by column binding the obtained data tables
final_data <- cbind(subject_test_train, Y_test_train, X_test_train)
final_data <- select(final_data, -activity)

# Providing descriptive names of measurement variables
names(final_data)<-gsub("^t", "Time", names(final_data))
names(final_data)<-gsub("^f", "Frequency", names(final_data))
names(final_data)<-gsub("-", "", names(final_data))
names(final_data)<-gsub("\\(", "", names(final_data))
names(final_data)<-gsub(")", "", names(final_data))
names(final_data)<-gsub("mean", "Mean", names(final_data))
names(final_data)<-gsub("std", "Standard", names(final_data))
names(final_data)<-gsub("Acc", "Accelerometer", names(final_data))
names(final_data)<-gsub("Gyro", "Gyroscope", names(final_data))
names(final_data)<-gsub("Mag", "Magnitude", names(final_data))
names(final_data)<-gsub("BodyBody", "Body", names(final_data))
names(final_data)<-gsub("X$", "InXaxis", names(final_data))
names(final_data)<-gsub("Y$", "InYaxis", names(final_data))
names(final_data)<-gsub("Z$", "InZaxis", names(final_data))

# Write the first data set to file
setwd("/Users/soumyadas/Downloads/UCI HAR Dataset/")
write.table(final_data, file = "First_Tidy_Dataset_Unsummarized.txt", row.names = FALSE)

# Code for Requirement 5 
# Create a second independent dataset idy data set with the average of each variable for each activity and each subject
final_data_summary <- (final_data %>% 
                         group_by(activityName, subjectId) %>% 
                         summarise_each(funs(mean))
                      )

# Write the second data set to file
setwd("/Users/soumyadas/Downloads/UCI HAR Dataset/")
write.table(final_data_summary, file = "Second_Independent_Summarized_Dataset.txt", row.names = FALSE)



