
# Define output folder ----
outputFolder <- here::here("Feasibility Code","Results")   
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
  file = here("Results", paste0("snapshot_", cdmName(cdm), ".csv")),
  row.names = FALSE
)


# Feasibility step  ----
info(logger, 'QUERY DED PACKAGE')
output_feasibility <- executeChecks(
  cdm,
  ingredients = c(19098548
  ),    
  checks = c("missing", "exposureDuration","quantity","diagnosticsSummary"),
  minCellCount = 5,
  sample = 10000,
  earliestStartDate = "2010-01-01",
  verbose = FALSE
)
info(logger, 'OBTAINED DED RESULTS')

## Export zip file ---
info(logger, 'WRITE DED RESULTS')
result <- writeResultToDisk(
  resultList = output_feasibility ,
  databaseId = dbName,
  outputFolder = outputFolder)


info(logger, 'SAVED RESULTS IN THE OUTPUT FOLDER')


print("Done!")
print("If all has worked, there should now be a zip file with your feasibility results in the output folder to share")
print("Thank you for running the feasibility step!")
