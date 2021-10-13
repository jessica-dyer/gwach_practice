##################################################
## Project: GWACh Practice
## Script purpose: Table 1
## Date: 2021-10-11
## Author: Jessica Dyer
##################################################

current_wd <- getwd()

if(endsWith(current_wd, "gwach_practice")){
        gwach_project_wd <- current_wd
} else if (endsWith(current_wd, "/report")) {
        gwach_project_wd <- str_remove(current_wd, "/report")
} else {
        message("Got a WD that's not handled in the If-else ladder yet")
}

if(!exists("gwach_data")){
        source(paste(gwach_project_wd,"/code/data_import.R", sep = ""))
}

create_variable_properties_list <- function(var_name_arg, 
                                            var_label_arg){
        return(list(
                var_name = var_name_arg, 
                var_label = var_label_arg))
}

demo_variable_properties_list <- list(
        gender = create_variable_properties_list('gender', 'Gender'), 
        age = create_variable_properties_list('age', 'Age (years)'), 
        visit_type = create_variable_properties_list('visit_type', 'Visit type'), 
        phq_category = create_variable_properties_list('phq_category', 'PHQ-2 category')
)



generate_labeled_df_for_table_1 <- function(df = gwach_data_clean, properties){
        demographic_vars <- NULL
        for(var in properties){
                demographic_vars <- append(demographic_vars, var$var_name)     
        }
        
        temp <- 
             df %>% 
             select(all_of(demographic_vars))
        
        demographic_vars_labels <- NULL
        for(var in properties){
                demographic_vars_labels <- append(demographic_vars_labels, var$var_label)
        }
        
        names(temp) <- demographic_vars_labels
     
     return(temp)
}


table_1 <-
        gwach_data_clean %>%
        generate_labeled_df_for_table_1(properties = demo_variable_properties_list) %>%
        tbl_summary(
           # by = demo_variable_properties_list$visit_type$var_label
        ) %>%
        add_n()

table_1_ft <- table_1 %>%
        as_flex_table()