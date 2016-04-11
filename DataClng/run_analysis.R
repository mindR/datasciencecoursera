library(dplyr)

#1 Getting the data

if(!file.exists("./data")){dir.create("./data")}
#1a downloading data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./data/activitydata.zip")

#1b extracting data
if(!file.exists("./data/unzipdata")){dir.create("./data/unzipdata")}
unzip("./data/activitydata.zip",exdir = "./data/unzipdata")


path <- "./data/unzipdata/UCI HAR Dataset"


#2 reading the data into R

#2a reading the activity labels

activity_labels <- read.csv(paste0(path,"/activity_labels.txt"), header = F, sep = "",na.strings = "",stringsAsFactors = F)
colnames(activity_labels) <- c("activity_label", "activity_name")

#2b reading the feature.txt to get the list of all the variables
#each window sample is a vector of values corresponding to these variables

features <- read.csv(paste0(path,"/features.txt"),header = F,sep = "",na.strings = "",stringsAsFactors = F)

colnames(features) <- c("var_id","var_name")

#since only mean and standard deviation data is to be read
#creating a logical vector which is true for wanted values only

features_wanted <- grepl("*-mean*|*-std*",features$var_name, ignore.case = TRUE)


#2c reading subject data
#each row identifies the subject who performed the activity for each window sample
#window sample data is in X_test and X_train tables

subject_train <- read.csv(paste0(path,"/train/subject_train.txt"),header = FALSE)
subject_test <- read.csv(paste0(path,"/test/subject_test.txt"),header = FALSE)

colnames(subject_test) <- "subject_label"
colnames(subject_train) <- "subject_label"

#adding an ID column to maintain the indexing of the data

subject_train$id <- seq.int(nrow(subject_train))
subject_test$id <- seq.int(nrow(subject_test))

#2d reading y_train and y_test tables

y_train <- read.csv(paste0(path,"/train/y_train.txt"),header = FALSE)
y_test <- read.csv(paste0(path,"/test/y_test.txt"),header = FALSE)

colnames(y_test) <- "activity_label"
colnames(y_train) <- "activity_label"

#adding an ID column to maintain the indexing of the data

y_train$id <- seq.int(nrow(y_train))
y_test$id <- seq.int(nrow(y_test))

#merging the y_test and y_train tables with activity_lables to get activity names

y_test <- merge(y_test,activity_labels)
y_train <- merge(y_train,activity_labels)

y_test <- arrange(y_test,id)
y_train <- arrange(y_train,id)


#2e reading X_train and X_test table
#reading only the relevant columns using features_wanted table

X_train <- read.csv(paste0(path,"/train/X_train.txt"),header = FALSE,sep = "", na.strings = "",stringsAsFactors = F, col.names = features$var_name)[,features_wanted]
X_test <- read.csv(paste0(path,"/test/X_test.txt"),header = FALSE,sep = "", na.strings = "",stringsAsFactors = F, col.names = features$var_name)[,features_wanted]


#3 Modifying the data

#adding the activity name and the subject label on the respective window sample

X_test <- cbind(activity_name=y_test$activity_name,X_test)
X_test <- cbind(subject_label=subject_test$subject_label,X_test)


X_train <- cbind(activity_name=y_train$activity_name,X_train)
X_train <- cbind(subject_label=subject_train$subject_label,X_train)


#merging the data set to create one data merged data set
#this data set contains only mean and standard deviation variables
#this data set contains the activity names
#this data set contains the descriptive variable names

X_merge <- rbind(X_test,X_train)


#creating a tidy summary - mean of all variables for each activity of each subject

Tidy_summary <- X_merge %>% group_by(subject_label, activity_name) %>% summarise_each(funs(mean))


write.table(Tidy_summary, file = "Tidy_summary.txt",row.names=FALSE)


