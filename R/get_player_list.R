#' @export
get_player_list <- function(leagueid = "121038", numPlayers = 200) {
  check_token()


  playerlist <- data.frame()
  for(i in 0:((numPlayers/25) - 1)) {

    url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/380.l.121038/players;sort=OR;start=", 25*i)
    response <- httr::GET(url, httr::content_type("applilcation/xml"),
                   httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
    check_request(response)
    response <- httr::content(response)
    response <- XML::xmlToList(XML::xmlParse(response))
    if(length(response$league$players) == 0) {
      break
    }
    reponse$league$players$.attrs <- NULL

    reponse <- plyr::ldply(reponse$league$players, function(x) {
      data.frame(name = x$name$full)
    })
    reponse$.id <- NULL
    playerlist <- rbind(playerlist, reponse)
  }
  return(playerlist)
}
