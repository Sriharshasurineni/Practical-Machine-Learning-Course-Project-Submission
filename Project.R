#Practical Machine Learning



library(Hmisc)
library(caret)
library(randomForest)
library(foreach)
set.seed(2048)
options(warn=-1)

training_data <- read.csv("pml-training.csv", na.strings=c("#DIV/0!") )
evaluation_data <- read.csv("pml-testing.csv", na.strings=c("#DIV/0!") )


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

We now build 5 random forests with 150 trees each. We make use of parallel processing to build this
model. I found several examples of how to perform parallel processing with random forests in R, this
provided a great speedup.



x <- training[-ncol(training)]
y <- training$classe

rf <- foreach(ntree=rep(250, 4), .combine=randomForest::combine, .packages='randomForest') %dopar% {
randomForest(x, y, ntree=ntree) 

#Confusion Matrix for Training
predictions1 <- predict(rf, newdata=training)
confusionMatrix(predictions1,training$classe)

#Confusion Matrix for testing 
predictions2 <- predict(rf, newdata=testing)
confusionMatrix(predictions2,testing$classe)



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
