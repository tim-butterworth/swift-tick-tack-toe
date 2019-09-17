import UIKit

class RootController: UIViewController {
    
    private var viewMap: [View: () -> UIViewController] = [:]
    private var selectedView: (view: View, instance: UIViewController)?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activateChildView(.SignIn)
    }

    private func activateChildView(_ viewKey: View) {
        if let childViewProvider = viewMap[viewKey] {
            selectedView.map { $0.instance.removeFromParent() }
            
            let childView = childViewProvider()
            
            childView.view.frame = self.view.frame
            addChild(childView)
            
            view.addSubview(childView.view)
            didMove(toParent: childView)
            
            selectedView = (view: viewKey, instance: childView)
        } else {
            print("Attempted to navigate to \(viewKey) and there is no view provider")
        }
    }
    
    func registerView(view: View, controllerProvider: @escaping  () -> UIViewController) {
        viewMap[view] = controllerProvider
    }
    
    func applyAction(_ navigationAction: NavigationAction) {
        print("applyingAction: \(navigationAction)")
        
        selectedView.map { (view, instance) in
            switch view {
            case .SignIn:
                switch navigationAction {
                case let .loginSuccess(userId):
                    self.activateChildView(.CreateGame)
                case .loginFailure: ()
                }
            default: ()
            }
        }
    }
}
