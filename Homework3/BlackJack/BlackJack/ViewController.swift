//
//  ViewController.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var dealerCards: [CardImageView]!
    @IBOutlet var playersCards: [CardImageView]!
    
    @IBOutlet var moneyOfPlayers: [UILabel]!
    
    @IBOutlet weak var wager: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainCards: UILabel!
    
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    @IBOutlet var roundIndicator: [UILabel]!
    
    @IBOutlet weak var advise: UILabel!
    @IBOutlet weak var playerNumLable: UILabel!
    @IBOutlet weak var deckNumLable: UILabel!
    var game = Game(numOfDecks: 3, numOfPlayers: 3)
    var dealerRound = false
    var playerNum = ""
    var deckNum = ""
    override func viewWillAppear(animated: Bool) {
        
    }
    @IBAction func clickBet(sender: AnyObject) {
        let textInt = inputText.text.toInt()
        if textInt == nil || !game.bet(textInt!) {
            messageBox()
            return
        }
        
        dealerRound = false
        startRound()
        updateUI()
        
        setGameButton(true)
        
        betButton.enabled = false
        nextRoundButton.enabled = true

    }
    
    @IBAction func clickNextRount(sender: AnyObject) {
        betButton.enabled = true
        nextRoundButton.enabled = false
    }
    @IBAction func clickReset(sender: AnyObject) {
        game = Game(numOfDecks: deckNum.toInt()!, numOfPlayers: playerNum.toInt()!)
        updateUI()
        nextRoundButton.enabled = false
        betButton.enabled = true
    }
   
    
    
    @IBAction func hit(sender: AnyObject) {
        let result = game.hit()
        if result == "end" {
            dealerRound = true
            updateUI()
            outputResult()
        }
        updateUI()
    }
    
    @IBAction func stand(sender: AnyObject) {
        if game.stand() == "end" {
            dealerRound = true
            updateUI()
            outputResult()
        }
        updateUI()
    }
    
    func startRound() {
        setGameButton(false)
        resultLabel.text = "Result"
        game.nextRound()
        updateUI()
    }

    func outputResult() {
        resultLabel.text = game.evaluateResult()
        updateLabels()
        
        setGameButton(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deckNumLable.text = deckNum
        playerNumLable.text = playerNum
        game = Game(numOfDecks: deckNum.toInt()!, numOfPlayers: playerNum.toInt()!)
        initCardsLabels()
        updateUI()
        setGameButton(false)
    }

  
    func setGameButton(onOff: Bool) {
        hitButton.enabled = onOff
        standButton.enabled = onOff
    }
  
    func updateUI() {
        updateLabels()
        updateCards()
        updataAdvise()
    }
    
    func updateLabels() {
        wager.text = "\(game.wager)"
        remainCards.text = "\(game.shoe.cards.count)"
        updatePlayersScore()
    }
    
    func updateCards() {
        //Update dealers Cards
        for index in 0..<dealerCards.count {
            var face = ""
            var card: Card? = nil
            if index < game.dealer.hand.count() {
                card = game.dealer.hand.instanceOfCard(inIndex: index)
                face = game.dealer.hand.contentOfCard(inIndex: index)
            }
            if game.dealer.hand.count() > 0 && index == 0 && !dealerRound {
                dealerCards[index].faceUP = false
            }else {
                dealerCards[index].faceUP = true
            }
            dealerCards[index].cardPresent = card
        }
        
        //Update players Cards
        for i in 0..<(game.numOfPlayers*5) {
            var card: Card? = nil
            if i%5 < game.players[i/5].hand.count() {
                card = game.players[i/5].hand.instanceOfCard(inIndex: i%5)
            }
            playersCards[i].cardPresent = card
            
        }
        updateRoundIndicator()
        
    }
    
    private func updateRoundIndicator() {
        //Update roundIndicator
        for index in 0..<self.roundIndicator.count {
            if index == game.currentPlayer-1 && index < game.numOfPlayers{
                roundIndicator[index].hidden = false
            }else{
                roundIndicator[index].hidden = true
            }
        }
    }
    
    func initCardsLabels() {
        let cardsInUse = game.numOfPlayers * 5
        for i in 0..<self.playersCards.count {
            if i < cardsInUse {
                self.playersCards[i].hidden = false
            }else {
                self.playersCards[i].hidden = true
            }
        }
    }
    
    func updatePlayersScore () {
        for i in 0..<self.moneyOfPlayers.count {
            if i < game.numOfPlayers {
                moneyOfPlayers[i].text = "\(game.players[i].score)"
            }else {
                moneyOfPlayers[i].text = ""
            }
        }
    }
    func updataAdvise (){
        self.advise.text = game.giveAdvise()
    }
    
    
    func messageBox() {
        let alertController = UIAlertController(title: "Input Bet", message:
            "Input is invalid", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

