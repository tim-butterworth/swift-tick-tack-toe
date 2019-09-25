import Foundation

enum ApplyMoveResult {
    case applied
    case win(winningMoves: [GameMove])
    case tie
    case invalidMove(move: GameMove)
}

func getMovesForSide(side: PlayerSide, moves: [GameMove]) -> [GameMove] {
    return moves.filter { move in move.side == side}
}
func append<T>(value: T, to: [T]) -> [T] {
    var mutableTo = to
    mutableTo.append(value)
    return mutableTo
}
func getAllMovesForCurrentSide(_ moves: [GameMove], _ newMove: GameMove) -> [GameMove] {
    return append(value: newMove, to: getMovesForSide(side: newMove.side, moves: moves))
}

func findErrors(_ moves: [GameMove], _ newMove: GameMove) -> ApplyMoveResult? {
    if (moves.count >= 9) {
        return .invalidMove(move: newMove)
    }
    
    let duplicates = moves.filter { move in
        return move.coordinate == newMove.coordinate
    }
    if (duplicates.count > 0) {
        return .invalidMove(move: newMove)
    }
    
    return .none
}

func hasHorizontalMatch(_ moves: [GameMove], _ coordinate: BoardCoordinate) -> [GameMove]? {
    let entriesInRow = moves.filter { move in move.coordinate.y == coordinate }
    
    if (entriesInRow.count == 3) {
        return entriesInRow
    } else {
        return .none
    }
}

func hasVerticalMatch(_ moves: [GameMove], _ coordinate: BoardCoordinate) -> [GameMove]? {
    let entriesInColumn = moves.filter { move in move.coordinate.x == coordinate }
    
    if (entriesInColumn.count == 3) {
        return entriesInColumn
    } else {
        return .none
    }
}

func getMatches(_ matchingSet: [GameCoordinate], _ moves: [GameMove]) -> [GameMove]? {
    let matches = moves.filter { move in
        matchingSet.contains(move.coordinate)
    }
    
    if (matches.count == 3) {
        return matches
    } else {
        return .none
    }
}

func hasNegativeDiagonal(_ moves: [GameMove]) -> [GameMove]? {
    let diagonal = [
        GameCoordinate(x: .one, y: .one),
        GameCoordinate(x: .zero, y: .zero),
        GameCoordinate(x: .minus_one, y: .minus_one)
    ]
    
    return getMatches(diagonal, moves)
}

func hasPositiveDiagonal(_ moves: [GameMove]) -> [GameMove]? {
    let diagonal = [
        GameCoordinate(x: .one, y: .minus_one),
        GameCoordinate(x: .zero, y: .zero),
        GameCoordinate(x: .minus_one, y: .one)
    ]
    
    return getMatches(diagonal, moves)
}

func findWinCondition(_ moves: [GameMove], _ newMove: GameMove) -> ApplyMoveResult? {
    let potentialWinningMoves = getAllMovesForCurrentSide(moves, newMove)
    
    let tooWinning: ([GameMove]) -> ApplyMoveResult? = { winningMoves in
        return .win(winningMoves: winningMoves)
    }
    
    let horizontalWin = hasHorizontalMatch(potentialWinningMoves, .minus_one).map(tooWinning) ??
    hasHorizontalMatch(potentialWinningMoves, .zero).map(tooWinning) ??
    hasHorizontalMatch(potentialWinningMoves, .one).map(tooWinning)
    
    let verticalWin = hasVerticalMatch(potentialWinningMoves, .minus_one).map(tooWinning) ??
    hasVerticalMatch(potentialWinningMoves, .zero).map(tooWinning) ??
    hasVerticalMatch(potentialWinningMoves, .one).map(tooWinning)
    
    let diagonalWin = hasNegativeDiagonal(potentialWinningMoves).map(tooWinning)

    return horizontalWin ?? verticalWin ?? diagonalWin ?? .none
}

struct GameRules {
    func attemptToApplyMove(move: GameMove, moves: [GameMove]) -> ApplyMoveResult {
        return findErrors(moves, move).map { $0 } ??
            findWinCondition(moves, move).map { $0 } ??
            .applied
    }
}
