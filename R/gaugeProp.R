#' @title Gauge proportion
#'
#' @description Calculates the the proportion of catchment that the gauge occupies using Thiessen / Voronoi polygons
#'
#' @param coords Coordinates of rain gauges set as a polygon shapefile
#' @param catchment Catchment shapefile
#'
#' @import data.table
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
#' gaugeProp(gcs, bewdCatch)
gaugeProp <- function(coords, catchment){

  voronoi <- teeSun(coords, catchment)
  vpoly <- intersectPoly(voronoi = voronoi,
                      catchment = catchment,
                      coords = coords)
  names(vPoly)[1] <- 'ID'
  area <- round(as.numeric(st_area(vPoly)/1000000,2), 2) #! calculates in km^2
  total <- sum(area)
  prop <- (area/total) * 100 # Percentage area
  dt <- data.table(Gauge = vPoly$ID, WISKI = vPoly$WISKI, Area = area, Proportion = prop)
  class(dt) <- append(class(dt), 'gaugeProp')
  return(dt)
}

# gaugeProp(gcs, catch)
