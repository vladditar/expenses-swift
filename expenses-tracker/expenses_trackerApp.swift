//
//  expenses_trackerApp.swift
//  expenses-tracker
//
//  Created by Vlad on 30/10/2024.
//

import SwiftUI
import Firebase

@main
struct expenses_trackerApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
