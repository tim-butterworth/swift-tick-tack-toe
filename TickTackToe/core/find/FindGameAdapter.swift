import Foundation

enum FindGameResult {
    case found(TickTackToeGame)
    case notfound
    case error(String)
}

protocol FindGameAdapter {
    func getGame() -> FindGameResult
}
