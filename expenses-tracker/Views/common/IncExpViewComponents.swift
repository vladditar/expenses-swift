//
//  IncExpViewComponents.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import Foundation
import SwiftUI
import Combine

struct TransactionForm: View {
    let transactionType: TransactionType
    let onAddTransaction: (TransactionCategory, Double) -> Void
    
    @State private var selectedCategory: TransactionCategory
    @State private var amountInput: String = ""
    private let maxCharacters = 10
    
    private var categories: [TransactionCategory] {
        TransactionCategory.allCases.filter { $0.type == transactionType }
    }
    
    init(transactionType: TransactionType, onAddTransaction: @escaping (TransactionCategory, Double) -> Void) {
        self.transactionType = transactionType
        self.onAddTransaction = onAddTransaction
        
        guard let firstCategory = TransactionCategory.allCases.first(where: { $0.type == transactionType }) else {
            fatalError("TransactionForm requires at least one category for the selected transaction type")
        }
        _selectedCategory = State(initialValue: firstCategory)
    }
    
    var body: some View {
        HStack {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category.displayName).tag(category as TransactionCategory)
                }
            }
            .frame(width: 120)
            .background(Color.white)
            .cornerRadius(10)
            
            TextField("Amount", text: $amountInput)
                .frame(width: 100)
                .background(Color.white)
                .cornerRadius(10)
                .keyboardType(.decimalPad)
                .onReceive(Just(amountInput)) { _ in
                    applyCharacterLimit()
                }
            
            Button(action: handleTransaction) {
                Image(systemName: "plus.app")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 35, height: 35)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.green))
            }
        }
    }
    
    private func applyCharacterLimit() {
        if amountInput.count > maxCharacters {
            amountInput = String(amountInput.prefix(maxCharacters))
        } else {
            amountInput = amountInput.filter { "0123456789.".contains($0) }
        }
    }
    
    private func handleTransaction() {
        guard let amount = Double(amountInput) else {
            print("Invalid input or no category selected")
            return
        }
        onAddTransaction(selectedCategory, amount)
        amountInput = ""
    }
}
