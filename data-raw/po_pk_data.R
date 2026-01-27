## code to prepare `po_pk_data` dataset goes here

lst_query <- as.Date("2026-01-27")
saveRDS(lst_query,"lst_query.rds")

test_stations <- get_stations()



usethis::use_data(test_stations, overwrite = TRUE)
