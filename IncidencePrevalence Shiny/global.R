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
library(IncidencePrevalence)

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

# read in data type for each database ------
databases <- read.csv('databases.csv')

# read in the database names for display -----
names <- read.csv('meta_names_incprev.csv')

# read in drug names for display ------
drugs <- read.csv('meta_drugs_incprev.csv')


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
  left_join(names %>% select("cdm_name","display_name","display_name_full"), by = c("cdm_name")) %>% 
  select(-"cdm_name") %>%
  rename("Database name - acronym" = "display_name",
         "Database name - full" = "display_name_full",
         "Persons in the database" = "person_count",
         "Number of observation periods" = "observation_period_count",
         "OMOP CDM vocabulary version" = "vocabulary_version") %>% 
  select("Database name - acronym",
         "Database name - full",
         "Persons in the database",
         "Number of observation periods",
         "OMOP CDM vocabulary version") %>%
  distinct() 

# incidence ------
incidence_files<-results[stringr::str_detect(results, ".csv")]
incidence_files<-incidence_files[stringr::str_detect(incidence_files, "incidence")]
incidence_files<-incidence_files[stringr::str_detect(incidence_files, "attrition", negate = TRUE)]
incidence <- list()
for(i in seq_along(incidence_files)){
  incidence[[i]]<-readr::read_csv(incidence_files[[i]], 
                                  show_col_types = FALSE)
}
incidence <- dplyr::bind_rows(incidence) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name) |
                                                    denominator_target_cohort_name == "None",
                                                  "General population",
                                                  denominator_target_cohort_name)) %>% 
  filter(n_events > 0,
         denominator_days_prior_observation == 30,
         incidence_start_date <= "2024-01-01")  %>%
  left_join(drug_alternative, by = "outcome_cohort_name") %>%
  left_join(databases, by = "cdm_name") %>%
  left_join(names %>% select("cdm_name","display_name","display_name_full"), by = c("cdm_name")) %>% 
  mutate(cdm_name = display_name) %>%
  select(-c("display_name_full","display_name","Extra_info")) %>%
  left_join(drugs, by = c("outcome_cohort_name")) %>% 
  mutate(outcome_cohort_name = display_drug) %>%
  select(-"display_drug")


# incidence_attrition  ------
incidence_attrition_files<-results[stringr::str_detect(results, ".csv")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "incidence")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "attrition")]
incidence_attrition <- list()
for(i in seq_along(incidence_attrition_files)){
  incidence_attrition[[i]]<-readr::read_csv(incidence_attrition_files[[i]], 
                                            show_col_types = FALSE)  %>%
    mutate(number_subjects = as.character(number_subjects)) %>%
    select(c("cdm_name", "reason","outcome_cohort_name", 
             "number_subjects","denominator_target_cohort_name",
             "denominator_age_group","denominator_sex","denominator_days_prior_observation"))
}
incidence_attrition <- dplyr::bind_rows(incidence_attrition) %>%
  left_join(names %>% select("cdm_name","display_name","display_name_full"), by = c("cdm_name")) %>% 
  mutate(cdm_name = display_name,
         denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name) |
                                                    denominator_target_cohort_name == "None",
                                                  "General population",
                                                  denominator_target_cohort_name)) %>% 
  filter(denominator_age_group == "0 to 150",
         denominator_sex == "Both",
         denominator_days_prior_observation == 30) %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) %>%
  left_join(drugs, by = c("outcome_cohort_name")) %>% 
  mutate(outcome_cohort_name = display_drug) %>%
  select(-"display_drug") %>%
  distinct()


# prevalence  ------
prevalence_files<-results[stringr::str_detect(results, ".csv")]
prevalence_files<-prevalence_files[stringr::str_detect(prevalence_files, "prevalence")]
prevalence_files<-prevalence_files[stringr::str_detect(prevalence_files, "attrition", negate = TRUE)]
prevalence <- list()
for(i in seq_along(prevalence_files)){
  prevalence[[i]]<-readr::read_csv(prevalence_files[[i]], 
                                   show_col_types = FALSE) 
}
prevalence <- dplyr::bind_rows(prevalence) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name) |
                                                    denominator_target_cohort_name == "None",
                                                  "General population",
                                                  denominator_target_cohort_name)) %>% 
  filter(n_cases > 0,
         denominator_days_prior_observation == 0,
         prevalence_start_date <= "2024-01-01")  %>%
  left_join(drug_alternative, by = "outcome_cohort_name") %>%
  left_join(databases, by = "cdm_name") %>%
  left_join(names %>% select("cdm_name","display_name","display_name_full"), by = c("cdm_name")) %>% 
  mutate(cdm_name = display_name) %>%
  select(-c("display_name_full","display_name","Extra_info")) %>%
  left_join(drugs, by = c("outcome_cohort_name")) %>% 
  mutate(outcome_cohort_name = display_drug) %>%
  select(-"display_drug")


# prevalence_attrition  ------
prevalence_attrition_files<-results[stringr::str_detect(results, ".csv")]
prevalence_attrition_files<-prevalence_attrition_files[stringr::str_detect(prevalence_attrition_files, "prevalence")]
prevalence_attrition_files<-prevalence_attrition_files[stringr::str_detect(prevalence_attrition_files, "attrition")]
prevalence_attrition <- list()
for(i in seq_along(prevalence_attrition_files)){
  prevalence_attrition[[i]]<-readr::read_csv(prevalence_attrition_files[[i]], 
                                             show_col_types = FALSE)  %>%
    mutate(number_subjects = as.character(number_subjects)) %>%
    select(c("cdm_name", "reason","outcome_cohort_name", 
             "number_subjects","denominator_target_cohort_name",
             "denominator_age_group","denominator_sex","denominator_days_prior_observation")) 
}
prevalence_attrition <- dplyr::bind_rows(prevalence_attrition) %>%
  left_join(names %>% select("cdm_name","display_name","display_name_full"), by = c("cdm_name")) %>% 
  mutate(cdm_name = display_name, 
         denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name) |
                                                    denominator_target_cohort_name == "None",
                                                  "General population",
                                                  denominator_target_cohort_name)) %>% 
  filter(denominator_age_group == "0 to 150",
         denominator_sex == "Both",
         denominator_days_prior_observation == 0) %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) %>%
  left_join(drugs, by = c("outcome_cohort_name")) %>% 
  mutate(outcome_cohort_name = display_drug) %>%
  select(-"display_drug") %>%
  distinct()