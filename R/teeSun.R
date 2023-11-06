#' @title teeSun
#'
#' @description Creates a Thiessen/Voronoi polygon shapefile.
#'
#' @param x SF file with point data within.
#' @param catchment Set as null, optional bounding box polygon derived from catchment polygon
#'
#' @return A polygon shapefile with Thiessen polygons
#' @export
#'
#' @examples
#' teeSun(s)
teeSun <- function(x, catchment = NULL){
  if('sf' %in% class(x)){
    if(is.null(catchment)){
      ## Combine features
      voronoi <- st_union(x)

      ## Create Voronoi tesselation
      voronoi <- suppressWarnings(st_voronoi(voronoi))

      ## Split (extract) Voronoi into polygons
      voronoi <- st_collection_extract(voronoi)
    } else {
      bbox <- st_bbox(catchment) + c(-0.5, -0.2, 0.5, 0.2)
      bbox <-  st_as_sfc(bbox)
      voronoi <- st_union(x)
      voronoi <- suppressWarnings(st_voronoi(voronoi, envelope = bbox))
      voronoi <- st_collection_extract(voronoi)
    }
    return(voronoi)
  }
  stop('This function only works with data of class type "sf"')
}

