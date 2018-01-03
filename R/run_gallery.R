#' Launch Gallery Application
#'
#' This package includes an experimental Shiny application that uses the
#' \code{alterryx} functions to mimic Alteryx Gallery functionality.
#' The goal of this is to understand how to use the API to extend Gallery
#' functionality. Big thanks to Dean Attali for his primer on including
#' Shiny apps in an R package.
#'
#' @export
run_gallery <- function() {
  appDir <- system.file("applications", "gallery_app", package = "alterryx")
  if (appDir == "") {
    stop("Could not find application directory. Try re-installing `alterryx`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
