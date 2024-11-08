//
//  ContentView.swift
//  expenses-tracker
//
//  Created by Vlad on 30/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userSessionManager = UserSessionManager()

    var body: some View {
        if userSessionManager.userIsLoggedIn {
           MainView()
                .environmentObject(userSessionManager)
        } else {
            AuthView()
                .environmentObject(userSessionManager)
                .withBackground()
        }
    }
}

#Preview {
    ContentView()
}
