//
//  ExpensesView.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import SwiftUI
import Combine

struct ExpensesView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    
    @State private var expenses: [Expense] = []
    private let expenseCategories = ExpenseCategory.allCases

    private let formatter = NumberFormatter.currencyFormatter

    var body: some View {
        VStack {
            Text("Add expense")
                .font(.title)
            
            TransactionForm(categories: expenseCategories) { selectedCategory, amount in
                 addExpense(selectedCategory: selectedCategory, amount: amount)
             }
                    
            Divider()
                        
            List {
                ForEach(expenses) { expense in
                    HStack {
                        Text(expense.category.rawValue.capitalized)
                        Spacer()
                        Text(formatter.string(from: NSNumber(value: expense.amount)) ?? "")
                        Text(expense.date, style: .date)
                    }
//                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteExpense)
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .onAppear {
                fetchExpenses()
        }
    }
    
    func addExpense(selectedCategory: ExpenseCategory, amount: Double) {
        userSessionManager.addExpense(amount: amount, category: selectedCategory, date: Date()) { success in
            if success {
                fetchExpenses()
            } else {
                print("Failed to add expense")
            }
        }
    }
    
    func fetchExpenses() {
        userSessionManager.fetchExpenses { fetchedExpenses in
            self.expenses = fetchedExpenses
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
           for index in offsets {
               let expense = expenses[index]
               userSessionManager.deleteExpense(expenseID: expense.id) { success in
                   if success {
                       expenses.remove(atOffsets: offsets)
                   }
               }
           }
       }
}

#Preview {
    ExpensesView()
        .environmentObject(UserSessionManager())
        .withBackground()
}
