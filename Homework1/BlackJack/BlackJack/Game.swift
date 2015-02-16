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
    var gameDeck: Deck
    var dealer: Player
    var player: Player
    var wager: Int = 0
    var insurance: Int = 0
    var splitted:Bool = false
    var splitRound = 0
    init() {
        self.leftTimes = 5
        self.gameDeck = Deck()
        self.dealer = Player()
        self.player = Player()
    }
    
    func give2Cards (){
        player.getCard(gameDeck.drawRandomCard()!)
        player.getCard(gameDeck.drawRandomCard()!)
        dealer.getCard(gameDeck.drawRandomCard()!)
        dealer.getCard(gameDeck.drawRandomCard()!)
    }
    
    func bet (wager: Int)-> Bool  {
        let temp = player.bet(wager)
        if temp != nil {
            self.wager = temp!
            return true
        }else {
            return false
        }
    }
    
    func hit () {
        if !splitted || splitRound == 0 {
            player.getCard(gameDeck.drawRandomCard()!)
        }else {
            player.getCardInSplit(gameDeck.drawRandomCard()!)
        }
    }
    
    func double() {
        wager += player.bet(self.wager)!
        self.hit()
        if player.currentState() != "burst"{
            stand()
        }
    }
    
    func stand () {
        if !splitted || splitRound == 1 {
            dealerAct()
        }
        splitRound += 1
    }
    
    func dealerAct () {
        let expect = player.point.1 > 21 ? player.point.0:player.point.1
        //reach 17
        while dealer.point.1 < 17 && dealer.cardsInHand.count<5{
            dealer.getCard(gameDeck.drawRandomCard()!)
        }
        //try to beat player
        var dealerPoint = dealer.point.1 > 21 ? dealer.point.0 : dealer.point.1
        while dealerPoint < expect && dealer.cardsInHand.count<5 {
            dealer.getCard(gameDeck.drawRandomCard()!)
            dealerPoint = dealer.point.1 > 21 ? dealer.point.0 : dealer.point.1
        }

    }
    
    func insure() -> Bool{
        //put insurance
        if player.score >= wager/2 {
            insurance = wager/2
            player.score -= insurance
        }else {
            insurance = player.score
            player.score = 0
        }
        //check backjacj, 21 means blackJack
        if dealer.point.1 == 21 {
            if player.point.1 == 21 {
                draw()
            }
            player.gain(insurance * 2)
            return true
        }else {
            return false
        }
        
    }
    
    func split() {
        splitted = true
        splitRound = 0
        player.bet(self.wager)
        player.getCardInSplit(player.cardsInHand.removeLast())
        player.updatePoint()
        player.getCard(gameDeck.drawRandomCard()!)
        player.getCardInSplit(gameDeck.drawRandomCard()!)
    }
    
    
    func result() -> Int{
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
        let playerPoint = player.point.1 > 21 ? player.point.0:player.point.1
        let dealerPoint = dealer.point.1 > 21 ? dealer.point.0:dealer.point.1
        if playerPoint > dealerPoint {
            return 1
        }else if playerPoint == dealerPoint {
            return 0
        }else {
            return -1
        }
    }
    func resultForSplit() -> Int {
        if player.currentStateForSplit() == "burst" {
            return -1
        }
        if dealer.currentState() == "burst" {
            return 1
        }
        if player.currentStateForSplit() != "normal" && dealer.currentState() != "normal" {
            return 0
        }
        if player.currentStateForSplit() != "normal" && dealer.currentState() == "normal" {
            return 1
        }
        if player.currentStateForSplit() == "normal" && dealer.currentState() != "normal" {
            return -1
        }
        let dealerPoint = dealer.point.1 > 21 ? dealer.point.0:dealer.point.1
        let playerPoint = player.splitPoint.1 > 21 ? player.splitPoint.0:player.splitPoint.1
        if playerPoint > dealerPoint {
            return 1
        }else if playerPoint == dealerPoint {
            return 0
        }else {
            return -1
        }
    }
    func win() {
        player.gain(wager * 2)
    }
    func draw() {
        player.gain(wager)
    }
    func bounce() {
        if dealer.currentState() != "blackjack" {
            if player.currentState() == "blackjack" {
                player.gain(wager/2)
            }
            if splitted && player.currentStateForSplit() == "blackjack" {
                player.gain(wager/2)
            }
        }
    }
    
    func nextRound() {
        if leftTimes == 0{
            gameDeck = Deck()
            leftTimes = 5
        }
        --leftTimes
        player.dropAllCards()
        dealer.dropAllCards()
        give2Cards()
        splitted = false
        
    }
    
    func insuranceEnable() -> Bool {
        return dealer.cardsInHand[1].rank == "A" ? true : false
    }
    
    func doubleEnable() -> Bool {
        return player.score >= wager ? true :false
    }
    
    func splitEnable() -> Bool {
        if player.cardsInHand.count == 2 && player.cardsInHand[0].value() == player.cardsInHand[1].value() && player.score >= wager{
            return true
        }else {
            return false
        }
    }
}