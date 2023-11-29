
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


# Feasibility step  ----
info(logger, 'QUERY DED PACKAGE')
output_feasibility <- executeChecks(
  cdm,
  ingredients = c(19098548,
                  1347450,
                  1594587,
                  912803,
                  40171288,
                  780442,
                  45892599,
                  1741122,
                  45892906,
                  1333379,
                  40239665,
                  1536743,
                  1742432,
                  1348407,
                  1525746,
                  1734104,
                  1750500,
                  1729720,
                  1728416,
                  1713332,
                  1759842,
                  1777806,
                  1774470,
                  1709170,
                  1778162,
                  1746114,
                  19136187,
                  1307515,
                  1186087,
                  42904205,
                  1510627,
                  1361580,
                  1151789,
                  937368,
                  912263,36857573,
                  19041065,
                  1114375,
                  19080982,
                  1397141,
                  718583,
                  40242044,
                  40168938,
                  36878937,
                  35200405,
                  37003361,
                  1311078,902730,36863408,
                  1311799,
                  19078097,
                  903643,
                  19012565,
                  19034726,
                  19010482,
                  950637,
                  1503983,
                  40174604,
                  42800246,
                  36878851
  ),    
  checks = c("missing", "exposureDuration","quantity","diagnosticsSummary"),
  minCellCount = 10,
  sample = 10000,
  earliestStartDate = "2010-01-01",
  verbose = FALSE
)
info(logger, 'OBTAINED DED RESULTS')

## save DED results ---
info(logger, 'WRITE DED RESULTS')
result <- writeResultToDisk(
  resultList = output_feasibility ,
  databaseId = dbName,
  outputFolder = outputFolder)
info(logger, 'SAVED DED RESULTS')


## zip everything together ---
zip(
  zipfile = here::here(paste0("Results_", cdmName(cdm), ".zip")),
  files = list.files(outputFolder),
  root = outputFolder
)


print("Done!")
print("If all has worked, there should now be a zip file with your feasibility results in the output folder to share")
print("Thank you for running the feasibility step!")
