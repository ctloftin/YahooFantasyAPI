#' @export
check_token <- function() {
  if(exists("fantasyEnv")) {
    if(Sys.time() > fantasyEnv$expire) {
      cat("Token has expired. Getting new one...")
      get_token(fantasyEnv$key, fantasyEnv$secret)
      cat("New token will expire in one hour")
    }
  } else {
    stop("Token does not exist. Please run get_token() first")
  }
}
