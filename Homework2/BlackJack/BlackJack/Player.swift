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
    
    
}