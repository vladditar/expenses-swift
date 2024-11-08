//
//  ExpensesView.swift
//  expenses-tracker
//
//  Created by Vlad on 05/11/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
                        TabView {
                            StatisticsView()
                                .withBackground()
                                .tabItem {
                                    Label("Statistics", systemImage: "circle.dashed.inset.filled")
                                }
            
                            ExpensesView()
                                .withBackground()
                                .tabItem {
                                    Label("Expenses", systemImage: "dollarsign.arrow.circlepath")
                                }
                            
                            IncomeView()
                                .withBackground()
                                .tabItem {
                                    Label("Income", systemImage: "dollarsign.arrow.circlepath")
                                }
                        }
                        .onAppear() {
                            UITabBar.appearance().backgroundColor = .systemBackground
                        }
            
            HStack {
                Spacer()
                Button(action: {
                    userSessionManager.logout()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold)) // Adjust the icon size here
                        .frame(width: 35, height: 35)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.red)
                        )
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            .frame(height: 80, alignment: .bottom)
            .background(Color(UIColor.systemBackground))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(UserSessionManager())
}
