
# string variables for file download
fileName<-"UCIdata.zip"
url<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir<-"UCI HAR Dataset"

download.file(url,fileName, mode = "wb") 
unzip("UCIdata.zip", files = NULL, exdir=".")

subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")  

data_set<-rbind(X_train,X_test)
MeanStd<-grep("mean()|std()",  features[, 2]) 
data_set<-data_set[,MeanStd]
CleanFeatureNames<-sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(data_set)<-CleanFeatureNames[MeanStd]

subject<-rbind(subject_train, subject_test)
names(subject)<-'subject'
activity<-rbind(y_train, y_test)
names(activity)<-'activity'

data_set<-cbind(subject,activity, data_set)

act_group<-factor(data_set$activity)
levels(act_group)<-activity_labels[,2]
data_set$activity<-act_group
# Creating a second, independent tidy data set 
install.packages("reshape2")
library("reshape2")

baseData<-melt(data_set,(id.vars=c("subject","activity")))
Data_set2<-dcast(baseData, subject + activity ~ variable, mean)
names(Data_set2)[-c(1:2)]<-paste("[mean of]" , names(Data_set2)[-c(1:2)] )
write.table(Data_set2, "tidydata.txt", sep = ",")

