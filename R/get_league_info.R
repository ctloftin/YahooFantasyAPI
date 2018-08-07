#' @export
get_league_info <- function(leagueid = "121038") {
  check_token()

  url <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/380.l.", leagueid)
  response <- httr::GET(url, httr::content_type("applilcation/xml"),
                 httr::add_headers(Authorization = paste0("Bearer ", fantasyEnv$token)))
  check_request(response)
  response <- XML::xmlToDataFrame(XML::xmlParse(response))
  cat("continued")
  return(response)
}
