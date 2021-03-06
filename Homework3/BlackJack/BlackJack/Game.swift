//
//  Game.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Game {
    var leftTimes: Int
    var shoe: Shoe
    var dealer: Player
    var players: [Player]
    var wager: Int = 0
    var currentPlayer: Int
    
    let numOfDecks: Int
    let numOfPlayers: Int
    let numOfHuman: Int
    
    var currentBet: Int
    
    func clearAllCard() {
        dealer.dropHand()
        for index in 0..<self.numOfPlayers {
            players[index].dropHand()
        }
    }
    
    init(numOfDecks: Int, numOfPlayers: Int, numOfHuman: Int) {
        self.numOfDecks = numOfDecks
        self.numOfPlayers = numOfPlayers
        self.numOfHuman = numOfHuman
        self.leftTimes = 5
        self.dealer = Player()
        self.players = []
        for _ in 0..<numOfPlayers {
            self.players.append(Player())
        }
        
        self.shoe = Shoe(numberOfDecks: numOfDecks)
        shoe.makeNewShoe()
        self.currentPlayer = 1
        self.currentBet = 1
    }
    
    // MARK: - Methods
    
    func bet (wager: Int)-> Bool  {
        let temp = players[currentBet-1].bet(wager)
        if temp != nil {
            players[currentBet-1].wager = temp!
            currentBet++
            self.wager = temp!
            return true
        }else {
            return false
        }
    }
    
    func playersBetFinished() -> Bool {
        return currentBet > numOfHuman
    }
    
    func aiBet() {
        for var i = currentBet; i <= numOfPlayers; i++ {
            var wage = 2
            if players[i-1].score >= 100 {
                wage = 10
            }else if players[i-1].score >= 60 {
                wage = 6
            }
            let tmp = players[i-1].bet(wage)
            players[i-1].wager = wage
        }
        currentBet = 1
    }
   
    func hit() -> String{
        let result = hitBy(players[currentPlayer-1])
        if result != "normal" {
            currentPlayer++
            checkBlackjack()
        }
        if allPlayerMoved() {
            aiAct()
            dealerAct()
            return "end"
        }
        return "continue"
    }
    
    func hitBy(person:Player) -> String {
        givePlayerACard(person)
        return person.currentState()
    }
    
    func allPlayerMoved() -> Bool{
//        return currentPlayer > numOfPlayers
        return currentPlayer > numOfHuman
    }
    
    func stand () -> String {
//        if (currentPlayer == numOfPlayers) {
//            dealerAct()
//            return "end"
//        }
        
        if currentPlayer == numOfHuman {
            currentPlayer++
            aiAct()
            dealerAct()
            return "end"
        }
        else {
            currentPlayer++
            checkBlackjack()
            if allPlayerMoved() {
                return "end"
            }
            return "continue"
        }
    }
    
    func nextRound() {
        if leftTimes == 0{
            shoe.makeNewShoe()
            leftTimes = 5
        }
        --leftTimes
        currentPlayer = 1
        dealer.dropHand()
        giveInitialTwoCardsToPlayer(dealer)
        for index in 0..<self.numOfPlayers {
            players[index].dropHand()
            giveInitialTwoCardsToPlayer(players[index])
        }
        checkBlackjack()
    }
    
    func checkBlackjack () {
        var index = currentPlayer
        while index <= numOfPlayers{
            if players[index-1].currentState() == "blackjack" {
                currentPlayer++
            }else {
                if allPlayerMoved() {
                    aiAct()
                }
                return
            }
            index++
        }
//        if allPlayerMoved() {
//            aiAct()
//        }
    }
    
    private func givePlayerACard(player: Player) {
        player.getCardInHand(shoe.drawRandomCard()!)
    }
    
    private func giveInitialTwoCardsToPlayer (person:Player){
        givePlayerACard(person)
        givePlayerACard(person)
    }
    
    // MARK: - AI Part
    func aiAct() {
        while currentPlayer <= numOfPlayers {
            var hint = getHint()
            while hint == "hit" {
                
                var result = hitBy(players[currentPlayer-1])
                if result != "normal" {
                    break
                }
                hint = getHint()
            }
            currentPlayer++
            checkBlackjack()
        }
        
    }
    
    func dealerAct () {
        var playerPoint = players[0].playerPoint()
        var expect = playerPoint.1 > 21 ? playerPoint.0:playerPoint.1
        if expect > 21 {
            expect = 0
        }
        //reach 17
        while dealer.playerPoint().1 < 17 && dealer.hand.count()<5{
            dealer.getCardInHand(shoe.drawRandomCard()!)
        }
        //try to beat player
        var dealerPoint = dealer.playerPoint().1 > 21 ? dealer.playerPoint().0 : dealer.playerPoint().1
        while dealerPoint < expect && dealer.hand.count()<5 {
            dealer.getCardInHand(shoe.drawRandomCard()!)
            dealerPoint = dealer.playerPoint().1 > 21 ? dealer.playerPoint().0 : dealer.playerPoint().1
        }
        
    }
    
    func giveAdvise() -> String {
        if dealer.hand.count() < 2 || currentPlayer > numOfPlayers {
            return "None"
        }
        return players[currentPlayer-1].advise(dealerSecondCardRank: dealer.hand.rankOfSecondCard())
        // modify mark
    }
    
    private func getHint() -> String {
        return players[currentPlayer-1].advise(dealerSecondCardRank: dealer.hand.rankOfSecondCard())
    }
    // MARK: - Result Process
    
    func resultOfPlayer(player:Player) -> Int{
        if player.currentState() == "burst" {
            return -1
        }
        if dealer.currentState() == "burst" {
            return 1
        }
        if player.currentState() != "normal" && dealer.currentState() != "normal" {
            if player.currentState() == "blackjack" && dealer.currentState() != "blackjack"{
                return 1
            }
            if player.currentState() != "blackjack" && dealer.currentState() == "blackjack"{
                return -1
            }
            return 0
        }
        if player.currentState() != "normal" && dealer.currentState() == "normal" {
            return 1
        }
        if player.currentState() == "normal" && dealer.currentState() != "normal" {
            return -1
        }
        let playerPoint = player.playerPoint().1 > 21 ? player.playerPoint().0:player.playerPoint().1
        let dealerPoint = dealer.playerPoint().1 > 21 ? dealer.playerPoint().0:dealer.playerPoint().1
        if playerPoint > dealerPoint {
            return 1
        }else if playerPoint == dealerPoint {
            return 0
        }else {
            return -1
        }
    }
    func evaluateResult() -> String{
        var rst = ""
        for player in self.players {
            switch self.resultOfPlayer(player) {
            case 1:
                rst += "Win! "
                self.winBy(player)
                
            case 0:
                rst += "Draw! "
                self.winBy(player)
            default:
                rst += "lose "
            }
        }
        
        return rst
    }
    
    func winBy(person: Player) {
        person.gain(person.wager * 2)
    }
    func drawBy (person: Player) {
        person.gain(person.wager)
    }
    
    //    func bounce() {
    //        if dealer.currentState() != "blackjack" {
    //            if player.currentState() == "blackjack" {
    //                player.gain(wager/2)
    //            }
    //            if splitted && player.currentStateForSplit() == "blackjack" {
    //                player.gain(wager/2)
    //            }
    //        }
    //    }
}