## set the working directory
setwd("C:/Users/Antonis/Dropbox/Public/coursera/Data Science Specialization/Getting and Cleaning Data/w4")
## load dplyr package
library(dplyr)

## read all .txt files from the dataset
file_list <- list.files(pattern = "[.]txt", recursive = TRUE)

## create dataframes for all files and change the name of each dataframe
for (i in file_list) {
  j <- gsub(".*/", "", i)
  j <- gsub(".txt", "", j)
  assign(j, read.csv(i, header=FALSE, sep=""))
  
}

## bind test and train datasets
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

## map activity labels to their description
activities <- merge(activity_labels, y, by="V1")
df <- cbind(subject, activities$V2, X)
colnames(df) <- c("Subject", "Activity", as.character(features$V2))

## identify mean and standard deviation variables
mean <- grep('mean()', colnames(df), fixed=TRUE)
std <- grep('std()', colnames(df), fixed = TRUE)

## create final dataset
columns <- c(1, 2, mean, std)
df <- df[,columns]

df <- tbl_df(df)

## create summary dataset
summary <- df %>% 
          group_by(Subject, Activity) %>%
          summarize_all(funs(mean))

write.csv(summary, "./tidy_dataset.csv")