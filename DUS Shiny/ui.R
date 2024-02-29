source("global.R")

# ui shiny ----
ui <- dashboardPage(
  dashboardHeader(title = "Menu"),
  ## menu ----
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Background",
        tabName = "background"
      ),
      menuItem(
        text = "Databases",
        tabName = "dbs",
        menuSubItem(
          text = "Database details",
          tabName = "cdm_snapshot"
        )
      ),
      menuItem(
        text = "Attrition",
        tabName = "attrition",
        menuSubItem(
          text = "Incidence Attrition",
          tabName = "incidence_attrition"
        ),
        menuSubItem(
          text = "Prevalence Attrition",
          tabName = "prevalence_attrition"
        )
      ),
      menuItem(
        text = "Charact. incident patients",
        tabName = "inc",
        menuSubItem(
          text = "Demographics",
          tabName = "inc_chars"
        ),
        menuSubItem(
          text = "Larce scale characterisation",
          tabName = "inc_lsc"
        ),
        menuSubItem(
          text = "Indication",
          tabName = "inc_indication"
        ),
        menuSubItem(
          text = "Drug use",
          tabName = "inc_use"
        )
      ),
      menuItem(
        text = "Charact. prevalent patients",
        tabName = "inc",
        menuSubItem(
          text = "Demographics",
          tabName = "prev_chars"
        ),
        
        menuSubItem(
          text = "Larce scale characterisation",
          tabName = "prev_lsc"
        ),
        menuSubItem(
          text = "Indication",
          tabName = "prev_indication"
        ),
        menuSubItem(
          text = "Drug use",
          tabName = "prev_drug_use"
        )
      )
    )
  ),
  
  ## body ----
  dashboardBody(
    use_theme(mytheme),
    tabItems(
      # background  ------
      tabItem(
        tabName = "background",
        h3("Incidence and prevalence of medicines with suggested shortages according to the European Medicines Agency drug shortages catalogue: a large scale network study"),
        tags$hr(),
        a(img(
          src = "logo.png", align = "right",
          height = "2%", width = "20%"
        ),
        href = "https://www.ehden.eu/",
        target = "_blank"
        )
      ),

      
      # cdm snapshot ------
      tabItem(
        tabName = "cdm_snapshot",
        htmlOutput("tbl_cdm_snaphot"),
        tags$hr(),
        downloadButton(
          "gt_cdm_snaphot_word",
          "Download table as word"
        )
      ),
      
      
      # incidence_attrition ------
      tabItem(
        tabName = "incidence_attrition",
        h3("Incidence attrition"),
        p("Number of patients retained in the study are shown below per study outcome."),
        p("There is the option to filter by study outcome (drug) and by database"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_attrition_cdm_name",
            label = "CDM name",
            choices = unique(incidence_attrition$cdm_name),
            selected = unique(incidence_attrition$cdm_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_attrition_outcome_cohort_name",
            label = "Outcome name",
            choices = sort(unique(incidence_attrition$outcome_cohort_name)),
            selected = unique(incidence_attrition$outcome_cohort_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        DT::dataTableOutput(outputId = "dt_incidence_attrition"),
        div(style="display:inline-block",
            downloadButton("incidence_attrition_download_table", "Download table"), 
            style="display:inline-block; float:right")
      ),

      # prevalence_attrition ------
      tabItem(
        tabName = "prevalence_attrition",
        h3("Prevalence attrition"),
        p("Number of patients retained in the study are shown below per study outcome."),
        p("There is the option to filter by study outcome (drug) and by database"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_attrition_cdm_name",
            label = "CDM name",
            choices = unique(prevalence_attrition$cdm_name),
            selected = unique(prevalence_attrition$cdm_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_attrition_outcome_cohort_name",
            label = "Outcome name",
            choices = sort(unique(prevalence_attrition$outcome_cohort_name)),
            selected = unique(prevalence_attrition$outcome_cohort_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        DT::dataTableOutput(outputId = "dt_prevalence_attrition"),
        div(style="display:inline-block",
            downloadButton("prevalence_attrition_download_table", "Download table"), 
            style="display:inline-block; float:right")
      ),
      
      ### incident patients ----
      tabItem(
        tabName = "inc_chars",
        tags$hr(),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_chars_cdm",
            label = "Database",
            choices = sort(unique(inc_patient_characteristics$cdm_name)),
            selected = sort(unique(inc_patient_characteristics$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_chars_group_level",
            label = "Cohort",
            choices = sort(unique(inc_patient_characteristics$group_level)),
            selected = sort(unique(inc_patient_characteristics$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_chars_strata",
            label = "Strata",
            choices = sort(unique(inc_chars_strataOpsChars$strata)),
            selected = sort(unique(inc_chars_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_chars_variable_name",
            label = "Variables",
            choices = sort(unique(inc_patient_characteristics$variable_name)),
            selected = sort(unique(inc_patient_characteristics$variable_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Raw data",
            tags$hr(),
            downloadButton("download_inc_patient_characteristics_raw", "Download csv data"),
            DTOutput("raw_inc_patient_characteristics") %>%
              withSpinner()
          )
        )
      ),
      # lsc ------
      tabItem(
        tabName = "inc_lsc",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_lsc_cdm",
            label = "Database",
            choices = sort(unique(inc_large_scale_characteristics$cdm_name)),
            selected = sort(unique(inc_large_scale_characteristics$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_lsc_group_level",
            label = "Cohort",
            choices = sort(unique(inc_large_scale_characteristics$group_level)),
            selected = sort(unique(inc_large_scale_characteristics$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_lsc_time_window",
            label = "Time window",
            choices = sort(unique(inc_large_scale_characteristics$variable_level)),
            selected = sort(unique(inc_large_scale_characteristics$variable_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_lsc_strata",
            label = "Strata",
            choices = sort(unique(inc_lsc_strataOpsChars$strata)),
            selected = sort(unique(inc_lsc_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        downloadButton("download_dt_inc_large_scale_characteristics", "Download"),
        DT::dataTableOutput("dt_inc_large_scale_characteristics") %>%
          withSpinner()
      ),
      # indication ------
      tabItem(
        tabName = "inc_indication",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_indication_cdm",
            label = "Database",
            choices = sort(unique(inc_indication$cdm_name)),
            selected = sort(unique(inc_indication$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_indication_group_level",
            label = "Cohort",
            choices = sort(unique(inc_indication$group_level)),
            selected = sort(unique(inc_indication$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_indication_time_window",
            label = "Time window",
            choices = sort(unique(inc_indication$variable_name)),
            selected = sort(unique(inc_indication$variable_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "indication_inc_indication",
            label = "Indication",
            choices = sort(unique(inc_indication$variable_level)),
            selected = sort(unique(inc_indication$variable_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_indication_strata",
            label = "Strata",
            choices = sort(unique(inc_indication_strataOpsChars$strata)),
            selected = sort(unique(inc_indication_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        downloadButton("download_dt_inc_indication", "Download"),
        DT::dataTableOutput("dt_inc_indication") %>%
          withSpinner()
      ),
      
    
      # inc_use -------
      tabItem(
        tabName = "inc_use",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_use_cdm",
            label = "Database",
            choices = sort(unique(inc_use_summary$cdm_name)),
            selected = sort(unique(inc_use_summary$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_use_group_level",
            label = "Cohort",
            choices = sort(unique(inc_use_summary$group_level)),
            selected = sort(unique(inc_use_summary$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "inc_use_strata",
            label = "Strata",
            choices = sort(unique(inc_use_strataOpsChars$strata)),
            selected = sort(unique(inc_use_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$style(HTML("
                  .tabbable > .nav > li > a {font-weight: bold; background-color: D3D4D8;  color:black}
                  ")),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Duration",
            tags$hr(),
            downloadButton("download_dt_inc_use_duration", "Download"),
            DT::dataTableOutput("dt_inc_use_duration") %>%
              withSpinner()
          ),
          tabPanel(
            "Initial daily dose (milligram)",
            tags$hr(),
            downloadButton("download_dt_inc_use_initial_dd", "Download"),
            DT::dataTableOutput("dt_inc_use_initial_dd") %>%
              withSpinner()
          ),
          tabPanel(
            "Cumulative dose (milligram)",
            tags$hr(),
            downloadButton("download_dt_inc_use_cumulative_dose", "Download"),
            DT::dataTableOutput("dt_inc_use_cumulative_dose") %>%
              withSpinner()
          ),
          tabPanel(
            "number_exposures",
            tags$hr(),
            downloadButton("download_dt_inc_use_number_exposures", "Download"),
            DT::dataTableOutput("dt_inc_use_number_exposures") %>%
              withSpinner()
          ),
          tabPanel(
            "Initial quantity",
            tags$hr(),
            downloadButton("download_dt_inc_use_initial_quantity", "Download"),
            DT::dataTableOutput("dt_inc_use_initial_quantity") %>%
              withSpinner()
          ),
          tabPanel(
            "Cumulative quantity",
            tags$hr(),
            downloadButton("download_dt_inc_use_cumulative_quantity", "Download"),
            DT::dataTableOutput("dt_inc_use_cumulative_quantity") %>%
              withSpinner()
          )
        )
      ),
      ### prevalent patients ----
      tabItem(
        tabName = "prev_chars",
        tags$hr(),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_chars_cdm",
            label = "Database",
            choices = sort(unique(prev_patient_characteristics$cdm_name)),
            selected = sort(unique(prev_patient_characteristics$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_chars_group_level",
            label = "Cohort",
            choices = sort(unique(prev_patient_characteristics$group_level)),
            selected = sort(unique(prev_patient_characteristics$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_chars_strata",
            label = "Strata",
            choices = sort(unique(prev_chars_strataOpsChars$strata)),
            selected = sort(unique(prev_chars_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_chars_variable_name",
            label = "Variables",
            choices = sort(unique(prev_patient_characteristics$variable_name)),
            selected = sort(unique(prev_patient_characteristics$variable_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Raw data",
            tags$hr(),
            downloadButton("download_prev_patient_characteristics_raw", "Download csv data"),
            DTOutput("raw_prev_patient_characteristics") %>%
              withSpinner()
          )
        )
      ),
      # prev_lsc ------
      tabItem(
        tabName = "prev_lsc",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_lsc_cdm",
            label = "Database",
            choices = sort(unique(prev_large_scale_characteristics$cdm_name)),
            selected = sort(unique(prev_large_scale_characteristics$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_lsc_group_level",
            label = "Cohort",
            choices = sort(unique(prev_large_scale_characteristics$group_level)),
            selected = sort(unique(prev_large_scale_characteristics$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_lsc_time_window",
            label = "Time window",
            choices = sort(unique(prev_large_scale_characteristics$variable_level)),
            selected = sort(unique(prev_large_scale_characteristics$variable_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_lsc_strata",
            label = "Strata",
            choices = sort(unique(prev_lsc_strataOpsChars$strata)),
            selected = sort(unique(prev_lsc_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        downloadButton("download_dt_prev_large_scale_characteristics", "Download"),
        DT::dataTableOutput("dt_prev_large_scale_characteristics") %>%
          withSpinner()
      ),
      # prev_indication ------
      tabItem(
        tabName = "prev_indication",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_indication_cdm",
            label = "Database",
            choices = sort(unique(prev_indication$cdm_name)),
            selected = sort(unique(prev_indication$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_indication_group_level",
            label = "Cohort",
            choices = sort(unique(prev_indication$group_level)),
            selected = sort(unique(prev_indication$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_indication_time_window",
            label = "Time window",
            choices = sort(unique(prev_indication$variable_name)),
            selected = sort(unique(prev_indication$variable_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "indication_prev_indication",
            label = "Indication",
            choices = sort(unique(prev_indication$variable_level)),
            selected = sort(unique(prev_indication$variable_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_indication_strata",
            label = "Strata",
            choices = sort(unique(prev_indication_strataOpsChars$strata)),
            selected = sort(unique(prev_indication_strataOpsChars$strata)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$hr(),
        downloadButton("download_dt_prev_indication", "Download"),
        DT::dataTableOutput("dt_prev_indication") %>%
          withSpinner()
      ),
      
      
      # prev_use -------
      tabItem(
        tabName = "prev_use",
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_use_cdm",
            label = "Database",
            choices = sort(unique(prev_use_summary$cdm_name)),
            selected = sort(unique(prev_use_summary$cdm_name)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prev_use_group_level",
            label = "Cohort",
            choices = sort(unique(prev_use_summary$group_level)),
            selected = sort(unique(prev_use_summary$group_level)),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tags$style(HTML("
                  .tabbable > .nav > li > a {font-weight: bold; background-color: D3D4D8;  color:black}
                  ")),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Duration",
            tags$hr(),
            downloadButton("download_dt_prev_use_duration", "Download"),
            DT::dataTableOutput("dt_prev_use_duration") %>%
              withSpinner()
          ),
          tabPanel(
            "Initial daily dose (milligram)",
            tags$hr(),
            downloadButton("download_dt_prev_use_initial_dd", "Download"),
            DT::dataTableOutput("dt_prev_use_initial_dd") %>%
              withSpinner()
          ),
          tabPanel(
            "Cumulative dose (milligram)",
            tags$hr(),
            downloadButton("download_dt_prev_use_cumulative_dose", "Download"),
            DT::dataTableOutput("dt_prev_use_cumulative_dose") %>%
              withSpinner()
          ),
          tabPanel(
            "number_exposures",
            tags$hr(),
            downloadButton("download_dt_prev_use_number_exposures", "Download"),
            DT::dataTableOutput("dt_prev_use_number_exposures") %>%
              withSpinner()
          ),
          tabPanel(
            "Initial quantity",
            tags$hr(),
            downloadButton("download_dt_prev_use_initial_quantity", "Download"),
            DT::dataTableOutput("dt_prev_use_initial_quantity") %>%
              withSpinner()
          ),
          tabPanel(
            "Cumulative quantity",
            tags$hr(),
            downloadButton("download_dt_prev_use_cumulative_quantity", "Download"),
            DT::dataTableOutput("dt_prev_use_cumulative_quantity") %>%
              withSpinner()
          )
        )
      )
      
      
      # end -----
    )
  )
)