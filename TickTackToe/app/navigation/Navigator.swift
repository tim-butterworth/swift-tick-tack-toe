import Foundation

struct Navigator {
    func applyMoveAction(_ currentView: View, _ navigationAction: NavigationAction) -> View {
        switch currentView {
        case .signIn:
            switch navigationAction {
            case .loginSuccess:
                return .createGame
            case .loginFailure: ()
            default: ()
            }
        case .createGame:
            switch navigationAction {
            case .gameCreated:
                return .playGame
            default: ()
            }
        default: ()
        }
        
        return currentView
    }
}
