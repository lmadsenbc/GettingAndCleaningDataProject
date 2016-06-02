---
title: "CodeBook"
author: "lmadsenbc"
date: "May 28, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Project Details

>Instructions
>
>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
>Review criterialess 
>The submitted data set is tidy.
>The Github repo contains the required scripts.
>GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
>The README that explains the analysis files is clear and understandable.
>The work submitted for this project is the work of the student who submitted it.
>Getting and Cleaning Data Course Projectless 
>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
>
>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
>
>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
>
>Here are the data for the project:
>
>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
>
>You should create one R script called run_analysis.R that does the following.
>
>Merges the training and the test sets to create one data set.
>Extracts only the measurements on the mean and standard deviation for each measurement.
>Uses descriptive activity names to name the activities in the data set
>Appropriately labels the data set with descriptive variable names.
>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
>Good luck!

## Output of Project (Files)

1. **run_analysis.R** : Contains the R code used to;
+ merge the training and test sets
+ extract only the measurements on the mean and standard deviation for each measurement.
+ add desciptive names to the data set
+ add labels to the data set
+ create a second, tidy data set call **HumanActivityDataset.txt**
2. **HumanActivityDataset.csv** : The tidy data set created by the *run_analysis.R* R script
3. **CodeBook.md** : This File.  Describes the steps taken in this project, as well as the variables and files used.
4. **README.md** : Describes how the scripts work. 

##File Desciptions
Specific details of the dataset can be found in the *README.txt* and *features_info.txt* files in the original data collection.
Broadly speaking, the data set represents data from 30 number participants, gathered from the onboard sensors (gyro, accel, etc) of smartphones, while the subjects performed various labelled activities. 


## Steps to Reproduce Project

1. Download and unzip project data from *https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip* .  This was done manually using chrome and 7zip, simply to avoid repeatedly preforming this step in the script. Data was extracted into *UCI_HAR_Dataset* directory off the working directory
2. Run *run_analysis.R* script

## Desciption of run_analysis.R and explination

Import needed libraries
```{r}
library(reshape2)
library(plyr)
library(knitr)
library(data.table)
```
Set directory paths
```{r}
path <- getwd()
dataDir <- file.path(path,"UCI_HAR_Dataset")

```
import subject, activity and data files
```{r}
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

```
Extract mean and std values
````{r}
featuresMeanStdIndex <-grep("mean|std",features$V2)
````

Rename columns and combine data
```{r}
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

```
Relabel Activities
```{r}

data$activity <- mapvalues(data$activity, from= levels(factor(data$activity)),to = activity_label) 

```
Calculate means (using plyr)
```{r}

dataMean <- aggregate(data, list(data$subject, data$activity), mean)
```

Clean up columns
```{r}
dataMean$subject <- NULL; dataMean$activity <- NULL
names(dataMean)[1] <- "subject"; names(dataMean)[2] <- "activity"
```


Output tidy data set as required by the project description
```{r}

write.table(dataMean,"ActivityDataset.txt",row.names = FALSE)
```
Output above annotated script as *run_analysis.R*
```{r}
purl("CodeBook.md",output="run_analysis.R",documentation = 1)
```

