//
//  Shoe.swift
//  BlackJack
//
//  Created by Kan Chen on 2/27/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import Foundation

class Shoe :Deck{
    let numberOfDecks: Int
    
    init (numberOfDecks num : Int){
        numberOfDecks = num
        super.init()
    }
    
    func makeNewShoe () {
        cards = []
        for _ in 0..<numberOfDecks {
            add52Cards()
        }
    }
}