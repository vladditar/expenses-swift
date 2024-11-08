//
//  IncomeCategory.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import Foundation

enum IncomeCategory: String, CaseIterable, Identifiable {
    var id: Self { self }
    case SALARY = "salary"
    case FREELANCE = "freelance"
    case OTHER = "other"
}
