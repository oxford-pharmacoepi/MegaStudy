# User interface definition

allTabsList <- list(
  tableFilterPanelViewer("ingredientConcepts", "Ingredient concepts", byConcept = FALSE),
  widths = c(2, 10))

# add tabs depending on if the data is available
if (nrow(ingredientOverview) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("ingredientOverview", "Ingredient detail strata", byConcept = FALSE)
}
if (nrow(ingredientPresence) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("ingredientPresence", "Ingredient presence", byConcept = FALSE)
}
if (nrow(drugRoutes) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugRoutes", "Drug routes")
}
if (nrow(drugTypes) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugTypes", "Drug types")
}
if (nrow(drugSourceConcepts) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugSourceConcepts", "Drug source concepts")
}
if (nrow(drugExposureDuration) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugExposureDuration", "Drug exposure duration")
}
if (nrow(drugVariablesMissing) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugVariablesMissing", "Drug variables missing")
}
if (nrow(drugDaysSupply) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugDaysSupply", "Drug days supply")
}
if (nrow(drugQuantity) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugQuantity", "Drug quantity")
}
if (nrow(drugSig) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugSig", "Drug sig")
}
if (nrow(drugVerbatimEndDate) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugVerbatimEndDate", "Drug verbatim end date")
}
if (nrow(drugDailyDose) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    tableFilterPanelViewer("drugDailyDose", "Drug daily dose")
}
if (nrow(drugDaysSupplyHistogram) > 0) {
  allTabsList[[length(allTabsList) + 1]] <-
    plotsPanelViewer("drugDistributions", "Drug distributions")
}

fluidPage(theme = bs_theme(version = "5", bootswatch = "spacelab"),
          useShinyjs(),
          titlePanel(title = h2("Drug Exposure Diagnostics Dashboard", align = "center"),
                     windowTitle = "Drug Exposure Diagnostics Dashboard"),
          do.call(navlistPanel, allTabsList))