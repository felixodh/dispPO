

# get_stations() ----------------------------------------------------------


testthat::test_that("get_stations returns a tibble with expected structure", {
  
  testthat::skip_if_offline()
  testthat::skip_on_cran()
  
  stations <- get_stations()
  
  # basic object checks
  testthat::expect_s3_class(stations, "tbl_df")
  testthat::expect_true(nrow(stations) > 0)
  
  # expected columns
  testthat::expect_named(
    stations,
    c(
      "uuid", "number", "shortname", "longname",
      "km", "agency", "long", "lat",
      "water_shortname", "water_longname"
    )
  )
  
  # column types
  testthat::expect_type(stations$uuid, "character")
  testthat::expect_type(stations$number, "character")
  testthat::expect_type(stations$shortname, "character")
  testthat::expect_type(stations$longname, "character")
  testthat::expect_type(stations$km, "double")
  testthat::expect_type(stations$agency, "character")
  testthat::expect_type(stations$long, "double")
  testthat::expect_type(stations$lat, "double")
  testthat::expect_type(stations$water_shortname, "character")
  testthat::expect_type(stations$water_longname, "character")
})

testthat::test_that("get_stations returns valid station identifiers", {
  
  testthat::skip_if_offline()
  testthat::skip_on_cran()
  
  stations <- get_stations()
  
  testthat::expect_false(anyNA(stations$uuid))
  testthat::expect_false(any(stations$uuid == ""))
  
  testthat::expect_false(anyNA(stations$shortname))
})


