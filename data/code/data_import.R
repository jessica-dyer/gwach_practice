##################################################
## Project: GWACH Practice Project
## Script purpose: Data Import
## Date: 2021-09-16
## Author: Jessica Dyer
##################################################

#### MANAGE FILE PATHS RELATIVE TO ROOT ####
current_wd <- getwd()

if(endsWith(current_wd, "gwach_practice")){
        gwach_project_wd <- current_wd
} else if (endsWith(current_wd, "/report")) {
        gwach_project_wd <- str_remove(current_wd, "/report")
} else {
        message("Got a WD that's not handled in the If-else ladder yet")
}

source(paste(gwach_project_wd,"/data/code/dependencies.R", sep = ""))
source(paste(gwach_project_wd, "/data/code/data_cleaning.R", sep = ""))

# EACH PERSON SHOULD HAVE A LOCAL R SCRIPT CALLED "keys.R" THAT YOU CAN SOURCE
# SHOULD BE IN CODE FOLDER. GIT IS IGNORING THIS FILE NAME
source(paste(gwach_project_wd,"/data/code/keys.R", sep = ""))

#### GET DATE OF LAST FRIDAY ####
last_friday <- Sys.Date() - wday(Sys.Date() + 1)

if((Sys.Date()-last_friday)>=7){
        last_friday <- Sys.Date()
}

#### Function to retrieve data from REDCap ####
import_redcap_data <- function(token_str){
        redcap_read(redcap_uri='https://redcap.iths.org/api/',
                    token=token_str,
                    raw_or_label = "label",
                    export_checkbox_label = TRUE
        )$data
}

#### Survey Data ####
gwach_data <- import_redcap_data(token)

#### WRITE DATA TO CSV FILE EVERY FRIDAY ####
## IF LAST FRIDAY'S DATA DOES NOT EXIST, WE'LL WRITE THE DATA TO CSV FOR A BACKUP. IF IT DOES EXIST, WE'LL JUST WORK WITH THE 
## DATA CALLED THROUGH API BUT NOT EXPORT. 

if(!file.exists(paste(current_wd, "/data/raw_data/gwach_data_", last_friday, ".csv", sep = ""))){
        write.csv(gwach_data, paste(current_wd, "/data/raw_data/gwach_data_", last_friday, ".csv", sep = ""))
}

#### CLEAN SURVEY DATA #### 
gwach_data_clean <- clean_all_survey_data(gwach_data, "gwach_survey")