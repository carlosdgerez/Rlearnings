

library(tidyquant)
library(tidyverse)
install.packages("dygraphs")
install.packages("shiny")

library(dygraphs)




# From : https://rstudio.github.io/dygraphs/index.html
#-----------------------------------
lungDeaths <- cbind(mdeaths, fdeaths)

dygraph(lungDeaths)

#----------------------------------

dygraph(lungDeaths) %>% dyRangeSelector()




#--------------------------------------
dygraph(lungDeaths) %>%
  dySeries("mdeaths", label = "Male") %>%
  dySeries("fdeaths", label = "Female") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector(height = 40)

#----------------------------------------------

hw <- HoltWinters(ldeaths)
predicted <- predict(hw, n.ahead = 72, prediction.interval = TRUE)

dygraph(predicted, main = "Predicted Lung Deaths (UK)") %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dySeries(c("lwr", "fit", "upr"), label = "Deaths") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"))


#-----------------------------------------------------
nhtemp

dygraph(nhtemp, main = "New Haven Temperatures", ylab = "Temp (F)") 


#----------------------------------------------------------------




library(shiny)
runExample("01_hello")


library(dplyr)
library(ggplot2)
library(lubridate)
library(timetk)

# Setup for the plotly charts (# FALSE returns ggplots)
interactive <- TRUE


taylor_30_min

#The plot_time_series() function generates an interactive plotly chart by default.

taylor_30_min %>% 
  plot_time_series(date, value, 
                   .interactive = interactive,
                   .plotly_slider = TRUE)




m4_daily %>% group_by(id)


m4_daily %>%
  group_by(id) %>%
  plot_time_series(date, value, 
                   .facet_ncol = 2, .facet_scales = "free",
                   .interactive = interactive)

m4_hourly %>%
  group_by(id) %>%
  plot_time_series(date, log(value),             # Apply a Log Transformation
                   .color_var = week(date),      # Color applied to Week transformation
                   # Facet formatting
                   .facet_ncol = 2, 
                   .facet_scales = "free", 
                   .interactive = interactive)


kroger <- tq_get("KR",
                  get = "stock.prices",
                   from = "2022-10-01")
kroger


#--------------------- Straw broom charts -----------------------------------
#quantmod


library(quantmod)

tickers <- c("AAPL", "MSFT")

getSymbols(tickers)

closePrices <- do.call(merge, lapply(tickers, function(x) Cl(get(x))))

dateWindow <- c("2008-01-01", "2009-01-01")
closePrices
dygraph(closePrices, main = "Value", group = "stock") %>%
  dyRebase(value = 100) %>%
  dyRangeSelector(dateWindow = dateWindow)

dygraph(closePrices, main = "Percent", group = "stock") %>%
  dyRebase(percent = TRUE) %>%
  dyRangeSelector(dateWindow = dateWindow)

dygraph(closePrices, main = "None", group = "stock") %>%
  dyRangeSelector(dateWindow = dateWindow)



#--------------------------------------------------
#rollPeriod
dygraph(discoveries, main = "Important Discoveries") %>% 
  dyRoller(rollPeriod = 5)



#---------- Anotations / shading ------------------
class(presidents)
presidents

dygraph(presidents, main = "Quarterly Presidential Approval Ratings") %>%
  dyAxis("y", valueRange = c(0, 100)) %>%
  dyAnnotation("1950-7-1", text = "A", tooltip = "Korea") %>%
  dyAnnotation("1965-1-1", text = "B", tooltip = "Vietnam")


#---------------Bottom Anotations ---------------
# with a function predefined.

presAnnotation <- function(dygraph, x, text) {
  dygraph %>%
    dyAnnotation(x, text, attachAtBottom = TRUE, width = 60)
}

dygraph(presidents, main = "Quarterly Presidential Approval Ratings") %>%
  dyAxis("y", valueRange = c(0, 100)) %>%
  presAnnotation("1950-7-1", text = "Korea") %>%
  presAnnotation("1965-1-1", text = "Vietnam")

#------------------ Events Lines --------------------------------

dygraph(presidents, main = "Quarterly Presidential Approval Ratings") %>%
  dyAxis("y", valueRange = c(0, 100)) %>%
  dyEvent("1950-6-30", "Korea", labelLoc = "bottom") %>%
  dyEvent("1965-2-09", "Vietnam", labelLoc = "bottom")



#---------------- Limit Lanes -----------------------------

quantmod::getSymbols("MSFT", from = "2014-06-01", auto.assign=TRUE)
MSFT


dygraph(MSFT[, 4], main = "Microsoft Share Price") %>% 
  dySeries("MSFT.Close", label = "MSFT") %>%
  dyLimit(as.numeric(MSFT[1, 4]), color = "red")
