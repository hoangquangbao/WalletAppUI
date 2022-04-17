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
    var cardType : String
    var cardNumber : String
    var bgCard : String
}

var cards : [Card] = [
    
    Card(name: "Quang Bao", cardType: "VISA", cardNumber: "1210 0121 2992 1229", bgCard: "bgCard1"),
    Card(name: "Quang Huy", cardType: "PAYPAL", cardNumber: "0302 2030 0660 0306", bgCard: "bgCard2"),
    Card(name: "Ha Luu", cardType: "MASTER CARD", cardNumber: "2302 2032 2662 2326", bgCard: "bgCard3")
    
]
