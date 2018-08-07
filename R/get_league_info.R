#' @export
get_league_info <- function(gameid = "380", leagueid = NULL) {
  check_token()

  if(is.null(leagueid)) {
    stop("Must pass in a leagueid")
  }

  url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/", gameid, ".l.", leagueid)
  response <- httr::GET(url, httr::content_type("applilcation/xml"),
                 httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
  check_request(response)
  response <- XML::xmlToDataFrame(XML::xmlParse(response))
  t[] <- lapply(t, as.character)
  return(response)
}
