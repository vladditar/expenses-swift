//
//  Transaction.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import Foundation
import SwiftUI
import FirebaseFirestore

enum TransactionType: String {
    case income = "incomes"
    case expense = "expenses"
}

protocol Transaction {
    init?(document: QueryDocumentSnapshot)
}

struct Income: Transaction, Identifiable {
    let id: String
    let category: IncomeCategory
    let amount: Double
    let date: Date

    init?(document: QueryDocumentSnapshot) {
        guard
            let category = IncomeCategory(rawValue: document.data()["category"] as? String ?? ""),
            let amount = document.data()["amount"] as? Double,
            let timestamp = document.data()["date"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.category = category
        self.amount = amount
        self.date = timestamp.dateValue()
    }
}

struct Expense: Transaction, Identifiable {
    let id: String
    let category: ExpenseCategory
    let amount: Double
    let date: Date

    init?(document: QueryDocumentSnapshot) {
        guard
            let category = ExpenseCategory(rawValue: document.data()["category"] as? String ?? ""),
            let amount = document.data()["amount"] as? Double,
            let timestamp = document.data()["date"] as? Timestamp
        else {
            return nil
        }

        self.id = document.documentID
        self.category = category
        self.amount = amount
        self.date = timestamp.dateValue()
    }
}
