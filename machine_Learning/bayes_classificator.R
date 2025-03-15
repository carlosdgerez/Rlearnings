
#install.packages("tm")
install.packages("SnowballC")
library(tm)
library(SnowballC)




#> Example – filtering mobile phone spam with the Naive Bayes algorithm



#> To develop the Naive Bayes classifier, we will use data adapted from the SMS Spam Collection at
#>  https://www.dt.fee.unicamp.br/~tiago/smsspamcollection/.



sms_raw <- read.csv("https://raw.githubusercontent.com/PacktPublishing/Machine-Learning-with-R-Fourth-Edition/main/Chapter%2004/sms_spam.csv")


str(sms_raw)


#> Factorize the type variable
#> 
sms_raw$type <- factor(sms_raw$type)


str(sms_raw$type)
table(sms_raw$type)


#> ######################################### cleaning and standardizing text data ##################################

#> To create a corpus, we’ll use the VCorpus() function in the tm package, 
#> which refers to a volatile corpus—the term “volatile” meaning that it is 
#> stored in memory as opposed to being stored on disk (the PCorpus() function 
#> is used to access a permanent corpus stored in a database). 
#> This function requires us to specify the source of documents for the corpus,
#>  which could be a computer’s filesystem, a database, the web, or elsewhere.
#>  
#>  
#>  'Since we already loaded the SMS message text into R, we’ll use the VectorSource() 
#>  reader function to create a source object from the existing sms_raw$text vector, 
#>  which can then be supplied to VCorpus() as follows:
#>  

sms_corpus <- VCorpus(VectorSource(sms_raw$text))


#> By specifying an optional readerControl parameter, the VCorpus() function can be used to import
#> text from sources such as PDFs and Microsoft Word files.
#> To learn more, examine the Data Import section in the tm package vignette using the vignette("tm") command
#> 
#> 

print(sms_corpus)

inspect(sms_corpus[1:2])

as.character(sms_corpus[[1]])



lapply(sms_corpus[1:2], as.character)





#> The tm_map() function provides a method to apply a transformation (also known as a mapping) to a tm corpus.
#>  We will use this function to clean up our corpus using a series of
#>   transformations and save the result in a new object called corpus_clean.
#>   
#>  Our first transformation will standardize the messages to use only lowercase characters. 
#>  To this end, R provides a tolower() function that returns a lowercase version of text strings.
#>  In order to apply this function to the corpus, we need to use the tm wrapper function content_transformer() 
#>  to treat tolower() as a transformation function that can be used to access the corpus. The full command is as follows:
#>  

sms_corpus_clean <- tm_map(sms_corpus,
                           content_transformer(tolower))

as.character(sms_corpus[[1]])

as.character(sms_corpus_clean[[1]])

#> Let’s continue our cleanup by removing numbers from the SMS messages. 
#> 

sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)



#> Note that the preceding code did not use the content_transformer() function.
#> This is because removeNumbers() is included with tm along with several other
#>  mapping functions that do not need to be wrapped. To see the other built-in transformations, 
#>  simply type getTransformations().


getTransformations()





#> Our next task is to remove filler words such as to, and, but, and or from the SMS messages. 
#> These terms are known as stop words and are typically removed prior to text mining. 
#> This is due to the fact that although they appear very frequently, 
#> they do not provide much useful information for our model as they are unlikely to distinguish between spam and ham.
#> 
?removeWords()
stopwords()


sms_corpus_clean <- tm_map(sms_corpus_clean,
                           removeWords, stopwords())

#> Continuing our cleanup process, 
#> we can also eliminate any punctuation 
#> from the text messages using the built-in removePunctuation() transformation:

removePunctuation("hello...world")

sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)


#> To work around the default behavior of removePunctuation(), it is possible to create a custom function 
#> that replaces rather than removes punctuation characters:

replacePunctuation <- function(x) {
  gsub("[[:punct:]]+", " ", x)
}

#> This uses R’s gsub() function to substitute any punctuation characters
#>  in x with a blank space. This replacePunctuation() function can then 
#>  be used with tm_map() as with other transformations.
#>  The odd syntax of the gsub() command here is due to the use of a regular expression,
#>  which specifies a pattern that matches text characters. 

#> Another common standardization for text data involves reducing words to their root 
#> form in a process called stemming. The stemming process takes words like learned,
#>  learning, and learns and strips the suffix in order to transform them into the base form,
#> learn. This allows machine learning algorithms to treat the related terms as a single
#> concept rather than attempting to learn a pattern for each variant.
#> 
#> 
#> 
#> The tm package provides stemming functionality via integration with the SnowballC package. 
#> At the time of writing, SnowballC is not installed by default with tm, 
#> so do so with install.packages("SnowballC") if you have not done so already.

wordStem(c("learn", "learned", "learning", "learns"))


#> To apply the wordStem() function to an entire corpus of text documents, the tm package
#> includes a stemDocument() transformation. We apply this to our corpus with the tm_map() function exactly as before:

sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)


#> After removing numbers, stop words, and punctuation, then also performing stemming,
#> the text messages are left with the blank spaces that once separated the now-missing pieces. 
#> Therefore, the final step in our text cleanup process is to remove additional whitespace using
#> the built-in stripWhitespace() transformation:
#> 

sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)


############################## splitting text documents into words TOKENIZATION ##################################################


#> Now that the data is processed to our liking, the final step is to split the messages into individual terms
#>  through a process called tokenization. A token is a single element of a text string; in this case, the tokens are words.
#>  

#> As you might assume, the tm package provides functionality to tokenize the SMS message corpus. 
#> The DocumentTermMatrix() function takes a corpus and creates a data structure called a document-term matrix (DTM)
#> in which rows indicate documents (SMS messages) and columns indicate terms (words).

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)




#> if we hadn’t already performed the preprocessing, we could do so here by providing a list of control parameter options 
#> to override the defaults. For example, to create a DTM directly from the raw, unprocessed SMS corpus, 
#> we can use the following command:
#> 


# this dataset is slightly different because uses a diferent function in removeWords. To have the same result we must apply 
# a custom aproach



sms_dtm2 <- DocumentTermMatrix(sms_corpus, control = list(
  tolower = TRUE,
  removeNumbers = TRUE,
  stopwords = TRUE,
  removePunctuation = TRUE,
  stemming = TRUE
))
sms_dtm

#> If we change this line the result will be the same : stopwords = function(x) { removeWords(x, stopwords())
#> The reason is the order in which splits the words and then apply the rest of clean up and in this case the order matters.
#> 
  
################################# Data preparation – creating training and test datasets ####################################


#> We’ll divide the data into two portions: 75 percent for training and 25 percent for testing.
#> Since the SMS messages are sorted in a random order, we can simply take the first 4,169 for
#>  training and leave the remaining 1,390 for testing. Thankfully, the DTM object acts very much
#> like a data frame and can be split using the standard [row, col] operations.
#>  As our DTM stores SMS messages as rows and words as columns, we must request a specific range of rows and all columns for each:

sms_dtm_train <- sms_dtm[1:4169, ]

sms_dtm_test  <- sms_dtm[4170:5559, ]

#> For convenience later, it is also helpful to save a pair of vectors with 
#> the labels for each of the rows in the training and testing matrices. 
#> These labels are not stored in the DTM, so we need to pull them from the original sms_raw data frame:
#> 

sms_train_labels <- sms_raw[1:4169, ]$type

sms_test_labels  <- sms_raw[4170:5559, ]$type



prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))



#> ################################## Visualizing text data – word clouds ##############################
# install.packages("wordcloud")
library(wordcloud)

wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE)



spam <- subset(sms_raw, type == "spam")


ham <- subset(sms_raw, type == "ham")


wordcloud(spam$text, max.words = 40, scale = c(3, 0.5))
wordcloud(ham$text, max.words = 40, scale = c(3, 0.5))

#> ########################### Data preparation – creating indicator features for frequent words ##################
#> 
#> The final step in the data preparation process is to transform the sparse matrix into a data structure
#> that can be used to train a Naive Bayes classifier. Currently, the sparse matrix includes over 6,500 features;
#> this is a feature for every word that appears in at least one SMS message. It’s unlikely that all of these are useful
#> for classification. 
#> To reduce the number of features, we’ll eliminate any word that appears in less than 5 messages, 
#> or in less than about 0.1 percent of records in the training data.
#> 
#> Finding frequent words requires the use of the findFreqTerms() function in the tm package.
#> This function takes a DTM and returns a character vector containing words that appear at least
#> a minimum number of times. For instance, the following command displays the words appearing at least
#> five times in the sms_dtm_train matrix:
#> 

findFreqTerms(sms_dtm_train, 5)

sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
str(sms_freq_words)



#> We now need to filter our DTM to include only the terms appearing in the frequent word vector. 
#> As before, we’ll use data frame-style [row, col] operations to request specific sections of the DTM,
#> noting that the DTM column names are based on the words the DTM contains. 
#> We can take advantage of this fact to limit the DTM to specific words. 
#> Since we want all rows but only the columns representing the words in the sms_freq_words vector, our commands are:
#> 

sms_dtm_freq_train <- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[ , sms_freq_words]



#> The Naive Bayes classifier is usually trained on data with categorical features. 
#> This poses a problem since the cells in the sparse matrix are numeric and measure 
#> the number of times a word appears in a message. We need to change this to a categorical 
#> variable that simply indicates yes or no, depending on whether the word appears at all.

#> The following defines a convert_counts() function to convert counts into Yes or No strings:
#> 

convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}


#> The apply() function allows a function to be used on each of the rows or columns in a matrix. 
#> It uses a MARGIN parameter to specify either rows or columns. 
#> Here, we’ll use MARGIN = 2 since we’re interested in the columns (MARGIN = 1 is used for rows). 
#> The commands to convert the training and test matrices are as follows:
#> 

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2,
                   convert_counts)
sms_test  <- apply(sms_dtm_freq_test, MARGIN = 2,
                     convert_counts)




#> ############################## Step 3 – training a model on the data #############################
#> 
#> The algorithm will use the presence or absence of words to estimate the probability that a given SMS message is spam.

# install.packages("naivebayes")

library(naivebayes)


sms_classifier <- naive_bayes(sms_train, sms_train_labels)
warnings()


#> These warnings are caused by words that appeared in zero spam or zero ham messages and 
#> have veto power over the classification process due to their associated zero probabilities. 
#> For instance, because the word accept only appeared in ham messages in the training data, 
#> it does not mean that every future message with this word should be automatically classified as ham.

#> There is an easy solution to this problem using the Laplace estimator described earlier, but for now,
#> we will evaluate this model using laplace = 0, which is the model’s default setting.
#> 



#> ####################################### Step 4 – evaluating model performance #################################

#> To evaluate the SMS classifier, we need to test its predictions on the unseen messages in the test data. 
#> Recall that the unseen message features are stored in a matrix named sms_test, while the class labels (spam or ham)
#> are stored in a vector named sms_test_labels. The classifier that we trained has been named sms_classifier. 
#> We will use this classifier to generate predictions and then compare the predicted values to the true values.



sms_test_pred <- predict(sms_classifier, sms_test)


# install.packages("gmodels")

library(gmodels)
CrossTable(sms_test_pred, sms_test_labels,
             prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
             dnn = c('predicted', 'actual'))



#> Looking at the table, we can see that a total of only 6 + 30 = 36 of 1,390 SMS messages were 
#> incorrectly classified (2.6 percent). 
#> Among the errors were 6 out of 1,207 ham messages that were misidentified as spam and 30 of 183 spam messages
#> that were incorrectly labeled as ham. 
#> Considering the little effort that we put into the project, this level of performance seems quite impressive. 
#> 
#> 
#> This case study exemplifies the reason why Naive Bayes is so often used for text classification: 
#> directly out of the box, it performs surprisingly well.
#>


#> ######################## Step 5 – improving model performance ####################################################33
#> 

sms_classifier2 <- naive_bayes(sms_train, sms_train_labels,
                              laplace = 1)


sms_test_pred2 <- predict(sms_classifier2, sms_test)


CrossTable(sms_test_pred2, sms_test_labels,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('predicted', 'actual'))



#>  we learned about classification using Naive Bayes. 
#>  This algorithm constructs tables of probabilities that are used to estimate the likelihood that new examples 
#>  belong to various classes. The probabilities are calculated using a formula known as Bayes’ theorem, 
#>  which specifies how dependent events are related. 
#>  
#>  
#>  Although Bayes’ theorem can be computationally expensive, a simplified version that makes so-called “naive” assumptions 
#>  about the independence of features is capable of handling much larger datasets.
#>  
#>  


#>The Naive Bayes classifier is often used for text classification. 
#> To illustrate its effectiveness, we employed Naive Bayes on a classification task involving spam SMS messages.
#> Preparing the text data for analysis required the use of specialized R packages for text processing and visualization. 
#> Ultimately, the model was able to classify over 97 percent of all the SMS messages correctly as spam or ham.