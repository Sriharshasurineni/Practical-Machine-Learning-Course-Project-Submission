#Practical Machine Learning


library(Hmisc)
library(caret)
library(randomForest)
library(foreach)
set.seed(998)

training.file       <- 'pml-training.csv'
test.cases.file     <- 'pml-test.csv'
training.url        <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
test.cases.url      <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'

download.file(training.url, training.file)
download.file(test.cases.url,test.cases.file )
training.df<-read.csv(training.file, na.strings=c("NA","#DIV/0!", ""))
test.cases.df<-read.csv(test.cases.file , na.strings=c("NA", "#DIV/0!", ""))

# X user_name raw_timestamp_part_1 raw_timestamp_part_2   cvtd_timestamp new_window num_window 



inTraining <- createDataPartition(Sonar$Class, p = 0.75, list = FALSE)
training <- Sonar[inTraining, ]
testing <- Sonar[-inTraining, ]


for(i in c(8:ncol(training_data)-1)) {training_data[,i] = as.numeric(as.character(training_data[,i]))}

for(i in c(8:ncol(evaluation_data)-1)) {evaluation_data[,i] = as.numeric(as.character(evaluation_data[,i]))}

#Determine and display out feature set.

feature_set <- colnames(training_data[colSums(is.na(training_data)) == 0])[-(1:7)]
model_data <- training_data[feature_set]
feature_set

#build Featue Set Pattition

index <- createDataPartition(y=model_data$classe, p=0.75, list=FALSE )
training <- model_data[index,]
testing <- model_data[-index,]

registerDoParallel()
x <- training[-ncol(training)]
y <- training$classe

rf <- foreach(ntree=rep(250, 4), .combine=randomForest::combine, .packages='randomForest') %dopar% {
randomForest(x, y, ntree=ntree) 
}

#Confusion Matrix for Training
predictionsTraining <- predict(rf, newdata=training)
confusionMatrix(predictionsTraining,training$classe)

#Confusion Matrix for testing 
predictionsTesting <- predict(rf, newdata=testing)
confusionMatrix(predictionsTesting,testing$classe)


#Coursera provided code for submission

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}


x <- evaluation_data
x <- x[feature_set[feature_set!='classe']]
answers <- predict(rf, newdata=x)

answers

pml_write_files(answers)
