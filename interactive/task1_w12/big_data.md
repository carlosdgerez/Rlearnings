---
title: "A Little Introduction to Big Data"
author: "Carlos Gerez"
date: "July 01, 2023"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---





## Background

1. Complete the listed reading for class discussion  
2. Find an additional article on R or Python and “big data” and write a summary of the article.  
3. Create an .Rmd file summarizing your reading (no R chunks needed).

## Article: 
I get into the practical use of big data in R after reading 3 different ways to work with big data in the article : 
[Three Strategies for Working with Big Data in R](https://rviews.rstudio.com/2019/07/17/3-big-data-strategies-for-r/)  

The author refers here to:

1. Strategy 1: Sample and Model.  
    - Speed (we work with samples of the model).  
    - Prototyping is an effective way to refine hyper parameters in models.
    
2. Strategy 2: Chunk and Pull  
    - Uses the full data set chunked into separate units.  
    - Then is pulled to make use of parallelization in the database.  
3. Strategy 3: Push Compute to Data  
    - Data is compressed in the database and then moved to R  
    - Uses the entire data set but faster because transfers are of compressed data. 
    
Each of this approaches has advantages and disadvantages and are used according to the task we look to resolve. Is a good enumeration of those and furthermore an example of how to implement each case.  

## Course in Datacamp 
After that I start the course [Big Data with R](https://app.datacamp.com/learn/skill-tracks/big-data-with-r), and saw the videos to have a first look to how is working with big data in a practical way.
First take outs of the course:

1. Check R version and keep at date helps to run code faster.
2. Benchmark is necessary to have a unit of measure of the code and implementations. Use library("microbenchmark").  
3. install.packages("benchmarkme"), is used to benchmark machine and is useful to know if invest in a new machine is worth. 

 I get to this point and then I get asked to upgrade my plan to continue.  
 
## Zeppelin.  

Then I found [Zeppelin](https://zeppelin.apache.org/docs/0.10.0/quickstart/install.html) installing page, and links to tutorials to start working with this tool. Zeppelin is a web based notebook that allows interactive analysis in Apache clusters.  Following the links a quick tutorial explain how to use r in this environment, and some examples of how to use ggplot and make a Shiny App also. Most of the examples runs r in the way it runs in a Jupyter interpreter in which is based.  
 
## Book : Mastering Spark with R.  
  
 As an extra I found the best source for working from Rstudio with Spark in the book [Mastering Spark with R](https://therinspark.com/) , a complete guide with examples of how to connect Rstudio with Apache local clusters and use the web interface calling by: spark_web(). This material is worth to study in the summer break. 
 









