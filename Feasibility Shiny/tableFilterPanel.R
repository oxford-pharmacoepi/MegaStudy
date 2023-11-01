# Module to display and filter data

# @file tableFilterPanel
# Copyright 2022 DARWIN EU®
#
# This file is part of IncidencePrevalence
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#' The module viewer for rendering the results
#'
#' @param id the unique reference id for the module
#' @param title panel title
#' @param byConcept add byConcept switch
#'
#' @return
#' The user interface to the results
#'
#' @export
tableFilterPanelViewer <- function(id, title, byConcept = TRUE) {
  ns <- shiny::NS(id)
  filterRow <- fluidRow(
    column(width = 3, uiOutput(ns("dbPickerUI"))),
    column(width = 3, uiOutput(ns("ingredientPickerUI"))),
    column(width = 3, uiOutput(ns("columnPickerUI")))
  )
  if (byConcept) {
    filterRow <- fluidRow(
      column(width = 3, uiOutput(ns("dbPickerUI"))),
      column(width = 3, uiOutput(ns("ingredientPickerUI"))),
      column(width = 3, uiOutput(ns("columnPickerUI"))),
      column(
        width = 3,
        tags$br(), tags$br(),
        prettyCheckbox(
          inputId = ns("byConcept"),
          label = "By concept",
          value = FALSE
        )
      )
    )
  }
  tabPanel(
    title,
    filterRow,
    fluidRow(column(width = 12, uiOutput(ns("tableDescription")))),
    tags$hr(),
    withSpinner(DT::dataTableOutput(ns("mainTable"))),
    tags$hr(),
    uiOutput(ns("downloadButtonUI"))
  )
}

#' The module server for rendering the results
#'
#' @param id the unique reference id for the module
#' @param data the data
#' @param dataByConcept the data
#' @param downloadFilename filename of the table data that can be downloaded
#' @param description table description
#' @param commonInputs common inputs
#'
#' @return the results table server
#'
#' @export
tableFilterPanelServer <- function(id, data, dataByConcept, downloadFilename, description, commonInputs) {
  ns <- shiny::NS(id)
  
  shiny::moduleServer(
    id,
    function(input, output, session) {
      
      requiredCols   <- c("database_id", "ingredient_id", "ingredient")
      ingredientCols <- requiredCols[2:3]
      referenceTabId <- "ingredientConcepts"
      
      if (nrow(data) > 0) {
        databases <- unique(data$database_id)
        ingredients <- data %>%
          dplyr::mutate(ingredient = str_to_title(ingredient)) %>%
          dplyr::select(all_of(ingredientCols)) %>%
          dplyr::distinct()
        ingredients <- do.call(paste, ingredients)
        columns <- colnames(data)[!colnames(data) %in% requiredCols]
        
        getData <- reactive({
          result <- NULL
          databases <- input$dbPicker
          ingredients <- input$ingredientPicker
          columns <- input$columnPicker
          if (!is.null(databases) && !is.null(ingredients) && !is.null(columns)) {
            result <- data
            byConcept <- input$byConcept
            if (!is.null(byConcept) && byConcept) {
              result <- dataByConcept
            }
            result <- result %>%
              select(all_of(c(requiredCols, columns))) %>%
              filter(database_id %in% databases) %>%
              filter(ingredient_id %in% sub(" .*", "", ingredients))
          }
        })
        
        observeEvent(input[["ingredientPicker"]], {
          if (id == referenceTabId) {
            commonInputs$ingredients <- input$ingredientPicker
          }
        }, ignoreNULL = FALSE, ignoreInit = TRUE)
        
        # update ingredients
        observeEvent(input[["dbPicker"]], {
          databases <- input$dbPicker
          if (id == referenceTabId) {
            commonInputs$databases <- databases
            if (!is.null(databases)) {
              ingredientIds <- data %>%
                filter(database_id %in% databases) %>%
                pull(ingredient_id)
              
              ingredients <- data %>%
                dplyr::filter(ingredient_id %in% .env$ingredientIds) %>%
                dplyr::mutate(ingredient = str_to_title(.data$ingredient)) %>%
                dplyr::select(all_of(ingredientCols)) %>%
                dplyr::distinct()
              
              ingredients <- do.call(paste, ingredients)
              updatePickerInput(
                session = session,
                inputId = "ingredientPicker",
                choices = ingredients,
                selected = ingredients
              )
            }
          }
        }, ignoreNULL = FALSE, ignoreInit = TRUE)
        
        observe({
          req(commonInputs)
          if (id != referenceTabId) {
            if (!identical(commonInputs$ingredients, commonInputsInitValue)) {
              ingredients <- commonInputs$ingredients
              updatePickerInput(
                session = session,
                inputId = "ingredientPicker",
                selected = ingredients)
            }
            
            if (!identical(commonInputs$databases, commonInputsInitValue)) {
              databases <- commonInputs$databases
              updatePickerInput(
                session = session,
                inputId = "dbPicker",
                selected = databases)
            }
          }
        })
        
        output$tableDescription <- renderUI({
          byConcept <- ifelse(!is.null(input$byConcept) && input$byConcept, " by concept", "")
          HTML(glue::glue("<center><b>{description}{byConcept}</b></center>"))
        })
        
        output$dbPickerUI <- renderUI({
          if (id != referenceTabId && !identical(commonInputs$databases, commonInputsInitValue)) {
            databases <- commonInputs$databases
          }
          pickerInput <- pickerInput(
            inputId = ns("dbPicker"),
            label = "Databases",
            choices = databases,
            options = list(`actions-box` = TRUE),
            multiple = T,
            selected = databases
          )
          if (id != referenceTabId) {
            pickerInput <- disabled(pickerInput)
          }
          pickerInput
        })
        
        output$ingredientPickerUI <- renderUI({
          if (id != referenceTabId && !identical(commonInputs$ingredients, commonInputsInitValue)) {
            ingredients <- commonInputs$ingredients
          }
          pickerInput <- pickerInput(
            inputId = ns("ingredientPicker"),
            label = "ingredients",
            choices = ingredients,
            options = list(`actions-box` = TRUE),
            multiple = T,
            selected = ingredients
          )
          if (id != referenceTabId) {
            pickerInput <- disabled(pickerInput)
          }
          pickerInput
        })
        
        output$columnPickerUI <- renderUI({
          pickerInput(
            inputId = ns("columnPicker"),
            label = "Columns",
            choices = columns,
            options = list(`actions-box` = TRUE),
            multiple = T,
            selected = columns
          )
        })
        
        output$downloadButtonUI <- renderUI({
          data <- getData()
          if (!is.null(data) && nrow(data) > 0) {
            downloadBttn(ns("downloadButton"),
                         size = "xs",
                         label = "Download")
          }
        })
        
        output$mainTable <- DT::renderDataTable({
          validate(need(ncol(getData()) > 1, "No input data"))
          
          DT::datatable(getData(), rownames = FALSE)
        })
        
        output$downloadButton <- downloadHandler(
          filename = function() {
            downloadFilename
          },
          content = function(file) {
            write.csv(getData(), file, row.names = FALSE)
          }
        )
      }
    }
  )
}