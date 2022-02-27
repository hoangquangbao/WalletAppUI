//
//  Card.swift
//  WalletAppUI
//
//  Created by Quang Bao on 27/02/2022.
//

import SwiftUI

// MARK - Sample Card Model and Data
struct Card: Identifiable {
    
    var id = UUID().uuidString
    var name : String
    var cardImage : String
    var cardNumber : String
}

var cards : [Card] = [
    
    Card(name: "Quang Bao", cardImage: "Card1", cardNumber: "1210 0121 2992 1229"),
    Card(name: "Quang Huy", cardImage: "Card2", cardNumber: "0302 2030 0660 0306"),
    Card(name: "Ha Luu", cardImage: "Card3", cardNumber: "2302 2032 2662 2326")
    
]
