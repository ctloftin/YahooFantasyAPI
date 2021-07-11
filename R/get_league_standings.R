#' @export
get_league_standings <- function(gameid = "406", leagueid = NULL) {
  check_token()

  if(is.null(leagueid)) {
    stop("Must pass in a leagueid")
  }

  url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/", gameid, ".l.", leagueid, "/standings")
  response <- httr::GET(url, httr::content_type("applilcation/xml"),
                 httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
  response <- httr::content(response)
  response <- XML::xmlToList(XML::xmlParse(response))
  response <- response$league$standings$teams[c(1:response$league$num_teams)]
  response <- plyr::ldply(response, function(x) {
    return(data.frame(team = x$name,
                      manager = x$managers$manager$nickname,
                      wins = x$team_standings$outcome_totals$wins,
                      losses = x$team_standings$outcome_totals$losses,
                      points_for = x$team_standings$points_for,
                      points_against = x$team_standings$points_against))
  })
  response$.id <- NULL
  response[] <- lapply(response, as.character)
  return(response)
}
