import Foundation

protocol CreateGameAdapter {
    func createGame(ifSuccessful: (UUID) -> GameCreationResult, ifFailure: (String) -> GameCreationResult) -> GameCreationResult
}
