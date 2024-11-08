% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_outliers.R
\name{check_outliers}
\alias{check_outliers}
\title{Outlier Detection in Numeric Vectors}
\usage{
check_outliers(
  x,
  method,
  zscore_threshold = 3,
  iqr_threshold = 1.5,
  quantile_type = 7
)
}
\arguments{
\item{x}{A numeric vector. This is the primary input for which outliers will be calculated. NA values are automatically omitted within the function to ensure accurate calculations. Named "x" because it is the standard name for a variable in statistics.}

\item{method}{A string specifying the method for detecting outliers. Options are "zscore" for Z-score method or "iqr" for IQR method. Inputted values are case insensitive. Named "method" to clearly indicate the desired approach to determine outliers.}

\item{zscore_threshold}{Numeric value equal to or greater than 1. The Z-score threshold (i.e number of standard deviations) above which values are considered outliers. Default is 3. Named "zscore_threshold" to specify the cut off for identifying outliers based on the Z-score method.}

\item{iqr_threshold}{Numeric value greater than 0. The multiplier for the IQR to define the bounds for detecting outliers. Default is 1.5. Named "iqr_threshold" to specify the multiplier for identifying outliers based on the IQR method.}

\item{quantile_type}{Numeric integer (1-9). The algorithm used to compute quantiles when calculating the IQR. Default is 7. Please see quantile() documentation from the stats package for details. Named "quantile_type" to refer to the specific quantile algorithm chosen for the quantile() function based on input.}
}
\value{
A numeric vector of outlier values. If no outliers are found, it returns a message "No outliers found" and an empty numeric vector.
}
\description{
This function checks for outlier values in a numeric vector based on either the Z-score method or the Interquartile Range (IQR) method. It returns a numeric vector containing the detected outliers, or an empty numeric vector with a message if no outliers were found or an error occurred. It provides flexibility in defining thresholds for outliers and the type of algorithm for calculating quartiles.
}
\examples{
# Example 1: Simple numeric vector with outliers for both methods
test_1 <- c(1:20, -50000)
check_outliers(test_1, "iqr")
check_outliers(test_1, "zscore")

# Example 2: Simple vector with no outliers
test_2 <-c(1:10)
check_outliers(test_2, "iqr")
check_outliers(test_2, "zscore")

# Example 3: Adjusting the threshold values
test_3 <- c(0:10, -300, 500)
check_outliers(test_3, "zscore")
# Nothing detected using the default threshold, but if we change the value:
check_outliers(test_3, "zscore", zscore_threshold = 1.5)

}
