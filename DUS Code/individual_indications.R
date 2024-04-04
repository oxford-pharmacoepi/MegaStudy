neutropenia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("neutropenia","neutropenic"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

bacteraemia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("bacteremia"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

infection <- getCandidateCodes(
  cdm = cdm,
  exclude = c("suspected","Suspected","Exposure","without",
              "risk","Sequelae","Late effects"),
  keywords = c("infection"),
  domains = c("Condition"),
  includeDescendants = TRUE
)

pneumonia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("pneumonia"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

cystic_fibrosis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("gene mutation","hepatic fibrosis","screening"),
  keywords = c("cystic fibrosis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)   

orthopaedic_surgery <- getCandidateCodes(
  cdm = cdm,
  exclude = c("Chronic pain","chronic pain","caused by"),
  keywords = c("orthopaedic","arthroscopy","arthroplasty"),
  domains = c("Condition","Procedure"),
  includeDescendants = TRUE
)  

cardiovascular_surgery <- getCandidateCodes(
  cdm = cdm,
  exclude = c("due to","Arteriosclerosis of","thrombosis of","Atherosclerosis of",
              "Mechanical breakdown of","after","associated with","following"),
  keywords = c("coronary artery bypass graft","angioplasty","heart valve","aortic aneurysm"),
  domains = c("Procedure"),
  includeDescendants = FALSE
)    

gynecologic_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hysterectomy","cesarean section"),
  domains = c("Procedure"),
  includeDescendants = FALSE
)   

chronic_bronchitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("chronic bronchitis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

cataract_surgery <- getCandidateCodes(
  cdm = cdm,
  exclude = c("fundus","PhenX"),
  keywords = c("cataract surgery"),
  domains = c("Observation","Procedure"),
  includeDescendants = TRUE
)  

meningitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("meningitis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

urogenital_surgery <- getCandidateCodes(
  cdm = cdm,
  exclude = c("cholecystectomy"),
  keywords = c("prostatectomy","transurethral resection of prostate",
               "cystectomy","vasectomy"),
  domains = c("Procedure"),
  includeDescendants = TRUE
)    

gastrointestinal_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("appendectomy","cholecystectomy","hernia","gastrectomy",
               "esophagectomy","liver resection","pancreatectomy",
               "bariatric Surgery"),
  domains = c("Procedure"),
  includeDescendants = TRUE
)   

colorectal_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("colectomy","hemorrhoidectomy","colostomy",
               "ileostomy"),
  domains = c("Procedure"),
  includeDescendants = TRUE
)   

endocarditis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("history","risk"),
  keywords = c("endocarditis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

sepsis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("risk"),
  keywords = c("sepsis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)     

lyme_disease <- getCandidateCodes(
  cdm = cdm,
  exclude = c("olymer","negative"),
  keywords = c("lyme"),
  domains = c("Condition"),
  includeDescendants = FALSE
)    

intraabdominal_infection <- getCandidateCodes(
  cdm = cdm,
  keywords = c("appendicitis","peritonitis","diverticulitis","duodenal perforation",
               "gastrointestinal perforation","perforation of colon","perforation of intestine"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

copd <- getCandidateCodes(
  cdm = cdm,
  exclude = c("risk"),
  keywords = c("chronic obstructive pulmonary disease","copd"),
  domains = c("Condition"),
  includeDescendants = FALSE
)  

syphilis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("associated","False-positive"),
  keywords = c("syphilis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)   

gonorrhea <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gonorrhea"),
  domains = c("Condition"),
  includeDescendants = TRUE
)     

otitis_media <- getCandidateCodes(
  cdm = cdm,
  keywords = c("otitis media"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

osteomyelitis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("without"),
  keywords = c("osteomyelitis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

septic_arthritis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("spondyloarthritis"),
  keywords = c("Septic arthritis","pyogenic arthritis","bacterial arthritis","Suppurative arthritis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)  

cellulitis_erysipelas_woundinfection <- getCandidateCodes(
  cdm = cdm,
  exclude = c("without"),
  keywords = c("cellulitis","erysipelas","wound infection"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

pyelonephritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("pyelonephritis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

cystitis_bacteriuria <- getCandidateCodes(
  cdm = cdm,
  exclude = c("dacryocystitis","cholecystitis"),
  keywords = c("cystitis","bacteriuria"),
  domains = c("Condition"),
  includeDescendants = TRUE
)     

sinusitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("sinusitis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

helicobacter_pylori <- getCandidateCodes(
  cdm = cdm,
  exclude = c("negative","equivocal","Cystic fibrosis"),
  keywords = c("helicobacter pylori"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

typhoid <- getCandidateCodes(
  cdm = cdm,
  exclude = c("vaccination"),
  keywords = c("typhoid","typhus"),
  domains = c("Condition"),
  includeDescendants = TRUE
)  

tonsillitis_pharyngitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("tonsillitis","pharyngitis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)  

rheumatic_fever <- getCandidateCodes(
  cdm = cdm,
  keywords = c("rheumatic fever","rheumatic chorea"),
  domains = c("Condition"),
  includeDescendants = FALSE
)  

yaws_pinta <- getCandidateCodes(
  cdm = cdm,
  keywords = c("yaws","pinta"),
  domains = c("Condition"),
  includeDescendants = TRUE
)   

gingivitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gingivitis","gingivostomatitis","gingivoperiodontitis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)    

scarlet_fever <- getCandidateCodes(
  cdm = cdm,
  keywords = c("scarlet","scarlatina"),
  domains = c("Condition"),
  includeDescendants = FALSE
)    

urethritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("urethritis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)   

cervicitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cervicitis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)    

fabry <- getCandidateCodes(
  cdm = cdm,
  keywords = c("fabry"),
  domains = c("Condition"),
  includeDescendants = FALSE
)    

gaucher <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gaucher"),
  domains = c("Condition"),
  includeDescendants = FALSE
)  

assisted_reproduction <- getCandidateCodes(
  cdm = cdm,
  exclude = c("Documentation","Conceived by in vitro fertilization","cancelled"),
  keywords = c("assisted reproduction","IVF","IVC","In vitro fertilization","artificial fertilization",
               "Assisted fertilization","Reproductive technology management"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)   

implant_transplant <- getCandidateCodes(
  cdm = cdm,
  exclude = c("implanted","with graft","without graft","revision","with prosthesis","training","implantable",
              "Repositioning","reinsertion","removal","attention to","with implant","service","hair transplant"),
  keywords = c("implant","transplant","graft","prosthe"),
  domains = c("Procedure"),
  includeDescendants = FALSE
)

apl <- getCandidateCodes(
  cdm = cdm,
  exclude = c("associated"),
  keywords = c("acute promyelocytic leukemia"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

hereditary_angioedema <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hereditary angioedema"),
  domains = c("Condition"),
  includeDescendants = TRUE
)

smoking_cessation <- getCandidateCodes(
  cdm = cdm,
  keywords = c("smoking cessation","Tobacco use cessation"),
  domains = c("Condition","Measurement","Observation","Procedure"),
  includeDescendants = FALSE
)

rheumatoid_arthritis <- getCandidateCodes(
  cdm = cdm,
  exclude = c("juvenile"),
  keywords = c("rheumatoid arthritis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

giant_cell_arteritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("giant cell arteritis"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

jia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("juvenile idiopathic arthritis","juvenile rheumatoid arthritis",
               "Juvenile psoriatic arthritis"),
  domains = c("Condition"),
  includeDescendants = TRUE
)

pcv_cnv <- getCandidateCodes(
  cdm = cdm,
  keywords = c("polypoidal choroidal vasculopathy","choroidal neovascularization"),
  domains = c("Condition"),
  includeDescendants = TRUE
)

csc <- getCandidateCodes(
  cdm = cdm,
  keywords = c("central serous chorioretinopathy"),
  domains = c("Condition"),
  includeDescendants = TRUE
)

exudative_amd <- getCandidateCodes(
  cdm = cdm,
  exclude = c("nonexudative"),
  keywords = c("exudative age-related macular degeneration","age-related exudative macular degeneration",
               "age-related exudative degeneration of macula"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

catheter_flushing <- getCandidateCodes(
  cdm = cdm,
  exclude = c("urinary","suprapubic","Foley","paravalvular leak","arterial occlusion"),
  keywords = c("Thrombus in peritoneal dialysis catheter","catheter related thrombosis","Obstruction of peritoneal dialysis catheter",
               "Occlusion of catheter"),
  domains = c("Condition","Procedure"),
  includeDescendants = FALSE
)

ischemic_stroke <- getCandidateCodes(
  cdm = cdm,
  exclude = c("Late effects"),
  keywords = c("ischemic stroke"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

pe <- getCandidateCodes(
  cdm = cdm,
  exclude = c("air","fluid","fat","septic","chronic","tumor"),
  keywords = c("pulmonary embolism"),
  domains = c("Condition"),
  includeDescendants = FALSE
)

mi <- getCandidateCodes(
  cdm = cdm,
  exclude = c("no myocardial","Old","syndrome","following","not resulting",
              "silent","manifest on","Past myocardial","postmyocardial"),
  keywords = c("myocardial infarction"),
  domains = c("Condition"),
  includeDescendants = TRUE
)
