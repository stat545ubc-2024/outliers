#' Outlier Detection in Numeric Vectors
#'
#' This function checks for outlier values in a numeric vector based on either the Z-score method or the Interquartile Range (IQR) method. It returns a numeric vector containing the detected outliers, or an empty numeric vector with a message if no outliers were found or an error occurred. It provides flexibility in defining thresholds for outliers and the type of algorithm for calculating quartiles.
#'
#' @param x A numeric vector. This is the primary input for which outliers will be calculated. NA values are automatically omitted within the function to ensure accurate calculations. Named "x" because it is the standard name for a variable in statistics.
#' @param method A string specifying the method for detecting outliers. Options are "zscore" for Z-score method or "iqr" for IQR method. Inputted values are case insensitive. Named "method" to clearly indicate the desired approach to determine outliers.
#' @param zscore_threshold Numeric value equal to or greater than 1. The Z-score threshold (i.e number of standard deviations) above which values are considered outliers. Default is 3. Named "zscore_threshold" to specify the cut off for identifying outliers based on the Z-score method.
#' @param iqr_threshold Numeric value greater than 0. The multiplier for the IQR to define the bounds for detecting outliers. Default is 1.5. Named "iqr_threshold" to specify the multiplier for identifying outliers based on the IQR method.
#' @param quantile_type Numeric integer (1-9). The algorithm used to compute quantiles when calculating the IQR. Default is 7. Please see quantile() documentation from the stats package for details. Named "quantile_type" to refer to the specific quantile algorithm chosen for the quantile() function based on input.
#'
#' @return A numeric vector of outlier values. If no outliers are found, it returns a message "No outliers found" and an empty numeric vector.
#' @importFrom stats na.omit quantile sd
#' @examples
#' # Example 1: Simple numeric vector with outliers for both methods
#' test_1 <- c(1:20, -50000)
#' check_outliers(test_1, "iqr")
#' check_outliers(test_1, "zscore")
#'
#' # Example 2: Simple vector with no outliers
#' test_2 <-c(1:10)
#' check_outliers(test_2, "iqr")
#' check_outliers(test_2, "zscore")
#'
#' # Example 3: Adjusting the threshold values
#' test_3 <- c(0:10, -300, 500)
#' check_outliers(test_3, "zscore")
#' # Nothing detected using the default threshold, but if we change the value:
#' check_outliers(test_3, "zscore", zscore_threshold = 1.5)
#'
#' @export
check_outliers <- function(x, method, zscore_threshold = 3, iqr_threshold = 1.5, quantile_type = 7) {

  # Remove all NA values. We are only calculating and returning outliers, and including NAs would disrupt our mean and SD calculations
  x <- na.omit(x)

  # Check if the input x is a numeric vector greater than length 0
  if (!is.numeric(x) || length(x) == 0) {
    stop('This function only works for a numeric vector greater than length 0, please provide the correct class and/or length')
  }


  # Z-score method: calculates z-score using the standard score formula (x-mean/SD) and indexes the vector for outliers outside the threshold
  if (tolower(method) == 'zscore') {

    # Validate the z-score threshold
    if (!is.numeric(zscore_threshold) || zscore_threshold < 1) {
      stop("The z-score threshold must be a numeric value at least 1 SD or greater.")
    }

    # Calculate mean and SD
    mean_x <- mean(x)
    sd_x <- sd(x)

    # Before continuing, check for SD = 0 or NA because then we cannot do the calculations below
    if (sd_x == 0 || is.na(sd_x)) {
      message("Standard deviation is zero or NA; no outliers can be determined using this method.")
      return(numeric(0))  # Return an empty vector to keep output consistent
    }

    zscores <- (x - mean_x)/sd_x # Calculate z-scores
    outliers <- x[abs(zscores) > zscore_threshold] # only include values above the threshold
  }

  # IQR method: calculates IQR using the inputting quantile algorithm and indexes the vector for outliers outside the threshold
  else if (tolower(method) == 'iqr') {

    # Validate the IQR threshold
    if (!is.numeric(iqr_threshold) || iqr_threshold <= 0) {
      stop("The IQR threshold must be a numeric value greater than or equal to 0.")
    }

    # Validate the quantile algorithm type
    if (!quantile_type %in% 1:9) {
      stop("Invalid quantile algorithm type; must be an integer between 1 and 9.")
    }

    # Calculate first and third quartiles, and IQR, using inputted algorithm type
    q1 <- quantile(x, prob = 0.25, type = quantile_type)
    q3 <- quantile(x, prob = 0.75, type = quantile_type)
    iqr_x <- q3 - q1

    # Calculate upper and lower bounds
    upper_bound <- q3 + (iqr_threshold * iqr_x)
    lower_bound <- q1 - (iqr_threshold * iqr_x)
    outliers <- x[x > upper_bound | x < lower_bound] # only include values outside these bounds
  }

  # If incorrect method input
  else{
    stop('The only supported methods are "zscore" or "iqr" [case insensitive]. Please check for typos and try again')
  }

  # Check if any outliers were found; print a message if not
  if (length(outliers) == 0) {
    message("No outliers found.")
    return(numeric(0))
  }

  # Return the outliers in a numeric vector
  return(outliers)
}


