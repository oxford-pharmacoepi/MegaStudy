neutropenia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("neutropenia","neutropenic"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

bacteraemia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("bacteremia"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

infection <- getCandidateCodes(
  cdm = cdm,
  keywords = c("infection"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

pneumonia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("pneumonia"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

cystic_fibrosis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cystic fibrosis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

orthopaedic_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("orthopaedic","arthroscopy","arthroplasty"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

cardiovascular_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("coronary artery bypass graft","angioplasty","stent","aortic aneurysm",
               "cardiac pacemaker","cardiac defibrillator","heart valve"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

gynecologic_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hysterectomy","cesarean section"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

chronic_bronchitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("chronic bronchitis"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

cataract_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cataract surgery"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

meningitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("meningitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

urogenital_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("prostatectomy","nephrectomy","cystectomy","vasectomy"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

prostatic_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("prostatectomy","transurethral resection of prostate"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

gastrointestinal_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("appendectomy","cholecystectomy","hernia","gastrectomy",
               "esophagectomy","liver resection","pancreatectomy",
               "bariatric Surgery"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

colorectal_surgery <- getCandidateCodes(
  cdm = cdm,
  keywords = c("colectomy","hemorrhoidectomy","colostomy",
               "ileostomy"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

endocarditis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("endocarditis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

sepsis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("sepsis"),
domains = c("Condition","Observation"),
includeDescendants = TRUE
)    

lyme_disease <- getCandidateCodes(
  cdm = cdm,
  keywords = c("lyme"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

intraabdominal_infection <- getCandidateCodes(
  cdm = cdm,
  keywords = c("appendicitis","peritonitis","diverticulitis","duodenal perforation",
               "gastrointestinal perforation","perforation of colon","perforation of intestine"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

copd <- getCandidateCodes(
  cdm = cdm,
  keywords = c("chronic obstructive pulmonary disease"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

syphilis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("syphilis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

gonorrhea <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gonorrhea"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

otitis_media <- getCandidateCodes(
  cdm = cdm,
  keywords = c("otitis media"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

osteomyelitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("osteomyelitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

septic_arthritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("septic arthritis","pyogenic arthritis"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

cellulitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cellulitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

pyelonephritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("pyelonephritis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

cystitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cystitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

sinusitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("sinusitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

helicobacter_pylori <- getCandidateCodes(
  cdm = cdm,
  keywords = c("helicobacter pylori"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

typhoid <- getCandidateCodes(
  cdm = cdm,
  keywords = c("typhoid","typhus"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

bacteriuria <- getCandidateCodes(
  cdm = cdm,
  keywords = c("bacteriuria"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

tonsillitis_pharyngitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("tonsillitis","pharyngitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

erysipelas <- getCandidateCodes(
  cdm = cdm,
  keywords = c("erysipelas"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

wound_infection <- getCandidateCodes(
  cdm = cdm,
  keywords = c("wound infection"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

rheumatic_fever <- getCandidateCodes(
  cdm = cdm,
  keywords = c("rheumatic fever","chorea","rheumatic carditis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

yaws_pinta <- getCandidateCodes(
  cdm = cdm,
  keywords = c("yaws","pinta"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

gingivitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gingivitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

scarlet_fever <- getCandidateCodes(
  cdm = cdm,
  keywords = c("scarlet fever"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

urethritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("urethritis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

cervicitis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("cervicitis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

fabry <- getCandidateCodes(
  cdm = cdm,
  keywords = c("fabry"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

gaucher <- getCandidateCodes(
  cdm = cdm,
  keywords = c("gaucher"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)    

assisted_reproduction <- getCandidateCodes(
  cdm = cdm,
  keywords = c("assisted reproduction","IVF","In vitro fertilization",
               "Assisted fertilization","Reproductive technology management"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)    

implant <- getCandidateCodes(
  cdm = cdm,
  keywords = c("implant"),
  domains = c("Procedure"),
  includeDescendants = TRUE
)

transplant <- getCandidateCodes(
  cdm = cdm,
  keywords = c("transplant"),
  domains = c("Procedure"),
  includeDescendants = TRUE
)

apl <- getCandidateCodes(
  cdm = cdm,
  keywords = c("acute promyelocytic leukemia"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

hereditary_angioedema <- getCandidateCodes(
  cdm = cdm,
  keywords = c("hereditary angioedema"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

smoking <- getCandidateCodes(
  cdm = cdm,
  keywords = c("smoking"),
  domains = c("Condition","Measurement","Observation","Procedure"),
  includeDescendants = TRUE
)

rheumatoid_arthritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("rheumatoid arthritis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

giant_cell_arteritis <- getCandidateCodes(
  cdm = cdm,
  keywords = c("giant cell arteritis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

jia <- getCandidateCodes(
  cdm = cdm,
  keywords = c("juvenile idiopathic arthritis"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

pcv <- getCandidateCodes(
  cdm = cdm,
  keywords = c("polypoidal choroidal vasculopathy"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

scs <- getCandidateCodes(
  cdm = cdm,
  keywords = c("central serous chorioretinopathy"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

cnv <- getCandidateCodes(
  cdm = cdm,
  keywords = c("choroidal neovascularization"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

exudative_amd <- getCandidateCodes(
  cdm = cdm,
  keywords = c("exudative age-related macular degeneration","age-related exudative macular degeneration",
               "age-related exudative degeneration of macula"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

catheter <- getCandidateCodes(
  cdm = cdm,
  keywords = c("catheter"),
  domains = c("Condition","Observation","Procedure"),
  includeDescendants = TRUE
)

ischemic_stroke = getCandidateCodes(
  cdm = cdm,
  keywords = c("ischemic stroke"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

pe <- getCandidateCodes(
  cdm = cdm,
  keywords = c("pulmonary embolism"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)

mi <- getCandidateCodes(
  cdm = cdm,
  keywords = c("myocardial infarction"),
  domains = c("Condition","Observation"),
  includeDescendants = TRUE
)
