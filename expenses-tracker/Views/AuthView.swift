//
//  AuthView.swift
//  expenses-tracker
//
//  Created by Vlad on 31/10/2024.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var userSessionManager: UserSessionManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Email", text: $email)
                .foregroundColor(.white)
                .textFieldStyle(.plain)
            
            Rectangle()
                .frame(width: 350, height: 1)
                .foregroundColor(.white)
            
            SecureField("Password", text: $password)
                .foregroundColor(.white)
                .textFieldStyle(.plain)
            
            Rectangle()
                .frame(width: 350, height: 1)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Button(action: {
                    userSessionManager.register(email: email, password: password)
                }) {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue)
                        )
                }
                
                Button(action: {
                    userSessionManager.login(email: email, password: password)
                }) {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding(.top)
            .offset(y: 50)
            
            if let errorMessage = userSessionManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .offset(y: 50)
            }
        }
        .frame(width: 350)
    }
}
