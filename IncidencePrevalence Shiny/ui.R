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
        text = "Study results",
        tabName = "study_results",
        menuSubItem(
          text = "Population-level incidence",
          tabName = "incidence"
        ),
        menuSubItem(
          text = "Population-level prevalence",
          tabName = "prevalence"
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
      
      ### incidence ----
      tabItem(
        tabName = "incidence",
        h3("Incidence estimates"),
        p("Incidence estimates are shown below, please select configuration to filter them:"),
        p("Database and study outcome"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_group",
            label = "Group",
            choices = sort(unique(incidence$group)),
            selected = unique(incidence$group),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_outcome_cohort_name",
            label = "Outcome name",
            choices = sort(unique(incidence$outcome_cohort_name)),
            selected = unique(incidence$outcome_cohort_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_cdm_name",
            label = "CDM name",
            choices = sort(unique(incidence$cdm_name)),
            selected = unique(incidence$cdm_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_data_type",
            label = "Data type",
            choices = sort(unique(incidence$data_type)),
            selected = unique(incidence$data_type),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_country",
            label = "Country",
            choices = sort(unique(incidence$country)),
            selected = unique(incidence$country),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        p("Denominator population settings"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_denominator_target_cohort_name",
            label = "Target cohort",
            choices = unique(incidence$denominator_target_cohort_name),
            selected = "General population",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_denominator_age_group",
            label = "Age group",
            choices = unique(incidence$denominator_age_group),
            selected = "0 to 150",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_denominator_sex",
            label = "Sex",
            choices = unique(incidence$denominator_sex),
            selected = "Both",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_denominator_days_prior_observation",
            label = "Days prior observation",
            choices = unique(incidence$denominator_days_prior_observation),
            selected = unique(incidence$denominator_days_prior_observation),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        p("Analysis settings"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_analysis_outcome_washout",
            label = "Outcome washout",
            choices = unique(incidence$analysis_outcome_washout),
            selected = unique(incidence$analysis_outcome_washout),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_analysis_repeated_events",
            label = "Repeated events",
            choices = unique(incidence$analysis_repeated_events),
            selected = unique(incidence$analysis_repeated_events),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_analysis_complete_database_intervals",
            label = "Complete period",
            choices = unique(incidence$analysis_complete_database_intervals),
            selected = unique(incidence$analysis_complete_database_intervals),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),        
        p("Dates"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_analysis_interval",
            label = "Interval",
            choices = unique(incidence$analysis_interval),
            selected = "years",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "incidence_estimates_incidence_start_date",
            label = "Incidence start date",
            choices = as.character(unique(incidence$incidence_start_date), format = "%Y-%m-%d"),
            selected = as.character(unique(incidence$incidence_start_date), format = "%Y-%m-%d"),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Table of estimates",
            downloadButton("incidence_estimates_download_table", "Download current estimates"),
            DTOutput("incidence_estimates_table") %>% withSpinner()
          ),
          tabPanel(
            "Plot of estimates",
            p("Plotting options"),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "incidence_estimates_plot_x",
                label = "x axis",
                choices = c("cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "denominator_start_date", "denominator_end_date", "analysis_outcome_washout", "analysis_repeated_events", "analysis_complete_database_intervals", "analysis_min_cell_count", "analysis_interval", "incidence_start_date"),
                selected = "incidence_start_date",
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = FALSE
              )
            ),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "incidence_estimates_plot_facet",
                label = "Facet by",
                choices = c("group","cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "denominator_start_date", "denominator_end_date", "analysis_outcome_washout", "analysis_repeated_events", "analysis_complete_database_intervals", "analysis_min_cell_count", "analysis_interval", "incidence_start_date"),
                selected = c("cdm_name","group"),
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = TRUE
              )
            ),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "incidence_estimates_plot_colour",
                label = "Colour by",
                choices = c("cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "denominator_start_date", "denominator_end_date", "analysis_outcome_washout", "analysis_repeated_events", "analysis_complete_database_intervals", "analysis_min_cell_count", "analysis_interval", "incidence_start_date"),
                selected = "outcome_cohort_name",
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = TRUE
              )
            ),
            plotlyOutput(
              "incidence_estimates_plot",
              height = "1100px",
              width = "1550px"
            ) %>%
              withSpinner(),
            h4("Download figure"),
            div("height:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block;",
              textInput("incidence_estimates_download_height", "", 10, width = "50px")
            ),
            div("cm", style = "display: inline-block; margin-right: 25px;"),
            div("width:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block;",
              textInput("incidence_estimates_download_width", "", 20, width = "50px")
            ),
            div("cm", style = "display: inline-block; margin-right: 25px;"),
            div("dpi:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block; margin-right:",
              textInput("incidence_estimates_download_dpi", "", 300, width = "50px")
            ),
            downloadButton("incidence_estimates_download_plot", "Download plot")
          )
        )
      ),
      # prevalence ----
      tabItem(
        tabName = "prevalence",
        h3("Prevalence estimates"),
        p("Prevalence estimates are shown below, please select configuration to filter them:"),
        p("Database and study outcome"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_group",
            label = "Group",
            choices = sort(unique(prevalence$group)),
            selected = unique(prevalence$group),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_outcome_cohort_name",
            label = "Outcome name",
            choices = sort(unique(prevalence$outcome_cohort_name)),
            selected = unique(prevalence$outcome_cohort_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_cdm_name",
            label = "CDM name",
            choices = unique(prevalence$cdm_name),
            selected = unique(prevalence$cdm_name),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_data_type",
            label = "Data type",
            choices = sort(unique(prevalence$data_type)),
            selected = unique(prevalence$data_type),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_country",
            label = "Country",
            choices = sort(unique(prevalence$country)),
            selected = unique(prevalence$country),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        p("Denominator population settings"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_denominator_target_cohort_name",
            label = "Target cohort",
            choices = unique(prevalence$denominator_target_cohort_name),
            selected = "General population",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_denominator_age_group",
            label = "Age group",
            choices = unique(prevalence$denominator_age_group),
            selected = "0 to 150",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_denominator_sex",
            label = "Sex",
            choices = unique(prevalence$denominator_sex),
            selected = "Both",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_denominator_days_prior_observation",
            label = "Days prior observation",
            choices = unique(prevalence$denominator_days_prior_observation),
            selected = unique(prevalence$denominator_days_prior_observation),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        p("Analysis settings"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_analysis_type",
            label = "Prevalence type",
            choices = unique(prevalence$analysis_type),
            selected = unique(prevalence$analysis_type),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_analysis_time_point",
            label = "Time point",
            choices = unique(prevalence$analysis_time_point),
            selected = unique(prevalence$analysis_time_point),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_analysis_complete_database_intervals",
            label = "Complete period",
            choices = unique(prevalence$analysis_complete_database_intervals),
            selected = unique(prevalence$analysis_complete_database_intervals),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_analysis_full_contribution",
            label = "Full contribution",
            choices = unique(prevalence$analysis_full_contribution),
            selected = unique(prevalence$analysis_full_contribution),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        p("Dates"),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_analysis_interval",
            label = "Interval",
            choices = unique(prevalence$analysis_interval),
            selected = "years",
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        div(
          style = "display: inline-block;vertical-align:top; width: 150px;",
          pickerInput(
            inputId = "prevalence_estimates_prevalence_start_date",
            label = "Prevalence start date",
            choices = as.character(unique(prevalence$prevalence_start_date), format = "%Y-%m-%d"),
            selected = as.character(unique(prevalence$prevalence_start_date), format = "%Y-%m-%d"),
            options = list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
            multiple = TRUE
          )
        ),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Table of estimates",
            downloadButton("prevalence_estimates_download_table", "Download current estimates"),
            DTOutput("prevalence_estimates_table") %>% withSpinner()
          ),
          tabPanel(
            "Plot of estimates",
            p("Plotting options"),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "prevalence_estimates_plot_x",
                label = "x axis",
                choices = c(
                  "cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "analysis_type", "analysis_time_point",
                  "analysis_complete_database_intervals", "analysis_full_contribution", "analysis_min_cell_count", "analysis_interval", "prevalence_start_date"
                ),
                selected = "prevalence_start_date",
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = FALSE
              )
            ),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "prevalence_estimates_plot_facet",
                label = "Facet by",
                choices = c("group","cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "denominator_start_date", "denominator_end_date", "analysis_type", "analysis_time_point", "analysis_complete_database_intervals", "analysis_full_contribution", "analysis_min_cell_count", "analysis_interval", "prevalence_start_date"),
                selected = "cdm_name",
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = TRUE
              )
            ),
            div(
              style = "display: inline-block;vertical-align:top; width: 150px;",
              pickerInput(
                inputId = "prevalence_estimates_plot_colour",
                label = "Colour by",
                choices = c("cdm_name", "outcome_cohort_name", "denominator_target_cohort_name", "denominator_age_group", "denominator_sex", "denominator_days_prior_observation", "denominator_start_date", "denominator_end_date", "analysis_type", "analysis_time_point", "analysis_complete_database_intervals", "analysis_full_contribution", "analysis_min_cell_count", "analysis_interval", "prevalence_start_date"),
                selected = "outcome_cohort_name",
                list(`actions-box` = TRUE, size = 10, `selected-text-format` = "count > 3"),
                multiple = TRUE
              )
            ),
            plotlyOutput(
              "prevalence_estimates_plot",
              height = "1100px",
              width = "1150px"
            ) %>%
              withSpinner(),
            h4("Download figure"),
            div("height:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block;",
              textInput("prevalence_estimates_download_height", "", 10, width = "50px")
            ),
            div("cm", style = "display: inline-block; margin-right: 25px;"),
            div("width:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block;",
              textInput("prevalence_estimates_download_width", "", 20, width = "50px")
            ),
            div("cm", style = "display: inline-block; margin-right: 25px;"),
            div("dpi:", style = "display: inline-block; font-weight: bold; margin-right: 5px;"),
            div(
              style = "display: inline-block; margin-right:",
              textInput("prevalence_estimates_download_dpi", "", 300, width = "50px")
            ),
            downloadButton("prevalence_estimates_download_plot", "Download plot")
          )
        )
      )
      
      
      # end -----
    )
  )
)
      
      