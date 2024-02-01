
concept_drugs <- getDrugIngredientCodes(
  cdm,
  name = c("tenecteplase",
           "alteplase",
           "sarilumab",
           "verteporfin",
           "tocilizumab",
           "varenicline",
           
           "C1 esterase inhibitor",
           
           "belatacept",
           "ganirelix",
           "tigecycline",
           "imiglucerase",
           "agalsidase beta",
           "azithromycin",
           
           "ceftriaxone",
           "cefotaxime",
           
           "cefuroxime",
           
           "urokinase",
           "abatacept",
           "tofacitinib",
           "baricitinib",
           "upadacitinib",
           "etanercept",
           "infliximab",
           
           "golimumab",
           "anakinra",
           "ranibizumab",
           "bevacizumab",
           
           "icatibant",
           "ecallantide",
           "Conestat alfa",
           "lanadelumab",
           "berotralstat",
           
           "idarubicin",
           
           "mycophenolic acid",
           "sirolimus",
           
           "cetrorelix",
           "velaglucerase alfa",
           "taliglucerase alfa",
           "Agalsidase alfa",
           "daunorubicin",
           "arsenic trioxide",
           "nicotine",
           "cyclosporine",
           "clarithromycin",
           "penicillin V",
           "penicillin G", 
           "amoxicillin", 
           "meropenem", 
           "streptokinase"),
  doseForm = NULL,
  ingredientRange = c(1, 1),
  withConceptDetails = FALSE
)


## other that need more doing ----------------------------------------------------------------------------

## certolizumab has two ingredient codes
certolizumab <- getDrugIngredientCodes(
  cdm,
  name = c("certolizumab","certolizumab pegol"),
  doseForm = NULL,
  ingredientRange = c(1, 1),
  withConceptDetails = FALSE
)
concept_drugs[["certolizumab"]] <- purrr::list_c(certolizumab)


## cytarabine, I only want the extended release drug (liposomal form)
## ingredient 902730 "Cytarabine liposomal"
## and concepts only (no ingredient) from "depocyte" and "cytarabine liposomal"

cytarabine_liposomal <- list(as.numeric(readLines(here::here("drug_vectors", "Athena_searches_depocyte_cytarabine_liposomal_ids.txt")))) 

## does not have descendants, just added the ingredient to the upper list
                  # getDrugIngredientCodes(
                  #                       cdm,
                  #                       name = "Cytarabine liposomal",
                  #                       doseForm = NULL,
                  #                       ingredientRange = c(1, 1),
                  #                       withConceptDetails = FALSE
                  #                       )


concept_drugs[["cytarabine_liposomal"]] <- purrr::list_c(cytarabine_liposomal)


## cytarabine, any of the three ingredients "cytarabine", "Cytarabine liposomal", "CYTARABINE 5'-PHOSPHATE"
cytarabine_any <- getDrugIngredientCodes(
  cdm,
  name = c("cytarabine", "Cytarabine liposomal", "CYTARABINE 5'-PHOSPHATE"),
  doseForm = NULL,
  ingredientRange = c(1, 1),
  withConceptDetails = FALSE
)
concept_drugs[["cytarabine_any"]] <- purrr::list_c(cytarabine_any)


## daunorubicin + cytarabine combination drugs
cytarabine_daunorubicin <- list(as.numeric(readLines(here::here("drug_vectors", "Athena_search_cytarabine_daunorubicin_ids.txt"))))
concept_drugs[["cytarabine_daunorubicin"]] <- purrr::list_c(cytarabine_daunorubicin)

## tacrolimus no topical
tacrolimus_no_topical <- getDrugIngredientCodes(cdm = cdm, name = "tacrolimus", ingredientRange = c(1,1),
                                                    doseForm = c("Oral Capsule","Oral Tablet","Injectable Solution","Oral Granules","Oral Powder",
                                                                 "Oral Solution","Oral Suspension","Prefilled Syringe","Extended Release Oral Capsule",
                                                                 "Injection","Prefilled Syringe","Intravenous Solution","Granules for Oral Suspension"
                                                    ),
                                                    withConceptDetails = FALSE) 
concept_drugs[["tacrolimus_no_topical"]] <- purrr::list_c(tacrolimus_no_topical)

## tretinoin oral only
tretinoin_oral <- getDrugIngredientCodes(cdm = cdm, name = "tretinoin", ingredientRange = c(1,1), doseForm = c("Oral Capsule","Oral Tablet"),
                                             withConceptDetails = FALSE) 
concept_drugs[["tretinoin_oral"]] <- purrr::list_c(tretinoin_oral)


## combination drugs--------------------------------------------------------------------------------------


## "amoxicillin" "clavulanate" combination only, so get the drug concept level
amoxicillin_clavulanate <- list(as.numeric(readLines(here::here("drug_vectors", "Athena_search_amoxicillin_clavulanate_ids.txt"))))
concept_drugs[["amoxicillin_clavulanate"]] <- purrr::list_c(amoxicillin_clavulanate)


# ceftozolane tazobactam combination only, so get the drug concept level
ceftozolane_tazobactam <- list(as.numeric(readLines(here::here("drug_vectors", "Athena_search_ceftozolane_tazobactam_ids.txt"))))
concept_drugs[["ceftozolane_tazobactam"]] <- purrr::list_c(ceftozolane_tazobactam)


# piperacillin tazobactam combination only, so get the drug concept level
piperacillin_tazobactam <-  list(as.numeric(readLines(here::here("drug_vectors", "Athena_search_piperacillin_tazobactam_ids.txt"))))
concept_drugs[["piperacillin_tazobactam"]] <- purrr::list_c(piperacillin_tazobactam)


