applyFilterPatforInd <- function(data,cov_ind){
   
       if(cov_ind == "neutropenia") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("piperacillin_tazobactam","meropenem","ceftriaxone")) 
       } else if(cov_ind == "bacteraemia") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","piperacillin_tazobactam","meropenem","ceftriaxone","ceftozolane_tazobactam")) 
       } else if(cov_ind ==  "sepsis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","piperacillin_tazobactam","meropenem",
                                                                                                 "ceftriaxone","ceftozolane_tazobactam")) 
       } else if(cov_ind ==  "infection") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("tigecycline","piperacillin_tazobactam","cefuroxime","amoxicillin","amoxicillin_clavulanate","penicillin_v",
                                                           "meropenem","cefotaxime","ceftriaxone","clarithromycin","penicillin_g","clarithromycin",
                                                           "azithromycin","ceftozolane_tazobactam"))
       } else if(cov_ind ==  "pneumonia") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftozolane_tazobactam","piperacillin_tazobactam","cefuroxime","amoxicillin","clarithromycin","azithromycin",
                                                           "meropenem","cefotaxime","ceftriaxone","amoxicillin_clavulanate","penicillin_v")) 
       } else if(cov_ind ==  "cystic_fibrosis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("meropenem")) 
       } else if(cov_ind ==  "orthopaedic_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","ceftriaxone","amoxicillin")) 
       } else if(cov_ind ==  "cardiovascular_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","ceftriaxone")) 
       } else if(cov_ind ==  "gynecologic_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "chronic_bronchitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","cefotaxime","amoxicillin_clavulanate",
                                                                    "amoxicillin","clarithromycin","azithromycin")) 
       } else if(cov_ind ==  "cataract_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime")) 
       } else if(cov_ind ==  "meningitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("meropenem","cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "urogenital_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "gastrointestinal_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "colorectal_surgery") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "endocarditis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone","amoxicillin")) 
       } else if(cov_ind ==  "lyme_disease") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone","amoxicillin")) 
       } else if(cov_ind ==  "intraabdominal_infection") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftozolane_tazobactam","tigecycline","piperacillin_tazobactam","cefuroxime",
                                                                          "meropenem","cefotaxime")) 
       } else if(cov_ind ==  "copd") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftriaxone")) 
       } else if(cov_ind ==  "syphilis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftriaxone","penicillin_g")) 
       } else if(cov_ind ==  "gonorrhea") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefotaxime","ceftriaxone")) 
       } else if(cov_ind ==  "otitis_media") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftriaxone","ceftriaxone","amoxicillin_clavulanate",
                                                              "amoxicillin","penicillin_v","azithromycin")) 
       } else if(cov_ind ==  "osteomyelitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftriaxone","ceftriaxone","amoxicillin_clavulanate")) 
       } else if(cov_ind ==  "septic_arthritis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftriaxone","ceftriaxone","amoxicillin_clavulanate")) 
       } else if(cov_ind ==  "pyelonephritis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftozolane_tazobactam","cefuroxime","meropenem","cefotaxime","ceftriaxone","amoxicillin_clavulanate","azithromycin",
                                                                "amoxicillin")) 
       } else if(cov_ind ==  "cystitis_bacteriuria") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","meropenem","cefotaxime","ceftriaxone","amoxicillin_clavulanate","azithromycin",
                                                          "amoxicillin","ceftozolane_tazobactam")) 
       } else if(cov_ind ==  "urethritis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","meropenem","cefotaxime","ceftriaxone","amoxicillin_clavulanate","azithromycin",
                                                            "amoxicillin","ceftozolane_tazobactam")) 
       } else if(cov_ind ==  "sinusitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("amoxicillin_clavulanate","amoxicillin","clarithromycin","azithromycin")) 
       } else if(cov_ind ==  "helicobacter_pylori") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("amoxicillin","clarithromycin")) 
       } else if(cov_ind ==  "typhoid") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("amoxicillin")) 
       } else if(cov_ind ==  "tonsillitis_pharyngitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("amoxicillin","penicillin_v","clarithromycin","azithromycin")) 
       } else if(cov_ind ==  "cellulitis_erysipelas_woundinfection") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("tigecycline","piperacillin_tazobactam","cefuroxime","amoxicillin_clavulanate","clarithromycin","azithromycin",
                                                            "meropenem","cefotaxime","ceftriaxone","ceftriaxone","penicillin_g","penicillin_v")) 
       } else if(cov_ind ==  "rheumatic_fever") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("penicillin_g","penicillin_v")) 
       } else if(cov_ind ==  "yaws_pinta") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("penicillin_g")) 
       } else if(cov_ind ==  "gingivitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("penicillin_v")) 
       } else if(cov_ind ==  "scarlet_fever") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("penicillin_v")) 
       } else if(cov_ind ==  "cervicitis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("cefuroxime","meropenem","azithromycin")) 
       } else if(cov_ind ==  "fabry") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("agalsidase_beta","agalsidase_alfa")) 
       } else if(cov_ind ==  "gaucher") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("imiglucerase","taliglucerase_alfa","velaglucerase_alfa")) 
       } else if(cov_ind ==  "assisted_reproduction") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ganirelix","cetrorelix")) 
       } else if(cov_ind ==  "implant_transplant") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("belatacept","cyclosporine","mycophenolic_acid" ,"sirolimus","tacrolimus_no_topical"  )) 
       } else if(cov_ind ==  "apl") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("arsenic_trioxide", "cytarabine_liposomal","cytarabine_any","cytarabine_daunorubicin",
                                                     "tretinoin_oral" , "idarubicin" , "daunorubicin" )) 
       } else if(cov_ind ==  "hereditary_angioedema") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("c1_esterase_inhibitor", "ecallantide" ,"icatibant",
                                                                       "berotralstat","lanadelumab","conestat_alfa" )) 
       } else if(cov_ind ==  "smoking_cessation") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("nicotine","varenicline")) 
       } else if(cov_ind ==  "rheumatoid_arthritis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("tocilizumab" , "infliximab"  ,"tofacitinib",  "certolizumab" ,  "etanercept" , "abatacept",
                                                                      "upadacitinib", "golimumab","sarilumab","baricitinib","anakinra")) 
       } else if(cov_ind ==  "giant_cell_arteritis") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("tocilizumab" , "infliximab"  ,"tofacitinib",  "certolizumab" , "etanercept" , "abatacept",
                                                                      "upadacitinib", "golimumab","sarilumab","baricitinib","anakinra")) 
       } else if(cov_ind ==  "jia") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("tocilizumab" , "infliximab"  ,"tofacitinib",  "certolizumab" , "etanercept" , "abatacept",
                                                     "upadacitinib", "golimumab","sarilumab","baricitinib","anakinra")) 
       } else if(cov_ind ==  "pcv_cnv") {filtered_data <- data %>% filter(outcome_cohort_name %in% c( "verteporfin"  ,"bevacizumab" ,"ranibizumab" )) 
       } else if(cov_ind ==  "csc") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("verteporfin"  ,"bevacizumab" ,"ranibizumab")) 
       } else if(cov_ind ==  "exudative_amd") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("verteporfin"  ,"bevacizumab" ,"ranibizumab")) 
       } else if(cov_ind ==  "catheter_flushing") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("urokinase","alteplase","tenecteplase" , "streptokinase")) 
       } else if(cov_ind ==  "ischemic_stroke") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("urokinase","alteplase","tenecteplase" , "streptokinase")) 
       } else if(cov_ind ==  "pe") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("urokinase","alteplase","tenecteplase" , "streptokinase")) 
       } else if(cov_ind ==  "mi") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("urokinase","alteplase","tenecteplase" , "streptokinase")) 
       } else if (cov_ind == "covid") {filtered_data <- data %>% filter(outcome_cohort_name %in% c("ceftozolane_tazobactam","piperacillin_tazobactam","cefuroxime",
                                                      "amoxicillin","clarithromycin","azithromycin",
                                                      "meropenem","cefotaxime","ceftriaxone","amoxicillin_clavulanate",
                                                      "penicillin_v","tocilizumab")) 
       }
    return(filtered_data)
  }
  

