

#' Title
#'
#' @param folder 
#' @param file 
#'
#' @returns
#' @export
#'
#' @examples
po_cache_dir <- function(folder,file) {
  dir <- tools::R_user_dir("dispPO", "cache")
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
  dir <- paste(dir,folder,file,sep = "/")
  if(!file.exists(dir)){
    stop("po_cache_dir: dir inexistent")
  }
  dir
}
