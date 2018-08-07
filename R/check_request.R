#' @export
check_request <- function(response) {
  status_code <- response$status_code
  if(status_code != 200) {
    response <- httr::content(response)
    response <- XML::xmlToList(XML::xmlParse(response))
    return(stop(paste0("Invalid request with following message:\n", response$description)))
  }
}
