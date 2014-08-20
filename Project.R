#Practical Machine Learning


library(Hmisc)
library(caret)
library(randomForest)
library(foreach)
library(doParallel)
set.seed(998)

training.file   <- 'pml-training.csv'
test.cases.file <- 'pml-test.csv'
training.url    <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
test.cases.url  <- 'http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'

download.file(training.url, training.file)
download.file(test.cases.url,test.cases.file )

training.df   <-read.csv(training.file, na.strings=c("NA","#DIV/0!", ""))
test.cases.df <-read.csv(test.cases.file , na.strings=c("NA", "#DIV/0!", ""))

training.df<-training.df[,colSums(is.na(training.df)) == 0]
test.cases.df <-test.cases.df[,colSums(is.na(test.cases.df)) == 0]

# Remove those Features unrelated to calulations (Confusion Matrix)
# X user_name raw_timestamp_part_1 raw_timestamp_part_2   cvtd_timestamp new_window num_window 
 training.df   <-training.df[,-c(1:7)]
 test.cases.df <-test.cases.df[,-c(1:7)]

#Create a stratified random sample of the data into training and test setsseed(998)
inTraining.matrix    <- createDataPartition(training.df$classe, p = 0.75, list = FALSE)
training.data.df <- training.df[inTraining.matrix, ]
testing.data.df  <- training.df[-inTraining.matrix, ]

modFit<-train(classe~.,data=training.data.df,method="rf",prox=TRUE)
modFit
pred <-predict(modFit,test.cases.df); test.cases.df$predRight <-pred==test.cases.df$classe
table(pred,test.cases.df$classe)

Random Forest 

14718 samples
   52 predictors
    5 classes: 'A', 'B', 'C', 'D', 'E' 

No pre-processing
Resampling: Bootstrapped (25 reps) 

Summary of sample sizes: 14718, 14718, 14718, 14718, 14718, 14718, ... 

Resampling results across tuning parameters:

  mtry  Accuracy  Kappa  Accuracy SD  Kappa SD
  2     0.989     0.987  0.00169      0.00213 
  27    0.99      0.987  0.0015       0.00189 
  52    0.982     0.977  0.00385      0.00486 

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 27. 

pred <-predict(modFit,test.cases.df); test.cases.df$predRight <-pred==test.cases.df$classe table(pred,test.cases.df$classe)




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
