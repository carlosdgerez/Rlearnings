


library(tidyverse)
library(downloader)
library(readxl)
library(rio)




# This code helps to look into the data.world API ( I don think will use it in this stage)

devtools::install_github("datadotworld/data.world-r", build_vignettes = TRUE)

# Link to the file I will want to start working 

nutrition <- "https://query.data.world/s/vczcvw6w35ex6epncn5y2gzbldml2y?dws=00000"


# Working with temp files to avoid send too much data to github

# Temporal files 
temporal <- tempfile()

download(nutrition, 
         dest = temporal,
         mode = "wb")

read_csv(temporal)
