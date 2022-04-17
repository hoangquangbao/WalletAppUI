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

var expense : [Expense] = [
    Expense(amountSpent: "$98", product: "Facebook", productIcon: "Facebook", spendType: "Add"),
    Expense(amountSpent: "$108", product: "Google", productIcon: "Goole", spendType: "Storage"),
    Expense(amountSpent: "$28", product: "Instagram", productIcon: "Instagram", spendType: "Add"),
    Expense(amountSpent: "$12", product: "Linkedin", productIcon: "Linkedin", spendType: "Career"),
    Expense(amountSpent: "$55", product: "Pinterest", productIcon: "Pinterest", spendType: "Picture"),
    Expense(amountSpent: "$78", product: "Twitter", productIcon: "Twitter", spendType: "Add"),
    Expense(amountSpent: "$128", product: "Whatsapp", productIcon: "Whatsapp", spendType: "Video"),
    Expense(amountSpent: "$11", product: "Youtube", productIcon: "Youtube", spendType: "Video")
]
