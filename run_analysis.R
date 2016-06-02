## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------
library(reshape2)
library(plyr)
library(knitr)
library(data.table)

## ------------------------------------------------------------------------
path <- getwd()
dataDir <- file.path(path,"UCI_HAR_Dataset")


## ------------------------------------------------------------------------
activity_label <- read.table(file.path(dataDir,"activity_labels.txt", sep = ""))
features <- read.table(file.path(dataDir, "features.txt", sep = ""), header = FALSE)

trainDir <- file.path(dataDir, "train/", sep = "")
x_train <- read.table(file.path(trainDir, "X_train.txt", sep = ""),header= FALSE)
y_train <- read.table(file.path(trainDir, "Y_train.txt", sep = ""), header= FALSE)
subject_train <-  read.table(file.path(trainDir, "subject_train.txt", sep = ""),header= FALSE)

testDir <- file.path(dataDir, "test/", sep = "")
x_test <- read.table(file.path(testDir, "X_test.txt", sep = ""),header= FALSE)
y_test <- read.table(file.path(testDir, "Y_test.txt", sep = ""),header= FALSE)
subject_test <-  read.table(file.path(testDir, "subject_test.txt", sep = ""),header= FALSE)


## ------------------------------------------------------------------------
featuresMeanStdIndex <-grep("mean|std",features$V2)

## ------------------------------------------------------------------------
activity_label <- activity_label$V2
activity_label <- tolower(activity_label)
activity_label <- sub("_", " ", activity_label)

names(x_train) <- features$V2 
x_train<- x_train[featuresMeanStdIndex]
names(y_train) <- "activity"

names(subject_train)<- "subject"

#Combine training data
train <- cbind(subject_train,y_train,x_train)

names(x_test) <- features$V2 
x_test <- x_test[featuresMeanStdIndex]
names(y_test) <- "activity"

names(subject_test)<- "subject"

#Combine testing data
test <- cbind(subject_test,y_test,x_test)

#Combine testing and  training data
data<-rbind(test,train)


## ------------------------------------------------------------------------

data$activity <- mapvalues(data$activity, from= levels(factor(data$activity)),to = activity_label) 


## ------------------------------------------------------------------------

dataMean <- aggregate(data, list(data$subject, data$activity), mean)


## ------------------------------------------------------------------------
dataMean$subject <- NULL; dataMean$activity <- NULL
names(dataMean)[1] <- "subject"; names(dataMean)[2] <- "activity"

## ------------------------------------------------------------------------

write.table(dataMean,"ActivityDataset.txt",row.names = FALSE)

## ------------------------------------------------------------------------
#purl("CodeBook.md",output="run_analysis.R",documentation = 1)

