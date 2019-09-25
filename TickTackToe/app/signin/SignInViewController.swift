import UIKit

class SignInViewController: UIViewController {
    
    private weak var navigation: RootController?
    private var credentials: TickTackToeCredentials = TickTackToeCredentials(username: .none, password: .none)
    private let credentialsVerifier: CredentialsVerifier
    
    init(
        navigation: RootController,
        credentialsVerifier: CredentialsVerifier
    ) {
        self.navigation = navigation
        self.credentialsVerifier = credentialsVerifier
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.green
        
        let username = UITextField(
            frame: CGRect(
                x: 100,
                y: 200,
                width: 200,
                height: 20
            )
        )
        username.placeholder = "username"
        username.addTarget(self, action: #selector(updatedUsername), for: .editingChanged)
        
        let password = UITextField(
            frame: CGRect(
                x: 100,
                y: 240,
                width: 200,
                height: 20
            )
        )
        password.placeholder = "password"
        password.isSecureTextEntry = true
        password.addTarget(self, action: #selector(updatedPassword), for: .editingChanged)
        
        let submit = UIButton(
            frame: CGRect(
                x: 100,
                y: 280,
                width: 200,
                height: 20
            )
        )
        submit.backgroundColor = UIColor.black
        submit.setTitle("submit", for: .normal)
        submit.tintColor = UIColor.white
        submit.addTarget(self, action: #selector(submitCredentials), for: .touchUpInside)
        
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(submit)
        
        super.viewDidLoad()
    }
    
    @objc func updatedPassword(_ element: UITextField) {
        element.text.map { text in
            self.credentials = TickTackToeCredentials(
                username: self.credentials.username,
                password: text
            )
        }
    }
    
    @objc func updatedUsername(_ element: UITextField) {
        element.text.map { text in
            self.credentials = TickTackToeCredentials(
                username: text,
                password: self.credentials.password
            )
        }
    }

    @objc func submitCredentials(_ element: UIButton) {
        let navigationAction = credentialsVerifier.verifyCredentials(
            credentials,
            onSuccess: { (userId: UUID) in .loginSuccess(userId: userId) },
            onFailure: { .loginFailure }
        )
        
        navigation?.applyAction(navigationAction)
    }
}

struct TickTackToeCredentials {
    let username: Optional<String>
    let password: Optional<String>
}
