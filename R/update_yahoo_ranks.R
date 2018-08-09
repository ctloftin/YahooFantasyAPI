#' @export
update_yahoo_ranks <- function(gameid = "380", leagueid = NULL, numPlayers = 200) {
  check_token()

  plist <- get_player_list(gameid, leagueid, numPlayers)

  plist$rank <- c(1:nrow(plist))
  colnames(plist) <- c("Player",  "Team", "Pos", format(Sys.Date(), "%m/%d"))

  ranks <- read.csv(file = "data/yahoo_ranks.csv", header = TRUE, stringsAsFactors = FALSE)

  ranks <- merge(ranks, plist, by = c("Player", "Team", "Pos"), all.x = TRUE)
  nonunique <- grep("X", colnames(ranks))
  if(length(nonunique) > 0) {
    ranks <- ranks[,-nonunique]
  }
  ranks <- ranks[order(ranks[,ncol(ranks)]),]
  ranks$match <- ranks[,ncol(ranks)-1] == ranks[,ncol(ranks)]
  if(!(FALSE %in% ranks$match)) {
    ranks[,ncol(ranks)-1] <- NULL
  }
  ranks$match <- NULL

  write.csv(ranks, file = "data/yahoo_ranks.csv", row.names = FALSE)
}
