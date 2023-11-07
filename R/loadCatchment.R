#' Import catchment shapefiles suitable for flode
#'
#' @param filepath link to the shapefile of interest
#'
#' @importFrom sf st_read
#' @importFrom sf st_transform
#'
#' @return A catchment polygon set to the WGS 84 projection
#' @export
#'
#' @examples
#' ## Do not run
#' # loadCatchment(filepath = "c://abcd/efg/hi/jkl.shp")
loadCatchment <- function(filepath = NULL){
  if (is.null(filepath)){
    stop("Please insert a valid file path link")
  }
  ## Load catchment
  rawPoly <- sf::st_read(filepath)
  ## Convert to WGS 84 (4326)
  catchment <- sf::st_transform(rawPoly, 4326)
  return(catchment)
}
