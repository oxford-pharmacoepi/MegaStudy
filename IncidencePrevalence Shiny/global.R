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

# read results from data folder ----
results<-list.files(here("data"), recursive = TRUE,
                    full.names = TRUE)

# cdm snapshot ------
cdm_snapshot_files<-results[stringr::str_detect(results, ".csv")]
cdm_snapshot_files<-results[stringr::str_detect(results, "snapshot")]
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

# incidence ------
incidence_files<-results[stringr::str_detect(results, ".csv")]
incidence_files<-incidence_files[stringr::str_detect(incidence_files, "Incidence")]
incidence <- list()
for(i in seq_along(incidence_files)){
  incidence[[i]]<-readr::read_csv(incidence_files[[i]], 
                                  show_col_types = FALSE) 
}
incidence <- dplyr::bind_rows(incidence) 
incidence <- dplyr::bind_rows(incidence) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name))
# prevalence  ------
prevalence_files<-results[stringr::str_detect(results, ".csv")]
prevalence_files<-prevalence_files[stringr::str_detect(prevalence_files, "Prevalence")]
prevalence <- list()
for(i in seq_along(prevalence_files)){
  prevalence[[i]]<-readr::read_csv(prevalence_files[[i]], 
                                   show_col_types = FALSE) 
}
prevalence <- dplyr::bind_rows(prevalence) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name))
