//
//  Player.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Player {
    var score:Int
    let minimum:Int
    var hand: Hand
    var wager: Int = 1
    init () {
        self.hand = Hand()
        self.score = 100
        self.minimum = 1
    }
    
    func bet (money: Int) -> Int?{
        if money >= self.minimum && self.score-money > 0 {
            self.score -= money
            hand.betAHand(money)
            return money
        }else {
            return nil
        }
    }
    
    func gain (money: Int) {
        self.score += money
    }
    
    func getCardInHand (newCard: Card) {
        hand.getCard(newCard)
    }
    
    func currentState() -> String {
        return hand.evaluateHand()
    }
    
    func dropHand() {
        hand.dropAll()
    }
    
    func playerPoint() -> (Int,Int) {
        return hand.point
    }
    func bestPoint() -> Int {
        return hand.point.1>21 ? hand.point.0 : hand.point.1
    }
    func advise (dealerSecondCardRank rank: Int) -> String{
        //soft
        if hand.point.0 != hand.point.1 {
            if hand.point.1 <= 17 {
                return "hit"
            }
            if hand.point.1 >= 18 && hand.point.1 <= 21 {
                return "stand"
            }
            if rank <= 8 {
                return "stand"
            }else {
                return "hit"
            }
        }
        //hard
        if bestPoint() >= 17 {
            return "stand"
        }
        if bestPoint() <= 12 {
            return "hit"
        }
        if rank >= 7 {
            return "hit"
        } else {
            return "stand"
        }
    }
}