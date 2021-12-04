source("./src/solution.R")

lines <- readLines("./data/input.txt")

drawnNumbers = lapply(strsplit(lines[1], ","), function(s) strtoi(s, base=10))

boards = list()
currentBoard = 1
currentBoardItems = list()

for (i in 3:length(lines)) {
  if (lines[i] == "") {
    boards[[currentBoard]] <- board(unlist(currentBoardItems))
    currentBoard <- currentBoard + 1
    currentBoardItems <- list()
  }

  numbers = lapply(strsplit(lines[i], " "), function(s) strtoi(s, base=10))
  currentBoardItems <- c(currentBoardItems, unlist(numbers))
}

boards[[currentBoard]] <- board(unlist(currentBoardItems))

score = WinnerBoardScore(unlist(drawnNumbers), boards)
print(sprintf("Part 1: %d", score))

lastWinnerScore = LastWinnerBoardScore(unlist(drawnNumbers), boards)
print(sprintf("Part 2: %d", lastWinnerScore))
