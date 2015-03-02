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
    
    init(numOfDecks: Int, numOfPlayers: Int) {
        self.numOfDecks = numOfDecks
        self.numOfPlayers = numOfPlayers
        self.leftTimes = 5
        self.dealer = Player()
        self.players = []
        for _ in 0..<numOfPlayers {
            self.players.append(Player())
        }
        self.shoe = Shoe(numberOfDecks: numOfDecks)
        shoe.makeNewShoe()
        self.currentPlayer = 1
    }
    
   
    
    func bet (wager: Int)-> Bool  {
        for i in 0..<numOfPlayers {
            let temp = players[i].bet(wager)
            if temp != nil {
                self.wager = temp!
            }else {
                return false
            }
        }
        return true
    }
    
    func hit() -> String{
        let result = hitBy(players[currentPlayer-1])
        if result != "normal" {
            currentPlayer++
            checkBlackjack()
        }
        if allPlayerMoved() {
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
        return currentPlayer > numOfPlayers
    }
    
    func stand () -> String {
        if (currentPlayer == numOfPlayers) {
            dealerAct()
            return "end"
        }else {
            currentPlayer++
            checkBlackjack()
            return "continue"
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
        person.gain(wager * 2)
    }
    func drawBy (person: Player) {
        person.gain(wager)
    }
//    func win() {
//        player.gain(wager * 2)
//    }
//    func draw() {
//        player.gain(wager)
//    }
    
//    func surrender () {
//        player.gain(wager/2)
//    }
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
//        splitted = false
    }
    
    func checkBlackjack () {
        var index = currentPlayer
        while index <= numOfPlayers{
            if players[index-1].currentState() == "blackjack" {
                currentPlayer++
            }else {
                return
            }
            index++
        }
    }
    func giveAdvise() -> String {
        if dealer.hand.count() < 2 || currentPlayer > numOfPlayers {
            return "None"
        }
        return players[currentPlayer-1].advise(dealerSecondCardRank: dealer.hand.rankOfSecondCard())
    }
    private func givePlayerACard(player: Player) {
        player.getCardInHand(shoe.drawRandomCard()!)
    }
    
    private func giveInitialTwoCardsToPlayer (person:Player){
        givePlayerACard(person)
        givePlayerACard(person)
    }
}