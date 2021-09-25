# sta308fa2021_fars_analysis

This repository contains code that accesses data from the National Highway Traffic Safety Administration (NHTSA) Fatality Analysis Reporting System (FARS) program API.

The FARS data contains information on motor vehicle crashes in the United States that result in a death.

In this short program we query the API to collect all crashes involving a death in every county in Ohio for 2019.

Ultimately we will merge the data from the API with Ohio county-level population data from the US Census and perform a short analysis.

## API Details

The FARS API is publicly available and instructions for accessing the API can be found here: https://crashviewer.nhtsa.dot.gov/CrashAPI

We will be obtaining crash-level information for all counties in Ohio from 2019. 
The API requires we enter the FIPS code for each county, the list of counties and FIPS codes can be found here: https://en.wikipedia.org/wiki/List_of_counties_in_Ohio.
Note that the county FIPS codes are odd numbered, 1, 3, 5, .... 165, 167, ...., 175.



