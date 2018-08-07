#' @export
get_token <- function(key = NULL, secret = NULL) {
  Sys.setenv(TZ='America/New_York')
  currentTime <- Sys.time()
  #Create Endpoint
  yahoo <- httr::oauth_endpoint(authorize = "https://api.login.yahoo.com/oauth2/request_auth"
                                , access = "https://api.login.yahoo.com/oauth2/get_token"
                                , base_url = "https://fantasysports.yahooapis.com")

  if(is.null(key)) {
    if(exists("fantasyEnv") == FALSE) {
      stop("Must pass a value to key")
    } else {
      key <- fantasyEnv$key
    }
  }
  if(is.null(secret)) {
    if(exists("fantasyEnv") == FALSE) {
      stop("secret must have a value")
    } else {
      secret <- fantasyEnv$secret
    }
  }

  #Create App
  yahoo_app <- httr::oauth_app("yahoo", key = key, secret = secret, redirect_uri = "oob")

  #Open Browser to Authorization Code
  yahoo <- httr::oauth_endpoint(authorize = "https://api.login.yahoo.com/oauth2/request_auth"
                                , access = "https://api.login.yahoo.com/oauth2/get_token"
                                , base_url = "https://fantasysports.yahooapis.com")

  httr::BROWSE(httr::oauth2.0_authorize_url(yahoo, yahoo_app, scope="fspt-w"
                                            , redirect_uri = yahoo_app$redirect_uri))

  code <- readline(prompt = "Enter Yahoo-provided code: ")
  #Create Token
  yahoo_token<- httr::oauth2.0_access_token(yahoo,yahoo_app,code=code)

  if(exists("fantasyEnv") == FALSE) {
    fantasyEnv <- new.env()
    assign("fantasyEnv", fantasyEnv, envir = baseenv())
    rm(fantasyEnv)
  }

  if(exists("key", envir = fantasyEnv, inherits = FALSE) == TRUE) {
    if(bindingIsLocked("key", fantasyEnv) == TRUE) {
      unlockBinding("key", fantasyEnv)
    }
  }
  if(exists("secret", envir = fantasyEnv, inherits = FALSE) == TRUE) {
    if(bindingIsLocked("secret", fantasyEnv) == TRUE) {
      unlockBinding("secret", fantasyEnv)
    }
  }
  if(exists("token", envir = fantasyEnv, inherits = FALSE) == TRUE) {
    if(bindingIsLocked("token", fantasyEnv) == TRUE) {
      unlockBinding("token", fantasyEnv)
    }
  }
  if(exists("refresh", envir = fantasyEnv, inherits = FALSE) == TRUE) {
    if(bindingIsLocked("refresh", fantasyEnv) == TRUE) {
      unlockBinding("refresh", fantasyEnv)
    }
  }
  if(exists("expire", envir = fantasyEnv, inherits = FALSE) == TRUE) {
    if(bindingIsLocked("expire", fantasyEnv) == TRUE) {
      unlockBinding("expire", fantasyEnv)
    }
  }

  fantasyEnv$key <- key
  fantasyEnv$secret <- secret
  fantasyEnv$token <- yahoo_token$access_token
  fantasyEnv$expire <- currentTime + lubridate::hours(1)

}
