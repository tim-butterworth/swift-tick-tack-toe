import Foundation

private func gameUpdateFunction(_ move: GameMove) -> (TickTackToeGame) -> TickTackToeGame {
    return { game in
        var updatedMoves = game.moves
        updatedMoves.append(move)
        
        return TickTackToeGame(
            id: game.id,
            moves: updatedMoves
        )
    }
}

private func updatedGame(_ move: GameMove, _ game: TickTackToeGame?) -> TickTackToeGame? {
    return game.map(gameUpdateFunction(move))
}

class InMemoryCreateGameAdapter: CreateGameAdapter, MakeMoveAdapter, FindGameAdapter {
    var game: TickTackToeGame?
    
    func getGame() -> FindGameResult {
        return game.map { .found($0) } ?? .notfound
    }

    func makeMove(move: GameMove) -> SaveResult {
        game = updatedGame(move, game)
        
        switch game {
        case .none: return .failure
        case .some: return .success
        }
    }
    
    func createGame<GameCreationResult>(ifSuccessful: (UUID) -> GameCreationResult, ifFailure: (String) -> GameCreationResult) -> GameCreationResult {
        let id = UUID()
        
        game = TickTackToeGame(
            id: id,
            moves: []
        )
        
        return ifSuccessful(id)
    }
}
