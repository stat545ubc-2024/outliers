# 1) For these tests, we should expect to return an empty numeric vector and a message for both methods
test_that("Vector with no NA and no outliers", {
  test_vec1 <- c(1:5)
  expect_equal(check_outliers(test_vec1, "zscore"), numeric(0))
  expect_message(check_outliers(test_vec1, "zscore"), "No outliers found.")
  expect_equal(check_outliers(test_vec1, "iqr"), numeric(0))
  expect_message(check_outliers(test_vec1, "iqr"), "No outliers found.")
})


# 2) The NAs within the vector should not interfere with the return since they are being omitted, and return 5000 for both methods
test_that("Vector with NAs and outliers", {
  test_vec2 <- c(1:10, NA, 11:16, NA, 5000)
  expect_equal(check_outliers(test_vec2, "zscore"), 5000)
  expect_equal(check_outliers(test_vec2, "iqr"), 5000)

  # Lets also test that the tolower() function is working properly
  expect_equal(check_outliers(test_vec2, "ZsCoRe"), 5000)
  expect_equal(check_outliers(test_vec2, "IQr"), 5000)

})

# 3) These should all return errors as they are not numeric vectors greater than length 0
test_that("Non-numeric or >0 length vectors", {
  test_vec3 <- c("a", "b", "c")
  test_vec4 <- c(TRUE, FALSE, FALSE)
  test_vec5 <- c(1, 2, "s")
  expect_error(check_outliers(test_vec3, "zscore"))
  expect_error(check_outliers(test_vec3, "iqr"))
  expect_error(check_outliers(test_vec4, "zscore"))
  expect_error(check_outliers(test_vec4, "iqr"))
  expect_error(check_outliers(test_vec5, "zscore"))
  expect_error(check_outliers(test_vec5, "iqr"))
  expect_error(check_outliers(numeric(0), "zscore"))
  expect_error(check_outliers(numeric(0), "iqr"))
})


# 4) Test other miscellaneous errors and stops based on input ranges

test_that("invalid inputs or other messages", {

  # Test for when SD of a vector is 0 using the zscore method
  test_vec6 <- c(5, 5, 5, 5, 5)
  test_vec2 <- c(1:10, NA, 11:16, NA, 5000)
  expect_message(check_outliers(test_vec6, "zscore"), "Standard deviation is zero or NA; no outliers can be determined using this method.")
  expect_equal(check_outliers(test_vec6, "zscore"), numeric(0))  # Expect empty numeric vector


  # Test for when the z-score threshold is a non-numeric or less than 1
  expect_error(check_outliers(test_vec2, "zscore", zscore_threshold = TRUE), "The z-score threshold must be a numeric value at least 1 SD or greater.")
  expect_error(check_outliers(test_vec2, "zscore", zscore_threshold = 0.7), "The z-score threshold must be a numeric value at least 1 SD or greater.")

  # However, this should not interfere if the chosen method is not "zscore"
  expect_equal(check_outliers(test_vec2, "iqr", zscore_threshold = 0.2), 5000)

  # Test for when the IQR threshold multipler is a non-numeric or negative number
  expect_error(check_outliers(test_vec2, "iqr", iqr_threshold = -5), "The IQR threshold must be a numeric value greater than or equal to 0.")
  expect_error(check_outliers(test_vec2, "iqr", iqr_threshold = "7"), "The IQR threshold must be a numeric value greater than or equal to 0.")


  # Test for when IQR quantile algorithm is a non-integer between 1-9
  expect_error(check_outliers(test_vec2, "iqr", iqr_threshold = 1, quantile_type = 4.5), "Invalid quantile algorithm type; must be an integer between 1 and 9.")
  expect_error(check_outliers(test_vec2, "iqr", quantile_type = -3), "Invalid quantile algorithm type; must be an integer between 1 and 9.")

  # However, this should not interfere if the chosen method is not "iqr"
  expect_equal(check_outliers(test_vec2, "zscore", iqr_threshold = 0.2, quantile_type = 50), 5000)


})
