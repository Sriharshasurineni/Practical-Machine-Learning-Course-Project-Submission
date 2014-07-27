# Goal

Analyze data to determine predict correctl and incorrect execution of  forearm, arm, and dumbell barbell barbell lifts.

## Data
data from accelerometers on the belt of 6 individuals executing  forearm, arm, and dumbell barbell barbell lifts
correctly and incorrectly in 5 different ways. 

The training data for this project are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv
 
More information is available from the website here: http://groupware.les.inf.puc-rio.br/har 
(see the section on the Weight Lifting Exercise Dataset).


## Modeling

The Random Forest Model using the defacto starting point of 5 random forests with 100 trees each

A random seed of 1024 was selected to insure reproduceability. 

## Data sanitization

1.  Remove excel division error strings, artifacts of excel data  `#DIV/0!` were replace with `NA` values.
1.  Empty strings were also converted to `NA` values.


## Feature Selection
Down selected features based relevance and completness:
* `Columns that were mostly NA`
* `the unlabled row index`
* `user_name`
* `raw_timestamp_part_1`
* `raw_timestamp_part_2`
* `cvtd_timestamp`
* `new_window`
* `num_window`

## Cross Validation

Cross validation was achieved by splitting the training data into a test set and a training set using the following:

Both Training and Testing data were provided (see Data).  A difference of approximatly < 0.05 was anticipated between the 
training and testing data. Actual results were less than 0.01.

The data was partioned by the `classe` variable to ensure the training set and test set contain examples of each class. 60% of the training data was allocated to the training set and the remainder for the validation set.

## Prediction
The confusion matrix (see R code) for this model is highly accurate at around 99%. 
Furthermore, all answers (20) were correct.

## Conclusion

The random forest models is a sufficient model, based on the data sets and answers to questions for 
accelerometers measurements.
