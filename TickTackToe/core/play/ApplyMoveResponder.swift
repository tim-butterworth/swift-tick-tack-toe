import Foundation

protocol ApplyMoveResponder {
    func error(message: String)
    func noGameFound()
    func invalidMove(move: GameMove)
    func appliedMove(move: GameMove)
    func win(winningMoves: [GameMove])
}
