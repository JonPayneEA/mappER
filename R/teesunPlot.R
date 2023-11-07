#' @title teesunPlot
#'
#' @description Creates a map of a catchment with Thiessen / Voronoi polygons overlayed
#'
#' @param gaugeCoords Coordinates of rain gauges set as a polygon shapefile
#' @param intersectPoly Catchment shapefile
#' @param polyCol Set colours for the polygons
#' @param pointCol Set colour for the points
#'
#' @return An interactive Thiessen polygon map
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
#' teeSunPlot <- teeSunPlot(guageCoords = gcs,
#'                          intersectPoly = int)
teeSunPlot <- function(gaugeCoords, intersectPoly, polyCol = c("green", "yellow", "red"), pointCol = "orangered"){
  ## Set the colour pallete
  colors <- colorFactor(palette = polyCol,
                        domain = (intersectPoly$stationName))
  p <- leaflet(intersectPoly) %>%
    # Base groups
    addTiles(group = "OSM (default)") %>%
    # addProviderTiles(providers$Stadia.StamenToner, group = "Toner") %>%
    # addProviderTiles(providers$Stadia.StamenTonerLite, group = "Toner Lite") %>%
    # addLayersControl(
    #   baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    #   options = layersControlOptions(collapsed = FALSE)
    # ) %>%
    addPolygons(data = teeSun(gaugeCoords),
                color = "black",
                fillOpacity = 0.1,
                weight = 1.5) %>%
    addPolygons(color = 'black',
                fillColor = colors(int$stationName),
                fillOpacity = 0.7,
                weight = 1,
                popup = paste0("<strong> Rain Gauge: </strong>",
                               intersectPoly$stationName,
                               "<br>",
                               "<strong> Area: </strong>",
                               round(st_area(intersectPoly)/1000000,2),
                               "km^2",
                               "<br>",
                               "<strong> Coverage: </strong>",
                               round(st_area(intersectPoly)/sum(st_area(intersectPoly))*100, 2),
                               '%'),
                popupOptions =  popupOptions(closeOnClick = FALSE)
    ) %>%
    addCircleMarkers(data = gaugeCoords,
                     color = pointCol,
                     radius = 6,
                     fillOpacity = 0.8,
                     stroke = 'black',
                     label = ~stationName,
                     labelOptions = labelOptions(permanent = TRUE,
                                                 noHide = TRUE,
                                                 direction = "bottom"))
  return(p)
}
