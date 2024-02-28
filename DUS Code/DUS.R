
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


## Generate indication concepts ----
info(logger, "GENERATE INDICATION CONCEPTS")
source(here("individual_indications.R"))

## Generate indication cohorts ----
info(logger, "GENERATE INDICATION COHORTS")

covid <- CDMConnector::readCohortSet(
  here::here("json_cohort"))

cdm <- CDMConnector::generateCohortSet(cdm,
                                       covid,
                                       name = "covid",
                                       overwrite = TRUE)

attr(cdm$covid, "cohort_attrition") <- attr(cdm$covid, "cohort_attrition") %>% mutate(number_subjects = as.integer(number_subjects),
                                                                                      number_records = as.integer(number_records))

name_indication <- c("neutropenia",
                     "bacteraemia",
                     "infection",
                     "pneumonia",
                     "orthopaedic_surgery",
                     "cardiovascular_surgery",
                     "gynecologic_surgery",
                     "chronic_bronchitis",
                     "cataract_surgery",
                     "meningitis",
                     "urogenital_surgery",
                     "prostatic_surgery",
                     "gastrointestinal_surgery",
                     "colorectal_surgery",
                     "endocarditis",
                     "sepsis",
                     "lyme_disease",
                     "copd",
                     "syphilis",
                     "gonorrhea",
                     "otitis_media",
                     "osteomyelitis",
                     "cellulitis",
                     "pyelonephritis",
                     "cystitis",
                     "sinusitis",
                     "helicobacter_pylori",
                     "typhoid",
                     "bacteriuria",
                     "tonsillitis_pharyngitis",
                     "erysipelas",
                     "rheumatic_fever",
                     "yaws_pinta",
                     "gingivitis",
                     "scarlet_fever",
                     "urethritis",
                     "cervicitis",
                     "fabry",
                     "gaucher",
                     "assisted_reproduction",
                     "implant",
                     "transplant",
                     "apl",
                     "hereditary_angioedema",
                     "smoking",
                     "rheumatoid_arthritis",
                     "giant_cell_arteritis",
                     "jia",
                     "pcv",
                     "scs",
                     "cnv",
                     "exudative_amd",
                     "catheter",
                     "ischemic_stroke",
                     "pe",
                     "mi")

for (ind in name_indication) {
  
  ind_obj <- get(ind)
  ind_list <- list(as.integer(ind_obj$concept_id))
  names(ind_list) <- ind
  
  cdm <- generateConceptCohortSet(
    cdm,
    conceptSet = ind_list,
    name = ind,  
    limit = "all",
    requiredObservation = c(0, 0),
    end = 1,
    overwrite = TRUE
  )
  
  attr(cdm[[ind]], "cohort_attrition") <- attr(cdm[[ind]], "cohort_attrition") %>% mutate(number_subjects = as.integer(number_subjects),
                                                                                          number_records = as.integer(number_records))
}

## Generate drug concepts ----
info(logger, "GENERATE DRUG CONCEPTS")
source(here("drugs.R"))


## get denominator population ----
info(logger, "GENERATE DENOMINATOR COHORT")
cdm <- generateDenominatorCohortSet(
  cdm = cdm, 
  name = "denominator",
  cohortDateRange = as.Date(c("2010-01-01",NA)),
  ageGroup = list(
    c(0, 150) 
  ),
  sex = c("Both"), 
  daysPriorObservation = c(0,30),   # 30 for incidence, 0 for prevalence
  requirementInteractions = TRUE
)


## Generate incident drug cohorts---
info(logger, "GENERATE INCIDENT DRUG COHORTS")

inc_attrition <- tibble::as_tibble(NULL)
inc_pat <- tibble::as_tibble(NULL)
for (i in seq_along(concept_drugs)){

cdm <- generateDrugUtilisationCohortSet(
  cdm,
  name = "drug_cohorts",
  conceptSet = concept_drugs[i],
  durationRange = c(1, Inf),
  imputeDuration = "none",
  gapEra = 0,
  priorUseWashout = 0,
  priorObservation = 0,
  cohortDateRange = as.Date(c("2010-01-01",NA)),
  limit = "all"
)

inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "drug_cohorts",
  interval = "years",
  completeDatabaseIntervals = FALSE,
  outcomeWashout = 30,
  repeatedEvents = TRUE,
  minCellCount = 10,
  returnParticipants = TRUE
) 

inc_attrition <- bind_rows(inc_attrition,attrition(inc))

inc_analysis_id <- inc %>% 
  filter(denominator_days_prior_observation == "30") %>%
  distinct(analysis_id,outcome_cohort_name) %>% 
  mutate(analysis_id = as.integer(analysis_id))

  addition <- IncidencePrevalence::participants(result = inc, analysisId = inc_analysis_id$analysis_id) %>%
    filter(!is.na(outcome_start_date)) %>%
    mutate(
      calendar_year = lubridate::year(outcome_start_date)
    ) %>% 
    distinct(subject_id, calendar_year, .keep_all = TRUE)  %>%
      collect() %>%
      mutate(analysis_id = inc_analysis_id$analysis_id) %>%
      inner_join(inc_analysis_id, by = "analysis_id") %>%
      mutate(cohort_definition_id = analysis_id * i) %>%
      select(-"analysis_id")
    
    inc_pat <- bind_rows(inc_pat, addition)

}

cdm <- insertTable(cdm, "inc_pat", inc_pat)
cdm$inc_pat <- omopgenerics::newCohortTable(cdm$inc_pat) 

## no overlapping periods means per subject_id and cohort_definition_id


info(logger, "WRITE INCIDENCE ATTRITION")
write.csv(inc_attrition,
          here("storage", paste0(
            "incidence_attrition_", cdmName(cdm), ".csv"
          )))


## characterisation of demographics of incident patients ---------------------
info(logger, "DEMOGRAPHICS INCIDENT PATIENTS")

inc_demographics <- cdm[["inc_pat"]]  %>%
            addDemographics(
              indexDate = "outcome_start_date",
              age = TRUE,
              ageName = "age",
              ageGroup = list(
                c(0,18),
                c(19,64),
                c(65,150)
              ),
              sex = TRUE,
              sexName = "sex",
              priorObservation = FALSE,
              futureObservation = FALSE,
            ) %>% 
summariseCharacteristics(
  strata = list( "Calendar Year" = "calendar_year"),
  demographics = TRUE,
  ageGroup = list(
    c(0,18),
    c(19,64),
    c(65,150)
  ),
  tableIntersect = list(),
  cohortIntersect = list(),
  conceptIntersect = list(),
  otherVariables = character()
) %>% suppress(minCellCount = 5) %>%
  mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
               left_join(cdm[["inc_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
  select(-"cohort_definition_id") %>%
  filter(variable_name %in% c("Number subjects","Number records","Age","Sex","Age group"))
  
write.csv(inc_demographics, here("storage", paste0(
  "inc_demographics_summary_", cdmName(cdm), ".csv"
)))

## characterisation of indication of incident patients ---------------------
info(logger, "INDICATION INCIDENT PATIENTS")

cov_indication <- c(name_indication,"covid")

source("applyFilterPatforInd.R")

inc_indication_summary <- tibble::as.tibble(NULL)
for (cov_ind in cov_indication){
 indication_drug_cohort <- applyFilterPatforInd(cdm[["inc_pat"]], cov_ind) %>%
            addIndication(
              indicationCohortName = cov_ind,
              indicationGap = c(0,30,Inf),
              unknownIndicationTable = NULL,
              indicationDate = "outcome_start_date"
            ) %>% 
            summariseIndication(
              strata = list("Calendar Year" = "calendar_year")
              ) %>% suppress(minCellCount = 5) %>%
   mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
   inner_join(cdm[["inc_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
   select(-"cohort_definition_id") %>% 
   filter(!is.na(estimate_value), estimate_value != "<5")
 
  inc_indication_summary <- bind_rows(inc_indication_summary,indication_drug_cohort)

}

write.csv(inc_indication_summary, here("storage", paste0(
            "inc_indication_summary_", cdmName(cdm), ".csv"
          )))

## large scale characterisation of incident patients ---------------------
info(logger, "LARGE SCALE CHARACTERISATION INCIDENT PATIENTS")
inc_lsc <- cdm[["inc_pat"]]  %>%
            summariseLargeScaleCharacteristics(
              window = list(
                c(-Inf, -30), c(-Inf, -1),  c(-30, -1), c(0, 0), c(1, 7),c(8,Inf),c(1,Inf)
              ),
              strata = list("Calendar Year" = "calendar_year"),
              eventInWindow = "condition_occurrence",       ## refers to start_date of condition
              episodeInWindow = "drug_exposure",            ## looks at start and end date (drug_era are collapsed exposures with standard gaps), not all DP have drug_era filled
              indexDate = "outcome_start_date",
              censorDate = NULL,
              minimumFrequency = 0.01,                      ## it is a proportion: 0.5% threshold
              excludedCodes = NULL) %>%                     ## maybe exclude things like blood pressure measurement or those frequent generic codes, can do in post-processing
  suppress(minCellCount = 5) %>%                
  mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
  inner_join(cdm[["inc_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
  select(-"cohort_definition_id") %>% 
  filter(!is.na(estimate_value), estimate_value != "<5")
  

write.csv(inc_lsc, here("storage", paste0(
            "inc_lsc_", cdmName(cdm), ".csv"
          )))


## characterisation of drug use of incident patients ---------------------
info(logger, "DRUG USE INCIDENT PATIENTS")

ingredients <- as.integer(c(19098548,
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
))
names <- c("tenecteplase",
           "alteplase",
           "sarilumab",
           "verteporfin",
           "tocilizumab",
           "varenicline",
           "ceftolozane",
           "tazobactam",
           "C1 esterase inhibitor",
           "arsenic trioxide",
           "belatacept",
           "ganirelix",
           "tigecycline",
           "imiglucerase",
           "agalsidase beta",
           "azithromycin",
           "clarithromycin",
           "penicillin V",
           "penicillin G",
           "amoxicillin",
           "clavulanate",
           "ceftriaxone",
           "cefotaxime",
           "meropenem",
           "cefuroxime",
           "piperacillin",
           "streptokinase",
           "urokinase",
           "abatacept",
           "tofacitinib",
           "baricitinib",
           "upadacitinib",
           "etanercept",
           "infliximab",
           "certolizumab pegol",	"CERTOLIZUMAB",
           "golimumab",
           "anakinra",
           "ranibizumab",
           "bevacizumab",
           "nicotine",
           "icatibant",
           "ecallantide",
           "Conestat alfa",
           "lanadelumab",
           "berotralstat",
           "cytarabine","Cytarabine liposomal","CYTARABINE 5'-PHOSPHATE",
           "daunorubicin",
           "idarubicin",
           "tretinoin",
           "mycophenolic acid",
           "sirolimus",
           "cyclosporine",
           "tacrolimus",
           "cetrorelix",
           "velaglucerase alfa",
           "taliglucerase alfa",
           "Agalsidase alfa"
)

inc_use_summary <- tibble::as_tibble(NULL)
for (j in seq_along(ingredients)) {
  ingredient <- ingredients[j]
  name <- names[j]  

  use_drug_cohort <- cdm[["inc_pat"]] %>%     
    filter(str_detect(outcome_cohort_name, str_sub(name, 1, 8)) | str_detect(outcome_cohort_name, str_sub(name, -8))
           ) %>%   #### this will not work for all databases ## move to the R side or write a function that filters with ifelse()
    addDrugUse(
      ingredientConceptId = ingredient ,
      duration = TRUE,
      quantity = TRUE,
      dose = TRUE,
      gapEra = 0,
      eraJoinMode = "subsequent",
      overlapMode = "subsequent",
      sameIndexMode = "sum",
      imputeDuration = "none",
      imputeDailyDose = "none"
    ) %>%
    summariseDrugUse(
      strata = list("Calendar Year" = "calendar_year")
      ) %>%  suppress(minCellCount = 5) %>%
    mutate(variable_level = name) %>%
    mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
    inner_join(cdm[["inc_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
    select(-"cohort_definition_id") %>%
    filter(variable_name %in% c("number subjects","number records","duration","number_exposures","cumulative_quantity",
                                "initial_quantity","initial_daily_dose_milligram","cumulative_dose_milligram"))
  
  inc_use_summary <- bind_rows(inc_use_summary,use_drug_cohort)
}

write.csv(inc_use_summary, here("storage", paste0(
  "inc_use_summary_", cdmName(cdm), ".csv")))

## during postprocess include demographics information in other tables as well



## Generate prevalent drug cohorts---------------------------------------------------------------------------------------------------------------------------
info(logger, "GENERATE PREVALENT DRUG COHORTS")

prev_attrition <- tibble::as_tibble(NULL)
prev_pat <- tibble::as_tibble(NULL)
for (i in seq_along(concept_drugs)){

  cdm <- generateDrugUtilisationCohortSet(
    cdm,
    name = "drug_cohorts",
    conceptSet = concept_drugs[i],
    durationRange = c(1, Inf),
    imputeDuration = "none",
    gapEra = 0,
    priorUseWashout = 0,
    priorObservation = 0,
    cohortDateRange = as.Date(c("2010-01-01",NA)),
    limit = "all"
  )
  
  prev <- estimatePeriodPrevalence(
    cdm = cdm,
    denominatorTable = "denominator",
    outcomeTable = "drug_cohorts",
    interval = "years",
    completeDatabaseIntervals = FALSE,
    minCellCount = 10,
    returnParticipants = TRUE    
  )
  
  prev_attrition <- bind_rows(prev_attrition,attrition(prev))
  
  prev_analysis_id <- prev %>% 
    filter(denominator_days_prior_observation == "0") %>%
    distinct(analysis_id,outcome_cohort_name) %>% 
    mutate(analysis_id = as.integer(analysis_id))
  
  addition <- IncidencePrevalence::participants(result = prev, analysisId = prev_analysis_id$analysis_id) %>%
    filter(!is.na(outcome_start_date)) %>%
    mutate(
      calendar_year = lubridate::year(outcome_start_date)
    ) %>% 
    distinct(subject_id, calendar_year, .keep_all = TRUE)  %>%
    collect() %>%
    mutate(analysis_id = prev_analysis_id$analysis_id) %>%
    inner_join(prev_analysis_id, by = "analysis_id") %>%
    mutate(cohort_definition_id = analysis_id * i) %>%
    select(-"analysis_id")
  
  prev_pat <- bind_rows(prev_pat, addition)
  
}

info(logger, "WRITE PREVALENCE ATTRITION")
write.csv(prev_attrition,
          here("storage", paste0(
            "prevalence_attrition_", cdmName(cdm), ".csv"
          )))

## characterisation of prevalent patients ---------------------
info(logger, "CHARACTERISATION PREVALENT PATIENTS")

cdm <- insertTable(cdm, "prev_pat", prev_pat)

## prevent overlapping cohort start and end dates 
## make the cohort_end_date the outcome_start_date
## make the cohort_start_date of the next row outcome_start_date + 1 (but not the first row of each patient/cohort_definition_id combination) ---------------------------------------------------------

# cdm$prev_pat <- omopgenerics::newCohortTable(cdm[["prev_pat"]] %>%
#                                                window_order(subject_id, cohort_definition_id, outcome_start_date) %>%
#                                                group_by(subject_id, cohort_definition_id) %>%
#                                                mutate(
#                                                  new_outcome_end_date = outcome_start_date, 
#                                                  new_outcome_start_date = ifelse(is.na(lag(outcome_start_date)),cohort_start_date,lag(outcome_start_date)),
#                                                  row_count = row_number()
#                                                ) %>%
#                                                mutate(
#                                                  new_outcome_start_date = as.Date(ifelse(row_count > 1,  !!dateadd("new_outcome_start_date", 1, interval = "day"),new_outcome_start_date ))
#                                                ) %>% ungroup() %>%
#                                                select(-"cohort_start_date",-"cohort_end_date",-"row_count") %>%
#                                                rename(cohort_start_date = new_outcome_start_date,
#                                                       cohort_end_date = new_outcome_end_date) %>%
#                                                window_order(cohort_definition_id, subject_id, outcome_start_date)
# )
# 

cdm$prev_pat <- omopgenerics::newCohortTable(cdm[["prev_pat"]],.softValidation = TRUE)    


prev_demographics <- cdm[["prev_pat"]]  %>%
  addDemographics(
    indexDate = "outcome_start_date",
    age = TRUE,
    ageName = "age",
    ageGroup = list(
      c(0,18),
      c(19,64),
      c(65,150)
    ),
    sex = TRUE,
    sexName = "sex",
    priorObservation = FALSE,
    futureObservation = FALSE,
  ) %>% 
  summariseCharacteristics(
    strata = list( "Calendar Year" = "calendar_year"),
    demographics = TRUE,
    ageGroup = list(
      c(0,18),
      c(19,64),
      c(65,150)
    ),
    tableIntersect = list(),
    cohortIntersect = list(),
    conceptIntersect = list(),
    otherVariables = character()
  ) %>% suppress(minCellCount = 5) %>%
  mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
  left_join(cdm[["prev_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
  select(-"cohort_definition_id") %>%
  filter(variable_name %in% c("Number subjects","Number records","Age","Sex","Age group"))

write.csv(prev_demographics, here("storage", paste0(
  "prev_demographics_summary_", cdmName(cdm), ".csv"
)))



## characterisation of indication of prevalent patients ---------------------
info(logger, "INDICATION PREVALENT PATIENTS")

prev_indication_summary <- tibble::as.tibble(NULL)
for (cov_ind in cov_indication){
  indication_drug_cohort <- applyFilterPatforInd(cdm[["prev_pat"]], cov_ind) %>%
    addIndication(
      indicationCohortName = cov_ind,
      indicationGap = c(0,30,Inf),
      unknownIndicationTable = NULL,
      indicationDate = "outcome_start_date"
    ) %>% 
    summariseIndication(
      strata = list("Calendar Year" = "calendar_year")
    ) %>% suppress(minCellCount = 5) %>%
    mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
    inner_join(cdm[["prev_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
    select(-"cohort_definition_id") %>% 
    filter(!is.na(estimate_value), estimate_value != "<5")
  
  prev_indication_summary <- bind_rows(prev_indication_summary,indication_drug_cohort)
  
}

write.csv(prev_indication_summary, here("storage", paste0(
  "prev_indication_summary_", cdmName(cdm), ".csv"
)))


## large scale characterisation of prevalent patients ---------------------
info(logger, "LARGE SCALE CHARACTERISATION PREVALENT PATIENTS")
prev_lsc <- cdm[["prev_pat"]]  %>%
  summariseLargeScaleCharacteristics(
    window = list(
      c(-Inf, -30), c(-Inf, -1),  c(-30, -1), c(0, 0), c(1, 7),c(8,Inf),c(1,Inf)
    ),
    strata = list("Calendar Year" = "calendar_year"),
    eventInWindow = "condition_occurrence",       ## refers to start_date of condition
    episodeInWindow = "drug_exposure",            ## looks at start and end date (drug_era are collapsed exposures with standard gaps), not all DP have drug_era filled
    indexDate = "outcome_start_date",
    censorDate = NULL,
    minimumFrequency = 0.01,                      ## it is a proportion: 0.5% threshold
    excludedCodes = NULL)    %>%                  ## maybe exclude things like blood pressure measurement or those frequent generic codes, can do in post-processing
  suppress(minCellCount = 5) %>% 
  mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
  inner_join(cdm[["inc_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
  select(-"cohort_definition_id") %>% 
  filter(!is.na(estimate_value), estimate_value != "<5")


write.csv(prev_lsc, here("storage", paste0(
  "prev_lsc_", cdmName(cdm), ".csv"
)))


## characterisation of drug use of prevalent patients ---------------------
info(logger, "DRUG USE PREVALENT PATIENTS")

prev_use_summary <- tibble::as_tibble(NULL)
for (j in seq_along(ingredients)) {
  ingredient <- ingredients[j]
  name <- names[j]  
  
  use_drug_cohort <- cdm[["prev_pat"]] %>% 
    filter(str_detect(outcome_cohort_name, str_sub(name, 1, 8)) | str_detect(outcome_cohort_name, str_sub(name, -8))
    ) %>% 
    addDrugUse(
      ingredientConceptId = ingredient ,
      duration = TRUE,
      quantity = TRUE,
      dose = TRUE,
      gapEra = 0,
      eraJoinMode = "subsequent",
      overlapMode = "subsequent",
      sameIndexMode = "sum",
      imputeDuration = "none",
      imputeDailyDose = "none"
    ) %>%
    summariseDrugUse(
      strata = list("Calendar Year" = "calendar_year")
    ) %>%  suppress(minCellCount = 5) %>% 
    mutate(variable_level = name) %>%
    mutate(cohort_definition_id = as.integer(str_sub(group_level, 8))) %>%
    inner_join(cdm[["prev_pat"]] %>% select(cohort_definition_id, outcome_cohort_name) %>% distinct(), by = c("cohort_definition_id"), copy = TRUE ) %>%
    select(-"cohort_definition_id") %>%
    filter(variable_name %in% c("number subjects","number records","duration","number_exposures","cumulative_quantity",
                                "initial_quantity","initial_daily_dose_milligram","cumulative_dose_milligram"))
  
  prev_use_summary <- bind_rows(prev_use_summary,use_drug_cohort)
}

write.csv(prev_use_summary, here("storage", paste0(
  "prev_use_summary_", cdmName(cdm), ".csv")))

## during postprocess include demographics information in other tables as well


## zip everything together ---
info(logger, "ZIP EVERYTHING")
zip(
  zipfile = here::here(paste0("Results_", cdmName(cdm), ".zip")),
  files = list.files(outputFolder),
  root = outputFolder
)

## remove storage, caused confusion ---
info(logger, "REMOVE STORAGE FOLDER")
unlink(here("storage"), recursive = TRUE)

print("Done!")
print("If all has worked, there should now be a zip file with your DUS results in the same level as the .Rproj")
print("Thank you for running the DUS analysis!")