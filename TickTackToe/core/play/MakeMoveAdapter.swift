import Foundation

enum SaveResult {
    case success
    case failure
}

protocol MakeMoveAdapter {
    func makeMove(move: GameMove) -> SaveResult
}
