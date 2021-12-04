winnerCombination = c(-1, -1, -1, -1, -1)

# PART 1
WinnerBoardScore <- function(drawnNumbers, boards) {
  winner <- -1
  lastNumber <- -1

  for (number in drawnNumbers) {
    lastNumber <- number

    for (i in  1:length(boards)) {
      numberPositions = which(boards[[i]] == number, TRUE)

      # skip if no matches are found
      if (length(numberPositions) == 0) next

      # update the number into -1
      boards[[i]][numberPositions[1], numberPositions[2]] <- -1

      # check the column and row to see if the board wins
      if (identical(boards[[i]][numberPositions[1],], winnerCombination) || identical(boards[[i]][,numberPositions[2]], winnerCombination)) {
        winner <- i
        break
      }
    }

    if (winner > -1) {
      break
    }
  }

  return(sum(boards[[winner]][boards[[winner]] != -1]) * lastNumber)
}

# PART 2
LastWinnerBoardScore <- function(drawnNumbers, boards) {
  lastNumber <- -1
  winners <- list()

  for (number in drawnNumbers) {
    lastNumber <- number

    for (i in 1:length(boards)) {
      if (i %in% winners) next

      numberPositions = which(boards[[i]] == number, TRUE)

      # skip if no matches are found
      if (length(numberPositions) == 0) next

      # update the number into -1
      boards[[i]][numberPositions[1], numberPositions[2]] <- -1

      # check the column and row to see if the board wins
      if (identical(boards[[i]][numberPositions[1],], winnerCombination) || identical(boards[[i]][,numberPositions[2]], winnerCombination)) {
        winners <- append(winners, i)

        if (length(winners) == length(boards)) {
          break
        }
      }
    }

    if (length(winners) == length(boards)) {
      break
    }
  }

  lastWinner <- boards[[winners[[length(winners)]]]]
  return(sum(lastWinner[lastWinner != -1]) * lastNumber)
}

board = function(numbers) {
  return(matrix(numbers, nrow=5, ncol=5, byrow=TRUE))
}
