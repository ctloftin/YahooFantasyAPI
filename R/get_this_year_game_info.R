#' @export
get_this_year_game_info <- function(sport = NULL) {
  check_token()

  if(is.null(sport)) {
    sport <- c("nfl", "mlb", "nba", "nhl")
  }
  sport <- tolower(sport)

  gamecodes <- data.frame()
  for(i in 1:length(sport)) {
    url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/game/", sport[i])
    response <- httr::GET(url, httr::content_type("applilcation/xml"),
                          httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
    response <- XML::xmlToList(XML::xmlParse(response))
    response$.attrs <- NULL
    response <- as.data.frame(data.table::rbindlist(response))
    response$season <- as.integer(response$season)
    response$is_live_draft_lobby_active <- NULL
    gamecodes <- rbind(gamecodes, response)
  }
  return(gamecodes)
}
