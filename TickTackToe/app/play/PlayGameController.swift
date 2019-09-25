import UIKit

func convertToBoardCoordinate(_ coordinate: (x: Int, y: Int)) -> GameCoordinate? {
    let toBoardCoordinate = { (value: Int) -> BoardCoordinate? in
        var result: BoardCoordinate? = nil

        switch value {
        case -1: result = .minus_one
        case 0: result = .zero
        case 1: result = .one
        default: ()
        }
        
        return result
    }
    
    let maybeX = toBoardCoordinate(coordinate.x)
    let maybeY = toBoardCoordinate(coordinate.y)
    
    switch (maybeX, maybeY) {
    case (.none, _): return .none
    case (_, .none): return .none
    case let (.some(x), .some(y)): return GameCoordinate(x: x, y: y)
    }
}

func convertToInt(_ boardCoordinate: BoardCoordinate) -> Int {
    switch boardCoordinate {
    case .minus_one: return -1
    case .zero: return 0
    case .one: return 1
    }
}

func opposite(_ side: PlayerSide) -> PlayerSide {
    switch side {
    case .o: return .x
    case .x: return .o
    }
}

class PlayGameController: UIViewController {
    
    private var board: [[GameButton]]
    private var side: PlayerSide = .x
    let processor: PlayGameProcessor

    init(
        navigation: RootController,
        processor: PlayGameProcessor
    ){
        board = []
        self.processor = processor

        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.lightGray
        
        (-1...1).forEach { x in
            var row: [GameButton] = []
            (-1...1).forEach { y in
                let sideLength = 80
                let basisX = self.view.frame.maxX/2
                let basisY = self.view.frame.maxY/2
                
                let currentButton = GameButton(
                    coordinate: (x: x, y: y),
                    frame: CGRect(
                        x: basisX + CGFloat(x * (sideLength + 5)) - CGFloat(sideLength / 2),
                        y: basisY + CGFloat(y * (sideLength + 5)) - CGFloat(sideLength / 2),
                        width: CGFloat(sideLength),
                        height: CGFloat(sideLength)
                    )
                )
                currentButton.backgroundColor = UIColor.white
                currentButton.addTarget(self, action: #selector(boardClicked), for: .touchUpInside)
                
                row.append(currentButton)
            }
            board.append(row)
        }
        
        board.forEach { row in
            row.forEach { button in
                view.addSubview(button)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func boardClicked(_ button: GameButton) {
        let maybeGameCoordinate = convertToBoardCoordinate(button.coordinate)
        
        let move = maybeGameCoordinate.map { gameCoordinate in
            return GameMove(
                side: side,
                coordinate: gameCoordinate
            )
        }
        
        switch move {
        case .none: print("invalid move")
        case let .some(move): processor.applyMove(applyMoveResponder: self, move: move)
        }
    }
}

extension PlayGameController: ApplyMoveResponder {
    func win(winningMoves: [GameMove]) {
        DispatchQueue.main.async {
            winningMoves.forEach { move in
                let data = (x: convertToInt(move.coordinate.x) + 1, y: convertToInt(move.coordinate.y) + 1, side: move.side)
                
                let button = self.board[data.x][data.y]
                button.setTitle("\(data.side)", for: .normal)
                button.setTitleColor(UIColor.blue, for: .normal)
                button.backgroundColor = UIColor.green
            }
        }
    }
    
    func error(message: String) {
        print("Error -> \(message)")
    }
    
    func noGameFound() {
        print("noGameFound")
    }
    
    func invalidMove(move: GameMove) {
        print("Invalid move: \(move)")
    }
    
    func appliedMove(move: GameMove) {
        DispatchQueue.main.async {
            let data = (x: convertToInt(move.coordinate.x) + 1, y: convertToInt(move.coordinate.y) + 1, side: move.side)
            
            let button = self.board[data.x][data.y]
            button.setTitle("\(data.side)", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
        }
        
        self.side = opposite(side)
        
        print("Move was applied, updated moves => \(move)")
    }
}
