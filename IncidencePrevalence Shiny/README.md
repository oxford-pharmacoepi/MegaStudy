
# IncidencePrevalence Shiny

This step is optional if you want to look at your results before sending
them back to us. This code contains a shiny to view your results from
the IncidencePrevalence Code

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
the following three csv files into it (or multiples if you have several
databases): “dbName”\_snapshot.csv, “dbName”\_Incidence.csv,
“dbName”\_Prevalence.csv. You can also put folders into the “data”
folder with the csv’s therein, the code will look for the files also in
sub-directories.

Then open global.R and click “Run App” in the top right corner.

## Issues

If you encounter problems or have questions please open an issue here in
github.
