//
//  TransactionCategory.swift
//  expenses-tracker
//
//  Created by Vlad on 19/11/2024.
//

import Foundation

enum TransactionType: String, CaseIterable {
    case INCOME = "incomes"
    case EXPENSE = "expenses"
}

enum TransactionCategory: String, CaseIterable, Identifiable {
    var id: Self { self }
    case SALARY
    case FREELANCE
    case OTHER
    case FOOD
    case TRANSPORT
    case RENT
    case FUN

    var displayName: String {
        switch self {
        case .SALARY: return "Salary"
        case .FREELANCE: return "Freelance"
        case .OTHER: return "Other"
        case .FOOD: return "Food"
        case .TRANSPORT: return "Transport"
        case .RENT: return "Rent"
        case .FUN: return "Fun"
        }
    }
    
    
    var type: TransactionType {
        switch self {
        case .SALARY, .FREELANCE, .OTHER:
            return .INCOME
        case .FOOD, .TRANSPORT, .RENT, .FUN:
            return .EXPENSE
        }
    }
    
//    static func defaultCategory(for type: TransactionType) -> TransactionCategory {
//        switch type {
//        case .INCOME:
//            return .SALARY
//        case .EXPENSE:
//            return .RENT
//        }
//    }

}
