
# DUS Shiny

This code contains a shiny to view your results from the DUS Code. This
step is for you want to look at your results before sending them back to
us and to double check whether the results make sense.

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

Please create a “data” folder on the same level as the .Rproj into which
you upload your zip file: Results\_“dbName”.zip. RStudio automatically
unzips the files ending up in the “data” folder. In the end, your “data”
folder should contain 11 csv files:
inc_demographics_summary\_“dbName”.csv,
inc_indication_summary\_“dbName”.csv, inc_lsc\_“dbName”.csv,
ind_use_summary\_“dbName”.csv, incidence_attrition\_“dbName”.csv,
prev_demographics_summary\_“dbName”.csv,
prev_indication_summary\_“dbName”.csv, prev_lsc\_“dbName”.csv,
prev_use_summary\_“dbName”.csv, prevalence_attrition\_“dbName”.csv

If you have several databases, you will have several copies of those
files each with a different “dbName”.

Then open global.R and click “Run App” in the top right corner.

## Issues

If you encounter problems or have questions please open an issue here in
github.
