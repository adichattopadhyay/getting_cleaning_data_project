# run_analysis.R

# setwd("~/devel/coursera/getting_cleaning_data/getting_cleaning_data_project")

# download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
#               destfile = "getdata-projectfiles-UCI HAR Dataset.zip", 
#               method = "curl")

# unzip(zipfile = "getdata-projectfiles-UCI HAR Dataset.zip")

DATADIR <- "UCI HAR Dataset"

# Combine Test Data
activities   <- read.table(file= paste(DATADIR, "activity_labels.txt", sep = "/"), 
                         col.names = c("Activity.ID", "Activity.Name"))
y_test       <- read.table(paste(DATADIR, "test", "y_test.txt",        sep = "/"),
                         col.names = c("Activity.ID"))
y_activities <- merge(y_test, activities, by.x="Activity.ID", by.y="Activity.ID")
Activity     <- y_activities[,2]

features     <- read.table(paste(DATADIR, "features.txt", sep ="/"), 
                           col.names = c("Feature.Number", "Feature.Name"))
features     <- features[,2]

subject_test <- read.table(file = paste(DATADIR, "test", "subject_test.txt", sep = "/"),
                           col.names = c("Subject"))
x_test       <- read.table(file = paste(DATADIR, "test", "X_test.txt", sep = "/"),
                           col.names = features)

test_data    <- cbind(subject_test, Activity, x_test)

# Combine Training Data
y_train       <- read.table(paste(DATADIR, "train", "y_train.txt",        sep = "/"),
                            col.names = c("Activity.ID"))
y_activities  <- merge(y_train, activities, by.x="Activity.ID", by.y="Activity.ID")
Activity      <- y_activities[,2]

subject_train <- read.table(file = paste(DATADIR, "train", "subject_train.txt", sep = "/"),
                            col.names = c("Subject"))
x_train       <- read.table(file = paste(DATADIR, "train", "X_train.txt", sep = "/"),
                            col.names = features)

train_data    <- cbind(subject_train, Activity, x_train)

# Combine Test & Train data
data          <- rbind(test_data, train_data)

# Keep only the columns that are mean or standard deviation
data_mean_std <- data[,c("Subject",
                         "Activity",
                         grep("mean|std", colnames(data), value=TRUE))
                      ]
sub_act_data  <- melt(data_mean_std, id.vars=c("Subject","Activity"))
tidy_data     <- dcast(sub_act_data, Subject + Activity ~ variable, mean)