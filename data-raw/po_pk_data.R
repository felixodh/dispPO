## code to prepare `po_pk_data` dataset goes here

lst_query <- as.Date("2026-01-27")
saveRDS(lst_query,"lst_query.rds")

stations_meta <- get_stations()

wl_data <- fetch_po_data()

saveRDS(wl_data,po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))



usethis::use_data(stations_meta, overwrite = TRUE)