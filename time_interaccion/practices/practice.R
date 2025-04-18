

library(tidyverse)
library(tidyquant)



price_data <- tq_get(c("BA", "AMZN", "MSFT"),
                     get = "stock.prices",
                     from = "2020-03-01")

price_data




















#---------------------------------------------------


return_data <- price_data %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "daily",
               type = "log")
view(return_data)

return_anual <-  price_data %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "yearly",
               type = "log")


return_data2 <- price_data %>% 
  group_by(symbol) %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly",
               type = "log")

view(return_data2)

return_anual_indiv <- price_data %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "yearly", 
               type       = "arithmetic")










#-------------------Portfolios ---------------------------------


port1 <- return_data %>%
  tq_portfolio(assets_col=symbol,
               returns_col=daily.returns,
               weights = tibble(asset.names = c("BA", "AMZN", "MSFT"), 
                                weight = c(0.259,.534,.207)),
               wealth.index = T)                      
#port2 <- 

view(port1)

return_data2 %>% 
  tq_portfolio(assets_col=symbol,
               returns_col=monthly.returns,
               weights = tibble(asset.names = c("BA", "AMZN", "MSFT"), 
                                weight = c(0.259,.534,.207)),
               wealth.index = T)

return_anual %>%  tq_portfolio(assets_col=symbol,
                               returns_col=yearly.returns,
                               weights = tibble(asset.names = c("BA", "AMZN", "MSFT"), 
                                                weight = c(0.259,.534,.207)),
                               wealth.index = T)



#-------------------------------------------------
stock_returns_monthly <- c("AAPL", "GOOG", "NFLX") %>%
  tq_get(get  = "stock.prices",
         from = "2010-01-01",
         to   = "2015-12-31") %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "monthly", 
               col_rename = "Ra")
view(stock_returns_monthly)



#----------------- More practices from Tidyquant ----------------------

tq_index_options()

tq_index("SP500")


tq_exchange_options()

#tq_exchange("AMEX")

tq_get_options()


aapl_prices  <- tq_get("AAPL", get = "stock.prices", from = " 1990-01-01")
aapl_prices 

quandl_api_key("Yijz2v85FFts55wbRtmM")

quandl_search(query = "Oil", database_code = "NSE", per_page = 10)



end <- as_date("2023-03-01")
end

zoom_range <- price_data %>% 
  tail(60) %>% 
  summarise(
    max_high = max(high),
    min_low = min(low)
  )


zoom_range

# Line chart


p1 <- price_data %>%
  ggplot(aes(x = date, y = close, group= symbol, color = symbol)) +
  geom_line() +
  labs(title = "Line chart", y = "Closing Price", x = "") + 
  theme_tq()
p1


# Bar chart and zoom

p2 <- price_data %>%
  ggplot(aes(x = date, y = close, group = symbol, color = symbol)) +
  geom_barchart(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "Bar chart", y = "Closing Price", x = "") + 
  theme_tq()
p2

p3 <- price_data %>%
  ggplot(aes(x = date, y = close)) +
  geom_barchart(aes(open = open, high = high, low = low, close = close)) +
  labs(title = " Bar Chart", 
       subtitle = "Zoomed in using coord_x_date",
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(end - weeks(6), end),
               ylim = c(zoom_range$min_low - 200, zoom_range$max_high)) +
  theme_tq()
p3
# candlestick chart and zoom

p4 <- price_data %>%
  ggplot(aes(x = date, y = close)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "Candlestick Chart", y = "Closing Price", x = "") +
  theme_tq()
p4

p5 <- price_data %>%
  ggplot(aes(x = date, y = close)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "AAPL Candlestick Chart", 
       subtitle = "Zoomed in using coord_x_date",
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(end - weeks(6), end),
               c(zoom_range$min_low - 200, zoom_range$max_high - 200)) + 
  theme_tq()

p5

start <- end - weeks(6)

p6 <- price_data %>%
  filter(date >= start - days(2 * 15)) %>%
  ggplot(aes(x = date, y = close, group = symbol)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "Candlestick Chart", 
       subtitle = "Experimenting with Mulitple Stocks",
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(start, end)) +
  facet_wrap(~ symbol, ncol = 2, scale = "free_y") + 
  theme_tq()
p6





# with moving average

start <- end - weeks(6)
p7 <- price_data %>%
  filter(date >= start - days(2 * 15)) %>%
  ggplot(aes(x = date, y = close, group = symbol)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  geom_ma(ma_fun = SMA, n = 15, color = "darkblue", size = 1) +
  labs(title = "FANG Candlestick Chart", 
       subtitle = "Experimenting with Mulitple Stocks",
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(start, end)) +
  facet_wrap(~ symbol, ncol = 2, scale = "free_y") +
  theme_tq()

p7
# charting  returns yearly

p8 <- return_anual_indiv %>%
  ggplot(aes(x = date, y = yearly.returns, fill = symbol)) +
  geom_col() +
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Annual Returns",
       subtitle = "Get annual returns quickly with tq_transmute!",
       y = "Annual Returns", x = "") + 
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  theme_tq() + 
  scale_fill_tq()
p8
# Charting returns daily

p9 <- return_data %>%
  ggplot(aes(x = daily.returns, fill = symbol)) +
  geom_density(alpha = 0.5) +
  labs(title = "Charting the Daily Log Returns",
       x = "Daily Returns", y = "Density") +
  theme_tq() +
  scale_fill_tq() + 
  facet_wrap(~ symbol, ncol = 2)
p9


p10 <- return_data %>%
  ggplot(aes(x = daily.returns, fill = symbol)) +
  geom_density(alpha = 0.6) +
  labs(title = "Charting the Daily Log Returns",
       x = "Daily Returns", y = "Density") +
  theme_tq() +
  scale_fill_tq() 
p10




# daily price data graph by stock

p11 <- price_data %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Daily Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() + 
  scale_color_tq()
p11

p12 <- price_data %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Daily Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  #    facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() + 
  scale_color_tq()
p12
# with monthly aggregation

price_monthly <- price_data %>%
  group_by(symbol) %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = to.period, 
               period     = "months")
price_monthly

p13 <- price_monthly %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Monthly Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() + 
  scale_color_tq()

p13
p14 <- price_monthly %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line(size = 1) +
  labs(title = "Monthly Stock Prices",
       x = "", y = "Adjusted Prices", color = "") +
  #    facet_wrap(~ symbol, ncol = 2, scales = "free_y") +
  scale_y_continuous(labels = scales::dollar) +
  theme_tq() + 
  scale_color_tq()

p14

