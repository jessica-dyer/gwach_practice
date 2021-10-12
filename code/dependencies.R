##################################################
## Project: Jessica Dyer
## Script purpose: Libraries for project
## Date: 2021-08-26
## Author: Jessica Dyer
##################################################


packages <- c("redcapAPI", "dplyr", "ggplot2", "DiagrammeR", "tidyverse", "Hmisc", "tibble", 
              "REDCapR", "lubridate", "plotly", "viridis", "gtsummary")

new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load packages
invisible(lapply(packages, library, character.only = TRUE))