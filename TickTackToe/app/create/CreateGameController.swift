import UIKit

class CreateGameController: UIViewController {
    
    let navigation: RootController
    let createProcessor: CreateGameProcessor<InMemoryCreateGameAdapter>
    
    init(navigation: RootController, _ createProcessor: CreateGameProcessor<InMemoryCreateGameAdapter>) {
        self.navigation = navigation
        self.createProcessor = createProcessor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.orange
        
        let createButton = UIButton(
            frame: CGRect(
                x: (view.frame.maxX / 2) - 100,
                y: (view.frame.maxY / 2) - 10,
                width: 200,
                height: 20
            )
        )
        createButton.setTitle("create", for: .normal)
        createButton.backgroundColor = UIColor.black
        createButton.tintColor = UIColor.white
        createButton.titleLabel?.textAlignment = .center
        createButton.addTarget(self, action: #selector(createHandler), for: .touchUpInside)

        view.addSubview(createButton)
    }
    
    @objc func createHandler(_ button: UIButton) {
        switch createProcessor.createGame() {
        case let .success(gameId):
            navigation.applyAction(.gameCreated(gameId: gameId))
        case let .failure(errorMessage):()
        }
    }
}
