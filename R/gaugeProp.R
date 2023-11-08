#' @title Gauge proportion
#'
#' @description Calculates the the proportion of catchment that the gauge occupies using Thiessen / Voronoi polygons
#'
#' @param intersectPoly Shapefile of the intersected catchment polygon
#' @param catchment Catchment shapefile
#'
#' @import data.table
#' @importFrom sf st_area
#'
#' @return Rainfall proportions for each rain gauge
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
#' int <- intersectPoly(coords = gcs,
#'                      voronoi = bewdTeeSun,
#'                      catchment = bewdCatch)
#' gaugeProp(intersectPoly = int)
gaugeProp <- function(intersectPoly){
  ## Calculate polygon areas
  ##! calculates in km^2
  area <- round(as.numeric(sf::st_area(intersectPoly)/1000000,2), 2)
  total <- sum(area)
  prop <- (area/total) * 100 # Percentage area
  dt <- data.table(Station = intersectPoly$stationName,
                   WISKI = intersectPoly$WISKI,
                   Area = area,
                   Proportion = prop)
  class(dt) <- append(class(dt), 'gaugeProp')
  return(dt)
}
