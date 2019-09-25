import Foundation

enum View: Hashable {
    case signIn
    case createGame
    case playGame
}

enum NavigationAction {
    case loginSuccess(userId: UUID)
    case loginFailure
    case gameCreated(gameId: UUID)
}
