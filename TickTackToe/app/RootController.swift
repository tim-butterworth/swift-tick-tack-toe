import UIKit

class RootController: UIViewController {
    
    private var viewMap: [View: () -> UIViewController] = [:]
    private var selectedView: (view: View, instance: UIViewController)?
    private let navigator: Navigator

    init() {
        navigator = Navigator()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activateChildView(.signIn)
    }

    private func activateChildView(_ viewKey: View) {
        if let childViewProvider = viewMap[viewKey] {
            DispatchQueue.main.async {
                self.selectedView.map {
                    let childController: UIViewController = $0.instance
                    childController.willMove(toParent: nil)
                    childController.view.removeFromSuperview()
                    childController.removeFromParent()
                }
                
                let childView = childViewProvider()
                
                childView.view.frame = self.view.frame
                self.addChild(childView)
                
                self.view.addSubview(childView.view)
                self.didMove(toParent: childView)
                
                self.selectedView = (view: viewKey, instance: childView)
            }
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
            let nextView = navigator.applyMoveAction(view, navigationAction)
            
            if (nextView != view) {
                activateChildView(nextView)
            }
        }
    }
}
