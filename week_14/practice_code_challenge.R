



library(tidyverse)
library("ggthemes")
library(directlabels)
library(ggplot2)
library(lubridate)
# useful formats 




ggplot(data =  , aes(x = , y = )) +
  geom_point() +
  geom_line() +
  labs(
    x = "   ",
    y = "   ",
    title = " ",
    subtitle = "",
    caption = ""
  ) +
  scale_x_continuous(breaks = c(1:6), labels = c("uno", "dos","tres","cuatro","cinco","seis"))
  scale_x_date(date_labels = "%b/%d", limits = c(min, max))  + # for months and years +
  theme(angle = 45. hjust = 1) +
  theme(axis.text.x = element_text(face="bold", color="#993333", # format tikcs
                                     size=14, angle=45),
        axis.text.y = element_text(face="bold", color="#993333", 
                                     size=14, angle=45)) +
    theme(axis.text.x = element_blank(),
          axis.ticks = element_blank()) + # hide
    # Remove tick mark labels and gridlines
     scale_y_continuous(breaks=NULL) +
    
    
    
    
    
    
    stat_boxplot(geom = "errorbar",
                 width = 0.25) +
    geom_boxplot(fill = "dodgerblue1",
                 colour = "black",
                 alpha = 0.5,
                 outlier.colour = "tomato2")  +
    
    
    
    
    guides(color = "none") +
    guides(size = guide_legend(order = 1), color = guide_legend(order = 2)) +#change the order of legends
  
  
  # remember
    geom_bar(stat="identity") +
    theme(axis.title.y = element_text(margin = margin(r = 70))) #margins
  
  
  
  
  
  
  
  # replace nas
  
  guns <- guns %>% mutate(
    place = stringi::stri_replace_na(guns$place, replacement = "Not Informed"))
  
  
  
 # mutate by condition 
  guns <- guns %>% mutate(
    age_group = case_when(
      age %in% as.character(c(0:14)) ~ "Under 15",
      age %in% as.character(c(15:24)) ~ "15 - 24",
      age %in% as.character(c(25:34)) ~ "25 - 34",
      age %in% as.character(c(35:50)) ~ "35 - 50",
      age %in% as.character(c(51:64)) ~ "51 - 64",
      age %in% as.character(c(65:107)) ~ "65+",
    ),
    season = case_when(
      month %in% c('12', '1', '2') ~ 'Winter',
      month %in% c('3', '4', '5') ~ 'Spring',
      month %in% c('6', '7', '8') ~ 'Summer',
      month %in% c('9', '10', '11') ~ 'Fall'),
    sex = case_when(
      sex %in% "F" ~ "Female",
      sex %in% "M" ~ "Male"
    ))
  
  
# remember this mutate:
  
  mutate(country = recode(country,
                          "old name" = "new name")) #change the values in the rows of country column
  
  rename(perc_obesity = Data_Value, # new nmae, old name
         perc_poverty = value) # the order is different
  
  
  
  
  
  ggplot(data = data_obesity_state, aes(x = YearStart, y = Data_Value, group = 1) ) +
    geom_point() +
    geom_line() +
    geom_text(label = "COVID", x = 2020, y = 10, color = "black") +
    
    annotate('rect', xmin=2020, xmax = 2021, ymin = 0, ymax = 10, alpha = .2, fill = 'red') +
    
    scale_x_continuous(breaks = c(2011:2021)) +
    scale_y_discrete(labels = paste0(data_obesity_state$Data_Value," %")) + # change output in the axis labels 
    labs(x = "", 
         y = "",
         title = "Obesity in adult populations in USA",
         subtitle = "A food insecurity problem?") +
    theme_economist() 
  
  
  # padding horizontal, vertical with x, can be mult or add
  scale_y_continuous(expand = expansion(mult = c(0.1,0.01))
                     )
  
  geom_text_repel(data = lastpoints, aes(label = country), nudge_x = 2)
  