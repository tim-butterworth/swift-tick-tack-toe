import UIKit

class GameButton: UIButton {
    
    let coordinate: (x: Int, y: Int)

    init(coordinate: (x: Int, y: Int), frame: CGRect) {
        self.coordinate = coordinate
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
