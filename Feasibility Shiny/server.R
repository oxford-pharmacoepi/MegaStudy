#### SERVER ------
server <-	function(input, output, session) {
  
  commonInputs <- reactiveValues()
  commonInputs$databases   <- commonInputsInitValue
  commonInputs$ingredients <- commonInputsInitValue
  
  tableFilterPanelServer(id = "ingredientConcepts",
                         data = ingredientConcepts,
                         downloadFilename = "IngredientConcepts.csv",
                         description = "Ingredient concepts",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "ingredientOverview",
                         data = ingredientOverview,
                         downloadFilename = "ingredientOverview.csv",
                         description = "Ingredient detail strata",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "ingredientPresence",
                         data = ingredientPresence,
                         downloadFilename = "IngredientPresence.csv",
                         description = "Ingredient presence",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugRoutes",
                         data = drugRoutes,
                         dataByConcept = drugRoutesByConcept,
                         downloadFilename = "DrugRoutes.csv",
                         description = "Drug routes",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugTypes",
                         data = drugTypes,
                         dataByConcept = drugTypesByConcept,
                         downloadFilename = "DrugTypes.csv",
                         description = "Drug types",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugSourceConcepts",
                         data = drugSourceConcepts,
                         dataByConcept = drugSourceConceptsByConcept,
                         downloadFilename = "DrugSourceConcepts.csv",
                         description = "Drug source concepts",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugExposureDuration",
                         data = drugExposureDuration,
                         dataByConcept = drugExposureDurationByConcept,
                         downloadFilename = "DrugExposureDuration.csv",
                         description = "Drug exposure duration",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugVariablesMissing",
                         data = drugVariablesMissing,
                         dataByConcept = drugVariablesMissingByConcept,
                         downloadFilename = "DrugVariablesMissing.csv",
                         description = "Drug variables missing",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugDaysSupply",
                         data = drugDaysSupply,
                         dataByConcept = drugDaysSupplyByConcept,
                         downloadFilename = "DrugDaysSupply.csv",
                         description = "Drug days supply",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugQuantity",
                         data = drugQuantity,
                         dataByConcept = drugQuantityByConcept,
                         downloadFilename = "DrugQuantity.csv",
                         description = "Drug quantity",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugSig",
                         data = drugSig,
                         dataByConcept = drugSigByConcept,
                         downloadFilename = "DrugSig.csv",
                         description = "Drug sig",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugVerbatimEndDate",
                         data = drugVerbatimEndDate,
                         dataByConcept = drugVerbatimEndDateByConcept,
                         downloadFilename = "DrugVerbatimEndDate.csv",
                         description = "Drug verbatim end date",
                         commonInputs = commonInputs)
  tableFilterPanelServer(id = "drugDailyDose",
                         data = drugDailyDose,
                         dataByConcept = drugDailyDoseByConcept,
                         downloadFilename = "drugDailyDose.csv",
                         description = "Drug daily dose",
                         commonInputs = commonInputs)
  plotsPanelServer(id = "drugDistributions",
                   description = "Drug distribution",
                   plotData = list(drugDaysSupplyHistogram,
                                   drugDurationHistogram,
                                   drugQuantityHistogram),
                   commonInputs = commonInputs)
}