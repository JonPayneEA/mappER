#' @title teeSun
#'
#' @description Creates a Thiessen/Voronoi polygon shapefile.
#'
#' @param gaugeCoords SF file with point data within.
#' @param catchment Set as null, optional bounding box polygon derived from catchment polygon
#'
#' @return A polygon shapefile with Thiessen polygons
#' @export
#'
#' @examples
#' library(riskyData)
#' data(crowle); data(bickley); data(barnhurst); data(hollies); data(ledbury);
#' data(bettwsYCrwyn); data(bewdCatch)
#'
#' # Obtain gauge coordinates
#' gcs <- getCoords(crowle,
#'                  bickley,
#'                  barnhurst,
#'                  hollies,
#'                  ledbury,
#'                  bettwsYCrwyn)
#'
#' bewdTeeSun <- teeSun(gaugeCoords = gcs, catchment = bewdCatch)
#'
#' leaflet(bewdTeeSun) %>%
#'   addTiles() %>%
#'   addPolygons()
teeSun <- function(gaugeCoords, catchment = NULL){
  if('sf' %in% class(gaugeCoords)){
    if(is.null(catchment)){
      ## Combine features
      voronoi <- st_union(gaugeCoords)

      ## Create Voronoi tessellation
      voronoi <- suppressWarnings(st_voronoi(voronoi))

      ## Split (extract) Voronoi into polygons
      voronoi <- st_collection_extract(voronoi)
    } else {
      bbox <- st_bbox(catchment) + c(-0.5, -0.2, 0.5, 0.2)
      bbox <-  st_as_sfc(bbox)
      voronoi <- st_union(gaugeCoords)
      voronoi <- suppressWarnings(st_voronoi(voronoi, envelope = bbox))
      voronoi <- st_collection_extract(voronoi)
    }
    return(voronoi)
  }
  stop('This function only works with data of class type "sf"')
}

