# All data intensive commands are nested in system.time to monitor time taken by command. Though, it was not asked in the assignment.
#Set Working Directory
setwd("C:/Users/Caris/Documents/DataScience/gettingAndCleaningData/project/UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set.
system.time(tab_test_x <- read.table("test/X_test.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_train_x <- read.table("train/X_train.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_x <- rbind(tab_test_x,tab_train_x))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
tab_x_mean_sd <- cbind(mean=apply(tab_x,1,mean),sd=apply(tab_x,1,sd))

# 3. Uses descriptive activity names to name the activities in the data set
system.time(tab_test_y <- read.table("test/Y_test.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_train_y <- read.table("train/Y_train.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_y <- rbind(tab_test_y,tab_train_y))
tab_x_y <- cbind(tab_x_mean_sd ,activity_code=tab_y)

#4. Appropriately labels the data set with descriptive variable names. 
tab_x_y$V1 <- factor(tab_x_y$V1, levels=c(1:6), labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
system.time(tab_test_subject <- read.table("test/subject_test.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_train_subject <- read.table("train/subject_train.txt", header = FALSE, colClasses = "numeric"))
system.time(tab_subject <- rbind(tab_test_subject,tab_train_subject))
tab_final<- cbind(tab_x_y ,subject=tab_subject)

colnames(tab_final) <- c("mean","sd","activity_name","subject")

aggdata <-aggregate(tab_final,by=list(tab_final$subject,tab_final$activity),FUN=mean)[,1:4];
colnames(aggdata) <- c("subject","activity","mean of means","mean of sd")

#output tidy data to file
write.table(aggdata , file = "tidy_data.txt", append = FALSE, quote = TRUE, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

