//
//  Income.swift
//  expenses-tracker
//
//  Created by Vlad on 06/11/2024.
//

import Foundation

enum Income: String, CaseIterable, Identifiable {
    var id: Self { self }
    case FOOD = "food"
    case TRANSPORT = "transport"
    case RENT = "rent"
    case FUN = ""
}
