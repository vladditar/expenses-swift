//
//  TransactionsView.swift
//  expenses-tracker
//
//  Created by Vlad on 18/11/2024.
//

import SwiftUI
import Combine

struct TransactionsView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager

    @State private var transactionType: TransactionType = .EXPENSE
    @State private var transactions: [Transaction] = []

    private let formatter = NumberFormatter.currencyFormatter

    
    var body: some View {
        VStack {
            Picker("View", selection: $transactionType) {
                Text("Expenses").tag(TransactionType.EXPENSE)
                Text("Incomes").tag(TransactionType.INCOME)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: transactionType) {
                fetchData()
            }

            List {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.category.displayName)
                        Spacer()
                        Text(formatter.string(from: NSNumber(value: transaction.amount)) ?? "")
                        Text(transaction.date, style: .date)
                    }
                }
                .onDelete(perform: deleteTransaction)
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        userSessionManager.fetchTransactions(for: transactionType) { fetchedTransactions in
            self.transactions = fetchedTransactions
        }
    }

    private func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            userSessionManager.deleteTransaction(transactionID: transaction.id) { success in
                if success {
                    transactions.remove(atOffsets: offsets)
                }
            }
        }
    }
}
#Preview {
    TransactionsView()
        .environmentObject(UserSessionManager())
        .withBackground()
}
