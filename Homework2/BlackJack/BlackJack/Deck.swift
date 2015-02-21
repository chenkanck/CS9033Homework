//
//  Deck.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Deck {
    var cards:[Card]
    
    init (){
        cards = []
        for rank in Card.validRank(){
            for suit in Card.validSuit(){
                self.cards.append(Card(rank: rank, suit: suit))
            }
        }
    }
    
    func showDeck () {
        println("We have \(cards.count) cards in the deck")
        for card in cards{
            println(card.content())
        }
    }
    
    func drawRandomCard() -> Card? {
        if cards.count > 0 {
            let index = Int(arc4random_uniform(UInt32(cards.count)))
            return cards.removeAtIndex(index)
        }else {
            return nil
        }
    }
}