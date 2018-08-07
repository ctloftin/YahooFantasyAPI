#' @export
get_all_game_info <- function() {
  check_token()

  url <- "https://fantasysports.yahooapis.com/fantasy/v2/games;game_codes=nfl"
  response <- httr::GET(url, httr::content_type("applilcation/xml"),
                 httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
  response <- XML::xmlToList(XML::xmlParse(response))
  response$.attrs <- NULL
  response$games$.attrs <- NULL
  response <- as.data.frame(data.table::rbindlist(response$games))
  return(response)
}
