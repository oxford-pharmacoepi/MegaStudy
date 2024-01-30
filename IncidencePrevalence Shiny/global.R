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
binomialCiWilson <- function(x, n) {
  alpha <- 0.05
  p <- x / n
  q <- 1 - p
  z <- stats::qnorm(1 - alpha / 2)
  t1 <- (x + z^2 / 2) / (n + z^2)
  t2 <- z * sqrt(n) / (n + z^2) * sqrt(p * q + z^2 / (4 * n))
  return(dplyr::tibble(
    incidence_proportion_95CI_lower = t1 - t2,
    incidence_proportion_95CI_upper = t1 + t2
  ))
}



# helper functions

plotEstimates <- function(result,
                          x,
                          y,
                          yLower,
                          yUpper,
                          ylim,
                          ytype,
                          ribbon,
                          facet,
                          colour,
                          colour_name) {
  errorMessage <- checkmate::makeAssertCollection()
  checkmate::assertTRUE(inherits(result, "IncidencePrevalenceResult"))
  checkmate::assertTRUE(all(c(x, y) %in% colnames(result)))
  checkmate::reportAssertions(collection = errorMessage)
  
  plot_data <- getPlotData(
    estimates = result,
    facetVars = facet,
    colourVars = colour
  )
  
  if (is.null(colour)) {
    plot <- plot_data %>%
      ggplot2::ggplot(
        ggplot2::aes(
          x = !!rlang::sym(x),
          y = !!rlang::sym(y)
        )
      )
  } else {
    plot <- plot_data %>%
      ggplot2::ggplot(
        ggplot2::aes(
          x = !!rlang::sym(x),
          y = !!rlang::sym(y),
          group = .data$colour_vars,
          colour = .data$colour_vars,
          fill = .data$colour_vars
        )
      ) +
      ggplot2::geom_point(size = 2.5) +
      ggplot2::labs(
        fill = colour_name,
        colour = colour_name
      )
  }
  
  plot <- plot +
    ggplot2::geom_point(size = 2.5) +
    ggplot2::geom_errorbar(
      ggplot2::aes(
        ymin = !!rlang::sym(yLower),
        ymax = !!rlang::sym(yUpper)
      ),
      width = 0
    )
  
  if (is.null(ylim)) {
    if (ytype == "count") {
      plot <- plot +
        ggplot2::scale_y_continuous(labels = scales::comma)
    }
    if (ytype == "percentage") {
      plot <- plot +
        ggplot2::scale_y_continuous(
          labels =
            scales::percent_format(accuracy = 0.1)
        )
    }
  } else {
    plot <- addYLimits(plot = plot, ylim = ylim, ytype = ytype)
  }
  
  if (!is.null(facet)) {
    plot <- plot +
      ggplot2::facet_wrap(ggplot2::vars(.data$facet_var)) +
      ggplot2::theme_bw()
  } else {
    plot <- plot +
      ggplot2::theme_minimal()
  }
  
  if (isTRUE(ribbon)) {
    plot <- addRibbon(plot = plot, yLower = yLower, yUpper = yUpper)
  }
  
  
  
  plot <- plot
  
  return(plot)
}


getPlotData <- function(estimates, facetVars, colourVars) {
  plotData <- estimates
  if (!is.null(facetVars)) {
    plotData <- plotData %>%
      tidyr::unite("facet_var",
                   c(tidyselect::all_of(.env$facetVars)),
                   remove = FALSE, sep = "; "
      )
  }
  if (!is.null(colourVars)) {
    plotData <- plotData %>%
      tidyr::unite("colour_vars",
                   c(tidyselect::all_of(.env$colourVars)),
                   remove = FALSE, sep = "; "
      )
  }
  
  return(plotData)
}

addYLimits <- function(plot, ylim, ytype) {
  if (ytype == "count") {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels = scales::comma,
        limits = ylim
      )
  }
  if (ytype == "percentage") {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels =
          scales::percent_format(accuracy = 0.1),
        limits = ylim
      )
  }
  return(plot)
}

addRibbon <- function(plot, yLower, yUpper) {
  plot <- plot +
    ggplot2::geom_ribbon(
      ggplot2::aes(
        ymin = !!rlang::sym(yLower),
        ymax = !!rlang::sym(yUpper)
      ),
      alpha = .3, color = NA, show.legend = FALSE
    ) +
    ggplot2::geom_line(linewidth = 0.25)
}


plotIncidenceProportion <- function(result,
                          x = "incidence_start_date",
                          ylim = c(0, NA),
                          ribbon = FALSE,
                          facet = NULL,
                          colour = NULL,
                          colour_name = NULL) {
  plotEstimates(
    result = result,
    x = x,
    y = "incidence_proportion",
    yLower = "incidence_proportion_95CI_lower",
    yUpper = "incidence_proportion_95CI_upper",
    ylim = ylim,
    ytype = "count",
    ribbon = ribbon,
    facet = facet,
    colour = colour,
    colour_name = colour_name
  )
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

# incidence ------
incidence_files<-results[stringr::str_detect(results, ".csv")]
incidence_files<-incidence_files[stringr::str_detect(incidence_files, "incidence")]
incidence_files<-incidence_files[stringr::str_detect(incidence_files, "attrition", negate = TRUE)]
incidence <- list()
for(i in seq_along(incidence_files)){
  incidence[[i]]<-readr::read_csv(incidence_files[[i]], 
                                  show_col_types = FALSE)
}
inc <- dplyr::bind_rows(incidence) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name)) %>% 
  filter(n_events > 0) %>%
  mutate(incidence_proportion = n_events / n_persons)
incidence <- inc %>%  
  dplyr::bind_cols(binomialCiWilson(inc$n_events,inc$n_persons))
  

# incidence_attrition  ------
incidence_attrition_files<-results[stringr::str_detect(results, ".csv")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "incidence")]
incidence_attrition_files<-incidence_attrition_files[stringr::str_detect(incidence_attrition_files, "attrition")]
incidence_attrition <- list()
for(i in seq_along(incidence_attrition_files)){
  incidence_attrition[[i]]<-readr::read_csv(incidence_attrition_files[[i]], 
                                            show_col_types = FALSE) %>% select(-"excluded_subjects",-"excluded_records")
}
incidence_attrition <- dplyr::bind_rows(incidence_attrition) %>% 
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name)) %>%
  filter(denominator_age_group == "0 to 150",
         denominator_sex == "Both") %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) 


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
  mutate(denominator_target_cohort_name = if_else(is.na(denominator_target_cohort_name),
                                                  "General population",
                                                  denominator_target_cohort_name)) 

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
         denominator_sex == "Both") %>%
  select(c("cdm_name", "reason","outcome_cohort_name", 
           "number_subjects")) 
 