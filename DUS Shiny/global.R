# load packages -----
library(shiny)
library(shinydashboard)
library(dplyr)
library(readr)
library(here)
library(stringr)
library(PatientProfiles)
library(DT)
library(shinycssloaders)
library(shinyWidgets)
library(gt)
library(scales)
library(kableExtra)
library(tidyr)
library(stringr)
library(ggplot2)
library(fresh)
library(plotly)


# theme -----
mytheme <- create_theme(
  adminlte_color(
    light_blue = "#0c0e0c" 
  ),
  adminlte_sidebar(
    # width = "400px",
    dark_bg = "#78B7C5", #  "#D8DEE9",
    dark_hover_bg = "#3B9AB2", #"#81A1C1",
    dark_color ="white"# "#2E3440"
  ), 
  adminlte_global(
    content_bg = "#eaebea" 
  ),
  adminlte_vars(
    border_color = "#112446",
    active_link_hover_bg = "#FFF",
    active_link_hover_color = "#112446",
    active_link_hover_border_color = "#112446",
    link_hover_border_color = "#112446"
  )
)
# functions ----
nice.num3<-function(x) {
  trimws(format(x,
                big.mark=",", nsmall = 3, digits=3, scientific=FALSE))}
nice.num1<-function(x) {
  trimws(format(round(x,2),
                big.mark=",", nsmall = 1, digits=1, scientific=FALSE))}
nice.num.count<-function(x) {
  trimws(format(x,
                big.mark=",", nsmall = 0, digits=1, scientific=FALSE))}



# read in alternative grouping -----
drug_alternative <- read.csv('drug_alternatives.csv')


# unzip results -----
zip_files <- list.files(here("data"), full.names = TRUE, recursive = TRUE)
for (i in zip_files) {
  if (endsWith(tolower(i), "zip")) {
    unzip(i, exdir = dirname(i))
    file.remove(i)
  } 
}

# read results from data folder ----
results<-list.files(here("data"), recursive = TRUE,
                    full.names = TRUE)



# cdm snapshot ------
cdm_snapshot_files<-results[stringr::str_detect(results, ".csv")]
cdm_snapshot_files<-cdm_snapshot_files[stringr::str_detect(cdm_snapshot_files, "snapshot")]
cdm_snapshot <- list()
for(i in seq_along(cdm_snapshot_files)){
  cdm_snapshot[[i]]<-readr::read_csv(cdm_snapshot_files[[i]], 
                                     show_col_types = FALSE) %>% 
    select("cdm_name", "person_count", "observation_period_count" ,
           "vocabulary_version")
}
cdm_snapshot <- dplyr::bind_rows(cdm_snapshot)
cdm_snapshot <- cdm_snapshot %>% 
  mutate(person_count = nice.num.count(person_count), 
         observation_period_count = nice.num.count(observation_period_count)) %>% 
  rename("Database name" = "cdm_name",
         "Persons in the database" = "person_count",
         "Number of observation periods" = "observation_period_count",
         "OMOP CDM vocabulary version" = "vocabulary_version") %>% 
  distinct()


# incidence_attrition  ------
incidence_attrition_files<-results[stringr::str_detect(results, ".csv")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "incidence")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "attrition")]
incidence_attrition <- list()
for(i in seq_along(incidence_attrition_files)){
  incidence_attrition[[i]]<-readr::read_csv(incidence_attrition_files[[i]], 
                                            show_col_types = FALSE)
}
incidence_attrition <- dplyr::bind_rows(incidence_attrition) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name)) %>%
  filter(denominator_age_group == "0 to 150",
         denominator_sex == "Both",
         denominator_days_prior_observation == 30) %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) 


# incident patients ------
inc_patient_characteristics_files<-results[stringr::str_detect(results, ".csv")]
inc_patient_characteristics_files<-inc_patient_characteristics_files[stringr::str_detect(inc_patient_characteristics_files, "inc_demographics")]
inc_patient_characteristics <- list()
for(i in seq_along(inc_patient_characteristics_files)){
  inc_patient_characteristics[[i]]<-readr::read_csv(inc_patient_characteristics_files[[i]], 
                                                show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
inc_patient_characteristics <- dplyr::bind_rows(inc_patient_characteristics)


inc_chars_strataOpsChars <- inc_patient_characteristics %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))




# large_scale_characteristics -----
inc_large_scale_characteristics_files<-results[stringr::str_detect(results, ".csv")]
inc_large_scale_characteristics_files<-inc_large_scale_characteristics_files[stringr::str_detect(inc_large_scale_characteristics_files, "inc_lsc")]
inc_large_scale_characteristics <- list()
for(i in seq_along(inc_large_scale_characteristics_files)){
  inc_large_scale_characteristics[[i]]<-readr::read_csv(inc_large_scale_characteristics_files[[i]], 
                                                    show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
inc_large_scale_characteristics <- dplyr::bind_rows(inc_large_scale_characteristics)
table(inc_large_scale_characteristics$strata_name)


inc_lsc_strataOpsChars <- inc_large_scale_characteristics %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))



# indication -----
inc_indication_files<-results[stringr::str_detect(results, ".csv")]
inc_indication_files<-inc_indication_files[stringr::str_detect(inc_indication_files, "inc_indication")]
inc_indication <- list()
for(i in seq_along(inc_indication_files)){
  inc_indication[[i]]<-readr::read_csv(inc_indication_files[[i]], 
                                             show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
inc_indication <- dplyr::bind_rows(inc_indication)


inc_indication_strataOpsChars <- inc_indication %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))



# use -----
inc_use_summary_files<-results[stringr::str_detect(results, ".csv")]
inc_use_summary_files<-inc_use_summary_files[stringr::str_detect(inc_use_summary_files, "inc_use_summary")]
inc_use_summary <- list()
for(i in seq_along(inc_use_summary_files)){
  print(i)
  inc_use_summary[[i]]<-readr::read_csv(inc_use_summary_files[[i]], 
                                    show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
  
  if(nrow(inc_use_summary[[i]]>0)){
    inc_use_summary[[i]] <- inc_use_summary[[i]] 
  }
  
}
inc_use_summary <- dplyr::bind_rows(inc_use_summary)


inc_use_strataOpsChars <- inc_use_summary %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))




# prevalence_attrition  ------
prevalence_attrition_files<-results[stringr::str_detect(results, ".csv")]
prevalence_attrition_files<-prevalence_attrition_files[stringr::str_detect(prevalence_attrition_files, "prevalence")]
prevalence_attrition_files<-prevalence_attrition_files[stringr::str_detect(prevalence_attrition_files, "attrition")]
prevalence_attrition <- list()
for(i in seq_along(prevalence_attrition_files)){
  prevalence_attrition[[i]]<-readr::read_csv(prevalence_attrition_files[[i]], 
                                             show_col_types = FALSE) 
}
prevalence_attrition <- dplyr::bind_rows(prevalence_attrition) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name)) %>%
  filter(denominator_age_group == "0 to 150",
         denominator_sex == "Both",
         denominator_days_prior_observation == 0) %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) 


# prevalent patients  ------
prev_patient_characteristics_files<-results[stringr::str_detect(results, ".csv")]
prev_patient_characteristics_files<-prev_patient_characteristics_files[stringr::str_detect(prev_patient_characteristics_files, "prev_demographics")]
prev_patient_characteristics <- list()
for(i in seq_along(prev_patient_characteristics_files)){
  prev_patient_characteristics[[i]]<-readr::read_csv(prev_patient_characteristics_files[[i]], 
                                                    show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
prev_patient_characteristics <- dplyr::bind_rows(prev_patient_characteristics)


prev_chars_strataOpsChars <- prev_patient_characteristics %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))




# large_scale_characteristics -----
prev_large_scale_characteristics_files<-results[stringr::str_detect(results, ".csv")]
prev_large_scale_characteristics_files<-prev_large_scale_characteristics_files[stringr::str_detect(prev_large_scale_characteristics_files, "prev_lsc")]
prev_large_scale_characteristics <- list()
for(i in seq_along(prev_large_scale_characteristics_files)){
  prev_large_scale_characteristics[[i]]<-readr::read_csv(prev_large_scale_characteristics_files[[i]], 
                                                        show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
prev_large_scale_characteristics <- dplyr::bind_rows(prev_large_scale_characteristics)
table(prev_large_scale_characteristics$strata_name)


prev_lsc_strataOpsChars <- prev_large_scale_characteristics %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))




# indication -----
prev_indication_files<-results[stringr::str_detect(results, ".csv")]
prev_indication_files<-prev_indication_files[stringr::str_detect(prev_indication_files, "prev_indication")]
prev_indication <- list()
for(i in seq_along(prev_indication_files)){
  prev_indication[[i]]<-readr::read_csv(prev_indication_files[[i]], 
                                       show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
}
prev_indication <- dplyr::bind_rows(prev_indication)


prev_indication_strataOpsChars <- prev_indication %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))




# use -----
prev_use_summary_files<-results[stringr::str_detect(results, ".csv")]
prev_use_summary_files<-prev_use_summary_files[stringr::str_detect(prev_use_summary_files, "prev_use_summary")]
prev_use_summary <- list()
for(i in seq_along(prev_use_summary_files)){
  print(i)
  prev_use_summary[[i]]<-readr::read_csv(prev_use_summary_files[[i]], 
                                        show_col_types = FALSE) %>%
    mutate(estimate_value = as.numeric(estimate_value)) %>%
    mutate(estimate_value = round(estimate_value,1)) %>%
    select(-"group_level") %>%
    rename(group_level = outcome_cohort_name,
           estimate = estimate_value) %>%
    relocate(group_level, .after = group_name)
  
  if(nrow(prev_use_summary[[i]]>0)){
    prev_use_summary[[i]] <- prev_use_summary[[i]] 
  }
  
}
prev_use_summary <- dplyr::bind_rows(prev_use_summary)



prev_use_strataOpsChars <- prev_use_summary %>%
  dplyr::select("strata_name", "strata_level") %>%
  dplyr::distinct() %>%
  dplyr::mutate(strata = paste0(strata_name, ": ", strata_level))



