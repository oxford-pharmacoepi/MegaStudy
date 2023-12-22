
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

Subsequently, please create a folder named “data” and put your results
folder (extracted from zip) into this folder. You can put all there is
(including the log and snapshot, it does not break the code), however
you would only need to put the folder in which your csv results are
stored (it is the only one that is read from the Shiny code). However,
the structure is important: inside the data folder you want another
folder (or several folders if you have several databases) and therein
the csv files. If there is more layers of folders than just one, it will
not work.

Then open global.R and click “Run App” in the top right corner.

## Issues

If you encounter problems or have questions please open an issue here in
github.
