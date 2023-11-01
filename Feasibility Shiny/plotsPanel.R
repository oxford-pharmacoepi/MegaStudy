# Module to display multiple plots in a panel

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
#' @param height plot height
#'
#' @return
#' The user interface to the results
#'
#' @export
plotsPanelViewer <- function(id, title, height = "200px") {
  ns <- shiny::NS(id)
  
  filterRow <- fluidRow(column(width = 3, uiOutput(ns("dbPickerUI"))),
                        column(width = 3, uiOutput(ns("ingredientPickerUI"))))
  tabPanel(title,
           filterRow,
           fluidRow(column(width = 12, uiOutput(ns("plotDescription")))),
           tags$hr(),
           withSpinner(plotlyOutput(ns('drugDaysSupplyPlot'), height = height)),
           withSpinner(plotlyOutput(ns('drugDurationPlot'), height = height)),
           withSpinner(plotlyOutput(ns('drugQuantityPlot'), height = height)))
}

#' The module server for rendering the results
#'
#' @param id the unique reference id for the module
#' @param description plot description
#' @param plotData
#'
#' @return the results server
#'
#' @export
plotsPanelServer <- function(id, description, plotData, commonInputs) {
  ns <- shiny::NS(id)
  
  createBarChart <- function(data) {
    if (!is.null(data) && nrow(data) > 0) {
      name <- unique(data$xname)
      data %>%
        dplyr::rename(!!name := breaks) %>%
        ggplot() +
        geom_bar(aes(x = !!sym(name), y = counts, fill = database_id), stat = "identity")
    }
  }
  
  getIngredientId <- function(ingredient) {
    as.numeric(sub(" .*", "", ingredient))
  }
  
  shiny::moduleServer(id,
                      function(input, output, session) {
                        
                        if (!is.null(plotData[[1]]) && nrow(plotData[[1]]) > 0) {
                          databases   <- unique(plotData[[1]]$database_id)
                          ingredients <- lapply(plotData, "[", c("ingredient_id", "ingredient"))
                          ingredients <- unique(bind_rows(ingredients))
                          ingredients <- do.call(paste, ingredients)
                          
                          output$plotDescription <- renderUI({
                            HTML(glue::glue("<center><b>{description}</b></center>"))
                          })
                          
                          observe({
                            req(commonInputs)
                            if (!identical(commonInputs$databases, commonInputsInitValue)) {
                              databases <- commonInputs$databases
                              updatePickerInput(
                                session = session,
                                inputId = "dbPicker",
                                selected = databases
                              )
                            }
                          })
                          
                          getDaysSupplyData <- reactive({
                            result <- NULL
                            databases <- input$dbPicker
                            ingredient <- input$ingredientPicker
                            if (!is.null(databases) && !is.null(ingredient)) {
                              result <- plotData[[1]]
                              result <- result %>%
                                filter(database_id %in% databases) %>%
                                filter(ingredient_id == getIngredientId(.env$ingredient))
                            }
                            result
                          })
                          
                          getDurationData <- reactive({
                            result <- NULL
                            databases <- input$dbPicker
                            ingredient <- input$ingredientPicker
                            if (!is.null(databases) && !is.null(ingredient)) {
                              result <- plotData[[2]]
                              result <- result %>%
                                filter(database_id %in% databases) %>%
                                filter(ingredient_id == getIngredientId(.env$ingredient))
                            }
                            result
                          })
                          
                          getQuantityData <- reactive({
                            result <- NULL
                            databases <- input$dbPicker
                            ingredient <- input$ingredientPicker
                            if (!is.null(databases) && !is.null(ingredient)) {
                              result <- plotData[[3]]
                              result <- result %>%
                                filter(database_id %in% databases) %>%
                                filter(ingredient_id == getIngredientId(.env$ingredient))
                            }
                            result
                          })
                          
                          output$dbPickerUI <- renderUI({
                            databases <- commonInputs$databases
                            pickerInput <- pickerInput(inputId = ns('dbPicker'),
                                                       label = 'Databases',
                                                       choices = databases,
                                                       options = list(`actions-box` = TRUE),
                                                       multiple = T,
                                                       selected = databases)
                            pickerInput <- disabled(pickerInput)
                            pickerInput
                          })
                          
                          output$ingredientPickerUI <- renderUI({
                            pickerInput(inputId = ns('ingredientPicker'),
                                        label = 'Ingredients',
                                        choices = ingredients,
                                        options = list(`actions-box` = TRUE),
                                        multiple = F,
                                        selected = ingredients)
                          })
                          
                          output$drugDaysSupplyPlot <- renderPlotly({
                            createBarChart(getDaysSupplyData())
                          })
                          output$drugDurationPlot <- renderPlotly({
                            createBarChart(getDurationData())
                          })
                          output$drugQuantityPlot <- renderPlotly({
                            createBarChart(getQuantityData())
                          })
                        }
                      }
  )
}