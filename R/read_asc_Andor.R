#' Import Raman Spectra/Maps from Andor Cameras/Solis ASCII files.
#'
#' `read_asc_Andor()` reads Andor Solis ASCII (`.asc`) files where the first column gives the wavelength
#' axes and the other columns the spectra.
#'
#' @param file filename or connection to ASCII file
#' @param ...,quiet,dec,sep handed to [base::scan()]
#' @return a hyperSpec object
#' @author Claudia Beleites
#' @seealso `vignette ("fileio")` for more information on file import and
#'
#' @concept io
#'
#' @export
read_asc_Andor <- function(file = stop("filename or connection needed"),
                           ..., quiet = TRUE, dec = ".", sep = ",") {

  ## check for valid data connection
  check_con(file = file)

  ## read spectra
  tmp <- readLines(file)
  nwl <- length(tmp)
  txt <- scan(text = tmp, dec = dec, sep = sep, quiet = quiet, ...)

  dim(txt) <- c(length(txt) / nwl, nwl)

  ## fix: Andor Solis may have final comma without values
  if (all(is.na(txt [nrow(txt), ]))) {
    txt <- txt [-nrow(txt), ]
  }

  spc <- new("hyperSpec", wavelength = txt [1, ], spc = txt [-1, ])

  ## consistent file import behaviour across import functions
  .fileio.optional(spc, file)
}

hySpc.testthat::test(read_asc_Andor) <- function() {
  context("read_asc_Andor")
  test_that("Andor Solis .asc text files", {
    skip("Need to adapt to new package")
    expect_known_hash(read_asc_Andor("fileio/asc.Andor/ASCII-Andor-Solis.asc"), "9ead937f51")
  })
}
