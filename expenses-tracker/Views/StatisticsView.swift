//
//  StatisticsView.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    @State private var categoryData: [ChartSliceData] = []
    @State private var selectedTab = 0


    // Unified function to fetch and process data
    func fetchData(for type: TransactionType) {
        let fetcher: (@escaping ([Transaction]) -> Void) -> Void = (type == .expense)
            ? userSessionManager.fetchExpenses
            : userSessionManager.fetchIncomes

        fetcher { transactions in
            self.categoryData = mapTransactionsToChartData(transactions)
        }
    }

    // Function to map transactions to chart data
    func mapTransactionsToChartData(_ transactions: [Transaction]) -> [ChartSliceData] {
        let groupedTransactions = Dictionary(grouping: transactions) { transaction in
            switch transaction {
            case let expense as Expense:
                return expense.category.rawValue
            case let income as Income:
                return income.category.rawValue
            default:
                return ""
            }
        }
        return groupedTransactions.map { category, items in
            let totalAmount = items.reduce(0) { total, item in
                if let expense = item as? Expense {
                    return total + expense.amount
                } else if let income = item as? Income {
                    return total + income.amount
                }
                return total
            }
            return ChartSliceData(category: category, amount: Int(totalAmount))
        }
        .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello,")
                    .font(.title)
                Text("\(userSessionManager.userData["name"] as? String ?? "Guest")!")
                    .font(.title)
                    .foregroundColor(.white)
            }

            Picker("Select Tab", selection: $selectedTab) {
                Text("Expenses").tag(0)
                Text("Incomes").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            PieChartView(data: categoryData)
                .onAppear {
                    fetchData(for: selectedTab == 0 ? .expense : .income)
                }
                .onChange(of: selectedTab) { oldValue, newValue in
                    fetchData(for: newValue == 0 ? .expense : .income)
                }
        }
        .onAppear {
            fetchData(for: .expense)
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(UserSessionManager())
        .withBackground()
}
