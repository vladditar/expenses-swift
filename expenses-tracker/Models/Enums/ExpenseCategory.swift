//
//  ExpenseCategory.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable {
    var id: Self { self }
    case FOOD = "food"
    case TRANSPORT = "transport"
    case RENT = "rent"
    case FUN = "fun"
}
