##################################################
## Project:ABC REDCap survey
## Script purpose: Data cleaning
## Date: 2021-09-09
## Author: Jessica Dyer
##################################################
source(paste(gwach_project_wd,"/data/code/dependencies.R", sep = ""))

last_friday_function <- function(){
        last_friday <- Sys.Date() - wday(Sys.Date() + 1)
        
        if((Sys.Date()-last_friday)>=7){
                last_friday <- Sys.Date()
        }
        return(last_friday)
}

## CLEAN ALL FUNCTIONS ## 
clean_all_survey_data <- function(df, name_of_df){
        export_cleaned_data(df, name_of_df)
}


## EXPORT CLEAN DATA SET FUNCTION ## 
export_cleaned_data <- function(df, name_of_df){
        fp <- paste(gwach_project_wd, "/data/clean_data/", name_of_df, "_clean_", last_friday, ".csv", sep = "")
        write.csv(df, fp)
}

## LOAD CLEAN DATA SET FUNCTION ## 
load_cleaned_data <- function(name_of_df){
        fp_raw <- paste(gwach_project_wd, "/data/raw_data/", name_of_df, "_", last_friday, ".csv", sep = "")
        fp_clean <- paste(gwach_project_wd, "/data/clean_data/", name_of_df, "_clean_", last_friday, ".csv", sep = "")
        
        if(!file.exists(fp_raw)){
                source(paste(gwach_project_wd, "/data/code/data_import.R", sep = ""))
                read_csv(fp_clean)
        } 
        
        if(!file.exists(fp_clean)) {
                source(paste(gwach_project_wd, "/data/code/data_import.R", sep = ""))
                read_csv(fp_clean)
        } else {
                read_csv(fp_clean)
        }
}