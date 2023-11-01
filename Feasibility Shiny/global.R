# Please restore the renv file first:
# if you have not installed renv, please first install: install.packages("renv")
# renv::activate()
# renv::restore()


#### PACKAGES -----
library(shiny)
library(bslib)
library(here)
library(readr)
library(dplyr)
library(stringr)
library(checkmate)
library(DT)
library(shinycssloaders)
library(shinyWidgets)
library(glue)
library(ggplot2)
library(plotly)
library(shinyjs)
source("tableFilterPanel.R")
source("plotsPanel.R")

# input directory
DATA_DIRECTORY <- "data"

if (!dir.exists(DATA_DIRECTORY)) {
  stop(glue("Please make sure the '{DATA_DIRECTORY}' directory exists."))
}

subDirs <- list.dirs(DATA_DIRECTORY, full.names = TRUE, recursive = FALSE)
if (identical(subDirs, character(0))) {
  stop(glue("No subdirectories found in '{DATA_DIRECTORY}'. Please make sure to
            store the results (per database) in a separate folder."))
}

commonInputsInitValue <- c("INIT")

# load data from directory, merge csv's for multiple databases
mergeFiles <- function(files) {
  results <- dplyr::bind_rows(lapply(files,
                                     FUN = function(filename) {
                                       result <- NULL
                                       if (file.exists(filename)) {
                                         result <- read.csv(filename)
                                         if (grepl("drugVerbatimEndDate", filename)) {
                                           result <- result %>%
                                             dplyr::mutate(minimum_verbatim_end_date = ifelse(class(minimum_verbatim_end_date) %in% c("numeric", "integer"),
                                                                                              format(as.Date(as.POSIXct(minimum_verbatim_end_date, origin="1970-01-01"))),
                                                                                              minimum_verbatim_end_date)) %>%
                                             dplyr::mutate(maximum_verbatim_end_date = ifelse(class(maximum_verbatim_end_date) %in% c("numeric", "integer"),
                                                                                              format(as.Date(as.POSIXct(maximum_verbatim_end_date, origin="1970-01-01"))),
                                                                                              maximum_verbatim_end_date))
                                         }
                                         if (grepl("ingredientConcepts", filename)) {
                                           result <- result %>%
                                             dplyr::mutate(concept_code = as.character(concept_code)) %>%
                                             dplyr::mutate(valid_start_date = ifelse(class(valid_start_date) == "integer",
                                                                                     format(as.Date(valid_start_date, origin="1970-01-01")),
                                                                                     valid_start_date)) %>%
                                             dplyr::mutate(valid_end_date = ifelse(class(valid_end_date) == "integer",
                                                                                   format(as.Date(valid_end_date, origin="1970-01-01")),
                                                                                   valid_end_date))
                                         }
                                       }
                                       result
                                     }))
  if (nrow(results) > 0) {
    results <- results %>%
      dplyr::rename(any_of(c(ingredient_id = "ingredient_concept_id"))) %>%
      dplyr::mutate_at(vars(starts_with("proportion_")), ~ 100*.) %>%
      dplyr::rename_with(~gsub("proportion_","perc_", .x)) %>%
      dplyr::mutate_at(vars(which(sapply(., is.numeric) & !names(.) %in% c("ingredient_id", "drug_concept_id","n"))),
                       ~signif(., 4))
  }
  return(results)
}

ingredientConcepts <- mergeFiles(file.path(subDirs, "conceptSummary.csv"))
ingredientOverview <- mergeFiles(file.path(subDirs, "drugIngredientOverview.csv"))
ingredientPresence <- mergeFiles(file.path(subDirs, "drugIngredientPresence.csv"))

# data overall and by concept
drugRoutes <- mergeFiles(file.path(subDirs, "drugRoutesOverall.csv"))
drugRoutesByConcept <- mergeFiles(file.path(subDirs, "drugRoutesByConcept.csv"))

drugVariablesMissing <- mergeFiles(file.path(subDirs, "missingValuesOverall.csv"))
drugVariablesMissingByConcept <- mergeFiles(file.path(subDirs, "missingValuesByConcept.csv"))

drugTypes <- mergeFiles(file.path(subDirs, "drugTypesOverall.csv"))
drugTypesByConcept <- mergeFiles(file.path(subDirs, "drugTypesByConcept.csv"))

drugExposureDuration <- mergeFiles(file.path(subDirs, "drugExposureDurationOverall.csv"))
drugExposureDurationByConcept <- mergeFiles(file.path(subDirs, "drugExposureDurationByConcept.csv"))

drugSourceConcepts <- mergeFiles(file.path(subDirs, "drugSourceConceptsOverall.csv"))
drugSourceConceptsByConcept <- mergeFiles(file.path(subDirs, "drugSourceConceptsByConcept.csv"))

drugDaysSupply <- mergeFiles(file.path(subDirs, "drugDaysSupply.csv"))
drugDaysSupplyByConcept <- mergeFiles(file.path(subDirs, "drugDaysSupplyByConcept.csv"))

drugQuantity <- mergeFiles(file.path(subDirs, "drugQuantity.csv"))
drugQuantityByConcept <- mergeFiles(file.path(subDirs, "drugQuantityByConcept.csv"))

drugSig <- mergeFiles(file.path(subDirs, "drugSig.csv"))
drugSigByConcept <- mergeFiles(file.path(subDirs, "drugSigByConcept.csv"))

drugVerbatimEndDate <- mergeFiles(file.path(subDirs, "drugVerbatimEndDate.csv"))
drugVerbatimEndDateByConcept <- mergeFiles(file.path(subDirs, "drugVerbatimEndDateByConcept.csv"))

drugDailyDose <- mergeFiles(file.path(subDirs, "drugDose.csv"))
drugDailyDoseByConcept <- mergeFiles(file.path(subDirs, "drugDoseByConcept.csv"))

# plots
drugDaysSupplyHistogram <- mergeFiles(file.path(subDirs, "drugDaysSupplyHistogram.csv"))
drugDurationHistogram <- mergeFiles(file.path(subDirs, "drugDurationHistogram.csv"))
drugQuantityHistogram <- mergeFiles(file.path(subDirs, "drugQuantityHistogram.csv"))