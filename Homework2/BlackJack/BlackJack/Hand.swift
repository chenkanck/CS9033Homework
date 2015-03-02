//
//  Hand.swift
//  BlackJack
//
//  Created by Kan Chen on 2/27/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Hand {
    private var cardsInHand: [Card]
    var bet: Int
    var point: (Int,Int)
    
//    var score: Int{
//        get{
//            return self.score
//        }
//        set{
//            self.score = newValue
//        }
//    }
    
    init (){
        cardsInHand = []
        bet = 0
        point = (0,0)
//        score = 0
    }
    func count() ->Int{
        return cardsInHand.count
    }
    func dropAll() {
        cardsInHand = []
        point = (0,0)
    }
    
    func betAHand (newBet: Int) {
        self.bet = newBet
    }
    
    func getCard (card:Card) {
        cardsInHand.append(card)
        if card.value() == "A" {
            point.0 += 1
            point.1 += 11
        }else {
            point.0 += card.value().toInt()!
            point.1 += card.value().toInt()!
        }
    }
    
    func contentOfCard(inIndex i:Int) -> String {
        return cardsInHand[i].content()
    }
    
    func evaluateHand () ->String {
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
}