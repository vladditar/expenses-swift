//
//  IncomeView.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import SwiftUI

struct IncomeView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    
    @State private var incomes: [Income] = []
    private let formatter = NumberFormatter.currencyFormatter

    var body: some View {
        VStack {
            List {
                ForEach(incomes) { income in
                    HStack {
                        Text(income.category.rawValue.capitalized)
                        Spacer()
                        Text(formatter.string(from: NSNumber(value: income.amount)) ?? "")
                        Text(income.date, style: .date)
                    }
                    //                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteIncome)
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .onAppear {
            fetchIncomes()
        }
    }
    
    func fetchIncomes() {
        userSessionManager.fetchIncomes { fetchedIncomes in
            self.incomes = fetchedIncomes
        }
    }
    
    func deleteIncome(at offsets: IndexSet) {
           for index in offsets {
               let income = incomes[index]
               userSessionManager.deleteIncome(incomeID: income.id) { success in
                   if success {
                       incomes.remove(atOffsets: offsets)
                   }
               }
           }
       }
}

#Preview {
    IncomeView()
        .environmentObject(UserSessionManager())
        .withBackground()
}
