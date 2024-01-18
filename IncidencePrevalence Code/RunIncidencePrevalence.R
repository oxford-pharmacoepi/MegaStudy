
# Define output folder ----
outputFolder <- here::here("storage")   
# Create output folder if it doesn't exist
if (!file.exists(outputFolder)){
  dir.create(outputFolder, recursive = TRUE)}


# Start log ----
log_file <- here::here(outputFolder, paste0(dbName, "_log.txt"))
logger <- create.logger()
logfile(logger) <- log_file
level(logger) <- "INFO"

# Create cdm object ----
info(logger, 'CREATE CDM OBJECT')
cdm <- cdmFromCon(
  con = db,
  cdmSchema = c(schema = cdmSchema),
  writeSchema = c(schema = writeSchema, prefix = writePrefix),
  cdmName = dbName
)


# cdm snapshot ----
info(logger, 'CREATE SNAPSHOT')
write.csv(
  x = snapshot(cdm),
  file = here(outputFolder, paste0("snapshot_", cdmName(cdm), ".csv")),
  row.names = FALSE
)


# if SIDIAP filter cdm$drug_exposure
if (cdmName(cdm) == "SIDIAP") {
  info(logger, "FILTER DRUG EXPOSURE TABLE SIDIAP")
  cdm$drug_exposure <- cdm$drug_exposure %>%
    filter(drug_type_concept_id == 32839) %>%
    compute()
}

## Generate drug cohorts ----
info(logger, "GENERATE DRUG COHORTS")
source(here("Concepts generation.R"))

cdm <- generateConceptCohortSet(
  cdm = cdm,
  conceptSet = concept_objects,
  name = "outcomes",
  limit = "all",
  requiredObservation = c(0, 0),
  end = "observation_period_end_date",
  overwrite = TRUE
)


## get denominator population ----
info(logger, "GENERATE DENOMINATOR COHORT")
cdm <- generateDenominatorCohortSet(
  cdm = cdm, 
  name = "denominator",
  cohortDateRange = as.Date(c("2010-01-01","2024-12-31")),
  ageGroup = list(
    c(0, 150),
    c(0, 17),
    c(18, 64),
    c(65, 150)
  ),
  sex = c("Both", "Female", "Male"),
  daysPriorObservation = 0,
  overwrite = TRUE
)


## get incidence proportion ---
## drug cohorts (repetitive events allowed) with 30 day washout period
info(logger, "ESTIMATE INCIDENCE RATES")
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcomes",
  interval = "years",
  completeDatabaseIntervals = FALSE,
  outcomeWashout = 30,
  repeatedEvents = FALSE,
  minCellCount = 10,
  temporary = TRUE
)
info(logger, "INCIDENCE ATTRITION")
write.csv(incidenceAttrition(inc),
          here("storage", paste0(
            "incidence_attrition_", cdmName(cdm), ".csv"
          )))

## get annual period prevalence ---
info(logger, "ESTIMATE PERIOD PREVALENCE")
prev <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcomes",
  interval = "years",
  completeDatabaseIntervals = FALSE,
  minCellCount = 10,
  temporary = TRUE
)

info(logger, "PREVALENCE ATTRITION")
write.csv(prevalenceAttrition(prev),
          here("storage", paste0(
            "prevalence_attrition_", cdmName(cdm), ".csv"
          )))

## export results
info(logger, "ZIP INCPREV RESULTS")
exportIncidencePrevalenceResults(
  resultList = list("Prevalence" = prev, "Incidence" = inc),
  zipName = paste0(cdmName(cdm), "_IncidencePrevalenceResults"),
  outputFolder = outputFolder
)


## zip everything together ---
info(logger, "ZIP EVERYTHING")
zip(
  zipfile = here::here(paste0("Results_", cdmName(cdm), ".zip")),
  files = list.files(outputFolder),
  root = outputFolder
)

print("Done!")
print("If all has worked, there should now be a zip file with your Incidence Prevalence results in the output folder to share")
print("Thank you for running the Incidence Prevalence analysis!")