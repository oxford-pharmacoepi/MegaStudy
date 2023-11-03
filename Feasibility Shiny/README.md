
# Feasibility Shiny

This step is optional if you want to look at your results before sending
them back to us. This code contains a shiny to view your results from
the Feasibility Code (all but the “diagnosticsSummary”)

## Instructions

You have already cloned the repository which means that this Shiny
project is already part of your R environment.

However, the renv lock for the shiny is different from the renv for the
Code. Therefore you have to run the following command in the console to
install all R packages in the right version.

``` r
renv::activate()
renv::restore()
```

Subsequently, please put your results folder (extracted from zip) into
the “data” folder that you see in this R project. You can put all there
is in the zip folder (including the log and snapshot, that does not
break the code), however you would only need to put the folder in which
your csv results are stored.

Then open global.R and click “Run App” in the top right corner.
