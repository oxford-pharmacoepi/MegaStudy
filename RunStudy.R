# Create output folder if it doesn't exist
if (!file.exists(output.folder)){
  dir.create(output.folder, recursive = TRUE)}

# Create zip file
zipName <- paste0(db.name,"_feasibility")
tempDir <- zipName
tempDirCreated <- FALSE
if (!dir.exists(tempDir)) {
  dir.create(tempDir)
  tempDirCreated <- TRUE
}

start <- Sys.time()

# Start log
log_file <- paste0(tempDir, "/log.txt")
logger <- create.logger()
logfile(logger) <- log_file
level(logger) <- "INFO"

# Counts
output_feasibility <- cdm[[cohort_table_name]] %>% 
  group_by(cohort_definition_id) %>% 
  tally() %>% 
  collect() %>% 
  right_join(FC_cohorts, by = c("cohort_definition_id")) %>% mutate(n = as.numeric(n)) %>% mutate(n = if_else(is.na(n), 0, n)) %>% mutate(n = ifelse(n <= 5, NA, n)) %>% select(cohort_name,n)
info(logger, 'GOT COUNTS')

# Export csv
write.csv(output_feasibility,
          file = file.path(
            tempDir,
            paste0(db.name,"_ded.csv")
          ),
          row.names = FALSE
)

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
