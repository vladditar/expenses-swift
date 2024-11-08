//
//  Extentions.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import Foundation

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter
    }()
}

extension UserSessionManager {
    func handleFirestoreResult(error: Error?, successMessage: String) {
        if let error = error {
            print("Error: \(error)")
        } else {
            print(successMessage)
        }
    }
}
