import Foundation

enum PlayerSide {
    case x
    case o
}

enum BoardCoordinate {
    case minus_one
    case zero
    case one
}

struct GameCoordinate: Equatable {
    let x: BoardCoordinate
    let y: BoardCoordinate
}

struct GameMove {
    let side: PlayerSide
    let coordinate: GameCoordinate
}

struct PlayGameProcessor {
    let makeMoveAdapter: MakeMoveAdapter
    let findGameAdapter: FindGameAdapter
    let gameRules: GameRules
    
    func applyMove(applyMoveResponder: ApplyMoveResponder, move: GameMove) {
        let tickTackToeGameFindResult = findGameAdapter.getGame()

        switch (tickTackToeGameFindResult) {
        case let .error(message): applyMoveResponder.error(message: message)
        case .notfound: applyMoveResponder.noGameFound()
        case let .found(game):
            switch gameRules.attemptToApplyMove(move: move, moves: game.moves) {
            case .applied:
                let persistanceResult = makeMoveAdapter.makeMove(move: move)

                switch persistanceResult {
                case .success: applyMoveResponder.appliedMove(move: move)
                case .failure: applyMoveResponder.error(message: "Failed to persist the game move :(")
                }
            case let .win(winningMoves):
                applyMoveResponder.win(winningMoves: winningMoves)
            case .tie: ()
            case let .invalidMove(move): ()
            }
        }
    }
}
