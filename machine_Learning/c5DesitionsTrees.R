
#install.packages("C50")
install.packages("rattle")
library(C50)
library(rattle)
#> #################################### Example – identifying risky bank loans using C5.0 decision trees ############################

#> The motivation for our credit model is to identify factors that are linked to a higher risk of loan default. 

#> To do this, we must obtain data on past bank loans as well as information about the loan applicants that would 
#> have been available at the time of credit application.
#> 
#> 
#> Data with these characteristics are available in a dataset donated to the UCI Machine Learning Repository (http://archive.ics.uci.edu/ml)
#> by Hans Hofmann of the University of Hamburg. The dataset contains information on loans obtained from a credit agency in Germany.


credit <- read.csv("https://raw.githubusercontent.com/PacktPublishing/Machine-Learning-with-R-Fourth-Edition/main/Chapter%2005/credit.csv")

str(credit)

table(credit$checking_balance)


table(credit$savings_balance)


#> Some of the loan’s features are numeric, such as its duration and the amount of credit requested:


summary(credit$months_loan_duration)

summary(credit$amount)

#> The loan amounts ranged from 250 DM to 18,420 DM across terms of 4 to 72 months. 
#> They had a median amount of 2,320 DM and a median duration of 18 months.

#> The default vector indicates whether the loan applicant was able to meet the agreed payment terms or if they went into default. 
#> A total of 30 percent of the loans in this dataset went into default:

table(credit$default)
factor(credit$default)

#> ################################### Data preparation – creating random training and test datasets ###############################
#> 
#> We will use 90 percent of the data for training and 10 percent for testing, which will provide us with 100 records to simulate new applicants. 
#> A 90-10 split is used here rather than the more common 75-25 split due to the relatively small size of the credit dataset; 
#> given that predicting loan defaults is a challenging learning task, we need as much training data as possible while still
#> holding out a sufficient test sample. 

#> As prior chapters used data that had been sorted in a random order, we simply divided the dataset into two portions by taking
#> the first subset of records for training and the remaining subset for testing. In contrast, the credit dataset is not randomly ordered,
#> making the prior approach unwise. Suppose that the bank had sorted the data by the loan amount, with the largest loans at the end of the file. 
#> If we used the first 90 percent for training and the remaining 10 percent for testing, we would be training a model on only the
#> small loans and testing the model on the big loans. Obviously, this could be problematic.
#> 

#> We’ll solve this problem by training the model on a random sample of the credit data. 
#> A random sample is simply a process that selects a subset of records at random. In R, the sample() function is used to perform random sampling.


set.seed(9829)
train_sample <- sample(1000, 900)

str(train_sample)

credit_train <- credit[train_sample, ]
credit_test  <- credit[-train_sample, ]


prop.table(table(credit_train$default))


prop.table(table(credit_test$default))

#>      ######################################### Step 3 – training a model on the data #################################################

#> The C5.0() function uses a new syntax known as the R formula interface to specify the model to be trained. 
#> The formula syntax uses the ~ operator (known as the tilde) to express the relationship between a target variable and its predictors. 
#> The class variable to be learned goes to the left of the tilde and the predictor features are written on the right, separated by + operators. 


#> If you would like to model the relationship between the target y and predictors x1 and x2, you would write the formula as y ~ x1 + x2. 
#> To include all variables in the model, the period character is used. For example, y ~ . specifies the relationship between y and all other 
#> features in the dataset.


#> For the first iteration of the credit approval model, we’ll use the default C5.0 settings, as shown in the following code. 
#> The target class is named default, so we put it on the left-hand side of the tilde, which is followed by a period indicating that all other 
#> columns in the credit_train data frame are to be used as predictors:


credit_model <- C5.0(default ~ ., data = credit_train)

credit_model


summary(credit_model)


plot(credit_model)



#> ############################################### Step 4 – evaluating model performance ####################################################


credit_pred <- predict(credit_model, credit_test)


#> This creates a vector of predicted class values, which we can compare to the actual class values using the CrossTable() function in 
#> the gmodels package. Setting the prop.c and prop.r parameters to FALSE removes the column and row percentages from the table. 
#> The remaining percentage (prop.t) indicates the proportion of records in the cell out of the total number of records:



library(gmodels)
CrossTable(credit_test$default, credit_pred,
             prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
             dnn = c('actual default', 'predicted default'))

#> Out of the 100 loan applications in the test set, our model correctly predicted that 56 did not default and 11 did default, 
#> resulting in an accuracy of 67 percent and an error rate of 33 percent. 
#> This is somewhat worse than its performance on the training data, but not unexpected, given that a model’s performance 
#> is often worse on unseen data. 
#> Also note that the model only correctly predicted 11 of the 35 actual loan defaults in the test data, or 31 percent. 
#> Unfortunately, this type of error is potentially a very costly mistake, as the bank loses money on each default. 
#> 
#> 
#> 
#> Let’s see if we can improve the result with a bit more effort.




#> ##################################### Step 5 – improving model performance ######################################################


#> Boosting the accuracy of decision trees

#> One way the C5.0 algorithm improved upon the C4.5 algorithm was through the addition of adaptive boosting. 
#> This is a process in which many decision trees are built, and the trees vote on the best class for each example.


#> As boosting can be applied more generally to any machine learning algorithm, it is covered in more detail later in this book in Chapter 14,
#> (Machine Learning with R - Fourth Edition Brett Lantz Published by Packt Publishing R) 
#> 
#> Building Better Learners.
#> For now, it suffices to say that boosting is rooted in the notion that by combining several weak-performing learners, you can create a team 
#> that is much stronger than any of the learners alone. 
#> Each of the models has a unique set of strengths and weaknesses, and may be better or worse at certain problems. 
#> Using a combination of several learners with complementary strengths and weaknesses can therefore dramatically improve the accuracy of a classifier.


#> The C5.0() function makes it easy to add boosting to our decision tree. 
#> We simply need to add an additional trials parameter indicating the number of separate decision trees to use in the boosted team. 
#> The trials parameter sets an upper limit; the algorithm will stop adding trees if it recognizes that additional trials do not seem to be 
#> improving the accuracy. We’ll start with 10 trials, a number that has become the de facto standard, 
#> as research suggests that this reduces error rates on test data by about 25 percent.

credit_boost10 <- C5.0(default ~ ., data = credit_train,
                       trials = 10)

credit_boost10
summary(credit_boost10)



#>The classifier made 19 mistakes on 900 training examples for an error rate of 2.1 percent. 
#>This is quite an improvement over the 13.1 percent training error rate we noted before boosting! 
#>However, it remains to be seen whether we see a similar improvement on the test data. Let’s take a look:



credit_boost_pred10 <- predict(credit_boost10, credit_test)
CrossTable(credit_test$default, credit_boost_pred10,
             prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
             dnn = c('actual default', 'predicted default'))


#> Here, we reduced the total error rate from 33 percent prior to boosting to 26 percent in the boosted model. 
#> This may not seem like a large improvement, but it is not too far away from the 25 percent reduction we expected. 
#> That said, if boosting can be added this easily, why not apply it by default to every decision tree? The reason is twofold. 
#> First, if building a decision tree once takes a great deal of computation time, building many trees may be computationally impractical. 
#> Secondly, if the training data is very noisy, then boosting might not result in an improvement at all. 
#> Still, if greater accuracy is needed, it’s worth giving boosting a try.




 
#> On the other hand, the model is still doing poorly at identifying the true defaults, predicting only 46 percent correctly (16 out of 35)
#> compared to 31 percent (11 of 35) in the simpler model. Let’s investigate one more option to see if we can reduce these types of costly errors.



############################################### Making some mistakes cost more than others #################################################



#> Giving a loan to an applicant who is likely to default can be an expensive mistake. One solution to reduce the number of false negatives may be 
#> to reject a larger number of borderline applicants under the assumption that the interest that the bank would earn from a risky loan is far
#> outweighed by the massive loss it would incur if the money is not paid back at all.

#> The C5.0 algorithm allows us to assign a penalty to different types of errors in order to discourage a tree from making more costly mistakes. 
#> The penalties are designated in a cost matrix, which specifies how many times more costly each error is relative to any other.


#> To begin constructing the cost matrix, we need to start by specifying the dimensions. 
#> Since the predicted and actual values can both take two values, yes or no, we need to describe a 2x2 matrix using a list of two vectors, each with two values. 
#> At the same time, we’ll also name the matrix dimensions to avoid confusion later:


matrix_dimensions <- list(c("no", "yes"), c("no", "yes"))
names(matrix_dimensions) <- c("predicted", "actual")

matrix_dimensions


#> Next, we need to assign the penalty for the various types of errors by supplying four values to fill the matrix. 
#> Since R fills a matrix by filling columns one by one from top to bottom, we need to supply the values in a specific order:

# Predicted no, actual no
# Predicted yes, actual no
# Predicted no, actual yes
# Predicted yes, actual yes

#> Suppose we believe that a loan default costs the bank four times as much as a missed opportunity. 
#> 
#> 
#> Our penalty values then could be defined as:

error_cost <- matrix(c(0, 1, 4, 0), nrow = 2,
                     dimnames = matrix_dimensions)
error_cost


#> As defined by this matrix, there is no cost assigned when the algorithm classifies a no or yes correctly, 
#> but a false negative has a cost of 4 versus a false positive’s cost of 1. 
#> To see how this impacts classification, let’s apply it to our decision tree using the costs parameter of the C5.0() function. 
#> We’ll otherwise use the same steps as before:

credit_cost <- C5.0(default ~ ., data = credit_train,
                    costs = error_cost)


credit_cost_pred <- predict(credit_cost, credit_test)
CrossTable(credit_test$default, credit_cost_pred,
             prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
             dnn = c('actual default', 'predicted default'))


#> Compared to our boosted model, this version makes more mistakes overall: 36 percent error here versus 26 percent in the boosted case. 
#> However, the types of mistakes are very different. 
#> Where the previous models classified only 31 and 46 percent of defaults correctly, in this model, 30 / 35 = 86% of the actual defaults
#> were correctly predicted to be defaults. This trade-off resulting in a reduction of false negatives at the expense of increasing false positives
#> may be acceptable if our cost estimates were accurate.



