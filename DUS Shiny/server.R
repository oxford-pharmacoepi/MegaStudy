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
  
  ## incident patient estimates ----
  # inc_patient_characteristics ----
  get_inc_patient_characteristics <- reactive({
    
    inc_patient_characteristics <- inc_patient_characteristics %>% 
      filter(cdm_name %in% input$inc_chars_cdm) %>% 
      filter(group_level %in% input$inc_chars_group_level) %>%
      filter(variable_name %in% input$inc_chars_variable_name) %>%
      inner_join(
        inc_chars_strataOpsChars %>%
          filter(strata %in% input$inc_chars_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
    inc_patient_characteristics  <- inc_patient_characteristics %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
    
    inc_patient_characteristics
  })
  
  output$raw_inc_patient_characteristics <- renderDataTable({
    datatable(get_inc_patient_characteristics(), options = list(scrollX = TRUE), rownames = FALSE)
  })
  
  output$download_inc_patient_characteristics_raw <- downloadHandler(
    filename = function() {
      "inc_demographics.csv"
    },
    content = function(file) {
      write.csv(get_inc_patient_characteristics(), file, row.names = FALSE)
    }
  )
  

  
  # inc_lsc ----
  get_inc_large_scale_characteristics <- reactive({
    
    inc_large_scale_characteristics <- inc_large_scale_characteristics %>% 
      filter(cdm_name %in% input$inc_lsc_cdm,
             group_level %in%  input$inc_lsc_group_level,
             variable_level %in%  input$inc_lsc_time_window) %>%
      inner_join(
        inc_lsc_strataOpsChars %>%
          filter(strata %in% input$inc_lsc_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
    
    inc_large_scale_characteristics <- inc_large_scale_characteristics %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
    
    inc_large_scale_characteristics
  })
  
  output$dt_inc_large_scale_characteristics  <- DT::renderDataTable({
    table_data <- get_inc_large_scale_characteristics()
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_large_scale_characteristics <- downloadHandler(
    filename = function() {
      "inc_lsc.csv"
    },
    content = function(file) {
      write.csv(get_inc_large_scale_characteristics(), file, row.names = FALSE)
    }
  )
  
  
  
  
  # inc_indication ----
  get_inc_indication <- reactive({
    
    inc_indication <- inc_indication %>% 
      filter(cdm_name %in% input$inc_indication_cdm,
             group_level %in%  input$inc_indication_group_level,
             variable_name %in%  input$inc_indication_time_window,
             variable_level %in%  input$indication_inc_indication) %>%
      inner_join(
        inc_indication_strataOpsChars %>%
          filter(strata %in% input$inc_indication_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      ) 

    inc_indication <- inc_indication %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
  })
  
  output$dt_inc_indication  <- DT::renderDataTable({
    table_data <- get_inc_indication()
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE) 
  })
  
  output$download_dt_inc_indication <- downloadHandler(
    filename = function() {
      "inc_indication.csv"
    },
    content = function(file) {
      write.csv(get_inc_indication(), file, row.names = FALSE)
    }
  )
  
  
  
 
  # inc_use ----
  get_inc_use <- reactive({
  
    inc_use_summary <- inc_use_summary %>% 
      filter(cdm_name %in% input$inc_use_cdm,
             group_level %in% input$inc_use_group_level) %>%
      inner_join(
        inc_use_strataOpsChars %>%
          filter(strata %in% input$inc_use_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
      
      inc_use_summary <- inc_use_summary %>%
        select(!c(1,"additional_name","group_name","additional_level","result_type"))
      
  })
  
  output$dt_inc_use_duration  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "duration")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_duration <- downloadHandler(
    filename = function() {
      "inc_use_duration.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "duration"), file, row.names = FALSE)
    }
  )
  
  output$dt_inc_use_initial_dd  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "initial_daily_dose_milligram")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_initial_dd <- downloadHandler(
    filename = function() {
      "inc_use_initial_dd.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "initial_daily_dose_milligram"), file, row.names = FALSE)
    }
  )
  
  output$dt_inc_use_cumulative_dose  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "cumulative_dose_milligram")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_cumulative_dose <- downloadHandler(
    filename = function() {
      "inc_use_cumulative_dose.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "cumulative_dose_milligram"), file, row.names = FALSE)
    }
  )
  
  output$dt_inc_use_duration  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "duration")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_duration <- downloadHandler(
    filename = function() {
      "inc_use_duration.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "duration"), file, row.names = FALSE)
    }
  )
  
  output$dt_inc_use_number_exposures  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "number_exposures")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_number_exposures <- downloadHandler(
    filename = function() {
      "inc_use_number_exposures.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "number_exposures"), file, row.names = FALSE)
    }
  )
  
  output$dt_inc_use_initial_quantity  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "initial_quantity")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_initial_quantity <- downloadHandler(
    filename = function() {
      "inc_use_initial_quantity.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "initial_quantity"), file, row.names = FALSE)
    }
  )
  

  output$dt_inc_use_cumulative_quantity  <- DT::renderDataTable({
    table_data <- get_inc_use() %>% 
      filter(variable_name == "cumulative_quantity")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_inc_use_cumulative_quantity <- downloadHandler(
    filename = function() {
      "inc_use_cumulative_quantity.csv"
    },
    content = function(file) {
      write.csv(get_inc_use() %>% 
                  filter(variable_name == "cumulative_quantity"), file, row.names = FALSE)
    }
  )
  
  
  ## prevalent patients----------------
  # inc_patient_characteristics ----
  get_prev_patient_characteristics <- reactive({
    
    prev_patient_characteristics <- prev_patient_characteristics %>% 
      filter(cdm_name %in% input$prev_chars_cdm) %>% 
      filter(group_level %in% input$prev_chars_group_level) %>%
      filter(variable_name %in% input$prev_chars_variable_name) %>%
      inner_join(
        prev_chars_strataOpsChars %>%
          filter(strata %in% input$prev_chars_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
    prev_patient_characteristics  <- prev_patient_characteristics %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
    
    prev_patient_characteristics
  })
  
  output$raw_prev_patient_characteristics <- renderDataTable({
    datatable(get_prev_patient_characteristics(), options = list(scrollX = TRUE), rownames = FALSE)
  })
  
  output$download_prev_patient_characteristics_raw <- downloadHandler(
    filename = function() {
      "prev_demographics.csv"
    },
    content = function(file) {
      write.csv(get_prev_patient_characteristics(), file, row.names = FALSE)
    }
  )
  
  
  
  # prev_lsc ----
  get_prev_large_scale_characteristics <- reactive({
    
    prev_large_scale_characteristics <- prev_large_scale_characteristics %>% 
      filter(cdm_name %in% input$prev_lsc_cdm,
             group_level %in%  input$prev_lsc_group_level,
             variable_level %in%  input$prev_lsc_time_window) %>%
      inner_join(
        prev_lsc_strataOpsChars %>%
          filter(strata %in% input$prev_lsc_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
    
    prev_large_scale_characteristics <- prev_large_scale_characteristics %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
    
    prev_large_scale_characteristics
  })
  
  output$dt_prev_large_scale_characteristics  <- DT::renderDataTable({
    table_data <- get_prev_large_scale_characteristics()
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_large_scale_characteristics <- downloadHandler(
    filename = function() {
      "prev_lsc.csv"
    },
    content = function(file) {
      write.csv(get_prev_large_scale_characteristics(), file, row.names = FALSE)
    }
  )
  
  
  
  
  # prev_indication ----
  get_prev_indication <- reactive({
    
    prev_indication <- prev_indication %>% 
      filter(cdm_name %in% input$prev_indication_cdm,
             group_level %in%  input$prev_indication_group_level,
             variable_name %in%  input$prev_indication_time_window,
             variable_level %in%  input$indication_prev_indication) %>%
      inner_join(
        prev_indication_strataOpsChars %>%
          filter(strata %in% input$prev_indication_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )
    
    prev_indication <- prev_indication %>% 
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
  })
  
  output$dt_prev_indication  <- DT::renderDataTable({
    table_data <- get_prev_indication()
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE) 
  })
  
  output$download_dt_prev_indication <- downloadHandler(
    filename = function() {
      "prev_indication.csv"
    },
    content = function(file) {
      write.csv(get_prev_indication(), file, row.names = FALSE)
    }
  )
  
  
  
  
  # prev_use ----
  get_prev_use <- reactive({
    
    prev_use_summary <- prev_use_summary %>% 
      filter(cdm_name %in% input$prev_use_cdm,
             group_level %in% input$prev_use_group_level) %>%
      inner_join(
        prev_use_strataOpsChars %>%
          filter(strata %in% input$prev_use_strata) %>%
          select(-strata),
        by = c("strata_name", "strata_level")
      )   
  
     
    prev_use_summary <- prev_use_summary %>%
      select(!c(1,"additional_name","group_name","additional_level","result_type"))
    
  })
  
  output$dt_prev_use_duration  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "duration")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_duration <- downloadHandler(
    filename = function() {
      "prev_use_duration.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "duration"), file, row.names = FALSE)
    }
  )
  
  output$dt_prev_use_initial_dd  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "initial_daily_dose_milligram")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_initial_dd <- downloadHandler(
    filename = function() {
      "prev_use_initial_dd.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "initial_daily_dose_milligram"), file, row.names = FALSE)
    }
  )
  
  output$dt_prev_use_cumulative_dose  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "cumulative_dose_milligram")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_cumulative_dose <- downloadHandler(
    filename = function() {
      "prev_use_cumulative_dose.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "cumulative_dose_milligram"), file, row.names = FALSE)
    }
  )
  
  output$dt_prev_use_duration  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "duration")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_duration <- downloadHandler(
    filename = function() {
      "prev_use_duration.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "duration"), file, row.names = FALSE)
    }
  )
  
  output$dt_prev_use_number_exposures  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "number_exposures")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_number_exposures <- downloadHandler(
    filename = function() {
      "prev_use_number_exposures.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "number_exposures"), file, row.names = FALSE)
    }
  )
  
  output$dt_prev_use_initial_quantity  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "initial_quantity")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_initial_quantity <- downloadHandler(
    filename = function() {
      "prev_use_initial_quantity.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "initial_quantity"), file, row.names = FALSE)
    }
  )
  
  
  output$dt_prev_use_cumulative_quantity  <- DT::renderDataTable({
    table_data <- get_prev_use() %>% 
      filter(variable_name == "cumulative_quantity")
    datatable(table_data, options = list(scrollX = TRUE), rownames = FALSE)
  })
  output$download_dt_prev_use_cumulative_quantity <- downloadHandler(
    filename = function() {
      "prev_use_cumulative_quantity.csv"
    },
    content = function(file) {
      write.csv(get_prev_use() %>% 
                  filter(variable_name == "cumulative_quantity"), file, row.names = FALSE)
    }
  )
  
}