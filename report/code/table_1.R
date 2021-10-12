##################################################
## Project: GWACH Practice Project
## Script purpose: Table 1
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

source(paste(gwach_project_wd,"/data/code/data_import.R", sep = ""))

table_1 <- 
        gwach_data_clean %>%
        select(gender, age, phq_category) %>%
        tbl_summary(
                label = list(gender = "Gender", age = "Age", phq_category = "PHQ-2 Category")
        )