#' @export
get_this_year_game_info <- function() {
  check_token()

  url <- "https://fantasysports.yahooapis.com/fantasy/v2/game/nfl"
  response <- httr::GET(url, httr::content_type("applilcation/xml"),
                 httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
  response <- XML::xmlToList(XML::xmlParse(response))
  response$.attrs <- NULL
  response <- as.data.frame(data.table::rbindlist(response))
  return(response)
}
