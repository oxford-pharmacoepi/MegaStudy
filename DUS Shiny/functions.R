#' Plot incidence results
#'
#' @param result characteristics results
#' @param x Variable to plot on x axis
#' @param facet Variables to use for facets
#' @param colour Variables to use for colours
#' @param colour_name Colour legend name
#' @param options a list of optional plot options
#'
#' @return A ggplot with the characteristics results plotted
#' @export
#'
#' @examples
#' \donttest{
#' }
plotInc_patient_characteristics <- function(result,
                          x = "strata_level",
                          ylim = c(0, NA),
                          facet = NULL,
                          colour = NULL,
                          colour_name = NULL,
                          options = list()) {
  plotEstimates(
    result = result,
    x = x,
    y = "estimate",
    ylim = ylim,
    ytype = "median",
    facet = facet,
    colour = colour,
    colour_name = colour_name,
    options = options
  )
}



# helper functions

plotEstimates <- function(result,
                          x,
                          y,
                          ylim,
                          ytype,
                          facet,
                          colour,
                          colour_name,
                          options) {

    plot_data <- getPlotData(
    estimates = result,
    facetVars = facet,
    colourVars = colour
  )
  
  if (is.null(colour)) {
    plot <- plot_data %>%
      ggplot2::ggplot(
        ggplot2::aes(
          x = !!rlang::sym(x),
          y = !!rlang::sym(y)
        )
      )
  } else {
    plot <- plot_data %>%
      ggplot2::ggplot(
        ggplot2::aes(
          x = !!rlang::sym(x),
          y = !!rlang::sym(y),
          group = colour_vars,
          colour = colour_vars,
          fill = colour_vars
        )
      ) +
      ggplot2::geom_point(size = 2.5) +
      ggplot2::labs(
        fill = colour_name,
        colour = colour_name
      )
  }
  
  plot <- plot +
    ggplot2::geom_point(size = 2.5) 
  

  if (is.null(ylim)) {
    if (ytype == "median") {
      plot <- plot +
        ggplot2::scale_y_continuous(labels = scales::comma)
    }
    if (ytype == "percentage") {
      plot <- plot +
        ggplot2::scale_y_continuous(
          labels =
            scales::percent_format(accuracy = 0.1)
        )
    }
  } else {
    plot <- addYLimits(plot = plot, ylim = ylim, ytype = ytype)
  }
  
  if (!is.null(facet)) {
    facetNcols <- NULL
    if ("facetNcols" %in% names(options)) {
      facetNcols <- options[["facetNcols"]]
    }
    facetScales <- "fixed"
    if ("facetScales" %in% names(options)) {
      facetScales <- options[["facetScales"]]
    }
    
    plot <- plot +
      ggplot2::facet_wrap(ggplot2::vars(facet_var),
                          ncol = facetNcols,
                          scales = facetScales) +
      ggplot2::theme_bw()
  } else {
    plot <- plot +
      ggplot2::theme_minimal()
  }

  
  plot <- plot +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
  
  return(plot)
}


getPlotData <- function(estimates, facetVars, colourVars) {
  plotData <- estimates
  if (!is.null(facetVars)) {
    plotData <- plotData %>%
      tidyr::unite("facet_var",
                   c(tidyselect::all_of(facetVars)),
                   remove = FALSE, sep = "; "
      )
  }
  if (!is.null(colourVars)) {
    plotData <- plotData %>%
      tidyr::unite("colour_vars",
                   c(tidyselect::all_of(colourVars)),
                   remove = FALSE, sep = "; "
      )
  }
  
  return(plotData)
}


addYLimits <- function(plot, ylim, ytype) {
  if (ytype == "median") {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels = scales::comma,
        limits = ylim
      )
  }
  if (ytype == "percentage") {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels =
          scales::percent_format(accuracy = 0.1),
        limits = ylim
      )
  }
  return(plot)
}

