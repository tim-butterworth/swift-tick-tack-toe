import Foundation

enum GameCreationResult {
    case success(gameId: UUID)
    case failure(errorMessage: String)
}

class ResponseContainer {
    
    let gameCreationResult: GameCreationResult
    
    init(gameCreationResult: GameCreationResult) {
        self.gameCreationResult = gameCreationResult
    }
}

struct CreateGameProcessor<Adapter: CreateGameAdapter> {
    
    let createGameAdapter: Adapter
    
    func createGame() -> GameCreationResult {
        return createGameAdapter.createGame(
            ifSuccessful: { .success(gameId: $0) },
            ifFailure: { .failure(errorMessage: $0) }
        )
    }
}
