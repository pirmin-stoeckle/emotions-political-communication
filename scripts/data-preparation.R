# load packages
library(tidyverse)

# load data from crowdtangle (historical data so available as a download-link sent via email)

data <- read_csv("data/raw/2021-05-17-10-59-15-CEST-Historical-Report-German-Parties-2004-02-03--2021-05-17.csv")

glimpse(data)


