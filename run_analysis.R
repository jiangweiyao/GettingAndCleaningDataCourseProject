library(dplyr)


##download data if appropriate
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="Dataset.zip")
unzip("Dataset.zip")

##Combine test_x and train_train using rbind.
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
all_x <- rbind(train_x, test_x)

##Label columne names of data set from features file. Remove invalid characters that can't be used as column name.
column_labels <- read.table("./UCI HAR Dataset/features.txt", sep = "", header = FALSE)
column_labels$V2 <- gsub("mean()", "Mean", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub("meanFreq()", "MeanFreq", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub("std()", "Std", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub("-", "", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub(",", "", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub("(", "", column_labels$V2, fixed=TRUE)
column_labels$V2 <- gsub(")", "", column_labels$V2, fixed=TRUE)
colnames(all_x) <- column_labels$V2

##Pick out columns with Mean, MeanFreq, and Std from mean(), meanFreq(), and std() columns.
##Do not include angle variables
all_x <- all_x[, (grepl("Mean", colnames(all_x)) | grepl("Std", colnames(all_x)))]
all_x <- all_x[, (!grepl("angle", colnames(all_x))) ]
colnames(all_x)

##Load subject data. Label as SubjectID
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = " ", header = FALSE)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = " ", header = FALSE)
all_subject <- rbind(train_subject, test_subject)
colnames(all_subject) <- "SubjectID"

##Load activity data. Label as ActivityID
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = " ", header = FALSE)
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = " ", header = FALSE)
all_y <- rbind(train_y, test_y)
colnames(all_y) <- "ActivityID"

##Load activity label. Left join y with activity labels so y is labeled with the name of the activity now.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
colnames(activity_labels) <- c("ActivityID", "Activity")
activity_final <- left_join(all_y, activity_labels, by = "ActivityID")
mean(activity_final$ActivityID == all_y$ActivityID)

##cbind to combine the subject, activity and selected x data
all <- cbind(all_subject, activity_final$Activity, all_x)
colnames(all)[2] <- "ActivityID"
###


test_aggregate <- aggregate(.~ActivityID+SubjectID, all, mean)
##write.csv(test_aggregate, file = "tidy.csv", row.names = FALSE)
write.table(test_aggregate, file = "tidy.txt", row.names = FALSE)