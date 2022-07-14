#' @export
update_yahoo_ranks <- function(gameid = "414", leagueid = NULL, numPlayers = 300) {
  check_token()

  plist <- get_player_list(gameid, leagueid, numPlayers)

  plist$rank <- c(1:nrow(plist))
  colnames(plist) <- c("Player",  "Team", "Pos", format(Sys.Date(), "%m/%d"))

  if(file.exists("data/yahoo_ranks.csv")) {
    ranks <- read.csv(file = "data/yahoo_ranks.csv", header = TRUE, stringsAsFactors = FALSE)
    colnames(ranks) <- gsub("X", "", colnames(ranks))
    colnames(ranks) <- gsub("\\.", "/", colnames(ranks))

    ranks <- merge(ranks, plist, by = c("Player", "Team", "Pos"), all = TRUE)

  } else {
    ranks <- plist
  }
  nonunique <- grep("X", toupper(colnames(ranks)))
  if(length(nonunique) > 0) {
    ranks <- ranks[,-nonunique]
  }

  ranks <- ranks[order(ranks[,ncol(ranks)]),]
  ranks$match <- ranks[,ncol(ranks)-1] == ranks[,ncol(ranks)]

  if(FALSE %in% ranks$match & ncol(ranks) > 5 | !file.exists("data/yahoo_ranks.csv")) {
    ranks$match <- NULL

    write.csv(ranks, file = "data/yahoo_ranks.csv", row.names = FALSE)
  }

}
