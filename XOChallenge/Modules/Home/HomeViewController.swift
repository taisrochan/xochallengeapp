//
//  HomeViewController.swift
//  XOChallenge
//
//  Created by Tais Rocha Nogueira on 06/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var playerOneTextField: UITextField!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var sizeOfBoardTextField: UITextField!
    @IBOutlet weak var sizeOfBoardButton: UIButton!
    @IBOutlet weak var startTheGameButton: UIButton!
    @IBOutlet weak var checkPlayHistoryButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension HomeViewController {
    func setupUI() {
        playerOneTextField.delegate = self
        playerTwoTextField.delegate = self
        playerOneTextField.addTarget(self, action: #selector(didchangeTextField), for: .editingChanged)
        playerTwoTextField.addTarget(self, action: #selector(didchangeTextField), for: .editingChanged)
        sizeOfBoardTextField.addTarget(self, action: #selector(didchangeTextField), for: .editingChanged)
        startTheGameButton.isEnabled = false
        sizeOfBoardTextField.isUserInteractionEnabled = false
    }
    
    @objc func didchangeTextField() {
        verifyTextFields()
    }
    
    func verifyTextFields() {
        let isPlayerOneEmpty = (playerOneTextField.text ?? "").isEmpty == true
        let isPlayerTwoEmpty = (playerTwoTextField.text ?? "").isEmpty == true
        let isSizeEmpty = (sizeOfBoardTextField.text ?? "").isEmpty == true
        let shouldDisableCreateButton = isPlayerOneEmpty || isPlayerOneEmpty || isSizeEmpty
        startTheGameButton.isEnabled = !shouldDisableCreateButton
    }
    
    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        let isAgainstRobot = selectedSegmentIndex == 1
        playerTwoTextField.text = isAgainstRobot ? "Robô" : ""
        playerTwoTextField.isUserInteractionEnabled = !isAgainstRobot
        verifyTextFields()
    }
    
    @IBAction func didClickSizeButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Escolha uma opção", message: nil, preferredStyle: .actionSheet)
        let actions = createActions()
        actions.forEach({
            alertController.addAction($0)
        })
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func createActions() -> [UIAlertAction] {
        var actions: [UIAlertAction] = []
        for i in 3..<11 {
            let act = createGameSizeAction(size: i)
            actions.append(act)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            self.sizeOfBoardTextField.text = ""
            self.verifyTextFields()
        }
        actions.append(cancelar)
        return actions
    }
    
    @IBAction func startTheGame(_ sender: UIButton) {
        guard let sizeString = sizeOfBoardTextField.text else {
            return
        }
        let gameController = createGameController(sizeString: sizeString)
        self.navigationController?.pushViewController(gameController, animated: true)
    }
    
    func createGameSizeAction(size: Int) -> UIAlertAction {
        let action = UIAlertAction(title: "\(size)x\(size)", style: .default) { (action) in
            self.sizeOfBoardTextField.text = "\(size)x\(size)"
            self.sizeOfBoardTextField.isUserInteractionEnabled = false
            self.verifyTextFields()
        }
        return action
    }
    
    func getBoardSize(text: String) -> Int {
        var boardSize: Int = 3
        if text == "10x10" {
            if let firstTwoCharacters = Int(text.prefix(2)) {
                boardSize = firstTwoCharacters
            }
        } else if let firstCharacter = text.first,
                  let singleCharacterSize = Int(String(firstCharacter)) {
            boardSize = singleCharacterSize
        }
        return boardSize
    }
    
    func createGameController(sizeString: String) -> UIViewController {
        let boardSize = getBoardSize(text: sizeString)
        let isAgainstRobot = segmentedControl.selectedSegmentIndex == 1
        let controller = GameViewController(boardSize: boardSize,
                                          isPlayingAgainsRobot: isAgainstRobot,
                                          namePlayerOne: playerOneTextField.text ?? "",
                                          namePlayerTwo: playerTwoTextField.text ?? "")
        return controller
    }
    
    @IBAction
    func checkPlayHistory(_ sender: UIButton) {
        print("hell yeah 3")
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .whitespaces) != nil {
            return false
        }
        return true
    }
}
