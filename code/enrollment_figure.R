##################################################
## Project: GWACh practice
## Script purpose: Enrollment figure
## Date: 2021-10-11
## Author: Jessica Dyer
##################################################

current_wd <- getwd()

if (endsWith(current_wd, "gwach_practice")) {
  gwach_project_wd <- current_wd
} else if (endsWith(current_wd, "/report")) {
  gwach_project_wd <- str_remove(current_wd, "/report")
} else {
  message("Got a WD that's not handled in the If-else ladder yet")
}

data <-
  gwach_data_clean %>%
  select(visit_date)

data$visit_date <- as.Date(data$visit_date)

## GENERATE A WEEK VARIABLE (WEEK STARTS ON MONDAYS)
data$week <- as.Date(cut(data$visit_date,
  breaks = "week"
))

## GENERATE ENROLLMENT NUMBERS PER WEEK
cumulative_enroll <- data.frame(table(data$week))

## GENERATE CUMULATIVE ENROLLMENT OVER TIME
cumulative_enroll <-
  cumulative_enroll %>%
  arrange(Var1) %>%
  mutate(cumsum = cumsum(Freq))

#### GENERATE GRAPH THAT SHOWS ENROLLMENT BY WEEK ####
x <- list(
  title = "Enrollment week"
)

y <- list(
  title = "Cumulative sum"
)

enrollment_by_week <-
  plot_ly(cumulative_enroll,
    x = ~Var1,
    y = ~Freq,
    type = "scatter",
    mode = "lines",
    colors = viridis_pal(option = "D")(3)
  )

#### GENERATE FIGURE THAT SHOWS CUMULATIVE ENROLLMENT OVER TIME ####
cumulative_enrollment <-
  plot_ly(cumulative_enroll,
    x = ~Var1,
    y = ~cumsum,
    type = "scatter",
    mode = "lines",
    colors = viridis_pal(option = "D")(3)
  )

#### FUNCTION THAT GIVES YOU AVERAGE NUMBER OF ENROLLMENTS PER WEEK SINCE START ####
average_enrollment_per_week <- function(df = cumulative_enroll) {
  mean_enrollments <- floor(mean(cumulative_enroll$Freq))
  return(mean_enrollments)
}

#### FUNCTION THAT GIVES YOU WHEN YOU WILL MEET YOUR GOAL IF YOU CONTINUE WITH ENROLLMENT RATE TO DATE ####
when_meet_enrollment_goal_current_rate <- function(enrollment_goal = 3000){
        average_to_date <- average_enrollment_per_week()
        ## calculate remaining enrollments
        enrollments_needed <- enrollment_goal - nrow(gwach_data_clean)
        
        ## calculate the number of weeks needed to reach goal
        weeks_needed <- floor(enrollments_needed/average_to_date)
        
        ## calculate end date
        end_date <- as.Date(Sys.Date()) + weeks(weeks_needed)
        # time_interval <- interval(start = Sys.Date(), end = end_date)
        # weeks_between <- time_length(time_interval, "weeks")
        return(end_date)
}

#### FUNCTION THAT TELLS YOU HOW MANY ENROLLMENTS YOU NEED TO AVERAGE PER WEEK TO REACH GOAL
calculate_average_needed_to_reach_goal <- function(df = cumulative_enrollment, end_date, enrollment_goal, print_nice = FALSE) {
  ## calculate remaining enrollments
  enrollments_needed <- enrollment_goal - nrow(gwach_data_clean)

  ## calculate number of weeks remaining until end_date
  end_date <- as.Date(end_date)
  time_interval <- interval(start = Sys.Date(), end = end_date)
  weeks_between <- time_length(time_interval, "weeks")
  ## divide the number of remaining enrollments by number of weeks remaining
  avg_num_per_week <- floor(enrollments_needed / weeks_between)
  nice_message <- glue("In order to reach your goal of {enrollment_goal} enrollments, your team will need to
                             enroll an average of {avg_num_per_week} people per week from now through {end_date}.

                             You can do it!")
  if(print_nice){
          return(nice_message)
  }
  return(avg_num_per_week)
}