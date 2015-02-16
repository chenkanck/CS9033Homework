//
//  Player.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Player {
    var score = 100
    let minimum = 1
    var cardsInHand: [Card] = []
    var point = (0,0)
    
    var splitInHand: [Card] = []
    var splitPoint = (0,0)
    func bet (money: Int) -> Int?{
        if money >= self.minimum && self.score-money > 0 {
            self.score -= money
            return money
        }else {
            return nil
        }
    }
    
    func gain (money: Int) {
        self.score += money
    }
    
    func dropAllCards () {
        cardsInHand = []
        point = (0,0)
        
        splitInHand = []
        splitPoint = (0,0)
    }
    func updatePoint() {
        switch cardsInHand[0].rank {
        case "A":
            point.0 = 1
            point.1 = 11
        case "J", "Q" ,"K":
            point.0 = 10
            point.1 = 10
        default:
            point.0 = cardsInHand[0].rank.toInt()!
            point.1 = cardsInHand[0].rank.toInt()!
        }

    }
    func getCard (card: Card) {
        cardsInHand.append(card)
        switch card.rank {
        case "A":
            point.0 += 1
            point.1 += 11
        case "J", "Q" ,"K":
            point.0 += 10
            point.1 += 10
        default:
            point.0 += card.rank.toInt()!
            point.1 += card.rank.toInt()!
        }
    }
    func getCardInSplit (card: Card){
        splitInHand.append(card)
        switch card.rank {
            case "A":
                splitPoint.0 += 1
                splitPoint.1 += 11
            case "J", "Q" , "K":
                splitPoint.0 += 10
                splitPoint.1 += 10
            default:
                splitPoint.0 += card.rank.toInt()!
                splitPoint.1 += card.rank.toInt()!
        }
    }
    func currentState () -> String {
        if point.0 > 21 {
            return "burst"
        }
        if cardsInHand.count == 2 && point.1 == 21 {
            return "blackjack"
        }
        if cardsInHand.count == 5 && point.0 <= 21 {
            return "5"
        }
        return "normal"
    }
    
    func currentStateForSplit () -> String {
        if splitPoint.0 > 21 {
            return "burst"
        }
        if splitInHand.count == 2 && splitPoint.1 == 21 {
            return "blackjack"
        }
        if splitInHand.count == 5 && splitPoint.0 <= 21 {
            return "5"
        }
        return "normal"
    }
    
}