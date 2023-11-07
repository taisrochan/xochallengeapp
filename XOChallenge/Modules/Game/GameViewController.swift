
//  GameViewController.swift
//  XOChallenge
//
//  Created by Tais Rocha Nogueira on 06/11/23.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var verticalStackView: UIStackView!
    
    private let winnerVerification = WinnerVerification()
    private let robotAction = RobotAction()
    private let boardSize: Int
    private let isPlayingAgainsRobot: Bool
    private let namePlayerOne: String
    private let namePlayerTwo: String
    private let spacing: CGFloat = 12
    private let turnLabel = UILabel()
    private var imageSize: Double = 0
    private var isXturn = true
    private var buttonsMatrix: [[ButtonInfos]] = []
    private var firstPlayerTurn: String {
        "É a vez de \(namePlayerOne.capitalized)"
    }
    private var secondPlayerTurn: String {
        "É a vez de \(namePlayerTwo.capitalized)"
    }
    
    init(boardSize: Int, isPlayingAgainsRobot: Bool, namePlayerOne: String, namePlayerTwo: String) {
        self.boardSize = boardSize
        self.isPlayingAgainsRobot = isPlayingAgainsRobot
        self.namePlayerOne = namePlayerOne
        self.namePlayerTwo = namePlayerTwo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension GameViewController {
    func setupUI() {
        verticalStackView.spacing = spacing
        verticalStackView.backgroundColor = .black
        view.backgroundColor = .black
        setupTurnLabel()
        
        for i in 0..<boardSize {
            let horizontalStackView = createHorizontalStackView()
            buttonsMatrix.append([])
            
            for _ in 0..<boardSize {
                let button = createButton()
                buttonsMatrix[i].append(.init(button: button, imageIdentifier: .empty))
                horizontalStackView.addArrangedSubview(button)
            }
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        verticalStackView.addArrangedSubview(turnLabel)
        verticalStackView.addArrangedSubview(UIView())
    }
    
    func createHorizontalStackView() -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = spacing
        return horizontalStackView
    }
    
    func createButton() -> UIButton {
        let size = Double(UIScreen.main.bounds.width) / Double(boardSize) - 24
        imageSize = size - 4
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.setTitle("", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    func setupTurnLabel() {
        turnLabel.text = firstPlayerTurn
        turnLabel.textColor = .white
        turnLabel.textAlignment = .center
        turnLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        turnLabel.numberOfLines = 2
    }
    
    @objc
    func buttonTapped(sender: UIButton) {
        guard sender.imageView?.image == nil else {
            return
        }
        setupButtonClicked(sender: sender)
        let buttonIdentifier = isXturn ? ImageIdentifier.x : ImageIdentifier.circle
        changeIdentifierOf(button: sender, with: buttonIdentifier)
        performActionsAfterTurn()
    }
    
    func performActionsAfterTurn() {
        if let winnerIdentifier = winnerVerification.checkWinner(with: buttonsMatrix) {
            somebodyHasWon(identifier: winnerIdentifier)
        } else {
            checkDraw()
            isXturn = !isXturn
            turnLabel.text = isXturn ? firstPlayerTurn : secondPlayerTurn
            performActionIfIsPlayingAgainstRobot()
        }
    }
    
    func setupButtonClicked(sender: UIButton) {
        let imageName = isXturn ? "xmark" : "circle"
        let tintColor: UIColor = isXturn ? .blue : .red
        let configuration = UIImage.SymbolConfiguration(pointSize: imageSize)
        let image = UIImage.init(systemName: imageName, withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        sender.setImage(image, for: .normal)
        sender.tintColor = tintColor
    }
    
    func changeIdentifierOf(button: UIButton, with identifier: ImageIdentifier) {
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                if button == buttonsMatrix[i][j].button {
                    buttonsMatrix[i][j].imageIdentifier = identifier
                }
            }
        }
    }
    
    func somebodyHasWon(identifier: ImageIdentifier) {
        let winner = getVictoriousName(for: identifier)
        let alertController = UIAlertController(title: "Há um jogador vitorioso",
                                                message: "Parabéns \(winner) pela vitória", preferredStyle: .alert)
        let action = UIAlertAction(title: "Concluir", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func getVictoriousName(for identifier: ImageIdentifier) -> String {
        if identifier == .x {
            return namePlayerOne
        } else {
            return namePlayerTwo
        }
    }
    
    func checkDraw() {
        var isThereEmptyButton = false
        buttonsMatrix.forEach { horizontalStackButtons in
            horizontalStackButtons.forEach { buttonModel in
                if buttonModel.button.imageView?.image == nil {
                    isThereEmptyButton = true
                }
            }
        }
        if !isThereEmptyButton {
            presentDrawAlert()
        }
    }
    
    func presentDrawAlert() {
        let alertController = UIAlertController(title: "Vixi!", message: "Deu velha!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Concluir", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func performActionIfIsPlayingAgainstRobot() {
        guard isPlayingAgainsRobot && !isXturn else {
            return
        }
        let (row, column) = robotAction.calculateNextMove(board: buttonsMatrix)
        let button = buttonsMatrix[row][column].button
        buttonTapped(sender: button)
    }
}
