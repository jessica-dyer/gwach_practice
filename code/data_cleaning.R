##################################################
## Project:ABC REDCap survey
## Script purpose: Data cleaning
## Date: 2021-09-09
## Author: Jessica Dyer
##################################################
source(paste(gwach_project_wd,"/code/dependencies.R", sep = ""))

last_friday_function <- function(){
        last_friday <- Sys.Date() - wday(Sys.Date() + 1)
        
        if((Sys.Date()-last_friday)>=7){
                last_friday <- Sys.Date()
        }
        return(last_friday)
}

## CLEAN ALL FUNCTION ## 
clean_all_survey_data <- function(df, name_of_df){
        df[, "phq_score"] <- generate_phq_score(df)
        df[, "phq_category"] <- generate_phq_category(df)
        export_cleaned_data(df, name_of_df)
        return(df)
}

## PHQ 2 SCORES ## 
clean_phq <- function(df, column_name){
        df[, column_name] <- ifelse(df[, column_name] == "Not at all", 0, 
                               ifelse(df[, column_name] == "Several days", 1, 
                                      ifelse(df[, column_name] == "More than half the days", 2,
                                             ifelse(df[, column_name] == "Nearly every day", 3, NA))))
        return(df[, column_name])
}

generate_phq_score <- function(df){
        df[, "phq1"] <- clean_phq(df, "phq1")
        df[, "phq2"] <- clean_phq(df, "phq2")
        df[, "phq_score"] <- df[, "phq1"] + df[, "phq2"]
        return(df[, "phq_score"])
}

generate_phq_category <- function(df){
        df[, "phq_category"] <- ifelse(df[, "phq_score"] >= 3, "PHQ-2 >=3", "PHQ-2 <3")
        df[, "phq_category"] <- factor(df[, "phq_category"], 
                                       levels = c("PHQ-2 <3", "PHQ-2 >=3"))
        return(df[, "phq_category"])
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
                source(paste(gwach_project_wd, "/code/data_import.R", sep = ""))
                read_csv(fp_clean)
        } 
        
        if(!file.exists(fp_clean)) {
                source(paste(gwach_project_wd, "/code/data_import.R", sep = ""))
                read_csv(fp_clean)
        } else {
                read_csv(fp_clean)
        }
}