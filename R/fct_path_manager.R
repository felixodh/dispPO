

#' Get Path to Cached PegelOnline Data
#'
#' `po_cache_dir` returns the full path to a cached file for PegelOnline data
#' stored in the R user cache directory. It ensures the main cache directory
#' exists and checks that the requested file exists.
#'
#' @param folder Character. Name of the subfolder inside the cache directory.
#' @param file Character. Name of the file within the folder.
#'
#' @return Character string of the full path to the requested cache file.
#' 
#' @details
#' This function uses `tools::R_user_dir("dispPO", "cache")` to determine a
#' user-specific cache location. If the main cache directory does not exist,
#' it is created. The function then constructs the path to the requested
#' `folder/file` combination and stops with an error if the file does not exist.
#'
#' @examples
#' \dontrun{
#' # Check if a cached query file exists
#' path <- po_cache_dir(folder = "dispPO_data", file = "lst_query.rds")
#' print(path)
#' }
#'
#' @export
po_cache_dir <- function(folder,file) {
  dir <- tools::R_user_dir("dispPO", "cache")
  
  # fallback for shinyapps.io
  if (!dir.exists(dir)) {
    base_dir <- file.path(tempdir(), "dispPO_cache")
  }
  
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  
  
  
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  dir <- file.path(dir,folder,file)
  if(!file.exists(dir)){
      stop("po_cache_dir: dir inexistent")
  }
  dir
}

# po_cache_dir(folder = "dispPO_data",file = "curr_meas.rds")
#' Initialize cache files on first installation
#'
#' This function ensures that required cache files are available in the user's
#' cache directory for the \code{dispPO} package. If the cache directory does not
#' exist, it will be created. If specific cache files are missing, they will be
#' copied from the package's internal \code{inst/extdata/cache} directory.
#'
#' @details
#' The function checks for the presence of the following files in the user cache:
#' \itemize{
#'   \item \code{curr_meas.rds}
#'   \item \code{lst_query.rds}
#'   \item \code{wl_list.rds}
#' }
#' If any of these files are not found, they are copied from the installed
#' package directory.
#'
#' @return
#' This function is called for its side effects. It does not return a value.
#'
#' @examples
#' \dontrun{
#' first_installation()
#' }
first_installation <- function(){
  dir <- tools::R_user_dir("dispPO/dispPo_data", "cache")
  
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  
  if(!any(list.files(dir) %in% c("curr_meas.rds","lst_query.rds","wl_list.rds"))){
    system.file(package = "dispPO")
    package_path <- system.file("cache", package = "dispPO")
    if(package_path == ""){
      stop(paste("File", file, "not found in package 'dispPO/inst/extdata'"))
    }
    file.copy(from = package_path, to = dir)
  }
}



#' Title
#'
#' @returns
#' @export
#'
#' @examples
load_google_files <- function(){
  files <- googledrive::drive_ls()

  ### load wl_file
  wl_file <- files |> dplyr::filter(name == "wl_list.rds")
  
  tmp_wl <- tempfile(fileext = ".rds")
  
  wl_list <- googledrive::drive_download(
    googledrive::as_id(wl_file$id), path = tmp_wl, overwrite = TRUE)
  
  wl_list <- readRDS(tmp_wl)
  
  ### load curr_meas_file
  
  curr_meas_file <- files |> dplyr::filter(name == "curr_meas.rds")
  
  tmp_curr_meas <- tempfile(fileext = ".rds")
  
  curr_meas <- googledrive::drive_download(
    googledrive::as_id(curr_meas_file$id), path = tmp_curr_meas, overwrite = TRUE)
  
  curr_meas <- readRDS(tmp_curr_meas)
  
  ### load last query
  
  lst_query_file <- files |> dplyr::filter(name == "lst_query.rds")
  
  tmp_lst_query <- tempfile(fileext = ".rds")
  
  lst_query <- googledrive::drive_download(
    googledrive::as_id(lst_query_file$id), path = tmp_lst_query, overwrite = TRUE)
  
  curr_meas <- readRDS(tmp_lst_query)
  
  google_file_loc <- dplyr::tibble(
    file_name = c("wl_list.rds","curr_meas.rds","lst_query.rds"),
    file_path = c(tmp_wl,tmp_curr_meas,tmp_lst_query)
  )
  
  
  
  return()

}
