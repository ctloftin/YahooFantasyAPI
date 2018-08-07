#' @export
get_player_list <- function(gameid = "380", leagueid = NULL, numPlayers = 200) {
  check_token()

  if(is.null(leagueid)) {
    stop("Must pass in a leagueid")
  }

  playerlist <- data.frame()
  for(i in 0:((numPlayers/25) - 1)) {

    url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/", gameid, ".l.", leagueid,
                  "/players;sort=OR;start=", 25*i)
    response <- httr::GET(url, httr::content_type("applilcation/xml"),
                   httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
    check_request(response)
    response <- httr::content(response)
    response <- XML::xmlToList(XML::xmlParse(response))
    if(length(response$league$players) == 0) {
      break
    }
    response$league$players$.attrs <- NULL

    response <- plyr::ldply(response$league$players, function(x) {
      data.frame(name = x$name$full,
                 team = toupper(x$editorial_team_abbr))
    })
    response$.id <- NULL
    playerlist <- rbind(playerlist, response)
  }
  response[] <- lapply(response, as.character)
  return(playerlist)
}
