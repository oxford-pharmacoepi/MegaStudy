# Please restore the renv file first:
# if you have not installed renv, please first install: install.packages("renv")
renv::activate()
renv::restore()

library("odbc")
library("RPostgres")
library("DBI")
library("dplyr")
library("dbplyr")
library("CirceR")
library("CDMConnector")
library("here")
library("log4r")
library("zip")
library("DrugExposureDiagnostics")

# Connect to database
# please see examples to connect here:
# https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html
db <- dbConnect("...")


# parameters to connect to create cdm object
cdmSchema <- "..." # schema where cdm tables are located
writeSchema <- "..." # schema with writing permission
writePrefix <- "..." # combination of at least 5 letters + _ (eg. "abcde_") that will lead any table written in the cdm
dbName <- "..." # name of the database, use acronym in capital letters (eg. "CPRD GOLD")


# Run the study
source(here("Feasibility Code","RunFeasibility.R"))
