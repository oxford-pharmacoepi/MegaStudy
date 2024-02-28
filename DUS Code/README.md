
# DRUG UTILISATION STUDY (DUS) Code

### Instructions
Please clone the entire repository into your R environment or pull the update into your existing repository.

You only need to interact with the file CodeToRun.R
Please fill in all the necessary information according to your situation. 
However, if you have different drug_type_concept_id in your data (https://ohdsi.github.io/CommonDataModel/cdm54.html#DRUG_EXPOSURE) you can amend the code in line 35 - 40 in DUS.R to filter for your CDM Name and drug type you wish to use.


## Issues

If you encounter any errors or if you have questions, please report them as an issue here in github. 
Other people may have the same questions, and thereby we can answer them for all. 

### Of Note
The package CDM Connector does not support the database management system BIG QUERY, spark and oracle, i.e. it may not be possible for you to contribute results to the MegaStudy. 
It does support SQLServer, postgresql, redshift, and snowflake. 
If you have another database management system we will find out how it goes. Please report this as an issue in github.

## There is a shiny available to check your results

## Returning results

If everything worked you should get a zip file on the same level as the DUS Code.Rproj file named "Results_(database name).zip"
Please upload this in the EHDEN teams in the folder "DUS"/"uploads from data partners/"new results".

Thank you for running the DUS code!

