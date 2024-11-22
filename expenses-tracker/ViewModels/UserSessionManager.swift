//
//  AuthModel.swift
//  expenses-tracker
//
//  Created by Vlad on 31/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserSessionManager: ObservableObject {
    @Published var userIsLoggedIn = false
    @Published var errorMessage: String?
    @Published var userData: [String: Any] = [:]

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        setupAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    // MARK: - Authentication

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else if let user = result?.user {
                self?.createUserDocument(user: user)
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else if let user = result?.user {
                self?.fetchUserData(userID: user.uid)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false
            userData = [:]
        } catch {
            errorMessage = "Error signing out: \(error.localizedDescription)"
        }
    }
    
    private func setupAuthStateListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userIsLoggedIn = (user != nil)
            if let user = user {
                self?.fetchUserData(userID: user.uid)
            }
        }
    }

    private func removeAuthStateListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Firestore Data Management

    private func createUserDocument(user: User) {
        let userDocRef = db.collection("users").document(user.uid)
        let email = user.email ?? ""
        let userData: [String: Any] = [
            "name": email.split(separator: "@").first.map(String.init) ?? "Anonymous",
            "preferences": ["theme": "light", "notifications": true]
        ]
        userDocRef.setData(userData, merge: true) { error in
            self.handleFirestoreResult(error: error, successMessage: "User data successfully written!")
        }
    }

    private func fetchUserData(userID: String) {
        db.collection("users").document(userID).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                self?.userData = document.data() ?? [:]
            } else {
                print("User data does not exist")
            }
        }
    }


    // MARK: - Common methods
    func addTransaction(transaction: Transaction, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let transactionData: [String: Any] = [
            FirestoreKeys.Transaction.category: transaction.category.rawValue,
            FirestoreKeys.Transaction.amount: transaction.amount,
            FirestoreKeys.Transaction.date: Timestamp(date: transaction.date)
        ]

        db.collection("users").document(userID)
            .collection("transactions")
            .addDocument(data: transactionData) { error in
                completion(error == nil)
            }
    }

    // Fetching Transactions
    func fetchTransactions(for type: TransactionType, completion: @escaping ([Transaction]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users").document(userID)
            .collection("transactions")
            .order(by: FirestoreKeys.Transaction.date, descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let transactions: [Transaction] = documents.compactMap { Transaction(document: $0) }
                let filteredTransactions = transactions.filter { $0.category.type == type }
                completion(filteredTransactions)
            }
    }
    
    // Deleting a Transaction
    func deleteTransaction(transactionID: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.collection("users").document(userID)
            .collection("transactions")
            .document(transactionID)
            .delete { error in
                completion(error == nil)
            }
    }
}


struct FirestoreKeys {
    struct User {
        static let name = "name"
        static let preferences = "preferences"
    }
    struct Transaction {
        static let category = "category"
        static let amount = "amount"
        static let date = "date"
    }
}
