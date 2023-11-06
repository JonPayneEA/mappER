#' @title getCoords
#'
#' @description This extracts the site name, Latitude, and Longitude data from the imported
#' WISKI metadata associated with each file. Outputs are a shapefile of class SF.
#'
#' @param ... The files you wish to include
#'
#' @return The site name and coordinates for a site as a shapefile
#' @export
#'
#' @import R6
#' @import data.table
#'
#' @examples
#' library(riskyData)
#' data(crowle); data(bickley); data(barnhurst); data(hollies); data(ledbury);
#' data(bettwsYCrwyn)
#' gcs <- getCoords(crowle,
#'                  bickley,
#'                  barnhurst,
#'                  hollies,
#'                  ledbury,
#'                  bettwsYCrwyn)
getCoords <- function(...){
  lst <- list(...)
  ## Check for correct classes
  classes <- list()
  for(i in seq_along(lst)){
    classes[[i]] <- class(lst[[i]])
  }
  classes <- unique(unlist(classes, use.names = FALSE))
  if(any(!classes %in% c("R6", "HydroImport", "HydroAggs"))){
    stop("Unknown class present in list")}

  ## Extract coordinates
  coordsLst <- list()
  for(i in seq_along(lst)){
    coordsLst[[i]] <- lst[[i]]$coords()
  }
  dt <- data.table::rbindlist(coordsLst)

  ## Convert to shapefile
  projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  sf <- sf::st_as_sf(x = dt,
                     coords = c("Longitude", "Latitude"),
                     crs = st_crs(4326))
  return(sf)
}
