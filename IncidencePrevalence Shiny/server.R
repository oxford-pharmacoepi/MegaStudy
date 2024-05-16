source("global.R")

# server shiny ----
server <- function(input, output, session) {

  
  # cdm snapshot ----
  output$tbl_cdm_snaphot <- renderText(kable(cdm_snapshot) %>%
                                         kable_styling("striped", full_width = F) )
  
  output$gt_cdm_snaphot_word <- downloadHandler(
    filename = function() {
      "cdm_snapshot.docx"
    },
    content = function(file) {
      x <- gt(cdm_snapshot)
      gtsave(x, file)
    }
  )
  
  # incidence_attrition ----
  getIncAtt <- reactive({
    
    incidence_attrition %>% 
      filter(cdm_name %in% input$incidence_attrition_cdm_name,
             outcome_cohort_name %in% input$incidence_attrition_outcome_cohort_name) %>%
      pivot_wider(names_from = cdm_name, values_from = number_subjects) 
    
  })
  ### download table ----
  output$incidence_attrition_download_table <- downloadHandler(
    filename = function() {
      "incidence_attrition_Table.csv"
    },
    content = function(file) {
      write_csv(getIncAtt(), file)
    }
  )
  ### table estimates ----
  output$dt_incidence_attrition <- renderDataTable({
    datatable(getIncAtt(),
              rownames = FALSE,
              extensions = "Buttons",
              options = list(scrollX = TRUE, scrollCollapse = TRUE, pageLength = 11)
    )
  })


  # prevalence_attrition ----
  getPrevAtt <- reactive({
    
    prevalence_attrition %>% 
      filter(cdm_name %in% input$prevalence_attrition_cdm_name,
             outcome_cohort_name %in% input$prevalence_attrition_outcome_cohort_name) %>%
      pivot_wider(names_from = cdm_name, values_from = number_subjects) 
    
  })
  ### download table ----
  output$prevalence_attrition_download_table <- downloadHandler(
    filename = function() {
      "prevalence_attrition_Table.csv"
    },
    content = function(file) {
      write_csv(getPrevAtt(), file)
    }
  )
  ### table estimates ----
  output$dt_prevalence_attrition <- renderDataTable({
    datatable(getPrevAtt(),
              rownames = FALSE,
              extensions = "Buttons",
              options = list(scrollX = TRUE, scrollCollapse = TRUE, pageLength = 11)
    )
  })
  
  ## incidence_estimates ----
  ### get estimates ----
  getincidence <- reactive({
    incidence %>%   
      filter(cdm_name %in% input$incidence_estimates_cdm_name) %>%
      filter(outcome_cohort_name %in% input$incidence_estimates_outcome_cohort_name) %>%
      filter(group %in% input$incidence_estimates_group) %>%
      filter(data_type %in% input$incidence_estimates_data_type) %>%
      filter(country %in% input$incidence_estimates_country) %>%
      filter(denominator_target_cohort_name %in% input$incidence_estimates_denominator_target_cohort_name) %>%
      filter(denominator_age_group %in% input$incidence_estimates_denominator_age_group) %>%
      filter(denominator_sex %in% input$incidence_estimates_denominator_sex) %>%
      filter(denominator_days_prior_observation %in% input$incidence_estimates_denominator_days_prior_observation) %>%
      filter(analysis_outcome_washout %in% input$incidence_estimates_analysis_outcome_washout) %>%
      filter(analysis_repeated_events %in% input$incidence_estimates_analysis_repeated_events) %>%
      filter(analysis_complete_database_intervals %in% input$incidence_estimates_analysis_complete_database_intervals) %>%
      filter(analysis_interval %in% input$incidence_estimates_analysis_interval) %>%
      filter(incidence_start_date %in% as.Date(input$incidence_estimates_incidence_start_date)) %>%
      mutate(
        person_years = round(suppressWarnings(as.numeric(person_years))),
        n_events = round(suppressWarnings(as.numeric(n_events))),
        incidence_100000_pys = round(suppressWarnings(as.numeric(incidence_100000_pys)),3),
        incidence_100000_pys_95CI_lower = round(suppressWarnings(as.numeric(incidence_100000_pys_95CI_lower)),3),
        incidence_100000_pys_95CI_upper = round(suppressWarnings(as.numeric(incidence_100000_pys_95CI_upper)),3)
        ) 
  })
  ### download table ----
  output$incidence_estimates_download_table <- downloadHandler(
    filename = function() {
      "incidenceTable.csv"
    },
    content = function(file) {
      write_csv(getincidence(), file)
    }
  )
  ### table estimates ----
  output$incidence_estimates_table <- renderDataTable({
    table <- getincidence()
    validate(need(nrow(table) > 0, "No results for selected inputs"))
    table <- table %>%
      mutate(incidence_100000_pys = paste0(
        incidence_100000_pys, " (", incidence_100000_pys_95CI_lower, " to ",
        incidence_100000_pys_95CI_upper, " )"
      )) %>%
      select(cdm_name, outcome_cohort_name, denominator_target_cohort_name, denominator_age_group, denominator_sex, denominator_days_prior_observation, denominator_start_date, denominator_end_date, analysis_outcome_washout, analysis_repeated_events, analysis_complete_database_intervals, analysis_min_cell_count, analysis_interval, incidence_start_date, n_events, n_persons, incidence_100000_pys)
    datatable(
      table,
      rownames = FALSE,
      extensions = "Buttons",
      options = list(scrollX = TRUE, scrollCollapse = TRUE)
    )
  })
  ### make plot ----
  plotincidence <- reactive({
    table <- getincidence()
    validate(need(nrow(table) > 0, "No results for selected inputs"))
    class(table) <- c("IncidenceResult", "IncidencePrevalenceResult", class(table))
    plotIncidence(
      table,
      x = input$incidence_estimates_plot_x,
      ylim = c(0, NA),
      facet = input$incidence_estimates_plot_facet,
      colour = input$incidence_estimates_plot_colour,
      colour_name = paste0(input$incidence_estimates_plot_colour, collapse = "; "),
      ribbon = FALSE
    )
  })
  ### download plot ----
  output$incidence_estimates_download_plot <- downloadHandler(
    filename = function() {
      "incidencePlot.png"
    },
    content = function(file) {
      ggsave(
        file,
        plotincidence(),
        width = as.numeric(input$incidence_estimates_download_width),
        height = as.numeric(input$incidence_estimates_download_height),
        dpi = as.numeric(input$incidence_estimates_download_dpi),
        units = "cm"
      )
    }
  )
  ### plot ----
  output$incidence_estimates_plot <- renderPlotly({
    plotincidence()
   })
  
  ### update dropdowns
  observeEvent(input$incidence_estimates_group, {
    # Filter the data based on the selected groups
    filtered_incidence <- incidence[incidence$group %in% input$incidence_estimates_group,]


    unique_cdm_names <- sort(unique(filtered_incidence$cdm_name))
    unique_outcome_cohort_names <- sort(unique(filtered_incidence$outcome_cohort_name))
    unique_data_types <- sort(unique(filtered_incidence$data_type))
    unique_countries <- sort(unique(filtered_incidence$country))


    updatePickerInput(session, inputId = "incidence_estimates_cdm_name",
                         choices = unique_cdm_names,
                         selected = unique_cdm_names)
    
    updatePickerInput(session, inputId = "incidence_estimates_outcome_cohort_name",
                      choices = unique_outcome_cohort_names,
                      selected = unique_outcome_cohort_names)
    
    updatePickerInput(session, inputId = "incidence_estimates_data_type",
                      choices = unique_data_types,
                      selected = unique_data_types)
    
    updatePickerInput(session, inputId = "incidence_estimates_country",
                      choices = unique_countries,
                      selected = unique_countries)
  })


  
  ## prevalence_estimates ----
  ### get estimates ----
  getprevalence <- reactive({
    prevalence %>%
      filter(n_cases >0) %>%
      filter(cdm_name %in% input$prevalence_estimates_cdm_name) %>%
      filter(outcome_cohort_name %in% input$prevalence_estimates_outcome_cohort_name) %>%
      filter(group %in% input$prevalence_estimates_group) %>%
      filter(data_type %in% input$prevalence_estimates_data_type) %>%
      filter(country %in% input$prevalence_estimates_country) %>%
      filter(denominator_target_cohort_name %in% input$prevalence_estimates_denominator_target_cohort_name) %>%
      filter(denominator_age_group %in% input$prevalence_estimates_denominator_age_group) %>%
      filter(denominator_sex %in% input$prevalence_estimates_denominator_sex) %>%
      filter(denominator_days_prior_observation %in% input$prevalence_estimates_denominator_days_prior_observation) %>%
      filter(analysis_type %in% input$prevalence_estimates_analysis_type) %>%
      filter(analysis_time_point %in% input$prevalence_estimates_analysis_time_point) %>%
      filter(analysis_complete_database_intervals %in% input$prevalence_estimates_analysis_complete_database_intervals) %>%
      filter(analysis_interval %in% input$prevalence_estimates_analysis_interval) %>%
      filter(prevalence_start_date %in% as.Date(input$prevalence_estimates_prevalence_start_date)) %>%
      mutate(
        n_cases = round(suppressWarnings(as.numeric(n_cases))),
        n_population = round(suppressWarnings(as.numeric(n_population))),
        prevalence = round(suppressWarnings(as.numeric(prevalence)), 4),
        prevalence_95CI_lower = round(suppressWarnings(as.numeric(prevalence_95CI_lower)), 4),
        prevalence_95CI_upper = round(suppressWarnings(as.numeric(prevalence_95CI_upper)), 4))
  })
  ### download table ----
  output$prevalence_estimates_download_table <- downloadHandler(
    filename = function() {
      "prevalenceTable.csv"
    },
    content = function(file) {
      write_csv(getprevalence(), file)
    }
  )
  ### table estimates ----
  output$prevalence_estimates_table <- renderDataTable({
    table <- getprevalence()
    validate(need(nrow(table) > 0, "No results for selected inputs"))
    table <- table %>%
      mutate(`prevalence (%)` = paste0(
        100 * prevalence, " (", 100 * prevalence_95CI_lower, " to ",
        100 * prevalence_95CI_upper, " )"
      )) %>%
      select(cdm_name, outcome_cohort_name, denominator_target_cohort_name, denominator_age_group, denominator_sex, denominator_days_prior_observation, denominator_start_date, denominator_end_date, analysis_type, analysis_time_point, analysis_complete_database_intervals, analysis_full_contribution, analysis_min_cell_count, analysis_interval, prevalence_start_date, n_cases, n_population, "prevalence (%)")
    datatable(
      table,
      rownames = FALSE,
      extensions = "Buttons",
      options = list(scrollX = TRUE, scrollCollapse = TRUE)
    )
  })
  ### make plot ----
  plotprevalence <- reactive({
    table <- getprevalence()
    validate(need(nrow(table) > 0, "No results for selected inputs"))
    class(table) <- c("PrevalenceResult", "IncidencePrevalenceResult", class(table))
    plotPrevalence(
      table,
      x = input$prevalence_estimates_plot_x,
      ylim = c(0, NA),
      facet = input$prevalence_estimates_plot_facet,
      colour = input$prevalence_estimates_plot_colour,
      colour_name = paste0(input$prevalence_estimates_plot_colour, collapse = "; "),
      ribbon = FALSE
    )
  })
  ### download plot ----
  output$prevalence_estimates_download_plot <- downloadHandler(
    filename = function() {
      "prevalencePlot.png"
    },
    content = function(file) {
      ggsave(
        file,
        plotprevalence(),
        width = as.numeric(input$prevalence_estimates_download_width),
        height = as.numeric(input$prevalence_estimates_download_height),
        dpi = as.numeric(input$prevalence_estimates_download_dpi),
        units = "cm"
      )
    }
  )
  
  
  ### plot ----
  output$prevalence_estimates_plot <- renderPlotly({
    plotprevalence()
  })
  
  ### update dropdowns
  observeEvent(input$prevalence_estimates_group, {
    # Filter the data based on the selected groups
    filtered_prevalence <- prevalence[prevalence$group %in% input$prevalence_estimates_group,]
    
    
    unique_cdm_names <- sort(unique(filtered_prevalence$cdm_name))
    unique_outcome_cohort_names <- sort(unique(filtered_prevalence$outcome_cohort_name))
    unique_data_types <- sort(unique(filtered_prevalence$data_type))
    unique_countries <- sort(unique(filtered_prevalence$country))
    
    
    updatePickerInput(session, inputId = "prevalence_estimates_cdm_name",
                      choices = unique_cdm_names,
                      selected = unique_cdm_names)
    
    updatePickerInput(session, inputId = "prevalence_estimates_outcome_cohort_name",
                      choices = unique_outcome_cohort_names,
                      selected = unique_outcome_cohort_names)
    
    updatePickerInput(session, inputId = "prevalence_estimates_data_type",
                      choices = unique_data_types,
                      selected = unique_data_types)
    
    updatePickerInput(session, inputId = "prevalence_estimates_country",
                      choices = unique_countries,
                      selected = unique_countries)
  })
  

  
}

