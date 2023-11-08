#' @title Intersect of polygons
#'
#' @description Creates intersected polygons of catchment against Voronoi polygons
#'
#' @param voronoi Voronoi/Thiessen polygon
#' @param catchment Catchment shapefile
#' @param coords Coordinates of rain gauges set as a polygon shapefile
#'
#' @return The calculated intersections of a polygon
#' @export
#'
#' @importFrom sf st_cast
#' @importFrom sf st_intersection
#' @importFrom sf st_sf
#' @importFrom sf st_join
#' @importFrom sf st_nearest_feature
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
#' int <- intersectPoly(coords = gcs,
#'                      voronoi = bewdTeeSun,
#'                      catchment = bewdCatch)
#' int
intersectPoly <- function(voronoi, catchment, coords){
  ## Simplify geometry
  cast <- sf::st_cast(voronoi)

  ## Return all non-empty intersections between voronoi and catchment polygon
  intersect <- sf::st_intersection(cast, catchment)

  ## Convert to sf
  intersect_sf <- sf::st_sf(intersect)

  ## Join between intersected polygons and raingauge coordinates
  join <- sf::st_join(intersect_sf, coords, join = st_nearest_feature)
  return(join)
}

