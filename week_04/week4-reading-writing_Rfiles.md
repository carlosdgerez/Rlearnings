---
title: "Week4 Reading and Writing R Files"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: show
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---





## Reading and writing R data objects

After you read in some data and spend lots of time wranglinging it, you may want to save that as a file. If you save it as a .csv or some other type of file, it will loose all of the structure you created (for example, defining factor levels and data types). To keep all of that intact, you can save the dataset as file type that is exclusive to R. This way, when you or someone else opens the file again in R all of the data is structured and defined exactly the way you want it. There are two file types you should consider using.

A `.rds` file is for writing/saving just 1 object at a time in .rds format:


```r
#two ways to save a dataset as a .rds file
saveRDS(mtcars, file = "my_data.rds") #base R
#OR
write_rds(mtcars, "my_data.rds") #readr package, faster

read_rds() #read in an .rds file. This is a wrapper around base R readRDS()
```

`.RData` allows you to **write many objects** to a file


```r
save(mtcars, iris, file = "my_2_datasets.RData")
load("my_2_datasets.RData") #read it back in
```

*Note:* unlike using `.rds`, the objects *cannot* be restored under different names using an assignment operator. The original object names are automatically used.
