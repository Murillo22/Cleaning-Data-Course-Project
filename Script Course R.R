#This script allows to download a file with data, organize their information and show in a tidy model.

#Download the file

#We include the link of the file in the object "fileURL"

fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Here, lets downloas the file using a curl method.

download.file(fileURL,"Data.zip","curl")

#Lets unzip the file in the directory TestR_Data
unzip(zipfile="Data.zip",exdir="./TestR_Data")

#Set the directory where the file was unzip.
setwd("./TestR_Data/")

#Read files from the directory
#Read initial files for X test and train
read.table("./UCI HAR Dataset/test/X_test.txt")->Xtest
read.table("./UCI HAR Dataset/train/X_train.txt")->Xtrain
X<-rbind(Xtest,Xtrain)

#Read initial files for features to set names of columns
read.table("./UCI HAR Dataset/features.txt",sep="")->features
features[,2]->features
colnames(X)<-features

#Read initial files for Y test and train
read.table("./UCI HAR Dataset/test/y_test.txt")->Ytest
read.table("./UCI HAR Dataset/train/y_train.txt")->Ytrain
Y<-rbind(Ytest,Ytrain)

#Label activities in Y
read.table("./UCI HAR Dataset/activity_labels.txt",sep="")->Labels
merge(Y,Labels)->Y
data.frame(Y[,2])->Y
colnames(Y)<-"Activity"

#Read files for subjects
read.table("./UCI HAR Dataset/test/subject_test.txt")->Subtest
read.table("./UCI HAR Dataset/train/subject_train.txt")->Subtrain
Sub<-rbind(Subtest,Subtrain)
colnames(Sub)<-"SubjectID"

#Bind data with subjects and activities
cbind(Sub,Y,X)->dataset
#Select labels with "std" and "mean" at the name
grep("std",features)->std
grep("mean",features)->mean
c(mean,std)->val
sort(val)->val
val+2->val
c(1:2,val)->val
dataset[,val]->dataset

#organize the data and aggregate information as it was required.
unite(dataset,nome,c(1,2),sep="_",remove=TRUE)->dataset
aggregate(dataset[,c(2:80)],list(dataset$nome),mean)->dataset
separate(dataset,Group.1,into=c("SubjectID","Activity"),sep="_")->dataset
#Write the result file.
write.table(dataset,file="./UCI HAR Dataset/result.txt",row.names=FALSE)



