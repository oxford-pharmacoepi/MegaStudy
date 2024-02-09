
# IncidencePrevalence Shiny

This code contains a shiny to view your results from the
IncidencePrevalence Code. This step is for you want to look at your
results before sending them back to us and to double check whether the
results make sense.

## Instructions

You have already pulled the update from the repository which means that
this Shiny project is already part of your R environment.

However, the renv lock for the shiny is different from the renv for the
Code. Therefore you have to run the following command in the console to
install all R packages in the right version.

``` r
renv::activate()
renv::restore()
```

Please create a “data” folder on the same level as the .Rproj and put
everything from your “storage” folder from the “IncidencePrevalence
Code” into it : “snapshot\_”dbName”.csv,
“dbName”\_IncidencePrevalenceResults.zip,
“incidence_attrition_dbName”.csv, and “prevalence_attrition_dbName”.csv
(or multiples of them if you have several databases)

Then open global.R and click “Run App” in the top right corner.

## Issues

If you encounter problems or have questions please open an issue here in
github.
