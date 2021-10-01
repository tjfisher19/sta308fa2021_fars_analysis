#######################################
## sta308_week06_day16_ohioPops.R
##
## Bailer/Fisher
##
## Important!!!!
##    - Save this .R file into the folder with your 
##      Day 15 Project, likely called 
##      sta308_day15_assignemnt-userID
##    - Make sure you have edited and completed the 
##      data processing in sta308_week06_day15_starter.R
##      You should have the resulting data.frame in your
##      environment to complete this part of the assignment.
##
## This R code is provided to streamline
##   the discussion for day 16 of STA 308.
##
## The code provided below should be familiar...
##   We read in county-level census data
##   and extract the population of each county of Ohio
##
## At the end of this file, write code that merges
##   the county-level vehicle fatality data with the
##   population data included here. Explore the
##   relationship between population and fatalities, adjust
##   as appropriate and explore which counties seem most
##   dangerous.

## The processed data from Day 15 is called
##    county_level_data

#### Fetch the US Census data
OhioPop <- 
  read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/asrh/cc-est2019-agesex-39.csv") 

##################################
## Extract the most recent year with filter (12==2019)
## Get the county names and drop the word " County"
## Select the county names and corresponding populations
##
OhioCountyPop <- OhioPop %>% 
  filter(YEAR == 12) %>% 
  mutate(County = str_remove(CTYNAME, " County") ) %>% 
  select(County, Population=POPESTIMATE) 
glimpse(OhioCountyPop)


#####################
## Below, edit the character string from the
##   county-level fatality data and merge
##   it will the population data from above.

glimpse(county_level_data)

## First, let's remove the parenthesis (punctuation)
county_level_data %>%
  mutate(County2 = str_remove_all(COUNTYNAME, "[:punct:]"),
         County3 = str_remove_all(County2, "[:digit:]"),
         County4 = str_trim(County3),
         County5 = str_to_title(County4)) %>%
  glimpse()

county_level_data2 <- county_level_data %>%
  mutate(County2 = str_remove_all(COUNTYNAME, "[:punct:]"),
         County3 = str_remove_all(County2, "[:digit:]"),
         County4 = str_trim(County3),
         County5 = str_to_title(County4)) %>%
  select(County5, Total_fatalities)
View(county_level_data2)


## Merge the two datasets together
ohioCountyFatalPop <- merge(county_level_data2,
                            OhioCountyPop,
                            by.x="County5",
                            by.y="County")

View(ohioCountyFatalPop)

plot(ohioCountyFatalPop[,2:3])
plot(ohioCountyFatalPop[,3:2])

### Let's calculate the rate of fatalities
## Using population as a proxy for roadways & traffic, etc...

ohioCountyFatalPop %>%
  mutate(Fatality_rate = Total_fatalities/Population*10000) %>%
  arrange(Fatality_rate) %>%
  slice(1:15)

ohioCountyFatalPop %>%
  mutate(Fatality_rate = Total_fatalities/Population*10000) %>%
  arrange(desc(Fatality_rate)) %>%
  slice(1:15)
