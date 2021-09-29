######################################
## 
##  sta308_week06_farsAPI_analysis.R
##
##  Starter code provided by Bailer/Fisher
##
##  This starter file will be updated over the 
##   coming classes with more content, but for
##   now it does the following:
##
## 1. Demonstrates functionality of the fromJSON()
##    function and demonstrates the NHTSA FARS API
##    Including code that accesses data from the 
##    National Highway Traffic Safety Administration
##    (NHTSA) Fatality Analysis Reporting System 
##    (FARS) program API.
## 
## The FARS data:  US motor vehicle crashes resulting in a death 
##
## 2. Provides a function that will fetch the crash
##    data for a given county in Ohio (specified by
##    a FIPS code number: 1, 3, 5,..., 173, 175
##    see: https://en.wikipedia.org/wiki/List_of_counties_in_Ohio
##
## Task: Your task is to take this output from the API
##       and build a data.frame where each row
##       corresponds to a County in Ohio and the
##       recorded number of fatalities in 2018-2019.
## Wednesday task: Merge the data from the API with 
##       Ohio county-level population data from the 
##       US Census and perform a short analysis.
## 
## Background:  API Details
## The publicly available FARS API - instructions for accessing 
## the API: https://crashviewer.nhtsa.dot.gov/CrashAPI
##
## Obtain crash-level information for all counties in Ohio from 
## 2018-2019. The API requires we enter the FIPS code for each county, ## the list of counties and FIPS codes can be found here: 
## https://en.wikipedia.org/wiki/List_of_counties_in_Ohio. Note that ##      county FIPS codes are odd numbered, 1, 3, ... 167, ..., 175.
##
##
library(tidyverse)
library(jsonlite)

################################
## First, we look at the output 
##   from the fromJSON() function
## Here, we use the sample API call
##   provided on https://crashviewer.nhtsa.dot.gov/CrashAPI
##   for summary counts.
fromJSON("https://crashviewer.nhtsa.dot.gov/CrashAPI/analytics/GetInjurySeverityCounts?fromCaseYear=2014&toCaseYear=2015&state=1&format=json")

###################
## Note that the output is a named list
##   It is quite easy to extract information
##   from the output of the fromJSON() function.
##

###########################
## Now we learn how to get the data of interest
##   Here we collect for Ohio County 17 - Butler County
##   for the year 2014
butler_co <- fromJSON("https://crashviewer.nhtsa.dot.gov/CrashAPI/crashes/GetCrashesByLocation?fromCaseYear=2014&toCaseYear=2014&state=39&county=17&format=json")
butler_co
## By looking at this single county we can start
##   to understand what information we will need later
## The variable FATALS in Results includes the number 
##   of fatalities for each crash.
## Our ultimate goal is to aggregate all those results
##   for each county in 2018-2019

#################################
## get_county_json(county=1)
##
## This function takes the provided 'county' number
##   parameter and appends it to the website/API
##   call. The result of the API call is then output.
## We use this function so we can lapply() over
##   all valid county FIPS codes.
get_county_json <- function(county=1) {
  site <- paste0("https://crashviewer.nhtsa.dot.gov/CrashAPI/crashes/GetCrashesByLocation?fromCaseYear=2018&toCaseYear=2019&state=39&county=", 
                 county, 
                 "&format=json")
  fromJSON(site)
}

all_county_list <- lapply(seq(1,175,2), get_county_json)

##################################
## In the below lines, write code
##   that extracts the county name &
##   number of fatalities in that county

str(all_county_list)
length(all_county_list)
all_county_list[[1]]
all_county_list[[1]]$Results
class(all_county_list[[1]]$Results)
all_county_list[[1]]$Results[[1]]
class(all_county_list[[1]]$Results[[1]])

all_county_list[[1]]$Results[[1]] %>%
  summarize(Total_fatalities = sum(FATALS))

all_county_list[[1]]$Results[[1]]$FATALS
as.numeric(all_county_list[[1]]$Results[[1]]$FATALS)

all_county_list[[1]]$Results[[1]] %>%
  summarize(Total_fatalities = sum(as.numeric(FATALS)))

all_county_list[[5]]$Results[[1]] %>%
  group_by(COUNTYNAME) %>%
  summarize(Total_fatalities = sum(as.numeric(FATALS)))

####################
## Let's write a function
get_county_fatalities <- function(x) {
  x$Results[[1]] %>%
    group_by(COUNTYNAME) %>%
    summarize(Total_fatalities = sum(as.numeric(FATALS)))
}

get_county_fatalities(all_county_list[[1]])
get_county_fatalities(all_county_list[[2]])

county_level_data <- lapply(all_county_list,
                            get_county_fatalities)
length(county_level_data)
str(county_level_data)
county_level_data <- bind_rows(county_level_data)
View(county_level_data)
