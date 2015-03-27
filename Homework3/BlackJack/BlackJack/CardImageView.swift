//
//  CardImageView.swift
//  BlackJack
//
//  Created by Kan Chen on 3/25/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import UIKit

class CardImageView: UIImageView {
    var faceUP: Bool = true
    var cardPresent: Card?{
        didSet{
            if cardPresent != nil {
                self.hidden = false
                let viewName = getImageViewName(cardPresent!)
                if faceUP {
                    self.image = UIImage(named: viewName)
                }else {
                    self.image = UIImage(named: "cardBackImage")
                }
            }else {
                self.hidden = true
            }
            
        }
    }
    
    private func getImageViewName(card:Card) ->String {
        let joint = "_of_"
        var imageName = ""
        var prefix:String
        switch card.rank {
            case "A": prefix = "ace"
            case "J": prefix = "jack"
            case "Q": prefix = "queen"
            case "K": prefix = "king"
            default : prefix = card.rank
        }
        var suffix:String
        switch card.suit {
            case "♥️": suffix = "hearts"
            case "♦️": suffix = "diamonds"
            case "♣️": suffix = "clubs"
            case "♠️": suffix = "spades"
            default: suffix = ""
        }
        imageName += prefix
        imageName += joint
        imageName += suffix
        return imageName
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
