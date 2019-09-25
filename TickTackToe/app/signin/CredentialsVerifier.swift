import Foundation

class CredentialsVerifier {
    func verifyCredentials(
        _ credentials: TickTackToeCredentials,
        onSuccess: (UUID) -> NavigationAction,
        onFailure: () -> NavigationAction
    ) -> NavigationAction {
        return getUser(forCredentials: credentials).map { (userId: UUID) in
            onSuccess(userId)
        } ?? onFailure()
    }

    private func getUser(forCredentials credentials: TickTackToeCredentials) -> Optional<UUID> {
        if (credentials.password == "SuperSecret" && credentials.username == "bestUser") {
            return UUID.init(uuidString: "AED23A9E-9D27-4BCA-809F-3686AE40CD97")
        } else {
            return .none
        }
    }
}
