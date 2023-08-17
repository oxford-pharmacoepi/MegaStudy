# Create output folder if it doesn't exist
if (!file.exists(output.folder)){
  dir.create(output.folder, recursive = TRUE)}

start <- Sys.time()

# Start log
log_file <- paste0(tempDir, "/log.txt")
logger <- create.logger()
logfile(logger) <- log_file
level(logger) <- "INFO"

# Feasibility step
output_feasibility <- executeChecks(
cdm,
ingredients = c(),    # put all the drugs on ingredient level here
subsetToConceptId = NULL,
checks = c("missing", "exposureDuration", "type", "route", "sourceConcept",
"daysSupply", "verbatimEndDate", "dose", "sig", "quantity", "histogram"),
minCellCount = 5,
sample = 1e+06,
tablePrefix = NULL,
earliestStartDate = "2010-01-01",
verbose = FALSE
)

## Export csv from DED package
result <- writeResultToDisk(
  resultList = output_feasibility ,
  databaseId = db.name,
  outputFolder = output.folder)


info(logger, 'SAVED RESULTS IN THE OUTPUT FOLDER')
Sys.time() - start
readLines(log_file)

zip::zip(zipfile = file.path(output.folder, paste0(zipName, ".zip")),
         files = list.files(tempDir, full.names = TRUE))
if (tempDirCreated) {
  unlink(tempDir, recursive = TRUE)
}

print("Done!")
print("If all has worked, there should now be a zip file with your results in the output folder to share")
print("Thank you for running the feasibility step!")
