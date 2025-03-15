

#> Step 1 – collecting data

#> We will utilize the Breast Cancer Wisconsin (Diagnostic) dataset from the UCI Machine Learning Repository 
#> at http://archive.ics.uci.edu/ml. This data was donated by researchers at the University of Wisconsin 
#> and includes measurements from digitized images of fine-needle aspirations of a breast mass. 
#> The values represent characteristics of the cell nuclei present in the digital image.


#> The breast cancer data includes 569 examples of cancer biopsies, each with 32 features. One feature is an identification number, another is the cancer diagnosis, and 30 are numeric-valued laboratory measurements. The diagnosis is coded as “M” to indicate malignant or “B” to indicate benign.

#> The 30 numeric measurements comprise the mean, standard error, and worst (that is, largest) value
#> for 10 different characteristics of the digitized cell nuclei, such as radius, texture, area, smoothness, 
#> and compactness. Based on the feature names, the dataset seems to measure the shape and size of the cell nuclei, 
#> but unless you are an oncologist, you are unlikely to know how each of these relates to benign or malignant masses. 
#> No such expertise is necessary, as the computer will discover the important patterns during the machine learning process.


#> ###################################### Step 2 – exploring and preparing the data ###################################


wbcd <- read.csv("https://raw.githubusercontent.com/PacktPublishing/Machine-Learning-with-R-Fourth-Edition/main/Chapter%2003/wisc_bc_data.csv")


str(wbcd)


#> The first feature is an integer variable named id. As this is simply a unique identifier (ID) for each patient in the data, 
#> it does not provide useful information, and we will need to exclude it from the model.

wbcd <- wbcd[-1]


table(wbcd$diagnosis)


#> Many R machine learning classifiers require the target feature to be coded as a factor,
#> so we will need to recode the diagnosis column.
#> We will also take this opportunity to give the "B" and "M" values more informative labels using the labels parameter:
#> 

wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"),
                         labels = c("Benign", "Malignant"))


round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)



#> The remaining 30 features are all numeric and, as expected, consist of three different measurements of 10 characteristics. 
#> For illustrative purposes, we will only take a closer look at three of these features:
#> 

summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])


#> Looking at the three side by side, do you notice anything problematic about the values? 
#> Recall that the distance calculation for k-NN is heavily dependent upon the measurement scale of the input features. 
#> Since smoothness ranges from 0.05 to 0.16, while area ranges from 143.5 to 2501.0, the impact of area is going to be 
#> much greater than smoothness in the distance calculation. This could potentially cause problems for our classifier, 
#> so let’s apply normalization to rescale the features to a standard range of values.


#>############################################ Transformation – normalizing numeric data ##################################

# This is a min_max from scratch and is very easy to implement in r

#> To normalize these features, we need to create a normalize() function in R. 
#> This function takes a vector x of numeric values, and for each value in x, subtracts the minimum x value and divides it 
#> by the range of x values. Lastly, the resulting vector is returned. The code for the function is as follows:

normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

normalize(c(1, 2, 3, 4, 5))


#> The lapply() function takes a list and applies a specified function to each list element. 
#> As a data frame is a list of equal-length vectors, we can use lapply() to apply normalize() to each feature in the data frame. 
#> The final step is to convert the list returned by lapply() to a data frame using the as.data.frame() function. 
#> The full process looks like this:

wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))


summary(wbcd_n$area_mean)


#> ################################# Data preparation – creating training and test datasets #######################################


wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]



#> When we constructed our normalized training and test datasets, we excluded the target variable, diagnosis. 
#> For training the k-NN model, we will need to store these class labels in factor vectors,
#> split between the training and test datasets:


wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]


#> ################################### Step 3 – training a model on the data ##############################################


#> To classify our test instances, we will use a k-NN implementation from the class package, which provides a 
#> set of basic R functions for classification. 
#> If this package is not already installed on your system, you can install it by typing:

# install.packages("class")

library(class)
#>The knn() function in the class package provides a standard, traditional implementation of the k-NN algorithm. 
#> For each instance in the test data, the function will identify the k nearest neighbors, using Euclidean distance, 
#> where k is a user-specified number. 
#> The test instance is classified by taking a “vote” among the k nearest neighbors—specifically, 
#> this involves assigning the class of the majority of neighbors. 
#> A tie vote is broken at random.


#> The only remaining parameter is k, which specifies the number of neighbors to include in the vote.

#> As our training data includes 469 instances, we might try k = 21, an odd number roughly equal to the square root of 469.
#> With a two-category outcome, using an odd number eliminates the possibility of ending with a tie vote.

wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k = 21)


#> ############################ Step 4 – evaluating model performance ########################################
#> 

CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
           prop.chisq = FALSE)

#> A total of 2 out of 100, or 2 percent of masses were incorrectly classified by the k-NN approach. 
#> While 98 percent accuracy seems impressive for a few lines of R code, we might try another iteration of the model 
#> to see if we can improve the performance and reduce the number of values that have been incorrectly classified, 
#> especially because the errors were dangerous false negatives.


#> ###################################### Step 5 – improving model performance #################################
#> 

#> We will attempt two simple variations on our previous classifier. 
#> First, we will employ an alternative method for rescaling our numeric features. 
#> Second, we will try several different k values.


# #################### Transformation – z-score standardization ###########################################

#> Although normalization is commonly used for k-NN classification, 
#> z-score standardization may be a more appropriate way to rescale the features in a cancer dataset.

#> Since z-score standardized values have no predefined minimum and maximum, 
#> extreme values are not compressed towards the center. Even without medical training, 
#> one might suspect that a malignant tumor might lead to extreme outliers as tumors grow uncontrollably. 
#> With this in mind, it might be reasonable to allow the outliers to be weighted more heavily in the distance calculation. 
#> Let’s see whether z-score standardization improves our predictive accuracy.


#> To standardize a vector, we can use R’s built-in scale() function, which by default rescales values using the z-score standardization. 
#> The scale() function can be applied directly to a data frame, so there is no need to use the lapply() function. 
#> To create a z-score standardized version of the wbcd data, we can use the following command:

wbcd_z <- as.data.frame(scale(wbcd[-1]))

summary(wbcd_z$area_mean)

#> The mean of a z-score standardized variable should always be zero, and the range should be fairly compact. 
#> A z-score less than -3 or greater than 3 indicates an extremely rare value. 
#> Examining the summary statistics with these criteria in mind, the transformation seems to have worked.



#> As we have done before, we need to divide the z-score-transformed data into training and test sets, 
#> and classify the test instances using the knn() function. 
#> We’ll then compare the predicted labels to the actual labels using CrossTable():


wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                        cl = wbcd_train_labels, k = 21)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
             prop.chisq = FALSE)


#> Unfortunately, in the following table, the results of our new transformation show a slight decline in accuracy. 
#> Using the same instances in which we had previously classified 98 percent of examples correctly, 
#> we now classified only 95 percent correctly. 
#> 
#> Making matters worse, we did no better at classifying the dangerous false negatives.



# #################################### Testing alternative values of k ##################################

# We may be able to optimize the performance of the k-NN model by examining its performance across various k values. 
#> Using the normalized training and test datasets, the same 100 records need to be classified using several different choices of k.
#> Given that we are testing only six k values, these iterations can be performed most simply by using copy-and-paste 
#> of our previous knn() and CrossTable() functions. 
#> 
#> However, it is also possible to write a for loop that runs these two functions for each of the 
#> values in a vector named k_values, as demonstrated in the following code:

k_values <- c(1, 5, 11, 15, 21, 27)
  for (k_val in k_values) {
  wbcd_test_pred <- knn(train = wbcd_train,
                        test = wbcd_test,
                        cl = wbcd_train_labels,
                        k = k_val)
  CrossTable(x = wbcd_test_labels,
             y = wbcd_test_pred,
             prop.chisq = FALSE)
}




#> Unlike many classification algorithms, k-nearest neighbors does not do any learning—at least not 
#> according to the formal definition of machine learning. Instead, it simply stores the training data verbatim. 
#> Unlabeled test examples are then matched to the most similar records in the training set using a distance function, 
#> and the unlabeled example is assigned the label of its nearest neighbors.

#> Although k-NN is a very simple algorithm, it can tackle extremely complex tasks, such as the identification of cancerous masses. 
#> In a few simple lines of R code, we were able to correctly identify whether a mass was malignant or benign 98 percent of the time
#> in an example using real-world data. 
#> 
#> Although this teaching dataset was designed to streamline the process of building a model,
#> the exercise demonstrated the ability of learning algorithms to make accurate predictions much like a human can.