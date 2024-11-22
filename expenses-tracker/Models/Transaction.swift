//
//  Transaction.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct Transaction: Identifiable {
    let id: String
    let category: TransactionCategory
    let amount: Double
    let date: Date
    
    func checkType() -> TransactionType {
        return category.type
    }
    
    // Manual initializer for creating new transactions
    init(id: String, category: TransactionCategory, amount: Double, date: Date, type: TransactionType) {
        self.id = id
        self.category = category
        self.amount = amount
        self.date = date
    }
    
    // Initialize from Firestore Document
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let categoryRawValue = data[FirestoreKeys.Transaction.category] as? String,
            let category = TransactionCategory(rawValue: categoryRawValue),
            let amount = data[FirestoreKeys.Transaction.amount] as? Double,
            let timestamp = data[FirestoreKeys.Transaction.date] as? Timestamp
        else {
            return nil
        }
        
        self.id = document.documentID
        self.category = category
        self.amount = amount
        self.date = timestamp.dateValue()
    }
}
