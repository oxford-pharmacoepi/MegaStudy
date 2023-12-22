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
  
  # code use ----
  getCodeUse <- reactive({
    
    validate(
      need(input$cd_cdm != "", "Please select a database")
    )
    validate(
      need(input$cd_cohort != "", "Please select a cohort")
    )
    
    code_use <- code_use %>% 
      select(c("cdm_name", "codelist_name",
               "group_name", 
               "strata_name", "strata_level",
               "standard_concept_name", "standard_concept_name",
               "source_concept_name",  "source_concept_id" ,   "domain_id",
               "variable_name", "estimate")) %>% 
      pivot_wider(names_from = variable_name, 
                  values_from = estimate)
    names(code_use)<-stringr::str_replace_all(names(code_use), "_", " ")
    code_use
    
  })
  
  output$dt_code_use  <- DT::renderDataTable({
    table_data <- getCodeUse()
    
    datatable(table_data, 
              filter = "top",
              rownames= FALSE) 
  })
  
  
  # index_codes ----
  get_index_codes <- reactive({
    
    validate(
      need(input$cd_cdm != "", "Please select a database")
    )
    validate(
      need(input$cd_cohort != "", "Please select a cohort")
    )
    
    index_codes <- index_codes %>% 
      filter(cdm_name %in% input$cd_cdm,
             cohort_name %in%  input$cd_cohort,
             group_name %in%  input$cd_index_group_name,
             strata_name %in%  input$cd_index_strata_name) %>% 
      select(c("cdm_name", "cohort_name" ,
               "group_name", 
               "strata_name", "strata_level",
               "standard_concept_name", "standard_concept_id",
               "source_concept_name",  "source_concept_id" , 
               "variable_name", "estimate")) %>% 
      pivot_wider(names_from = variable_name, 
                  values_from = estimate)
    
    
    if(all(input$cd_index_group_name %in%  "Codelist")){
      index_codes <- index_codes %>% 
        select(!c(
          "standard_concept_name", "standard_concept_id",
          "source_concept_name",  "source_concept_id"
        ))
    }
    
    index_codes<-index_codes %>% 
      arrange(desc(`Record count`))
    
    names(index_codes)<-stringr::str_replace_all(names(index_codes), "_", " ")
    
    index_codes
    
  })
  
  output$dt_index_codes  <- DT::renderDataTable({
    table_data <- get_index_codes()
    datatable(table_data, rownames= FALSE) 
  })   
  
  
  
  ## incidence_estimates ----
  ### get estimates ----
  getincidence <- reactive({
    incidence %>%   
      filter(n_events >0) %>%
      filter(cdm_name %in% input$incidence_estimates_cdm_name) %>%
      filter(outcome_cohort_name %in% input$incidence_estimates_outcome_cohort_name) %>%
      filter(denominator_target_cohort_name %in% input$incidence_estimates_denominator_target_cohort_name) %>%
      filter(denominator_age_group %in% input$incidence_estimates_denominator_age_group) %>%
      filter(denominator_sex %in% input$incidence_estimates_denominator_sex) %>%
      filter(denominator_days_prior_observation %in% input$incidence_estimates_denominator_days_prior_observation) %>%
      # filter(denominator_start_date %in% input$incidence_estimates_denominator_start_date) %>%
      # filter(denominator_end_date %in% input$incidence_estimates_denominator_end_date) %>%
      filter(analysis_outcome_washout %in% input$incidence_estimates_analysis_outcome_washout) %>%
      filter(analysis_repeated_events %in% input$incidence_estimates_analysis_repeated_events) %>%
      filter(analysis_complete_database_intervals %in% input$incidence_estimates_analysis_complete_database_intervals) %>%
      # filter(analysis_min_cell_count %in% input$incidence_estimates_analysis_min_cell_count) %>%
      filter(analysis_interval %in% input$incidence_estimates_analysis_interval) %>%
      # filter(incidence_start_date %in% input$incidence_estimates_incidence_start_date) %>%
      mutate(
        person_years = round(suppressWarnings(as.numeric(person_years))),
        person_days = round(suppressWarnings(as.numeric(person_days))),
        n_events = round(suppressWarnings(as.numeric(n_events))),
        incidence_100000_pys = round(suppressWarnings(as.numeric(incidence_100000_pys))),
        incidence_100000_pys_95CI_lower = round(suppressWarnings(as.numeric(incidence_100000_pys_95CI_lower))),
        incidence_100000_pys_95CI_upper = round(suppressWarnings(as.numeric(incidence_100000_pys_95CI_upper))),
        outcome_cohort_name = factor(
          outcome_cohort_name, 
          levels = c("tenecteplase",
                     "alteplase",
                     "sarilumab",
                     "verteporfin",
                     "tocilizumab",
                     "varenicline",
                     
                     "C1 esterase inhibitor",
                     
                     "belatacept",
                     "ganirelix",
                     "tigecycline",
                     "imiglucerase",
                     "agalsidase beta",
                     "azithromycin",
                     
                     "ceftriaxone",
                     "cefotaxime",
                     
                     "cefuroxime",
                     
                     "urokinase",
                     "abatacept",
                     "tofacitinib",
                     "baricitinib",
                     "upadacitinib",
                     "etanercept",
                     "infliximab",
                     
                     "golimumab",
                     "anakinra",
                     "ranibizumab",
                     "bevacizumab",
                     
                     "icatibant",
                     "ecallantide",
                     "Conestat alfa",
                     "lanadelumab",
                     "berotralstat",
                     
                     "idarubicin",
                     
                     "mycophenolic acid",
                     "sirolimus",
                     
                     "cetrorelix",
                     "velaglucerase alfa",
                     "taliglucerase alfa",
                     "Agalsidase alfa",
                     
                     "certolizumab_both",
                     "clarithromycin_no_combination",
                     "penicillin_V_no_combination",
                     "penicillin_G_no_combination",
                     "amoxicillin_no_combination",
                     "meropenem_no_combination",
                     "streptokinase_no_combination",
                     "arsenic_trioxide",
                     "cytarabine_liposomal_depocyte",
                     "cytarabine_any",
                     "daunorubicin_no_combination",
                     "cytarabine_daunorubicin_combination",
                     "amoxicillin_clavulanate_combination",
                     "ceftozolane_tazobactam",
                     "piperacillin_tazobactam",
                     "nicotine_no_combination",
                     "tretinoin_oral",
                     "cyclosporine_no_combination",
                     "tacrolimus_no_topical"),
          
          labels = c("tenecteplase",
                     "alteplase",
                     "sarilumab",
                     "verteporfin",
                     "tocilizumab",
                     "varenicline",
                     
                     "C1 esterase inhibitor",
                     
                     "belatacept",
                     "ganirelix",
                     "tigecycline",
                     "imiglucerase",
                     "agalsidase beta",
                     "azithromycin",
                     
                     "ceftriaxone",
                     "cefotaxime",
                     
                     "cefuroxime",
                     
                     "urokinase",
                     "abatacept",
                     "tofacitinib",
                     "baricitinib",
                     "upadacitinib",
                     "etanercept",
                     "infliximab",
                     
                     "golimumab",
                     "anakinra",
                     "ranibizumab",
                     "bevacizumab",
                     
                     "icatibant",
                     "ecallantide",
                     "conestat alfa",
                     "lanadelumab",
                     "berotralstat",
                     
                     "idarubicin",
                     
                     "mycophenolic acid",
                     "sirolimus",
                     
                     "cetrorelix",
                     "velaglucerase alfa",
                     "taliglucerase alfa",
                     "agalsidase alfa",
                     
                     "certolizumab",
                     "clarithromycin",
                     "penicillin V",
                     "penicillin G",
                     "amoxicillin",
                     "meropenem",
                     "streptokinase",
                     "arsenic trioxide",
                     "liposomal cytarabine",
                     "any cytarabine",
                     "daunorubicin",
                     "cytarabine and daunorubicin",
                     "amoxicillin and clavulanate",
                     "ceftozolane and tazobactam",
                     "piperacillin and tazobactam",
                     "nicotine",
                     "tretinoin systemic",
                     "cyclosporine",
                     "tacrolimus systemic")
        )
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
      select(cdm_name, outcome_cohort_name, denominator_target_cohort_name, denominator_age_group, denominator_sex, denominator_days_prior_observation, denominator_start_date, denominator_end_date, analysis_outcome_washout, analysis_repeated_events, analysis_complete_database_intervals, analysis_min_cell_count, analysis_interval, incidence_start_date, n_events, n_persons, person_years, incidence_100000_pys)
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
  
  ## prevalence_estimates ----
  ### get estimates ----
  getprevalence <- reactive({
    prevalence %>%
      filter(n_cases >0) %>%
      filter(cdm_name %in% input$prevalence_estimates_cdm_name) %>%
      filter(outcome_cohort_name %in% input$prevalence_estimates_outcome_cohort_name) %>%
      filter(denominator_target_cohort_name %in% input$prevalence_estimates_denominator_target_cohort_name) %>%
      filter(denominator_age_group %in% input$prevalence_estimates_denominator_age_group) %>%
      filter(denominator_sex %in% input$prevalence_estimates_denominator_sex) %>%
      filter(denominator_days_prior_observation %in% input$prevalence_estimates_denominator_days_prior_observation) %>%
      # filter(denominator_start_date %in% input$prevalence_estimates_denominator_start_date) %>%
      # filter(denominator_end_date %in% input$prevalence_estimates_denominator_end_date) %>%
      filter(analysis_type %in% input$prevalence_estimates_analysis_type) %>%
      # filter(analysis_outcome_lookback_days %in% input$prevalence_estimates_analysis_outcome_lookback_days) %>%
      filter(analysis_time_point %in% input$prevalence_estimates_analysis_time_point) %>%
      filter(analysis_complete_database_intervals %in% input$prevalence_estimates_analysis_complete_database_intervals) %>%
      filter(analysis_full_contribution %in% input$prevalence_estimates_analysis_full_contribution) %>%
      # filter(analysis_min_cell_count %in% input$prevalence_estimates_analysis_min_cell_count) %>%
      filter(analysis_interval %in% input$prevalence_estimates_analysis_interval) %>%
      # filter(prevalence_start_date %in% input$prevalence_estimates_prevalence_start_date) %>%
      mutate(
        n_cases = round(suppressWarnings(as.numeric(n_cases))),
        n_population = round(suppressWarnings(as.numeric(n_population))),
        prevalence = round(suppressWarnings(as.numeric(prevalence)), 4),
        prevalence_95CI_lower = round(suppressWarnings(as.numeric(prevalence_95CI_lower)), 4),
        prevalence_95CI_upper = round(suppressWarnings(as.numeric(prevalence_95CI_upper)), 4),
        ,
        outcome_cohort_name = factor(
          outcome_cohort_name, 
          levels = c("tenecteplase",
                     "alteplase",
                     "sarilumab",
                     "verteporfin",
                     "tocilizumab",
                     "varenicline",
                     
                     "C1 esterase inhibitor",
                     
                     "belatacept",
                     "ganirelix",
                     "tigecycline",
                     "imiglucerase",
                     "agalsidase beta",
                     "azithromycin",
                     
                     "ceftriaxone",
                     "cefotaxime",
                     
                     "cefuroxime",
                     
                     "urokinase",
                     "abatacept",
                     "tofacitinib",
                     "baricitinib",
                     "upadacitinib",
                     "etanercept",
                     "infliximab",
                     
                     "golimumab",
                     "anakinra",
                     "ranibizumab",
                     "bevacizumab",
                     
                     "icatibant",
                     "ecallantide",
                     "Conestat alfa",
                     "lanadelumab",
                     "berotralstat",
                     
                     "idarubicin",
                     
                     "mycophenolic acid",
                     "sirolimus",
                     
                     "cetrorelix",
                     "velaglucerase alfa",
                     "taliglucerase alfa",
                     "Agalsidase alfa",
                     
                     "certolizumab_both",
                     "clarithromycin_no_combination",
                     "penicillin_V_no_combination",
                     "penicillin_G_no_combination",
                     "amoxicillin_no_combination",
                     "meropenem_no_combination",
                     "streptokinase_no_combination",
                     "arsenic_trioxide",
                     "cytarabine_liposomal_depocyte",
                     "cytarabine_any",
                     "daunorubicin_no_combination",
                     "cytarabine_daunorubicin_combination",
                     "amoxicillin_clavulanate_combination",
                     "ceftozolane_tazobactam",
                     "piperacillin_tazobactam",
                     "nicotine_no_combination",
                     "tretinoin_oral",
                     "cyclosporine_no_combination",
                     "tacrolimus_no_topical"),
          
          labels = c("tenecteplase",
                     "alteplase",
                     "sarilumab",
                     "verteporfin",
                     "tocilizumab",
                     "varenicline",
                     
                     "C1 esterase inhibitor",
                     
                     "belatacept",
                     "ganirelix",
                     "tigecycline",
                     "imiglucerase",
                     "agalsidase beta",
                     "azithromycin",
                     
                     "ceftriaxone",
                     "cefotaxime",
                     
                     "cefuroxime",
                     
                     "urokinase",
                     "abatacept",
                     "tofacitinib",
                     "baricitinib",
                     "upadacitinib",
                     "etanercept",
                     "infliximab",
                     
                     "golimumab",
                     "anakinra",
                     "ranibizumab",
                     "bevacizumab",
                     
                     "icatibant",
                     "ecallantide",
                     "conestat alfa",
                     "lanadelumab",
                     "berotralstat",
                     
                     "idarubicin",
                     
                     "mycophenolic acid",
                     "sirolimus",
                     
                     "cetrorelix",
                     "velaglucerase alfa",
                     "taliglucerase alfa",
                     "agalsidase alfa",
                     
                     "certolizumab",
                     "clarithromycin",
                     "penicillin V",
                     "penicillin G",
                     "amoxicillin",
                     "meropenem",
                     "streptokinase",
                     "arsenic trioxide",
                     "liposomal cytarabine",
                     "any cytarabine",
                     "daunorubicin",
                     "cytarabine and daunorubicin",
                     "amoxicillin and clavulanate",
                     "ceftozolane and tazobactam",
                     "piperacillin and tazobactam",
                     "nicotine",
                     "tretinoin systemic",
                     "cyclosporine",
                     "tacrolimus systemic")
        )
      )
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
      select(cdm_name, outcome_cohort_name, denominator_target_cohort_name, denominator_age_group, denominator_sex, denominator_days_prior_observation, denominator_start_date, denominator_end_date, analysis_type, analysis_outcome_lookback_days, analysis_time_point, analysis_complete_database_intervals, analysis_full_contribution, analysis_min_cell_count, analysis_interval, prevalence_start_date, n_cases, n_population, "prevalence (%)")
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
  
}

