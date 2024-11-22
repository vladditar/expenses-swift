//
//  StatisticsViewModel.swift
//  expenses-tracker
//
//  Created by Vlad on 18/11/2024.
//

import Foundation

class StatisticsViewModel: ObservableObject {
    @Published var categoryData: [ChartSliceData] = []
    private var userSessionManager: UserSessionManager
    
    init(userSessionManager: UserSessionManager) {
        self.userSessionManager = userSessionManager
    }
    
    
    func fetchData(for type: TransactionType) {
        userSessionManager.fetchTransactions(for: type) { [weak self] transactions in
            DispatchQueue.main.async {
                self?.categoryData = self?.mapTransactionsToChartData(transactions) ?? []
            }
        }
    }
        
    private func mapTransactionsToChartData(_ transactions: [Transaction]) -> [ChartSliceData] {
        let groupedTransactions = Dictionary(grouping: transactions, by: { $0.category })
        
        return groupedTransactions.map { category, items in
            let totalAmount = items.reduce(0) { $0 + $1.amount }
            return ChartSliceData(category: category, amount: Int(totalAmount))
        }
        .sorted { $0.amount > $1.amount }
    }
}
