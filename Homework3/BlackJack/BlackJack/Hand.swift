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
    
    init (){
        cardsInHand = []
        bet = 0
        point = (0,0)
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
    func rankOfSecondCard () -> Int {
        if cardsInHand[1].rank.toInt() == nil {
            return 10
        }else {
            return cardsInHand[1].rank.toInt()!
        }
    }
    func contentOfCard(inIndex i:Int) -> String {
        return cardsInHand[i].content()
    }
    func instanceOfCard(inIndex i:Int) -> Card {
        return cardsInHand[i]
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
        if point.1 == 21 || point.0 == 21 {
            return "21"
        }
        return "normal"
    }
}