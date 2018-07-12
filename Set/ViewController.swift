//
//  ViewController.swift
//  Set
//
//  Created by Evgeniy Ziangirov on 14/06/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Game()

    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var setCountLabel: UILabel!
    @IBOutlet weak private var dealCardsButton: UIButton!
    @IBOutlet weak private var deckCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        updateDealCardsButtonView()
        updateViewFromModel()
        updateLabels()
    }
    
    private func updateButtonsViewWhenGameIsEnd() {
        let attributes: [NSAttributedString.Key: Any] = [.strokeWidth: 5.0,
                                                         .strokeColor: UIColor.red]
        let attributedString = NSAttributedString(string: "🏆", attributes: attributes)
        cardButtons.forEach() { button in
            button.isHidden = false
            button.isEnabled = false
            button.setAttributedTitle(attributedString, for: .normal)
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            button.layer.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        }
        scoreLabel.layer.borderWidth = 3.0
        scoreLabel.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func updateDealCardsButtonView() {
        if game.cardsOnTable.count < 24, game.deckCount > 0 {
            dealCardsButton.isEnabled = true
        } else {
            dealCardsButton.isEnabled = false
        }
    }
    
    private func updateLabels() {
        deckCountLabel.text = "Deck: \(game.deckCount)"
        setCountLabel.text = "Sets: \(game.cardsSets.count)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateViewFromModel() {
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card: Card? = {
                guard index < game.cardsOnTable.count else { return nil }
                return game.cardsOnTable[index]
            }()
            if let card = card, game.cardsOnTable.contains(card) {
                button.isEnabled = true
                button.isHidden = false
                button.setAttributedTitle(attributedStringFor(game.cardsOnTable[index]), for: .normal)
                button.layer.cornerRadius = 8.0
                button.layer.borderWidth = 4.0
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                button.layer.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9098039216, blue: 0.5725490196, alpha: 1)
            
                if game.cardsHints.contains(card) {
                    button.layer.borderColor = UIColor.cyan.cgColor
                }
                if game.cardsSelected.contains(card) {
                    button.layer.borderColor = UIColor.orange.cgColor
                }
            } else {
                button.isHidden = true
                button.setTitle("", for: UIControl.State.normal)
                let attributes: [NSAttributedString.Key: Any] = [.strokeWidth: 5.0,
                                                                 .strokeColor: UIColor.red]
                let attributedString = NSAttributedString(string: "", attributes: attributes)
                button.setAttributedTitle(attributedString, for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            }
        }
        if game.isEnd() {
            switch game.deckCount {
            case 0:
                updateButtonsViewWhenGameIsEnd()
            default:
                dealCardsButton.layer.borderWidth = 3.0
                dealCardsButton.layer.borderColor = UIColor.green.cgColor
            }
        } else {
            scoreLabel.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            dealCardsButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
}

extension ViewController {
    private func attributedStringFor(_ card: Card) -> NSAttributedString {
        let cardSymbol: String = {
            switch card.symbol {
            case .triangle: return "▲"
            case .circle: return "●"
            case .square: return "■"
            }
        }()
        let color: UIColor = {
            switch card.color {
            case .red: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            case .green: return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            case .purple: return #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
            }
        }()
        let strokeWidth: CGFloat = {
            switch card.shade {
            case .striped: return -8
            case .filled: return -8
            case .outline: return 8
            }
        }()
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeColor: color,
            .strokeWidth: strokeWidth,
            .foregroundColor: color.withAlphaComponent({
                switch card.shade {
                case .striped: return 0.35
                case .filled: return 1.0
                case .outline: return 0.60
                }
                }()
            )
        ]
        let cardTitle: String = {
            switch card.number {
            case .one: return cardSymbol
            case .two: return cardSymbol + " " + cardSymbol
            case .three: return cardSymbol + " " + cardSymbol + " " + cardSymbol
            }
        }()
        return NSAttributedString(string: cardTitle, attributes: attributes)
    }
}

//MARK: Actions
extension ViewController {
    @IBAction private func newGame(_ sender: UIButton) {
        game.reset()
        updateView()
    }
    @IBAction private func hintButton(_ sender: UIButton) {
        game.hint()
        updateView()
    }
    @IBAction private func dealCards(_ sender: UIButton) {
        game.dealThreeOnTable()
        updateView()
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateView()
        } else { print("chosen card was not in cardButtons") }
    }
}
