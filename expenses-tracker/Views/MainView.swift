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
            
                            TransactionsView()
                                .withBackground()
                                .tabItem {
                                    Label("Transactions", systemImage: "dollarsign.arrow.circlepath")
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
                        .font(.system(size: 16, weight: .bold))
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












// Dynamic Type Testing

//let test = Type1(id: "1", categoryEnum: .TWO)
//TypesView(prop: test)
//    .withBackground()
//    .tabItem {
//        Label("Test", systemImage: "dollarsign.arrow.circlepath")
//    }


//protocol TypeProtocol {
//    var id: String { get }
//    var category: String { get }
//    associatedtype Category: RawRepresentable where Category.RawValue == String
//    
//    static func parseTitle(from value: String) -> Category?
//}
//
//struct Type1: TypeProtocol {
//    let id: String
//    let categoryEnum: Type1Category
//    
//    var category: String {
//        categoryEnum.rawValue
//    }
//    
//    static func parseTitle(from value: String) -> Type1Category? {
//        return Type1Category(rawValue: value)
//    }
//}
//
//struct Type2: TypeProtocol {
//    let id: String
//    let categoryEnum: Type2Category
//    
//    var category: String {
//        categoryEnum.rawValue
//    }
//    
//    static func parseTitle(from value: String) -> Type2Category? {
//        return Type2Category(rawValue: value)
//    }
//}
//
//
//enum Type1Category: String {
//    var id: Self { self }
//    case ONE = "hello"
//    case TWO = "world"
//}
//
//enum Type2Category: String {
//    var id: Self { self }
//    case ONE = "hi"
//    case TWO = "people"
//}
//
//
//struct TypesView: View {
//    @State var prop: any TypeProtocol
//    
//    var body: some View {
//        Text(prop.category)
//    }
//}
