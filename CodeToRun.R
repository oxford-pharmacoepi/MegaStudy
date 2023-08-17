# This is the only code the user should interact with
# Gets the Feasibility Information for the MegaStudy

# Required packages
library("DBI")
library("dplyr")
library("dbplyr")
library("CirceR")
library("CDMConnector")
library("here")
library("log4r")
library("zip")
library("DrugExposureDiagnostics")

# Database name or acronym (e.g. for CPRD AURUM use "CPRDAurum")
db.name <- "..."

# Name of the output folder to save the results. Change to "output" or any other desired path
output.folder <- here("Results",db.name)

# Change the following parameters with your own database information
user <- Sys.getenv("...")
password <- Sys.getenv("...")
port <- Sys.getenv("...")
host <- Sys.getenv("...")
server_dbi <- Sys.getenv("...")

# Create database connection
# We use the DBI package to create a cdm_reference
db <- dbConnect("...",
                dbname = server_dbi,
                port = port,
                host = host, 
                user = user, 
                password = password)

# Name of the schema with the patient-level data
cdm_database_schema <- "..."

# Name of the schema with the vocabulary, usually the same as the patient-level data schema
vocabulary_database_schema <- cdm_database_schema

# Name of the schema where the result table will be created
results_database_schema <- "..."

# Name of the outcome table in the result table where the outcome cohorts will be stored
cohort_table_name <- "..."

# Create cdm reference
cdm <- CDMConnector::cdm_from_con(con = db, cdm_schema = cdm_database_schema, write_schema = results_database_schema)

# Check if the DBI connection is correct, the next line should give you a count of your person table
cdm$person %>% tally()

# Run the study
source(here("RunStudy.R"))

# After this is run you should have a zip file in your output folder to share
