//
//  IncExpViewComponents.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import Foundation
import SwiftUI
import Combine

struct TransactionForm<CategoryType: Hashable & RawRepresentable>: View where CategoryType.RawValue == String {
    let categories: [CategoryType]
    let onAddTransaction: (CategoryType, Double) -> Void
    
    @State private var selectedCategory: CategoryType
    @State private var amountInput: String = ""
    private let maxCharacters = 10
    
    init(categories: [CategoryType], onAddTransaction: @escaping (CategoryType, Double) -> Void) {
        self.categories = categories
        self.onAddTransaction = onAddTransaction
        _selectedCategory = State(initialValue: categories.first!)
    }
    
    var body: some View {
        HStack {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
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
        .padding(20)
        .background(Color.secondary)
        .cornerRadius(10)
    }
    
    private func applyCharacterLimit() {
        if amountInput.count > maxCharacters {
            amountInput = String(amountInput.prefix(maxCharacters))
        } else {
            amountInput = amountInput.filter { "0123456789.".contains($0) }
        }
    }
    
    private func handleTransaction() {
        if let amount = Double(amountInput) {
            onAddTransaction(selectedCategory, amount)
            amountInput = ""
        } else {
            print("Invalid amount entered")
        }
    }
}
