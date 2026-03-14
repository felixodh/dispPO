

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
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  dir <- paste(dir,folder,file,sep = "/")
  if(!file.exists(dir)){
    stop("po_cache_dir: dir inexistent")
  }
  dir
}
