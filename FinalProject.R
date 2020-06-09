library(dplyr)

#下载zip
filename <- "DS3_Final.zip"
if(!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method ="curl")
}

#解压
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

#合并数据框 Merges the training and the test sets to create one data set.
##读取导入各个txt
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt", col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

##合并行
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
data_merge <- cbind(subject, y, x)
#整理数据框 Extracts only the measurements on the mean and standard deviation for each measurement.
data_tidy <- data_merge %>% select(subject, code, contains("mean"), contains("std"))
##赋值变量 Uses descriptive activity names to name the activities in the data set
data_tidy$code <- activities[data_tidy$code, 2]
##精确变量名 Appropriately labels the data set with descriptive variable names.
names(data_tidy)[2] = "activity"
names(data_tidy) <- gsub("Accelerometerelerometerelerometer", "Accelerometer", names(data_tidy))
names(data_tidy) <- gsub("Gyroscopescopescope", "Gyroscope", names(data_tidy))
names(data_tidy) <- gsub("BodyBody", "Body", names(data_tidy))
names(data_tidy) <- gsub("Magnitudenitudenitude", "Magnitude", names(data_tidy))
names(data_tidy) <- gsub("^t", "Time", names(data_tidy))
names(data_tidy) <- gsub("^f", "Frequency", names(data_tidy))
names(data_tidy) <- gsub("tBody", "TimeBody", names(data_tidy))
names(data_tidy) <- gsub("-mean()", "Mean", names(data_tidy), ignore.case = T)
names(data_tidy) <- gsub("-std()", "STD", names(data_tidy), ignore.case = T)
names(data_tidy) <- gsub("-freq()", "Frequency", names(data_tidy), ignore.case = T)
names(data_tidy) <- gsub("angle", "Angle", names(data_tidy))
names(data_tidy) <- gsub("gravity", "Accelerometer", names(data_tidy))
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_final <- data_tidy %>% 
    group_by(subject, activity) %>% 
    summarise_all(funs(mean))
write.table(data_final, "FinalData.txt", row.names = F)

str(data_final)
data_final


