//
//  Card.swift
//  BlackJack
//
//  Created by Kan Chen on 2/14/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Card {
    var rank: String
    var suit: String
    
    init(rank:String, suit:String){
        self.rank = rank
        self.suit = suit
    }
    
    class func validSuit() -> [String] {
        return ["♥️","♦️","♣️","♠️"]
    }
    
    class func validRank() -> [String] {
        return ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
    }
    
    func content() -> String{
        return self.suit+self.rank
    }
    
    func value () -> String {
        if self.rank == "J" || self.rank == "Q" || self.rank == "K" {
            return "10"
        }else {
            return self.rank
        }
    }
    
}