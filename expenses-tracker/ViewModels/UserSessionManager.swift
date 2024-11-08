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
        let userData: [String: Any] = [
            "name": user.displayName ?? "Anonymous",
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

    func addIncome(amount: Double, category: IncomeCategory, date: Date, completion: @escaping (Bool) -> Void) {
        addTransaction(type: .income, amount: amount, category: category.rawValue, date: date, completion: completion)
    }

    func addExpense(amount: Double, category: ExpenseCategory, date: Date, completion: @escaping (Bool) -> Void) {
        addTransaction(type: .expense, amount: amount, category: category.rawValue, date: date, completion: completion)
    }

    func fetchIncomes(completion: @escaping ([Income]) -> Void) {
        fetchTransactions(type: .income, completion: completion)
    }

    func fetchExpenses(completion: @escaping ([Expense]) -> Void) {
        fetchTransactions(type: .expense, completion: completion)
    }

    func deleteIncome(incomeID: String, completion: @escaping (Bool) -> Void) {
        deleteTransaction(type: .income, id: incomeID, completion: completion)
    }

    func deleteExpense(expenseID: String, completion: @escaping (Bool) -> Void) {
        deleteTransaction(type: .expense, id: expenseID, completion: completion)
    }

    // MARK: - Common methods

    private func addTransaction(type: TransactionType, amount: Double, category: String, date: Date, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let transactionData: [String: Any] = ["category": category, "amount": amount, "date": Timestamp(date: date)]
        db.collection("users").document(userID).collection(type.rawValue).addDocument(data: transactionData) { error in
            completion(error == nil)
        }
    }

    private func fetchTransactions<T: Transaction>(type: TransactionType, completion: @escaping ([T]) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        db.collection("users").document(userID).collection(type.rawValue)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                
                let transactions: [T] = documents.compactMap { doc in
                    guard let transaction = T(document: doc) else { return nil }
                    return transaction
                }
                completion(transactions)
            }
    }

    private func deleteTransaction(type: TransactionType, id: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.collection("users").document(userID).collection(type.rawValue).document(id).delete { error in
            completion(error == nil)
        }
    }
}
