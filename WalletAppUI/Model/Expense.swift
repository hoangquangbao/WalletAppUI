//
//  Expense.swift
//  WalletAppUI
//
//  Created by Quang Bao on 17/04/2022.
//

import SwiftUI

//MARK: Expense Model and Sample Data
struct Expense: Identifiable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}

var expenses : [Expense] = [
    Expense(amountSpent: "$98", product: "Facebook", productIcon: "facebook", spendType: "Add"),
    Expense(amountSpent: "$108", product: "Google", productIcon: "google", spendType: "Storage"),
    Expense(amountSpent: "$28", product: "Instagram", productIcon: "instagram", spendType: "Add"),
    Expense(amountSpent: "$12", product: "Linkedin", productIcon: "linkedin", spendType: "Career"),
    Expense(amountSpent: "$55", product: "Pinterest", productIcon: "pinterest", spendType: "Picture"),
    Expense(amountSpent: "$78", product: "Twitter", productIcon: "twitter", spendType: "Add"),
    Expense(amountSpent: "$128", product: "Whatsapp", productIcon: "whatsapp", spendType: "Video"),
    Expense(amountSpent: "$11", product: "Youtube", productIcon: "youtube", spendType: "Video")
]
