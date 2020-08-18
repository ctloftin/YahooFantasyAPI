#' @export
get_all_game_info <- function(sport = NULL) {
  check_token()

  if(is.null(sport)) {
    sport <- c("nfl", "mlb", "nba", "nhl")
  }

  gamecodes <- data.frame()
  for(i in 1:length(sport)) {


    url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/games;game_codes=", sport[i])
    response <- httr::GET(url, httr::content_type("applilcation/xml"),
                          httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
    response <- XML::xmlToList(XML::xmlParse(response))
    response$.attrs <- NULL
    response$games$.attrs <- NULL
    response$games[21]$game$is_live_draft_lobby_active <- NULL
    response <- as.data.frame(data.table::rbindlist(response$games))
    response$season <- as.integer(response$season)
    response <- response[order(-response$season),]
    gamecodes <- rbind(gamecodes, response)
  }
  return(gamecodes)
}
