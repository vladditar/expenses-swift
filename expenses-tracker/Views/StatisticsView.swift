//
//  StatisticsView.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    @StateObject private var viewModel = StatisticsViewModel(userSessionManager: UserSessionManager())
    @State private var selectedTransactionType: TransactionType = .EXPENSE
    @State private var showPopUp: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Hello,")
                    .font(.title)
                Text("\(userSessionManager.userData["name"] as? String ?? "Guest")!")
                    .font(.title)
                    .foregroundColor(.white)
            }

            Picker("Select Tab", selection: $selectedTransactionType) {
                Text("Expenses").tag(TransactionType.EXPENSE)
                Text("Incomes").tag(TransactionType.INCOME)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 40)


            PieChartView(data: viewModel.categoryData)
                .onAppear {
                    viewModel.fetchData(for: selectedTransactionType)
                }
                .onChange(of: selectedTransactionType) { oldValue, newValue in
                    viewModel.fetchData(for: newValue)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .fullScreenCover(isPresented: $showPopUp) {
            AddTransactionPopUpView(
                removePopUp: $showPopUp,
                transactionType: selectedTransactionType,
                onTransactionAdded: { viewModel.fetchData(for: selectedTransactionType) }
            )
            .background(ClearFullCoverBackground())
            .frame(width: 250, height: 150)
        }
        .overlay(
            Button(action: {
                self.showPopUp.toggle()
            }) {
                Image(systemName: "plus.app")
                    .foregroundColor(.white)
                    .font(.system(size: 26, weight: .bold))
                    .frame(width: 50, height: 50)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.white).opacity(0.2))
            }
            .padding(20),
            alignment: .bottomTrailing
        )
    }
}

struct AddTransactionPopUpView: View {
    @Binding var removePopUp: Bool
    var transactionType: TransactionType
    var onTransactionAdded: () -> Void
    @EnvironmentObject var userSessionManager: UserSessionManager

    func addTransaction(selectedCategory: TransactionCategory, amount: Double) {
        let transaction = Transaction(
            id: UUID().uuidString,
            category: selectedCategory,
            amount: amount,
            date: Date(),
            type: transactionType
        )

        userSessionManager.addTransaction(transaction: transaction) { success in
            if success { onTransactionAdded() }
        }
    }

    var body: some View {
        VStack {
            TransactionForm(
                transactionType: transactionType,
                onAddTransaction: { selectedCategory, amount in
                    addTransaction(selectedCategory: selectedCategory, amount: amount)
                    removePopUp.toggle()
                }
            )

            Button(action: {
                removePopUp.toggle()
            }) {
                Text("Cancel")
                    .padding(5)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding(20)
        .background(Color.secondary)
        .cornerRadius(10)
    }
}

struct ClearFullCoverBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    StatisticsView()
        .environmentObject(UserSessionManager())
        .withBackground()
}
