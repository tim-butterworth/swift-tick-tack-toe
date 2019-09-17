import Foundation

enum View {
    case SignIn
    case CreateGame
    case PlayGame
}

enum NavigationAction {
    case loginSuccess(userId: UUID)
    case loginFailure
}
