//
//  ViewController.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var dealerCards: [UIButton]!
    @IBOutlet var playerCards: [UIButton]!
    @IBOutlet var splitCards: [UIButton]!
    @IBOutlet weak var dealerPoint: UILabel!
    @IBOutlet weak var playerPoint: UILabel!
    
    @IBOutlet weak var wager: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainCards: UILabel!
    
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var insureButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var surrenderButton: UIButton!
    
    var game = Game()
    var dealerRound = false
    
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
        surrenderButton.enabled = true
        if game.insuranceEnable() {
            insureButton.enabled = true
        }else {
            insureButton.enabled = false
        }
        
        if !game.doubleEnable() {
            doubleButton.enabled = false
        }
        
        if game.splitEnable() {
            splitButton.enabled = true
        }
    }
    @IBAction func clickSurrender(sender: AnyObject) {
        setGameButton(false)
        setFuncButton(false)
        game.surrender()
        resultLabel.text = "surrender."
        updateLabels()
    }
    @IBAction func clickRestart(sender: AnyObject) {
         betButton.enabled = true
    }
    @IBAction func clickReset(sender: AnyObject) {
        game = Game()
        updateUI()
    }
    
    @IBAction func clickInsure(sender: AnyObject) {
        if game.insure() {
            resultLabel.text = "Insurance works"
            dealerRound = true
            splitButton.enabled = false
            surrenderButton.enabled = false
            setGameButton(false)
        } else {
            resultLabel.text = "Game Continue.."
            if !game.doubleEnable() {
                doubleButton.enabled = false
            }
        }
        updateUI()
        insureButton.enabled = false
    }
    
    @IBAction func clickSplit(sender: AnyObject) {
        setFuncButton(false)
        game.split()
        updateUI()
    }
    @IBAction func clickDouble(sender: AnyObject) {
        game.double()
        dealerRound = true
        updateUI()
        outputResult()
        
    }
    
    @IBAction func hit(sender: AnyObject) {
        game.hit()
        if !game.splitted && game.player.currentState() == "burst" {
            resultLabel.text = "Player lose"
            setGameButton(false)
        }
        if game.splitted && game.splitRound == 1 && game.player.currentStateForSplit() == "burst" {
            outputResultForSplit()
        }
        if game.splitted && game.splitRound == 0 && game.player.currentState() == "burst" {
            game.splitRound++
        }
        
        setFuncButton(false)
        
        if game.player.cardsInHand.count == 5 {
            hitButton.enabled = false
        }
        updateUI()
    }
    
    @IBAction func stand(sender: AnyObject) {
        game.stand()
        if !game.splitted {
            dealerRound = true
            updateUI()
            outputResult()
        }else if game.splitRound == 2 {
            dealerRound = true
            updateUI()
            outputResultForSplit()
        }
        
    }
    
    func startRound() {
        setGameButton(false)
        insureButton.enabled = false
       
        resultLabel.text = "Result"
        game.nextRound()
        updateUI()
    }
    func outputResultForSplit() {
        var txt = ""
        switch game.result() {
        case 1:
            txt += "Win! "
            game.win()
        case 0:
            txt += "Draw! "
            game.draw()
        default:
            txt += "Lose. "
        }
        switch game.resultForSplit() {
        case 1:
            txt += "Win! "
            game.win()
        case 0:
            txt += "Draw! "
            game.draw()
        default:
            txt += "Lose. "
        }
        game.bounce()
        
        resultLabel.text = txt
        updateLabels()
        setGameButton(false)
        setFuncButton(false)
    }
    func outputResult() {
        switch game.result() {
        case 1:
            resultLabel.text = "Player Win!"
            game.win()
            updateLabels()
        case 0:
            resultLabel.text = "Draw!"
            game.draw()
            updateLabels()
        default:
            resultLabel.text = "Player lose"
        }
        game.bounce()
        
        setGameButton(false)
        setFuncButton(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        startRound()
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
    }
    
    func updateLabels() {
        money.text = "\(game.player.score)"
        wager.text = "\(game.wager)"
        remainCards.text = "\(game.gameDeck.cards.count)"
    }
    
    func updateCards() {
        for index in 0..<dealerCards.count {
            var face = ""
            if index < game.dealer.cardsInHand.count {
                face = game.dealer.cardsInHand[index].content()
            }
            if game.dealer.cardsInHand.count > 0 && index == 0 && !dealerRound {
                face = "??"
            }
            dealerCards[index].setTitle(face, forState: UIControlState())
            if face == "" {
                dealerCards[index].setBackgroundImage(UIImage(named: "cardback"), forState: UIControlState())
            }else {
                dealerCards[index].setBackgroundImage(UIImage(named: "cardface"), forState: UIControlState())
            }
        }
        
        for index in 0..<playerCards.count {
            var face = ""
            if index < game.player.cardsInHand.count {
                face = game.player.cardsInHand[index].content()
            }
            
            playerCards[index].setTitle(face , forState: UIControlState())
            if face == "" {
                playerCards[index].setBackgroundImage(UIImage(named: "cardback"), forState: UIControlState())
            }else {
                playerCards[index].setBackgroundImage(UIImage(named: "cardface"), forState: UIControlState())
            }
        }
        
        for index in 0..<splitCards.count {
            var face = ""
            if index < game.player.splitInHand.count {
                face = game.player.splitInHand[index].content()
            }
            
            splitCards[index].setTitle(face, forState: UIControlState())
            if face == "" {
                splitCards[index].setBackgroundImage(UIImage(named: "cardback"), forState: UIControlState())
            }else {
                splitCards[index].setBackgroundImage(UIImage(named: "cardface"), forState: UIControlState())
            }
        }
    }
    
    func updateScore() {
        dealerPoint.text = "\(game.dealer.point.0) / \(game.dealer.point.1)"
        playerPoint.text = "\(game.player.point.0) / \(game.player.point.1)"
    }
    
    func messageBox() {
        let alertController = UIAlertController(title: "Input Bet", message:
            "Input is invalid", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

