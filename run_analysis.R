
#### Setup


#Set the desired working directory here with setwd()

link <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("UCI HAR Dataset.zip")){
  download.file(link, destfile = "UCI HAR Dataset.zip", method = "auto")
}

library(data.table)
library(dplyr)

################ Feature names (for both test and training sets)

featCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/features.txt")
open(featCon)
feat <- read.table(featCon)
close(featCon)

names(feat) <- c("featNum","featName")


################ Building the Test set

## Features

testXCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/X_test.txt")
open(testXCon)
testFeat <- read.table(testXCon, colClasses = "numeric")
close(testXCon)


## Activity labels

testYCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/y_test.txt")
open(testYCon)
testActv <- read.table(testYCon)
close(testYCon)

names(testActv) <- "ActvID"


## Subjects

testSubjCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/test/subject_test.txt")

open(testSubjCon)
testSubj <- read.table(testSubjCon)
close(testSubjCon)

names(testSubj) <- "SubjID"


## Building the test data set

names(testFeat) <- paste(feat$featNum,feat$featName)
#names for bandsEnergy() variables are repeated, mutate() has troubles with that

test <- testFeat %>% 
  mutate(actvID = testActv$ActvID, subjID = testSubj$SubjID) 



################ Building the Training set

## Features

trainXCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/X_train.txt")
open(trainXCon)
trainFeat <- read.table(trainXCon, colClasses = "numeric")
close(trainXCon)


## Activity labels

trainYCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/y_train.txt")
open(trainYCon)
trainActv <- read.table(trainYCon)
close(trainYCon)

names(trainActv) <- "ActvID"


## Subjects

trainSubjCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/train/subject_train.txt")
open(trainSubjCon)
trainSubj <- read.table(trainSubjCon)
close(trainSubjCon)

names(trainSubj) <- "SubjID"


## Building the training data set

names(trainFeat) <- paste(feat$featNum,feat$featName)
#names for bandsEnergy() variables are repeated, mutate() has troubles with that

train <- trainFeat %>% 
  mutate(actvID = trainActv$ActvID, subjID = trainSubj$SubjID) 


################ Merging the data sets

#the subjects are different for each set, so it's a rows-wise merge

dataLarge <- merge(test, train, all = TRUE)


################ Extracting mean and standard deviation variables

meanStd <- grep("mean\\(\\)|std\\(\\)",names(dataLarge)) #get only the mean and std variables
data <- dataLarge[,c(563, 562 ,meanStd)]


################ Naming activities

actvCon <- unz("UCI HAR Dataset.zip","UCI HAR Dataset/activity_labels.txt")
open(actvCon)
actv <- read.table(actvCon)
close(actvCon)

names(actv) <- c("actvID","actvName")

namedActv <- merge(data["actvID"], actv, by="actvID")
#I chose the form data["actvID"] because it had to be a data.frame to work properly

data <- mutate(data, actvID = namedActv$actvName)


################ Renaming variables properly

names(data)

#eliminating the starting number
changedNames <- strsplit(names(data)," ")
changedNames <- sapply(changedNames
                       ,function(x){
                         if(length(x) > 1) x[2]
                         else x[1]
                       })

changedNames <- sub("tBodyAcc","BodyAcceleration-ThroughTime", changedNames)
changedNames <- sub("tGravityAcc","GravityAcceleration-ThroughTime", changedNames)
changedNames <- sub("tBodyGyro","BodyAngularVelocity-ThroughTime", changedNames)

changedNames <- sub("fBodyAcc|fBodyBodyAcc","BodyAcceleration-Frequency", changedNames)
changedNames <- sub("fGravityAcc","GravityAcceleration-Frequency", changedNames)
changedNames <- sub("fBodyGyro|fBodyBodyGyro","BodyAngularVelocity-Frequency", changedNames)

changedNames <- sub("Jerk","-JerkSignal", changedNames)
changedNames <- sub("Mag","-Magnitude", changedNames)

changedNames <- sub("mean\\(\\)","Mean", changedNames)
changedNames <- sub("std\\(\\)","StandardDeviation", changedNames)
changedNames <- sub("-X$","-X-axis", changedNames)
changedNames <- sub("-Y$","-Y-axis", changedNames)
changedNames <- sub("-Z$","-Z-axis", changedNames)

changedNames <- sub("subjID","SubjectID",changedNames)
changedNames <- sub("actvID","ActivityName",changedNames)

names(data) <- changedNames


################ Summary data set

summaryData <- data %>% group_by(SubjectID, ActivityName) %>%
  summarize_each(funs(mean))


################ Writing the final files

write.table(data,"FinalDataSet.txt",row.names = FALSE)
write.table(summaryData,"Summaries.txt",row.names = FALSE)
