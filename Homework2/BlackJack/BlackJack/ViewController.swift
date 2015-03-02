//
//  ViewController.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //main board
    @IBOutlet var dealerCards: [UIButton]!
    @IBOutlet var playersCards: [UILabel]!
    
    @IBOutlet var moneyOfPlayers: [UILabel]!
    @IBOutlet weak var dealerPoint: UILabel!
    @IBOutlet weak var playerPoint: UILabel!
    
    @IBOutlet weak var wager: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainCards: UILabel!
    
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var insureButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var surrenderButton: UIButton!
    
    @IBOutlet var roundIndicator: [UILabel]!
    
    @IBOutlet weak var advise: UILabel!
    @IBOutlet weak var playerNumLable: UILabel!
    @IBOutlet weak var deckNumLable: UILabel!
    var game = Game(numOfDecks: 3, numOfPlayers: 3)
    var dealerRound = false
    var playerNum = ""
    var deckNum = ""
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
//        surrenderButton.enabled = true
//        if game.insuranceEnable() {
//            insureButton.enabled = true
//        }else {
//            insureButton.enabled = false
//        }
//        
//        if !game.doubleEnable() {
//            doubleButton.enabled = false
//        }
//        
//        if game.splitEnable() {
//            splitButton.enabled = true
//        }
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
    
    @IBAction func clickInsure(sender: AnyObject) {
//        if game.insure() {
//            resultLabel.text = "Insurance works"
//            dealerRound = true
//            splitButton.enabled = false
//            surrenderButton.enabled = false
//            setGameButton(false)
//        } else {
//            resultLabel.text = "Game Continue.."
//            if !game.doubleEnable() {
//                doubleButton.enabled = false
//            }
//        }
//        updateUI()
//        insureButton.enabled = false
    }
    @IBAction func clickSplit(sender: AnyObject) {
//        setFuncButton(false)
//        game.split()
//        updateUI()
    }
    @IBAction func clickDouble(sender: AnyObject) {
//        game.double()
//        dealerRound = true
//        updateUI()
//        outputResult()
        
    }
    @IBAction func clickSurrender(sender: AnyObject) {
        //        setGameButton(false)
        //        setFuncButton(false)
        //        game.surrender()
        //        resultLabel.text = "surrender."
        //        updateLabels()
    }
    @IBAction func hit(sender: AnyObject) {
        let result = game.hit()
        if result == "end" {
            dealerRound = true
            updateUI()
            outputResult()
        }
        setFuncButton(false)

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
        insureButton.enabled = false
        resultLabel.text = "Result"
        game.nextRound()
        updateUI()
    }
    
    func outputResultForSplit() {
//        var txt = ""
//        switch game.result() {
//        case 1:
//            txt += "Win! "
//            game.win()
//        case 0:
//            txt += "Draw! "
//            game.draw()
//        default:
//            txt += "Lose. "
//        }
//        switch game.resultForSplit() {
//        case 1:
//            txt += "Win! "
//            game.win()
//        case 0:
//            txt += "Draw! "
//            game.draw()
//        default:
//            txt += "Lose. "
//        }
//        game.bounce()
//        
//        resultLabel.text = txt
//        updateLabels()
//        setGameButton(false)
//        setFuncButton(false)
    }

    func outputResult() {
        resultLabel.text = game.evaluateResult()
        updateLabels()
//        game.bounce()
        
        setGameButton(false)
        setFuncButton(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        startRound()
        deckNumLable.text = deckNum
        playerNumLable.text = playerNum
        game = Game(numOfDecks: deckNum.toInt()!, numOfPlayers: playerNum.toInt()!)
        initCardsLabels()
        updateUI()
        setGameButton(false)
        setFuncButton(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGameButton(onOff: Bool) {
        hitButton.enabled = onOff
        standButton.enabled = onOff
        doubleButton.enabled = onOff
    }
    func setFuncButton (onOff: Bool){
        insureButton.enabled = onOff
        splitButton.enabled = onOff
        surrenderButton.enabled = onOff
        doubleButton.enabled = onOff
    }
    
    func updateUI() {
        updateLabels()
        updateCards()
        updateScore()
        updataAdvise()
    }
    
    func updateLabels() {
        wager.text = "\(game.wager)"
        remainCards.text = "\(game.shoe.cards.count)"
        updatePlayersScore()
    }
    
    func updateCards() {
        for index in 0..<dealerCards.count {
            var face = ""
            if index < game.dealer.hand.count() {
                face = game.dealer.hand.contentOfCard(inIndex: index)
//                face = game.dealer.cardsInHand[index].content()
            }
            if game.dealer.hand.count() > 0 && index == 0 && !dealerRound {
                face = "??"
            }
            dealerCards[index].setTitle(face, forState: UIControlState())
            if face == "" {
                dealerCards[index].setBackgroundImage(UIImage(named: "cardback"), forState: UIControlState())
            }else {
                dealerCards[index].setBackgroundImage(UIImage(named: "cardface"), forState: UIControlState())
            }
        }
        //Update players Cards
        for i in 0..<(game.numOfPlayers*5) {
            var face = ""
//            playersCards[i].backgroundColor = UIColor(red: 51, green: 112, blue: 50, alpha: 0)
            
            if i%5 < game.players[i/5].hand.count() {
                face = game.players[i/5].hand.contentOfCard(inIndex: i%5)
//                playersCards[i].backgroundColor = UIColor(red: 244, green: 240, blue: 240, alpha: 100)
            }
            
            playersCards[i].text = face
            
        }
        //Update roundIndicator
        for index in 0..<self.roundIndicator.count {
            if index == game.currentPlayer-1 {
                roundIndicator[index].text = "🔵"
            }else{
                roundIndicator[index].text = ""
            }
        }
        
        
    }
    
    func initCardsLabels() {
        let cardsInUse = game.numOfPlayers * 5
        for i in 0..<self.playersCards.count {
            if i < cardsInUse {
                self.playersCards[i].text = ""
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
    func updateScore() {
        dealerPoint.text = "\(game.dealer.playerPoint().0) / \(game.dealer.playerPoint().1)"
        playerPoint.text = "\(game.players[0].playerPoint().0) / \(game.players[0].playerPoint().1)"
    }
    
    func messageBox() {
        let alertController = UIAlertController(title: "Input Bet", message:
            "Input is invalid", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

