
## create outcome cohorts using CapR for those without combination drugs (or few) within the descendants

## prevalent drug cohorts 

name_vector <- c("tenecteplase",
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
                 "Agalsidase alfa"
)

drug_vector <- c(19098548,
                 1347450,
                 1594587,
                 912803,
                 40171288,
                 780442,
          
                 45892906,
             
                 40239665,
                 1536743,
                 1742432,
                 1348407,
                 1525746,
                 1734104,
            
                 1777806,
                 1774470,
              
                 1778162,
             
                 1307515,
                 1186087,
                 42904205,
                 1510627,
                 1361580,
                 1151789,
                 937368,
              
                 19041065,
                 1114375,
                 19080982,
                 1397141,
                
                 40242044,
                 40168938,
                 36878937,
                 35200405,
                 37003361,
          
                 19078097,
                 
                 19012565,
                 19034726,
               
                 1503983,
                 40174604,
                 42800246,
                 36878851
)

concept_objects <- list()
for (i in seq_along(name_vector)) {
  name <- name_vector[i]
  drug <- drug_vector[i]
  
  # Create a concept set for the current drug
  drug_cs <- Capr::cs(descendants(drug), name = name)
  
  # Store the ConceptSet object in the list
  concept_objects[[name]] <- drug_cs

}


## other that need more doing ----------------------------------------------------------------------------

## certolizumab has two ingredient codes
concept_objects$certolizumab_both <- cs(descendants(36857573,912263), name = "certolizumab_both")

## cytarabine, I only want the extended release drug (liposomal form)
## ingredient 902730 "Cytarabine liposomal"
## and concepts only (no ingredient) from "depocyte" and "cytarabine liposomal"
## have no NA and no duplicates in the lists for the capr functionality

cytarabine_liposomal_ids <- as.numeric(readLines(here::here("drug_vectors", "Athena_searches_depocyte_cytarabine_liposomal_ids.txt")))
concept_objects$cytarabine_liposomal_depocyte <- cs(cytarabine_liposomal_ids, descendants(902730), name = "cytarabine_liposomal_ingredient")

## cytarabine, any of the three ingredients
concept_objects$cytarabine_any <- cs(descendants(1311078,902730,36863408), name = "cytarabine_any")

## daunorubicin (single)
daunorubicin_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "daunorubicin", ingredientRange = c(1,1),
                                                      withConceptDetails = FALSE) 
daunorubicin_ids <- as.numeric(do.call(c, daunorubicin_no_combination_ids))
concept_objects$daunorubicin_no_combination <- cs(daunorubicin_ids, name = "daunorubicin_no_combination")

## daunorubicin + cytarabine combination drugs
cytarabine_daunorubicin_ids <- as.numeric(readLines(here::here("drug_vectors", "Athena_search_cytarabine_daunorubicin_ids.txt")))
concept_objects$cytarabine_daunorubicin_combination <- cs(cytarabine_daunorubicin_ids, name = "cytarabine_daunorubicin_combination")

## tacrolimus no topical
tacrolimus_no_topical_ids <- getDrugIngredientCodes(cdm = cdm, name = "tacrolimus", ingredientRange = c(1,1),
                                                    doseForm = c("Oral Capsule","Oral Tablet","Injectable Solution","Oral Granules","Oral Powder",
                                                                 "Oral Solution","Oral Suspension","Prefilled Syringe","Extended Release Oral Capsule",
                                                                 "Injection","Prefilled Syringe","Intravenous Solution","Granules for Oral Suspension"
                                                    ),
                                                    withConceptDetails = FALSE) 
tacrolimus_ids <- as.numeric(do.call(c, tacrolimus_no_topical_ids))
concept_objects$tacrolimus_no_topical <- cs(tacrolimus_ids, name = "tacrolimus_no_topical")

## tretinoin oral only
tretinoin_oral_ids <- getDrugIngredientCodes(cdm = cdm, name = "tretinoin", ingredientRange = c(1,1), doseForm = c("Oral Capsule","Oral Tablet"),
                                             withConceptDetails = FALSE) 
tretinoin_ids <- as.numeric(do.call(c, tretinoin_oral_ids))
concept_objects$tretinoin_oral <- cs(tretinoin_ids, name = "nicotine_no_combination")


## combination drugs--------------------------------------------------------------------------------------


## "amoxicillin" "clavulanate" combination only, so get the drug concept level
amoxicillin_clavulanate_ids <- as.numeric(readLines(here::here("drug_vectors", "Athena_search_amoxicillin_clavulanate_ids.txt")))
concept_objects$amoxicillin_clavulanate_combination <- cs(amoxicillin_clavulanate_ids, name = "amoxicillin_clavulanate_combination")

# ceftozolane tazobactam combination only, so get the drug concept level
ceftozolane_tazobactam_ids <- as.numeric(readLines(here::here("drug_vectors", "Athena_search_ceftozolane_tazobactam_ids.txt")))
concept_objects$ceftozolane_tazobactam <- cs(ceftozolane_tazobactam_ids, name = "ceftozolane_tazobactam")

# piperacillin tazobactam combination only, so get the drug concept level
piperacillin_tazobactam_ids <- as.numeric(readLines(here::here("drug_vectors", "Athena_search_piperacillin_tazobactam_ids.txt")))
concept_objects$piperacillin_tazobactam <- cs(piperacillin_tazobactam_ids, name = "piperacillin_tazobactam")


## use Codelist generator to pick single ingredient drugs only ---------------------------------------------

## arsenic trioxide no combinations

arsenic_trioxide_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "arsenic trioxide", ingredientRange = c(1,1),
                                                      withConceptDetails = FALSE) 
arsenic_trioxide_ids <- as.numeric(do.call(c, arsenic_trioxide_no_combination_ids))
concept_objects$arsenic_trioxide_no_combination <- cs(arsenic_trioxide_ids, name = "arsenic_trioxide_no_combination")

## nicotine no combinations

nicotine_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "nicotine", ingredientRange = c(1,1),
                                                      withConceptDetails = FALSE) 
nicotine_ids <- as.numeric(do.call(c, nicotine_no_combination_ids))
concept_objects$nicotine_no_combination <- cs(nicotine_ids, name = "nicotine_no_combination")

## cyclosporine no combinations

cyclosporine_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "cyclosporine", ingredientRange = c(1,1),
                                                      withConceptDetails = FALSE) 
cyclosporine_ids <- as.numeric(do.call(c, cyclosporine_no_combination_ids))
concept_objects$cyclosporine_no_combination <- cs(cyclosporine_ids, name = "cyclosporine_no_combination")

## clarithromycin no combinations

clarithromycin_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "clarithromycin", ingredientRange = c(1,1),
                                                            withConceptDetails = FALSE) 
clarithromycin_ids <- as.numeric(do.call(c, clarithromycin_no_combination_ids))
concept_objects$clarithromycin_no_combination <- cs(clarithromycin_ids, name = "clarithromycin_no_combination")

## "penicillin V"  no combinations

penicillin_V_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "penicillin V", ingredientRange = c(1,1),
                                                          withConceptDetails = FALSE) 
penicillin_V_ids <- as.numeric(do.call(c, penicillin_V_no_combination_ids))
concept_objects$penicillin_V_no_combination <- cs(penicillin_V_ids, name = "penicillin_V_no_combination")

## "penicillin G"  no combinations

penicillin_G_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "penicillin G", ingredientRange = c(1,1),
                                                          withConceptDetails = FALSE) 
penicillin_G_ids <- as.numeric(do.call(c, penicillin_G_no_combination_ids))
concept_objects$penicillin_G_no_combination <- cs(penicillin_G_ids, name = "penicillin_G_no_combination")

## "amoxicillin" no combinations

amoxicillin_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "amoxicillin", ingredientRange = c(1,1),
                                                         withConceptDetails = FALSE) 
amoxicillin_ids <- as.numeric(do.call(c, amoxicillin_no_combination_ids))
concept_objects$amoxicillin_no_combination <- cs(amoxicillin_ids, name = "amoxicillin_no_combination")

##  "meropenem"   no combinations

meropenem_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "meropenem", ingredientRange = c(1,1),
                                                       withConceptDetails = FALSE) 
meropenem_ids <- as.numeric(do.call(c, meropenem_no_combination_ids))
concept_objects$meropenem_no_combination <- cs(meropenem_ids, name = "meropenem_no_combination")

## "streptokinase"  no combinations

streptokinase_no_combination_ids <- getDrugIngredientCodes(cdm = cdm, name = "streptokinase", ingredientRange = c(1,1),
                                                           withConceptDetails = FALSE) 
streptokinase_ids <- as.numeric(do.call(c, streptokinase_no_combination_ids))
concept_objects$streptokinase_no_combination <- cs(streptokinase_ids, name = "streptokinase_no_combination")


